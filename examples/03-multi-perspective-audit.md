# Example 3 — Multi-perspective audit (4× sonnet in parallel)

When a file or PR needs review along several axes, Meister fans out instead of doing one slow Opus pass.

## Prompt

```
Meister:Full audit of feature/checkout-rewrite PR

CONTEXT: 6 files changed, ~800 LOC delta. New payment integration.
DELIVERABLES:
  - security review
  - performance review
  - style / consistency review
  - UX review (rendered output via Playwright)
  - aggregated CRITICAL / HIGH list
```

## Expected flow

1. **PRE** — `memory_search` for prior payment-integration audits.
2. **PLAN**
   - 1.1 Prep: list changed files, estimate review surface.
   - 1.2 Breakdown: 4 review TASKs (security / perf / style / UX) + 1 aggregator TASK.
   - 1.3 Agent assignment: ECC routes the 4 reviews to 4× Claude agent (sonnet) **in parallel** (single message, four `Agent` tool uses). Aggregator = Opus.
3. **VERIFY** — token estimate: 4 × ~60 K parallel work = ~240 K parallel, but only ~12 K returns to main context.
4. **CODE** — fire all 4 agents at once.
5. **EVAL** — aggregator collects findings, dedupes, severity-grades.
6. **BULLETPROOF** — final gate: Opus reads the aggregated CRITICAL / HIGH list and confirms each finding is real.
7. **PHASE 7** — memory store: "payment-integration audit: 4-axis fan-out works; security caught a webhook idempotency bug."

## Key routing decisions

- **Solo Opus on the full file is banned** for > 50 KB. Fan out instead.
- **Parallel call pattern**: send a single message containing four `Agent` tool uses. Sequential = 4× wall time.
- **Opus as gate, not as auditor** — Opus aggregates and validates; sonnet auditors do the heavy reading.
