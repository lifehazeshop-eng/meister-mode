# Architecture

Meister Mode is a methodology on top of Claude Code with three cooperating layers and a strict 7-phase loop. This document walks the architecture in depth.

## The 3 layers

### L1 — Superpowers (orchestrator)

Superpowers (`obra/superpowers`) is a published plugin that teaches Claude:

- brainstorming
- writing plans
- subagent-driven development (spec → plan → subagent execution)
- dispatching parallel agents
- systematic debugging
- test-driven development
- verification before completion

Meister treats Superpowers as the **owner** of the 7-phase loop. It plans the super-phase → phase → sub-phase (TASK) hierarchy and enforces verification gates.

### L2 — ECC (task-decider)

ECC ("Everything-is-Claude") is the central decision authority. For each TASK it walks 5 steps:

1. Analyze context (goal, constraints, rules, history)
2. Pick agent + tool from the toolbox
3. Skill check — does a saved skill apply? Can a local code engine handle this?
4. Model bias — code-engine for pure code; Claude agent (sonnet/haiku) for hybrids and audits; direct bash for high-volume APIs
5. Memory-layer contact — every TASK calls `memory_search` minimum

ECC outputs a structured routing decision (`AGENT`, `MODEL`, `ENGINE`, `TOOLS`, `MEMORY-CONTACT`, `REASONING`, `RISK`, `TOKEN-EST`, `SIGN-OFF`) and **does not execute** the TASK itself.

### L3 — Memory MCP (memory layer)

The memory MCP is the interface between ECC, the dedicated agents, and the toolbox. At minimum it must expose:

- `memory_search` — search prior tasks / findings
- `memory_store` — persist new findings

A richer memory server (used in the reference deployment) additionally exposes:

- `swarm_init` — initialize a multi-agent swarm
- `agent_spawn` — spawn an agent with a model + spec
- `claims_board` — coordinate task claims across agents
- `consensus` — collect votes from a swarm

The framework works with the minimal `memory_search` + `memory_store` pair. Multi-step orchestration features degrade gracefully.

## The 7-phase loop

```
PRE          memory search
  ↓
1. PLAN      1.1 prep
             1.2 breakdown (TASKs + dependency graph + success criteria)
             1.3 agent assignment (per-TASK agent + model + tools + spec)
  ↓
2. VERIFY    audit plan against memory + tools + risks + budget; ECC sign-off
  ↓
3. CODE      execute TASKs in parallel where the dep graph allows
  ↓
4. EVAL ──┐  measure expected vs actual; diff → sub-TASKs
5. IMPL  ←┤  execute sub-TASKs
6. BPRF  ←┘  edge cases, anti-pattern hunt, hardcoded audit, long-term stability
  ↓          (loop until eval diff = 0)
7. MEMORY    persist findings; skill genesis on recurrence ≥ 3
```

Each phase has a checklist (`rules/meister-evidence-checklist.md`). The loop only exits when every check is green and the eval diff is zero (or explicitly noted as acceptable residual).

## Engine routing

ECC routes TASKs to engines based on a bias table. The full table lives in `rules/use-case-prompts.md`; here's the short version:

| Task type | Primary | Fallback |
|---|---|---|
| Pure code (≥ 6 lines, no template hybrid) | local code engine | Claude agent (sonnet) |
| Tiny edit (1-5 lines) | Edit tool | — |
| Template hybrid (.liquid / .hbs / .jinja) | code engine TIER 1 constrained + escape verify | Edit / Claude agent |
| External API / MCP-equivalent | direct bash `curl` | Claude agent + MCP |
| Vision / UI audit | Playwright + vision Read | Claude agent |
| Memory search | memory MCP `memory_search` | secondary memory MCP |
| Multi-step swarm | `swarm_init` + `agent_spawn` + `claims_board` | — |
| Multi-perspective audit | 4× sonnet agents in parallel | — |
| Plan + final gate | Opus | — |

**Banned**: running a code engine inside a subagent (sandbox blocks file writes); unconstrained code-engine rewrites of template files; solo Opus full-file audits on > 50 KB.

## Why these specific rules

- **Memory search first**: prior work is worth 60-90% of the next task. Skipping memory = stale work.
- **ECC authority**: routing decisions are visible, auditable, reproducible. No "I picked sonnet because I felt like it."
- **Iterative loop until 100%**: the eval gate stops you from declaring victory while sub-TASKs are still red.
- **Phase 7 mandatory**: continuous learning is the whole point. Skipping it makes Meister stateless.

## Extensibility

Every layer is replaceable:

- **Different orchestrator**: drop Superpowers and use any plan-first methodology. The 7-phase flow is methodology-agnostic.
- **Different memory MCP**: any server that exposes `memory_search` / `memory_store` works. Multi-step features degrade gracefully.
- **Different code engine**: the routing table refers to `<code-engine>`. Use any CLI that can patch files from bash, or skip entirely (every TASK falls back to the Claude-agent path).
- **Different agents**: the `agents/` directory is the reference toolbox. Add, remove, or replace at will.
