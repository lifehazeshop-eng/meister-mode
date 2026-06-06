#!/usr/bin/env bash
# Meister Mode — uninstaller
# Removes Meister rules + CLAUDE-meister.md. Does NOT touch ECC skills,
# agents, Superpowers plugin, or memory MCP (those stay because other
# tooling may depend on them).
set -euo pipefail

CLAUDE_DIR="${CLAUDE_DIR:-$HOME/.claude}"

say() { printf "\033[1;36m[meister]\033[0m %s\n" "$*"; }

for f in \
  rules/meister-mode.md \
  rules/meister-evidence-checklist.md \
  rules/use-case-prompts.md \
  CLAUDE-meister.md
do
  p="$CLAUDE_DIR/$f"
  if [ -e "$p" ]; then
    say "remove $p"
    rm -f "$p"
  fi
done

say "Meister rules removed. ECC skills + agents kept."
say "To remove ECC, agents, plugin, MCP — do that manually:"
say "  rm -rf $CLAUDE_DIR/skills/ecc"
say "  rm -f  $CLAUDE_DIR/agents/ecc-decider.md"
say "  /plugin uninstall superpowers"
say "  claude mcp remove memory"
