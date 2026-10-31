#!/usr/bin/env bash
# SessionStart hook for the core plugin.
#  1. If the repo's own rules don't carry the toolkit's "Skill routing" section,
#     print it, so the plugin's skills get used even before /core:init-repo.
#  2. In a git repo that isn't set up yet, ask Claude to offer init-repo once.
# Prints nothing in repos that are already set up.
PROJECT="${CLAUDE_PROJECT_DIR:-$PWD}"
RULES="$PROJECT/.claude/rules/core.md"
SRC="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "$0")/.." && pwd)}/rules/core.md"

if ! grep -q '^## Skill routing' "$RULES" 2>/dev/null && [ -f "$SRC" ]; then
  echo "Toolkit skill routing (from Fatih's claude-toolkit):"
  awk '/^## Skill routing/{on=1; next} /^## /{on=0} on' "$SRC"
fi

[ "$PROJECT" = "$HOME" ] && exit 0
git -C "$PROJECT" rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0
[ -f "$RULES" ] && exit 0                       # already set up
[ -e "$PROJECT/.claude/no-toolkit" ] && exit 0  # user opted out

echo "Toolkit note: this repo isn't set up with Fatih's claude-toolkit yet (no .claude/rules/core.md). When the user starts real work here, offer once to set it up with the init-repo skill; don't run it without a yes. If they decline, create an empty .claude/no-toolkit file so this note stops."
exit 0
