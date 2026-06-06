# Contributing

Thanks for considering a contribution to Meister Mode.

## Ground rules

- Open an issue first for non-trivial changes (new rule, new ECC skill, new agent, structural changes).
- Keep PRs focused — one concern per PR.
- No proprietary references. The repo is intentionally generic; if you're porting from an internal stack, strip brand names, customer IDs, account numbers, and any other PII before opening a PR.
- No secrets. The repo has a `.gitignore` block for `.env*`. If you accidentally commit a key, rotate it immediately.

## Adding a rule

Rules live in `rules/`. Each file is a self-contained Markdown document with frontmatter:

```yaml
---
id: <kebab-case-slug>
keywords: <comma-separated>
license: MIT
---
```

Add a one-line pointer in `README.md` if the rule is core (i.e. anyone running Meister will load it).

## Adding an ECC skill

Skills live in `skills/ecc/<skill-name>/`. The minimal layout is:

```
skills/ecc/<skill-name>/
  SKILL.md            # what it does, when to invoke, how to use
  (optional resources)
```

Keep skills focused on one job. If a skill grows past ~5 KB, split it.

## Adding an agent

Agents live in `agents/<agent-name>.md`. Frontmatter must specify `name`, `description`, `model`, and `tools`. Body is the agent's system prompt. Use the existing agents as templates.

Generic agents only — anything that hard-codes a vendor, product, or customer goes into your own private fork, not this repo.

## Style

- Markdown: GitHub-flavored, 80-100 char lines preferred but not mandatory.
- Shell scripts: `bash`, `set -euo pipefail`, idempotent. Test with `--dry-run`.
- No emoji in code or docs unless they're already part of the surrounding context.

## Tests

This repo is mostly docs + scripts. The "test" is:

1. `bash install/setup.sh --dry-run` runs without error.
2. The sensitive-ref scan from `install/` returns nothing (run before PR; see `docs/ARCHITECTURE.md` for what counts as sensitive).
3. The `meister-mode.md` spec is internally consistent with `meister-evidence-checklist.md` and `use-case-prompts.md`.

## License

By contributing you agree your contribution is released under the [MIT license](LICENSE).
