#!/usr/bin/env bash
# Meister Mode — full-auto installer
#
# Installs the complete Meister stack into ~/.claude/:
#   L1  Superpowers (orchestrator)     — git-cloned to ~/.claude/plugins/data/
#   L2  ECC          (task-decider)    — bundled rules + skills + agents
#   L3  Memory MCP   (memory layer)    — registered via `claude mcp add`
#   T   Toolbox      (~60 agents)      — copied to ~/.claude/agents/
#   M   Memory dir   (~/.claude/memory)— created with initial MEMORY.md
#
# Idempotent. Backs up existing files. Safe to re-run.
#
# Usage:
#   bash install/setup.sh             # full auto-install
#   bash install/setup.sh --dry-run   # show what would happen, change nothing
#   bash install/setup.sh --no-mcp    # skip memory MCP registration
#   bash install/setup.sh --no-plugin # skip Superpowers plugin install
#   bash install/setup.sh --extra-mcp-url <git-url>  # also git-clone a custom memory MCP
#
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLAUDE_DIR="${CLAUDE_DIR:-$HOME/.claude}"
BACKUP_DIR="$CLAUDE_DIR/.meister-backup-$(date +%Y%m%d-%H%M%S)"
SUPERPOWERS_REPO="https://github.com/obra/superpowers.git"
SUPERPOWERS_DEST="$CLAUDE_DIR/plugins/data/superpowers"
MEMORY_MCP_PKG="@modelcontextprotocol/server-memory"
DRY_RUN=0
SKIP_MCP=0
SKIP_PLUGIN=0
EXTRA_MCP_URL=""

while [ $# -gt 0 ]; do
  case "$1" in
    --dry-run)    DRY_RUN=1 ;;
    --no-mcp)     SKIP_MCP=1 ;;
    --no-plugin)  SKIP_PLUGIN=1 ;;
    --extra-mcp-url) EXTRA_MCP_URL="${2:-}"; shift ;;
    -h|--help)    sed -n '2,20p' "$0"; exit 0 ;;
    *) echo "unknown arg: $1" >&2; exit 1 ;;
  esac
  shift
done

# --- helpers ----------------------------------------------------------------
say()  { printf "\033[1;36m[meister]\033[0m %s\n" "$*"; }
ok()   { printf "\033[1;32m[ok]\033[0m %s\n" "$*"; }
warn() { printf "\033[1;33m[warn]\033[0m %s\n" "$*" >&2; }
err()  { printf "\033[1;31m[err]\033[0m %s\n" "$*" >&2; }
run()  { if [ $DRY_RUN -eq 1 ]; then printf "  DRY: %s\n" "$*"; else eval "$@"; fi; }

# --- preflight --------------------------------------------------------------
say "preflight"

HAVE_GIT=0;     command -v git    >/dev/null 2>&1 && HAVE_GIT=1
HAVE_CLAUDE=0;  command -v claude >/dev/null 2>&1 && HAVE_CLAUDE=1
HAVE_NPX=0;     command -v npx    >/dev/null 2>&1 && HAVE_NPX=1

[ $HAVE_GIT    -eq 1 ] || { err "git not found in PATH — install git first"; exit 1; }

if [ $HAVE_CLAUDE -eq 0 ]; then
  warn "claude CLI not found — install Claude Code: https://docs.anthropic.com/claude/code"
  warn "  plugin + MCP installs will be skipped"
  SKIP_PLUGIN=1
  SKIP_MCP=1
fi
if [ $HAVE_NPX -eq 0 ] && [ $SKIP_MCP -eq 0 ]; then
  warn "npx not found — install Node.js (>= 20) to enable the default memory MCP"
  warn "  npm reference: https://nodejs.org/"
fi

if [ ! -d "$CLAUDE_DIR" ]; then
  warn "$CLAUDE_DIR does not exist; creating it"
  run "mkdir -p '$CLAUDE_DIR'"
fi

# --- backup -----------------------------------------------------------------
say "backup existing files -> $BACKUP_DIR"
run "mkdir -p '$BACKUP_DIR'"
for f in rules/meister-mode.md rules/meister-evidence-checklist.md rules/use-case-prompts.md CLAUDE-meister.md; do
  src="$CLAUDE_DIR/$f"
  if [ -e "$src" ]; then
    dest="$BACKUP_DIR/$f"
    run "mkdir -p '$(dirname "$dest")'"
    run "cp -a '$src' '$dest'"
  fi
done
[ -d "$CLAUDE_DIR/skills/ecc" ] && run "cp -a '$CLAUDE_DIR/skills/ecc' '$BACKUP_DIR/skills-ecc'"

# --- install rules ----------------------------------------------------------
say "install Meister rules -> $CLAUDE_DIR/rules/"
run "mkdir -p '$CLAUDE_DIR/rules'"
for f in meister-mode.md meister-evidence-checklist.md use-case-prompts.md; do
  run "cp -a '$REPO_ROOT/rules/$f' '$CLAUDE_DIR/rules/$f'"
done

if [ -d "$REPO_ROOT/rules/ecc-rules" ]; then
  run "mkdir -p '$CLAUDE_DIR/rules/ecc'"
  run "cp -an '$REPO_ROOT/rules/ecc-rules/.' '$CLAUDE_DIR/rules/ecc/'"
fi
ok "rules installed"

# --- install ECC skills -----------------------------------------------------
say "install ECC skills -> $CLAUDE_DIR/skills/ecc/"
run "mkdir -p '$CLAUDE_DIR/skills/ecc'"
run "cp -an '$REPO_ROOT/skills/ecc/.' '$CLAUDE_DIR/skills/ecc/'"
ok "ECC skills installed"

