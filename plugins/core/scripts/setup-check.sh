#!/usr/bin/env bash
# SessionStart hook: if this git repo hasn't been set up with the toolkit yet,
# tell Claude so it can offer /core:init-repo once. Silent everywhere else.
PROJECT="${CLAUDE_PROJECT_DIR:-$PWD}"

[ "$PROJECT" = "$HOME" ] && exit 0
git -C "$PROJECT" rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0
[ -f "$PROJECT/.claude/rules/core.md" ] && exit 0   # already set up
[ -e "$PROJECT/.claude/no-toolkit" ] && exit 0      # user opted out

echo "Toolkit note: this repo isn't set up with Fatih's claude-toolkit yet (no .claude/rules/core.md). When the user starts real work here, offer once to set it up with the init-repo skill; don't run it without a yes. If they decline, create an empty .claude/no-toolkit file so this note stops."
exit 0
