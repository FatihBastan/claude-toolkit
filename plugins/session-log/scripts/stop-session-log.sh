#!/usr/bin/env bash
# Stop hook: nudge Claude to write a session-log entry before ending the turn.
#
# Pairs with skills/session-log. The skill defines *how* to write the log;
# this hook makes it deterministic *when* — Claude can't quietly forget.
#
# Behavior:
#   - No-op unless notes/daily/ exists in the project (opt-in per project).
#   - No-op if today's file was modified in the last hour (already logged).
#   - No-op on the second invocation (stop_hook_active=true) so we never loop.
#   - Otherwise: block stop and tell Claude to invoke the session-log skill.

set -euo pipefail

INPUT="$(cat)"

# No jq: plain bash + grep, so it also runs in Git Bash on Windows.
if printf '%s' "$INPUT" | grep -Eq '"stop_hook_active"[[:space:]]*:[[:space:]]*true'; then
  exit 0
fi

PROJECT="${CLAUDE_PROJECT_DIR:-$(pwd)}"
DAILY="$PROJECT/notes/daily"
[ -d "$DAILY" ] || exit 0

TODAY="$(date +%Y-%m-%d)"
TODAY_FILE="$DAILY/$TODAY.md"

if [ -f "$TODAY_FILE" ] && [ -n "$(find "$TODAY_FILE" -mmin -60 2>/dev/null)" ]; then
  exit 0
fi

REASON="Before stopping: this project uses session logging but today's entry has not been written in the last hour. Invoke the session-log skill (Mode 1) and write a Session block to notes/daily/$TODAY.md, then stop. If the user explicitly said not to log, acknowledge and stop without writing."

REASON="${REASON//\\/\\\\}"
REASON="${REASON//\"/\\\"}"
printf '{"decision": "block", "reason": "%s"}\n' "$REASON"
