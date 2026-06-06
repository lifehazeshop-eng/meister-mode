# Example 2 — Template hybrid edit (.liquid / .hbs / .jinja)

A template-hybrid edit is the case where Meister's TIER system pays off most.

## Prompt

```
Meister:Add a "free shipping over $X" banner to @sections/cart-drawer.liquid

CONTEXT: Live theme. The banner must appear at the top of the drawer when
         cart total < threshold. Threshold comes from theme settings.
DELIVERABLES:
  - cart-drawer.liquid patched
  - escape count unchanged
  - Playwright preview screenshot at 320 / 768 / 1024 px
```

## Expected flow

1. **PRE** — `memory_search` for cart-banner / liquid-banner patterns.
2. **PLAN**
   - 1.1 Prep: pull current `cart-drawer.liquid` via the platform API (truth-of-source — never the edge cache).
   - 1.2 Breakdown: TASK 1 = TIER 1 patch; TASK 2 = upload; TASK 3 = preview screenshot.
   - 1.3 Agent assignment: ECC routes TASK 1 to code engine TIER 1 constrained. ESC_BEFORE counted.
3. **VERIFY** — escape budget logged, rollback path defined (`git checkout`).
4. **CODE**
   - TASK 1: `<code-engine>` runs the constrained patch. ESC_AFTER == ESC_BEFORE → no drift.
   - TASK 2: `curl PUT` to upload.
   - TASK 3: Playwright screenshot via `?preview_theme_id=<X>&_pp_=1`.
5. **EVAL** — Vision Read confirms banner shows at the right breakpoint.
6. **BULLETPROOF** — hardcoded-audit: the threshold is wired to the theme setting, not a literal. Cookie-jar `curl` + `grep -c` confirms the marker is present in the rendered theme.
7. **PHASE 7** — memory store: "liquid-banner: TIER 1 constrained + escape verify works on this section type."

## Key routing decisions

- **TIER 1 first** — never TIER 3.
- **Escape-count gate** — if `ESC_AFTER != ESC_BEFORE`, rollback and fall to TIER 2 (Edit + Claude agent).
- **Truth via API**, not edge cache — caches lie.
- **Cookie-jar curl** for the post-edit verify is 50 tokens vs a 5 K Playwright dump.
