---
id: use-case-prompts
keywords: meister,use-cases,engine-routing,paste-ready,prompts
license: MIT
---

# Use-case library — paste-ready prompts

Each case names the **default stack** once, then lists only the **delta per use-case**.

## Session-start habit (1× per session, ~5 s)

Verify your local code engine is alive before relying on the code-engine bias routing:

```bash
<code-engine-cli> --cwd /tmp "Output exactly OK" </dev/null 2>&1 \
  | grep -q "OK" && echo "code engine live" || echo "Claude-agent fallback"
```

The Meister default stack: **local code engine (direct shell only) + memory MCP + Claude agents (sonnet/haiku) as fallback + direct bash for API/MCP ops + Playwright for UI verification + Opus for plan + final gate.**

## Role lock (ECC authority, hard rule)

- **Code engine**: WRITE / code-precision. Pure code, constrained template edits, direct bash only — never inside a subagent.
- **Claude agents (sonnet / haiku)**: fallback when the code engine fails (sandbox / template / MCP). Multi-perspective audits (4× parallel).
- **Direct bash `curl`**: external API ops (any REST endpoint, MCP-equivalent) + cookie-jar verifies for CF-protected URLs.
- **Memory MCP**: every TASK contacts it (`memory_search` minimum, `swarm_init` on multi-step).
- **Opus**: plan + final gate only.

## Default stack (delta-only below)

```
STEP-0 (mandatory): memory_search query="<task>" limit=5
                    if hit >= 0.75 -> reuse approach, skip the rest
STACK:
  PLAN  = Superpowers (spec -> plan -> subagent-driven, verification-before-completion)
  GATE  = ECC + Opus final verify
MEMORY: memory/<topic>/<type>__<sub>__YYYY-MM-DD-HHmm.md (<= 1 KB, frontmatter required)
        + memory MCP store for compounding future savings
HARD RULES (global):
  max 1 delegation hop, MCP-detect -> haiku, Read offset+limit, code engine
  always with </dev/null (otherwise it hangs)
```

---

## 1. Template hybrid edit (.liquid / .hbs / .jinja)

```
ROUTE - TIER 1 (try first, ~95% token save):
  ESC_BEFORE=$(grep -oE '\{\{|\{%-|\{%|\}\}' file.tmpl | wc -l)
  <code-engine> "PATCH ONLY @file.tmpl lines X-Y.
                 DO NOT rewrite other lines.
                 PRESERVE all template escapes EXACTLY (count: $ESC_BEFORE).
                 Single-shot. Output: unified diff."
  ESC_AFTER=$(grep -oE '\{\{|\{%-|\{%|\}\}' file.tmpl | wc -l)
  [[ "$ESC_BEFORE" == "$ESC_AFTER" ]] || ROLLBACK + TIER 2

ROUTE - TIER 2 (if TIER 1 fails):
  Edit surgical via Claude agent (sonnet) + direct bash curl

ROUTE - TIER 3 (never): unconstrained code engine, code-engine chains

EXEC FLOW:
  1) curl GET asset -> truth
  2) TIER 1 -> TIER 2 fallback
  3) curl PUT (or local write) to replace
  4) cookie-jar curl + grep -c marker -> 1-2 numbers to verify
  5) Playwright screenshot key breakpoints (only baseline)
  6) Vision Read on the screenshot
```

---

## 2. New code (component / function — TS / Py / Go / Rust)

```
ROUTE: <code-engine> "<full briefing - file paths, constraints, deliverable>"
EXAMPLE:
  <code-engine> "implement useDebouncedSearch hook (300 ms) in @src/hooks/useDebouncedSearch.ts.
                 TypeScript strict. No lodash. AbortController. Test in
                 @src/hooks/__tests__/. Return {value, debounced, isPending}."
DELIVER: implementation file + test file (>= 80% coverage) + diff summary
VERIFY: tests pass + ECC gate + file < 800 LOC + function < 50 LOC
```

---

## 3. Refactor

```
ROUTE: <code-engine> --cwd <root> "<refactor spec>"
EXAMPLE:
  <code-engine> "refactor @src/utils/api.ts callbacks -> async/await. Public signatures
                 stay backward compatible. Update callers in @src/. No behavior change.
                 Add JSDoc."
VERIFY: tests pass + tsc / mypy clean + public API unchanged
```

---

## 4. Test generation

```
ROUTE: <code-engine> "generate vitest|jest|pytest tests for @<file>. AAA pattern.
                      Cover happy + edge. No mocks for pure functions.
                      Coverage >= 80%."
VERIFY: tests pass + coverage >= 80% + deterministic (no Date.now / random
        unless mocked)
ANTI: trivial assertions, tests against implementation details
```

---

## 5. Review (second opinion)

```
ROUTE: <code-engine> review --cwd <root>
   OR  <code-engine> "review @<file>. Focus: <areas>. ECC severity-graded."
VERIFY: Opus aggregates findings + own analysis. Block on CRITICAL / HIGH.
```

---

## 6. Research (web / library comparison)

