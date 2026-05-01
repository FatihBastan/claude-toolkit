---
name: tight-claude-md
description: Generate a minimal, token-efficient CLAUDE.md for the current project. Use when starting work in a repo that has no CLAUDE.md, or when the existing one is verbose/out-of-date. Aims for under 80 lines — a map, not documentation.
---

# tight-claude-md

Write a CLAUDE.md that helps a future Claude session orient quickly without wasting input tokens. The output is a **map**, not documentation.

## Steps

1. **Inspect, don't slurp.** Use `ls` for the project root and 1–2 important subdirs. Read at most these files:
   - The existing CLAUDE.md if any (1)
   - `README.md` (first 100 lines)
   - The dep manifest: `package.json` / `pyproject.toml` / `requirements.txt` / `pubspec.yaml`
   - One config file relevant to the stack (e.g. `next.config.ts`, `tsconfig.json`, `pyproject.toml`)
   
   Hard cap: **6 reads**. If you need more, ask the user for guidance.

2. **For grep-style questions**, spawn the Explore subagent. Don't run grep in the main session.

3. **Draft sections** in this order, omitting any that would be empty rather than padding:
   - **Title** — project name, one-line description
   - **Stack** — language(s), key frameworks, runtime
   - **Map** — top-level dirs with one-line purposes
   - **Commands** — install, run, test, lint
   - **Conventions** — only the non-obvious ones
   - **Working with Claude** — Explore subagent rule, ranged-read note for any big file
   - **Don't read** — generic patterns + project-specific large dirs

4. **Cap at 80 lines.** If the draft is longer, the conventions section is probably bloated. Cut.

5. **Write to** `<project_root>/CLAUDE.md`. Confirm path with the user before overwriting if one already exists.

6. **Report** in 3 lines: what was detected, what was kept from any prior CLAUDE.md, what's a TODO marker the user should fill in.

## Anti-patterns to refuse

- Reproducing the README inside CLAUDE.md.
- Listing every npm script with explanations.
- Explaining what the framework is ("Next.js is a React framework…").
- Padding the "Conventions" section with generic advice ("write clean code", "use TypeScript types").

If you find yourself writing those, delete and move on.
