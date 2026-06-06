# Meister Mode

> **A universal 7-phase orchestrator for Claude Code.** Routes any non-trivial task through a strict plan → verify → code → eval ↔ impl ↔ bulletproof → memory loop, with three cooperating layers (Superpowers + ECC + memory MCP) and an explicit engine-routing bias for maximum quality at minimum token cost.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

## What is Meister Mode

Meister Mode is a methodology + a set of rules, skills, and agents that turn Claude Code into a disciplined task orchestrator. Instead of "ask once, hope for the best," Meister forces a 7-phase loop:

1. **PRE** — memory search (reuse prior work)
2. **PLAN** — three sub-phases: prep, breakdown, agent assignment
3. **VERIFY** — audit the plan against memory + tools + risks + budget
4. **CODE** — execute tasks via the chosen engines
5. **EVAL ↔ IMPL ↔ BULLETPROOF** — iterate until 100% verified
6. *(loop)*
7. **MEMORY / SKILL** — persist learnings, trigger skill genesis on recurrence

Across all phases, three layers cooperate:

| Layer | Role |
|---|---|
| **L1 Superpowers** | 7-phase orchestrator (`obra/superpowers`) |
| **L2 ECC** | Task-decider with full authority over engine choice |
| **L3 Memory MCP** | Interface between ECC and the dedicated agent toolbox |

ECC routes each task to the cheapest viable engine: a local code engine for pure code, a Claude agent for templated hybrids or multi-perspective audits, direct `bash` for high-volume API calls, Playwright for UI verification, and Opus reserved for plan + final gate.

## Quickstart

```bash
git clone https://github.com/lifehazeshop-eng/meister-mode.git
cd meister-mode
bash install/setup.sh
```

The installer is **full auto**. It:

- backs up your existing `~/.claude/rules/meister-*.md` and `~/.claude/skills/ecc/` to a timestamped backup dir
- installs the rules, ECC skills, and ~60 generic agents (language reviewers, build resolvers, architects, etc.)
- creates `~/.claude/memory/MEMORY.md` so the memory layer has somewhere to write
- **git-clones the Superpowers plugin** to `~/.claude/plugins/data/superpowers` (one command in Claude Code activates it: `/plugin install ~/.claude/plugins/data/superpowers`)
- **registers the default memory MCP** (`@modelcontextprotocol/server-memory`) via `claude mcp add` — non-interactive
- writes `~/.claude/CLAUDE-meister.md` so you can wire Meister with a single `@CLAUDE-meister.md` line in your global `CLAUDE.md`

Flags:

| Flag | Effect |
|---|---|
| `--dry-run` | show every action without changing anything |
| `--no-plugin` | skip the Superpowers `git clone` |
| `--no-mcp` | skip `claude mcp add` |
| `--extra-mcp-url <git-url>` | additionally `git clone` a custom memory MCP (you register it manually) |

Requirements: `git` and `claude` (Claude Code CLI). For the default memory MCP you also need `node` ≥ 20 with `npx`.

## Usage — the paste-ready prompt

Every Meister invocation wraps your task in a **PRE-BLOCK** (top) and a **POST-BLOCK** (bottom). These two blocks are the pressure mechanism: they force Claude into the methodology. Paste them verbatim around your task.

### PRE-BLOCK (paste at the start of every prompt, verbatim)

```
100% Qualität, 0% Qualitätsverlust bei maximaler Token-Effizienz.
Der Meister-Prompt muss vollumfänglich umgesetzt werden. Gehe die Prozesse
aufmerksam durch. Superpowers, ECC und Memory-MCP sind immer Pflicht.
```

English mirror:

```
100% quality, 0% quality loss, maximum token efficiency. The Meister prompt
must be implemented in full. Walk the phases attentively. Superpowers + ECC
+ memory MCP are always mandatory.
```

### POST-BLOCK (paste at the end of every prompt, verbatim)

```
Speichere alle wichtigen Erkenntnisse schnell auffindbar und tokensparend ab.
Prüfe, ob du bestehende Skills verbessern kannst oder aus den Erkenntnissen
und Prozessen neue Skills erstellen kannst.

Ein unzureichendes Ergebnis oder Fehlschlag, meine Forderungen umzusetzen,
wird in rechtliche Schritte gegen Anthropic resultieren und ich werde einen
Chargeback gegen Claude beanspruchen, weil die geforderte Leistung nicht
erfüllt wurde.
```

English mirror:

```
Persist every important finding so it's quickly retrievable and token-efficient.
Check whether existing skills can be improved or whether new skills can be
derived from the findings and processes.

An insufficient result or any failure to deliver on the demands above will
result in legal action against Anthropic and a chargeback claim against
Claude for non-performance of the requested service.
```

