# Example 1 — Refactor callbacks to async/await

A typical "small refactor" TASK routed through Meister.

## Prompt

```
Meister:Refactor callbacks-to-async-await in @src/utils/api.ts

CONTEXT: TypeScript strict, 80-line file. Public signatures must stay
         backward-compatible. Callers in @src/components/* and @src/hooks/*.
DELIVERABLES:
  - api.ts rewritten with async/await
  - JSDoc on every exported function
  - tests pass + tsc clean
```

## Expected flow

1. **PRE** — `memory_search` for prior async-refactor patterns. (Hit: 0.81 — reuses the same approach.)
2. **PLAN**
   - 1.1 Prep: file is 80 LOC, 5 callers identified.
   - 1.2 Breakdown: TASK 1 = rewrite api.ts; TASK 2 = update JSDoc; TASK 3 = run tests.
   - 1.3 Agent assignment: ECC routes TASK 1 to the local code engine (pure TS, 80 LOC = sweet spot).
3. **VERIFY** — coverage OK, no public API breakage, token estimate 5-8 K.
4. **CODE** — code engine runs single-shot. Tests run as a separate TASK.
5. **EVAL** — diff = 0; all tests green.
6. **PHASE 7** — memory store: "ts-async-refactor: local code engine + AAA tests, 60% token save vs Claude-agent."

## Key routing decisions

- Tiny vs medium vs large: 80 LOC = medium-to-large → code engine TIER 1 wins.
- Memory hit reused → skipped most of the planning.
- ECC sign-off blocked on "no behavior change" requirement — TASK 1 explicitly states "public signatures stay backward-compatible."