# --- install agents ---------------------------------------------------------
say "install agents -> $CLAUDE_DIR/agents/"
run "mkdir -p '$CLAUDE_DIR/agents'"
copied=0; skipped=0
for f in "$REPO_ROOT"/agents/*.md; do
  name="$(basename "$f")"
  dest="$CLAUDE_DIR/agents/$name"
  if [ -e "$dest" ]; then
    skipped=$((skipped+1))
  else
    run "cp -a '$f' '$dest'"
    copied=$((copied+1))
  fi
done
ok "agents: $copied installed, $skipped skipped (already present)"

# --- init memory dir --------------------------------------------------------
say "init memory directory -> $CLAUDE_DIR/memory/"
run "mkdir -p '$CLAUDE_DIR/memory'"
if [ ! -e "$CLAUDE_DIR/memory/MEMORY.md" ] && [ $DRY_RUN -eq 0 ]; then
  cat > "$CLAUDE_DIR/memory/MEMORY.md" <<'EOF'
# Memory Index

This file is the persistent memory index for Claude Code (Meister Mode).
Each line below is a one-line pointer to a topic memory file in this directory.

- (empty — your first Meister run will append entries here)
EOF
fi
ok "memory directory ready"

# --- install Superpowers plugin --------------------------------------------
if [ $SKIP_PLUGIN -eq 0 ]; then
  say "install Superpowers plugin"
  if [ -d "$SUPERPOWERS_DEST/.git" ]; then
    say "  already cloned -> git pull"
    run "git -C '$SUPERPOWERS_DEST' pull --ff-only --quiet"
  else
    run "mkdir -p '$(dirname "$SUPERPOWERS_DEST")'"
    run "git clone --depth 1 '$SUPERPOWERS_REPO' '$SUPERPOWERS_DEST'"
  fi
  ok "Superpowers plugin installed at $SUPERPOWERS_DEST"
  warn "  to activate in Claude Code, run:  /plugin install $SUPERPOWERS_DEST"
else
  warn "skipping Superpowers plugin install"
fi

# --- register memory MCP ----------------------------------------------------
if [ $SKIP_MCP -eq 0 ] && [ $HAVE_CLAUDE -eq 1 ]; then
  say "register default memory MCP ($MEMORY_MCP_PKG)"
  if claude mcp list 2>/dev/null | grep -qiE '^memory[: ]'; then
    ok "  memory MCP already registered"
  else
    if [ $HAVE_NPX -eq 1 ]; then
      run "claude mcp add memory -- npx -y $MEMORY_MCP_PKG"
      ok "  memory MCP registered"
    else
      warn "  npx missing — register manually:"
      warn "    claude mcp add memory -- npx -y $MEMORY_MCP_PKG"
    fi
  fi
else
  warn "skipping memory MCP registration"
fi

# --- optional: extra/alternative memory MCP --------------------------------
if [ -n "$EXTRA_MCP_URL" ] && [ $SKIP_MCP -eq 0 ] && [ $HAVE_CLAUDE -eq 1 ]; then
  say "install extra memory MCP from $EXTRA_MCP_URL"
  EXTRA_MCP_DEST="$CLAUDE_DIR/mcp/custom-memory"
  if [ -d "$EXTRA_MCP_DEST/.git" ]; then
    run "git -C '$EXTRA_MCP_DEST' pull --ff-only --quiet"
  else
    run "mkdir -p '$(dirname "$EXTRA_MCP_DEST")'"
    run "git clone --depth 1 '$EXTRA_MCP_URL' '$EXTRA_MCP_DEST'"
  fi
  warn "  extra memory MCP cloned to $EXTRA_MCP_DEST"
  warn "  register it manually with:"
  warn "    claude mcp add custom-memory -- <run-command-from-its-README>"
fi

# --- write CLAUDE.md snippet ------------------------------------------------
say "write CLAUDE.md snippet -> $CLAUDE_DIR/CLAUDE-meister.md"
if [ $DRY_RUN -eq 0 ]; then
  cat > "$CLAUDE_DIR/CLAUDE-meister.md" <<'SNIP'
## MEISTER MODE — 7-phase orchestrator (default-active)

Trigger: `Meister:<context>` → activates Superpowers + ECC + memory MCP.
Spec:    `~/.claude/rules/meister-mode.md`
Gates:   `~/.claude/rules/meister-evidence-checklist.md`
Routing: `~/.claude/rules/use-case-prompts.md`

Per task: ECC analyzes context, picks engine + agent, contacts the memory layer.
Loop Phases 4-6 (eval ↔ impl ↔ bulletproof) until 100% verified, then Phase 7 persists learnings.

Memory index: `~/.claude/memory/MEMORY.md`
SNIP
fi
ok "CLAUDE-meister.md written"

# --- final summary ----------------------------------------------------------
cat <<EOF

================================================================================
  Meister Mode installed.
================================================================================

  Append this line to your global CLAUDE.md to wire Meister:

      @CLAUDE-meister.md

  Or include the snippet directly:

      $CLAUDE_DIR/CLAUDE-meister.md

  Activate the Superpowers plugin in Claude Code:

      /plugin install $SUPERPOWERS_DEST

  Memory MCP status:

      claude mcp list

  Backup of pre-install state:

      $BACKUP_DIR

  Uninstall:

      bash $REPO_ROOT/install/uninstall.sh

================================================================================
EOF