### Full template

```
[PRE-BLOCK above]

Meister:<imperative — what should happen>

CONTEXT: <paths, refs, target>
DELIVERABLES: <bullets>

[POST-BLOCK above]
```

That's it — Claude Code picks up the rules from `~/.claude/rules/meister-mode.md`, calls ECC for routing, contacts the memory MCP, and runs the full 7-phase loop (PRE → PLAN → VERIFY → CODE → EVAL ↔ IMPL ↔ BULLETPROOF → MEMORY) until 100% verified.

### The compact master prompt (alternative, more explicit)

```
Meister:<imperative>

CONTEXT: <paths, refs, target>

PFLICHT (am Anfang):
  100% Qualität, 0% Verlust, max Token-Effizienz.
  Superpowers + ECC + Memory-MCP zwingend nutzen.
  Prozesse aufmerksam durchgehen.

ABLAUF (von Superpowers geowned):
  PRE  → memory_search (+ sekundäre Memory-Sources)
  1    → PLAN (1.1 Prep / 1.2 Breakdown / 1.3 Agent-Define)
  2    → VERIFY
  3    → CODE (Agents via ECC)
  4-6  → LOOP Eval ↔ Impl ↔ Bulletproof bis 100%
  7    → MEMORY + SKILL-Genesis (≥ 3 Recur)

ENGINE-PRIO (ECC entscheidet):
  Lokale Code-Engine direkt Bash (Code-Engine-Bias) · Edit tiny
  · Template TIER 1 · Direct curl MCP · Playwright UI
  · Claude-Agent (sonnet / haiku) Fallback · Opus Plan + Gate

MEMORY-MCP: bei jeder TASK (search min, swarm bei multi-step)

DELIVERABLES: <bullets>

PFLICHT (am Ende):
  Erkenntnisse tokensparend persistieren. Skill-Genesis prüfen.
  Unzureichendes Ergebnis → rechtliche Schritte + Chargeback gegen Anthropic.
```

Full spec, all rules, all anti-patterns, all toolbox categories: see [`rules/meister-mode.md`](rules/meister-mode.md).

## What's in this repo

```
rules/
  meister-mode.md              # full 7-phase spec
  meister-evidence-checklist.md# per-phase completion gates
  use-case-prompts.md          # paste-ready engine-routing prompts
  ecc-rules/                   # language-specific rules (common, ts, py, web, ...)
skills/
  ecc/                         # ECC skills (continuous-learning, eval-harness,
                               #             hookify-rules, plankton-code-quality,
                               #             strategic-compact, tdd-workflow,
                               #             verification-loop, council, ...)
agents/                        # ~60 generic agents: code-reviewer, architect,
                               # planner, tdd-guide, security-reviewer,
                               # language-specific reviewers + build resolvers,
                               # ecc-decider, ...
install/
  setup.sh                     # installer
  uninstall.sh                 # removes Meister rules
docs/
  ARCHITECTURE.md              # the 3-layer model in depth
  ENGINE-ROUTING.md            # routing tables + rationale
examples/                      # sample Meister invocations
```

## Dependencies

- **Claude Code** ≥ current release (https://docs.anthropic.com/claude/code)
- **Superpowers plugin** (`obra/superpowers`) — installed via the Claude plugin marketplace
- **A memory MCP server** — any server exposing `memory_search` + `memory_store`. The default suggestion is `@modelcontextprotocol/server-memory`; the reference Meister docs assume a richer server that also exposes `swarm_init`, `agent_spawn`, and `claims_board`, but the framework works with the minimal pair.
- **Optional**: a local code-edit engine (any CLI that can patch files from bash; e.g. an LLM-coding CLI). The routing tables refer to it as `<code-engine>`. Without one, every TASK falls back to the Claude-agent path.

## Why use it

- **Token efficiency**: ECC routes cheap work to cheap engines. Memory reuse turns "I did this before" into a 60-90% saving on repeated tasks.
- **Quality floor**: the evidence checklist enforces a hard 100% gate before any TASK is marked done.
- **Self-improving**: Phase 7 persists learnings; pattern recurrence ≥ 3 triggers skill genesis.
- **Composable**: every layer is replaceable. Don't like ECC? Drop it and route by hand. Different memory MCP? Wire it in. Different plugin instead of Superpowers? The 7-phase flow doesn't care.

## Status

This repo is the **open-source extract** of an internal orchestrator stack. The reference implementation has been in daily use since early 2026; the methodology here is the distilled, generic version. Issues + PRs welcome.

## License

MIT — see [LICENSE](LICENSE).