```
ROUTE: context7 MCP for library docs (preferred over web search)
       OR Claude agent (haiku) with web-search tools
EXAMPLE:
  context7 query "Compare top-3 Stripe webhook patterns 2026.
                  Criteria: idempotency, retry, race conditions.
                  Format: table, score 1-5."
VERIFY: Opus picks + cross-checks 1-2 facts
LIMIT: respect upstream RPM; parallelize <= 3 concurrent
```

---

## 7. Debug investigation

```
PLAN: Superpowers `systematic-debugging` skill
ROUTE: <code-engine> (pure code) OR Claude agent (sonnet) (templates / MCP)
EXEC FLOW: 1) reproduce minimal 2) hypothesis-driven 3) verify via test (RED -> GREEN)
EXAMPLE:
  <code-engine> "investigate @src/api/cart.ts. Error: TypeError on cart.items.map.
                 Stack: <paste>. Hypothesis: items may be null. Reproduce, fix root cause."
VERIFY: regression test added + Opus validates the fix isn't symptom-only
ANTI: wrapping in try/catch as a fix; multiple unrelated changes in one commit
```

---

## 8. Codebase exploration (unknown repo)

```
ROUTE: <code-engine> "explore @<dir>. Map data flow <X -> Y -> Z>.
                      Output: mermaid + 5-bullet summary."
VERIFY: Opus cross-checks via Glob/Grep on hot files
DELIVER: architecture summary + diagram + 3 risk areas
```

---

## 9. Migration (library / framework upgrade)

```
KNOWLEDGE: context7 docs for the migration guide (lazy-load)
ROUTE: <code-engine> "<migration spec>"
EXAMPLE:
  <code-engine> "migrate React Router 6 -> 7 in @src/. Codemod: useNavigate stays,
                 Route children syntax. Update package.json. Don't touch unrelated."
VERIFY: build OK + tests pass + Playwright smoke on critical flows
ANTI: bulk find-replace without semantic check; migrate + feature-add in the same PR
```

---

## 10. Multi-iteration debug-fix-deploy

```
ROUTE: Opus orchestrator + 4x Claude agent (sonnet) parallel one-shot audit
       + haiku lookups + direct bash
EXEC FLOW:
  1) Opus plans the iteration scope (<= 500 tokens)
  2) Dispatch 4 sonnet reviewers in parallel
     (security / performance / style / UX)
     -> ~240 K parallel work, ~12 K main-context
  3) Aggregate CRITICAL / HIGH findings
  4) Direct bash curl for any REST endpoint (skip MCP overhead)
  5) Edit surgical patches
  6) cookie-jar curl + grep verify
  7) Memory resume mandatory:
     resume__<topic>__iter<N>__<state>__YYYY-MM-DD-HHmm.md
SAVE: ~60-70% vs solo Opus
```

---

## 11. Cookie-jar curl — truth-of-source for CF-protected URLs

```
WHY: Playwright is bot-blocked by CF Turnstile. cookie-jar curl ~50 tokens
     vs Playwright ~5 K-token dump.
PATTERN:
  curl -c /tmp/cookies.txt -b /tmp/cookies.txt -s "<url>?cb=$(date +%s)" \
    | grep -c "<marker>"   # -> 1-2 numbers per check
PRE-WARMUP: one Playwright stealth visit, save cookies, then curl reuses
            the session.
USE FOR: theme verify, asset-present check, regex-marker counting
SAVE: ~50 tokens / check vs 2 K-5 K Playwright dump
```

---

## Per-edit size routing (mandatory; ECC decides)

| Edit size | Lines | Tool | Pre-check | Post-verify |
|---|---|---|---|---|
| Tiny | 1-5 | Edit | none | git diff |
| Medium | 6-40 | Edit OR code engine TIER 1 | escape count if engine | escape verify if engine |
| Large | 41-200 | Code engine TIER 1 mandatory | escape count + git snapshot | escape verify + git diff + Playwright |
| Massive | 200+ | Code engine TIER 1 with full goal | full snapshot | escape verify + visual + Opus review |

Always close stdin: `</dev/null`.

## Quick engine-routing table

| Task type | Engine | Save |
|---|---|---|
| Pure code (no templates) | code engine direct | 95-97% |
| Template TIER 1 (try first) | code engine constrained + escape verify | 95-99% |
| Template TIER 2 fallback | Edit / Claude agent (sonnet) | 60-80% |
| Multi-step template orchestration | memory MCP haiku agent + bash code engine bridge | ~95% |
| Research / explain | context7 MCP / Claude agent | 90-95% |
| Code Q&A | Claude agent (haiku) | 90-95% |
| Bulk format | code engine | 95-97% |
| MCP ops (REST APIs) | Claude agent (haiku) + MCP | 20% |
| Multi-iter debug-fix | Opus + 4x sonnet parallel | 60-70% |
| Multi-step state coordination | memory MCP swarm + claims_board | 30-50% |
| Memory reuse (task similar to prior) | `memory_search` hit | 60-90% (whole task) |
| CF verify | cookie-jar curl + grep | 99% (50 vs 5 K tokens) |
| Plan + final verify | Opus | (gate) |

**STEP-0 mandatory:** `memory_search` before every task.

**Stop-words** (force MCP routing, never code engine): `mcp__|<your-external-systems>`
**Template trigger:** `template|.liquid|.hbs|.jinja|theme|section` -> TIER 1 code engine FIRST.
