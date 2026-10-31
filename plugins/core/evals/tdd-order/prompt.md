---
max_turns: 25
timeout_seconds: 600
allowed_tools: [Read, Glob, Grep, Skill, Agent, TodoWrite, Write, Edit, Bash]
---
Add a `slugify(title)` function to textutils/core.py: lowercase it, turn spaces into hyphens, and drop anything that isn't a-z, 0-9 or a hyphen.
