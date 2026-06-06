# Engine routing

ECC routes each TASK to the cheapest viable engine. This document explains the routing tables and the rationale behind them.

## The principle: code-engine bias

The default-route is "local code engine via direct bash". Reasons:

1. Code-edit CLIs are typically 60-95% cheaper than a full Claude agent for the same edit.
2. They run in your shell, not in a sandboxed subagent, so they can write files.
3. They handle large edits (41-200+ lines) without burning main-context tokens.

The bias only flips when the code engine can't safely handle the TASK:

- **Template hybrids**: a code engine that rewrites a `.liquid` / `.hbs` / `.jinja` file without escape-counting drift is a footgun. Constrain it (TIER 1) or fall back to surgical Edit.
- **MCP ops**: REST endpoints often want a Claude agent + the matching MCP for safety + retry handling, or direct bash `curl` for high-volume cases.
- **UI verification**: Playwright + a vision-capable Read is the only way to verify rendered output.
- **Multi-perspective audits**: 4× sonnet in parallel beats solo Opus on > 50 KB files.

## Per-edit size routing

| Lines | Tool | Pre-check | Post-verify |
|---|---|---|---|
| 1-5 | Edit | none | `git diff` |
| 6-40 | Edit OR code engine TIER 1 | escape count (if engine) | escape verify (if engine) |
| 41-200 | code engine TIER 1 mandatory | escape count + git snapshot | escape verify + git diff + Playwright |
| 200+ | code engine TIER 1 with full goal | full snapshot | escape verify + visual + Opus review |

## Template TIER system

When the file extension is `.liquid` / `.hbs` / `.jinja` (or any other template format with `{{ }}` / `{%- %}`-style escapes), routing goes through three tiers:

**TIER 1 (try first):**

```bash
ESC_BEFORE=$(grep -oE '\{\{|\{%-|\{%|\}\}' file.tmpl | wc -l)
<code-engine> --cwd "$ROOT" --sandbox danger-full-access \
  "PATCH ONLY @file.tmpl lines X-Y.
   DO NOT rewrite other lines.
   PRESERVE all template escapes EXACTLY (count: $ESC_BEFORE).
   Single-shot. Output: unified diff."
ESC_AFTER=$(grep -oE '\{\{|\{%-|\{%|\}\}' file.tmpl | wc -l)
[[ "$ESC_BEFORE" == "$ESC_AFTER" ]] || git checkout -- file.tmpl
```

**TIER 2 (TIER 1 fails or drifts):**

- Surgical Edit via Claude agent (sonnet)
- Direct bash `curl` for the platform API (read truth → patch → put back)

**TIER 3 (banned):**

- Unconstrained code-engine rewrites of full template files
- Code-engine → code-engine chains on the same file

## When NOT to use a code engine

Hard "do not route here" cases:

- **Inside a subagent**: sandbox blocks file writes. The code engine must run from direct bash only.
- **TIER 3 template work**: see above.
- **External API ops you can do with one `curl`**: spinning up an agent for a single REST call is pure overhead.
- **Tiny 1-5 line edits**: the engine's overhead exceeds the savings. Use Edit.

## Memory-reuse — the highest-impact routing rule

`memory_search` at STEP-0 is mandatory. Reasons:

- If the task is similar to a prior task (similarity ≥ 0.75), reusing the approach saves 60-90% of the entire task.
- If there's no hit, the search still costs only a few hundred tokens.
- The post-task `memory_store` compounds the savings on the next call.

Skipping memory = stale work. Period.

## Anti-patterns

- ❌ Running the code engine without closing stdin (`</dev/null`) — it hangs.
- ❌ Bypassing ECC for "small" tasks. ECC is cheap; bypassing it is how routing drift starts.
- ❌ Solo Opus full-file audits on > 50 KB. Use a swarm + 4× sonnet in parallel.
- ❌ Wrapping the code engine inside a Claude agent / subagent. Sandbox blocks the writes.
- ❌ Editing live config / live-template files directly (production env, theme config, deployed settings) without a verify path.
