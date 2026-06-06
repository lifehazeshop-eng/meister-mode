---
id: meister-evidence-checklist
keywords: meister,evidence,phase-completion,checklist,gate
license: MIT
---

# Meister — Evidence checklist (phase-completion gates)

Per-phase mandatory evidence before the next phase begins. The loop (Phases 4–6) only exits when every check is green.

## PRE — Memory search
- [ ] `memory_search` called with a task-shaped query
- [ ] Result score ≥ 0.75 OR a "no prior hit" note is recorded
- [ ] Findings referenced as plan input in Sub-phase 1.1

## Sub-phase 1.1 — Prep
- [ ] Memory findings explicitly listed
- [ ] Context (paths, refs, target) captured
- [ ] Specs (what is being built) are clear
- [ ] Dependencies identified (tools, files, permissions)
- [ ] Risks named (at least one anti-pattern from history)

## Sub-phase 1.2 — Breakdown
- [ ] TASK list with ≥ 1 TASK
- [ ] Dependency graph (sequential vs parallel) marked
- [ ] Success criteria per TASK are measurable (output definition)
- [ ] Agents / resources per TASK named

## Sub-phase 1.3 — Agent assignment
- [ ] Per TASK: agent + model + tools + spec
- [ ] Communication / report structure defined (how the agent reports back)
- [ ] Start gate explicitly granted by ECC

## Phase 2 — VERIFY
- [ ] Coverage check against memory findings: all covered?
- [ ] Tool availability: every required skill/agent/MCP available?
- [ ] Risk map: every risk has a mitigation?
- [ ] Token estimate (rough range)
- [ ] ECC sign-off

## Phase 3 — CODE
- [ ] Per TASK: engine choice documented (code engine vs Claude agent vs direct bash)
- [ ] Parallel calls where the dependency graph allows (single message, multiple tool uses)
- [ ] Memory layer contacted (`memory_search` minimum)
- [ ] Per TASK: output produced + verified

## Phase 4 — Evaluation
- [ ] Actual measured (what came out)
- [ ] Compared against the success criteria from 1.2
- [ ] Diff explicit (what's missing, what's wrong, what's extra)
- [ ] Diff items formulated as new sub-TASKs

## Phase 5 — Implementation
- [ ] Sub-TASKs executed
- [ ] Engine choice per sub-TASK (via ECC)
- [ ] Output documented

## Phase 6 — Bulletproof
- [ ] Edge cases reviewed (≥ 3 scenarios)
- [ ] Anti-pattern check against the specification list
- [ ] Hardcoded audit: all phase outputs + code searched for hardcoded values (brand/price/names/paths/magic numbers/fixed examples); each finding reconciled against memory → intentional fallback / anti-example (keep) OR real leak (fix → single source)
- [ ] Long-term stability (what breaks in 30 days?)
- [ ] Reproducibility (can someone reproduce 1:1?)
- [ ] Security / permissions check
- [ ] Token cost acceptable (≤ budget from Phase 2)

## Loop-exit condition
- [ ] Every Phase 4 / 5 / 6 check is green
- [ ] Eval diff = 0 (or explicitly noted as "acceptable residual")
- [ ] User goal from 1.1 fulfilled

## Phase 7 — Memory / skill
- [ ] Findings stored as ≤ 1 KB memory file with frontmatter
- [ ] Naming: `<type>__<topic>__<sub>__YYYY-MM-DD-HHmm.md`
- [ ] Memory index pointer added (only for hot-relevant items)
- [ ] Skill-genesis check: pattern recurs ≥ 3 times? If yes: draft a skill
- [ ] Skill registry updated
- [ ] Status report (if bulk / long-running)

## Anti-skip mechanism
If a phase is skipped without running its checklist: STOP. Redo the phase. ECC records it in the phase log.

## When does "100%" hold?
All checks above green + user acknowledgement (explicit "okay" / "done" / "continue", or 30 s elapsed without a corrective instruction).
