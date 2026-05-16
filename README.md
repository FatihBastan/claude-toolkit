# claude-toolkit

Personal Claude Code toolkit. Templates, skills, and bootstrap instructions so a fresh Claude session in any of my projects gets up to speed in seconds — without reading half the repo and burning input tokens.

## How I use this

At the start of any new project (or when I want to re-init Claude in an existing one), I tell Claude:

> My toolkit is at `github.com/FatihBastan/claude-toolkit`. Clone it to `/tmp/claude-toolkit` if it isn't there, then follow `INIT.md` for this project.

Claude will:
1. Clone the toolkit (or `git pull` if already there).
2. Read `INIT.md`.
3. Detect the project type by inspecting a handful of files.
4. Pick the right `CLAUDE.md` template, fill it in, write it to the project root.
5. Append project-specific "don't read" rules.
6. Suggest which skills from `skills/` to install globally.

## Layout

| Path | What it is |
|---|---|
| [INIT.md](INIT.md) | Instructions Claude follows to init a project from this toolkit. |
| [templates/](templates/) | `CLAUDE.md` skeletons for the project types I work in, plus a generic don't-read list. |
| [skills/](skills/) | Custom skills I can install into `~/.claude/skills/` for global use. |
| [hooks/](hooks/) | Per-project shell hooks that make the `session-log` skill deterministic (auto-resume + stop-nudge). |
| [tips.md](tips.md) | My notes on token-efficient habits with Claude (Explore agent, ranged reads, etc.). |

## Installing skills globally

```bash
# All of them:
cp -r ~/claude-toolkit/skills/* ~/.claude/skills/

# Or pick one:
cp -r ~/claude-toolkit/skills/tight-claude-md ~/.claude/skills/
```

After copying, restart Claude Code or open a fresh session — they'll show up in the skills list.

## Updating

```bash
cd ~/claude-toolkit && git pull
```

When I learn a new pattern that saves tokens or improves Claude's accuracy on my projects, I add it here.
