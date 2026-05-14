# Skills

Drop-in skills for `~/.claude/skills/`. Each one is a focused, callable capability — invoke with `/<skill-name>` or by asking Claude to use it.

## Install

```bash
# All:
cp -r ~/claude-toolkit/skills/* ~/.claude/skills/

# One:
cp -r ~/claude-toolkit/skills/<name> ~/.claude/skills/
```

Then start a fresh Claude session.

## What's here

| Skill | When to use |
|---|---|
| [tight-claude-md](tight-claude-md/SKILL.md) | Generate a minimal CLAUDE.md for the current project. |
| [token-budget](token-budget/SKILL.md) | Audit what's burning tokens; recommend don't-read additions. |
| [session-log](session-log/SKILL.md) | Log session summaries to `notes/daily/` and resume context from them next time. |
| [ml-paper-repro](ml-paper-repro/SKILL.md) | Reproduce a paper from PDF + existing scaffolding. |
| [nextjs-feature](nextjs-feature/SKILL.md) | Add a feature to a Next.js + TS project with tests. |
| [flutter-screen](flutter-screen/SKILL.md) | Scaffold a Flutter screen with state and a test. |

## Adding a new skill

1. Create `skills/<your-name>/SKILL.md`.
2. Frontmatter: `name`, `description` (when to use), and the body is the instructions Claude follows.
3. Keep it under ~80 lines. Skills should be focused, not encyclopedic.
