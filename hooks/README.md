# Hooks

Deterministic guardrails that close the "the model has to remember" gap in the [session-log](../skills/session-log/SKILL.md) skill. Skills are *instructions* — Claude can quietly skip them. Hooks are shell scripts the harness fires at specific events. Always run.

| Hook | Fires on | What it does |
|---|---|---|
| `session-start-resume.sh` | `SessionStart` | If `notes/daily/` exists, injects the latest entry (capped to 150 lines) into context so the new session starts with last session's "Next" already loaded. |
| `stop-session-log.sh` | `Stop` | If `notes/daily/` exists and today's file wasn't touched in the last hour, blocks the stop once and tells Claude to invoke the session-log skill before ending. |

Both are **opt-in per project** — they no-op unless `notes/daily/` exists in `$CLAUDE_PROJECT_DIR`. Other projects see nothing.

## Install in a project

```bash
# From the project root:
mkdir -p .claude/hooks
cp ~/claude-toolkit/hooks/*.sh .claude/hooks/
chmod +x .claude/hooks/*.sh
```

Then merge this into `.claude/settings.json` (create if missing):

```json
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          { "type": "command", "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/session-start-resume.sh" }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          { "type": "command", "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/stop-session-log.sh" }
        ]
      }
    ]
  }
}
```

Restart the Claude Code session to pick up the new hooks.

## Requirements

- `jq` on `PATH` — used by `stop-session-log.sh` to read hook input JSON. If missing, the hook exits 0 (no-op, no error). Install with `brew install jq` on macOS.
- Bash 3+ (anything macOS or Linux ships).

## Why these two and not more

These cover the only case in this toolkit where a skill's value depends on the model remembering to invoke it. Everything else (token-budget, tight-claude-md, ml-paper-repro) is user-triggered — hooks would just be ceremony.

If you find yourself adding a `PreToolUse` to block `rm -rf` or auto-lint on `Write`, fine — but those are project policy, not toolkit defaults. Keep this folder narrow.

## Removing

```bash
rm -rf .claude/hooks
# Then delete the "hooks" block from .claude/settings.json.
```
