#!/usr/bin/env bash
# SessionStart hook: inject the most recent notes/daily/ entry into context.
#
# Pairs with skills/session-log. The skill says "read the latest 1-2 entries
# on resume" but only fires if the model notices a trigger phrase. This hook
# makes it deterministic — every session in a project with notes/daily/
# starts with the last entry already in context.
#
# Output goes to stdout and is appended to the session context by Claude Code.
# Cap at ~150 lines per entry so a long log doesn't drown the session.

set -euo pipefail

PROJECT="${CLAUDE_PROJECT_DIR:-$(pwd)}"
DAILY="$PROJECT/notes/daily"
[ -d "$DAILY" ] || exit 0

LATEST="$(ls -1 "$DAILY"/*.md 2>/dev/null | sort | tail -1)"
[ -z "${LATEST:-}" ] && exit 0

NAME="$(basename "$LATEST" .md)"

# Staleness flag: if the latest entry is >14 days old, say so up front.
STALE_FLAG=""
if find "$LATEST" -mtime +14 2>/dev/null | grep -q .; then
  STALE_FLAG=" (>14 days old — context may be stale; consider rescanning repo state)"
fi

echo "## Resuming from notes/daily/$NAME.md$STALE_FLAG"
echo ""
head -150 "$LATEST"
