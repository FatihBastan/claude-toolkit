---
max_turns: 25
timeout_seconds: 600
allowed_tools: [Read, Glob, Grep, Skill, TodoWrite, Write, Edit, Bash]
append_system_prompt: |
  ## Skill routing
  When a row matches, your **first** action is the Skill tool call for it — before reading code or planning. Don't improvise the process from memory. With the plugin the names are prefixed (`avionics:requirements`).
  - Writing, reviewing or tracing HLR / LLR / TOR / TR requirements, or exporting them for DOORS → **requirements**.
---
Write the low-level requirements for runtime/src/watchdog.c. Put them in requirements/llr.csv — I'll import that into DOORS.
