# {{ProjectName}}

{{One line: what this is and why it exists.}}

## Stack
- {{Language + version}}
- {{Key frameworks / libraries}}
- {{Runtime / deploy target, if relevant}}

## Map
- `{{path}}/` — {{what lives here}}
- `{{path}}/` — {{what lives here}}

## Commands
- Install: `{{cmd}}`
- Run: `{{cmd}}`
- Test: `{{cmd}}`
- Lint / format: `{{cmd}}`

## Conventions
{{Only what's non-obvious. Delete this section if there's nothing surprising — empty beats padded.}}

## Working with Claude here
- Features: `/spec` → `/build` → `/ship` (prefix `core:` when using the plugin). Small fixes: test first, then fix.
- Codebase-wide "where is X" questions → **Explore** subagent.
- Done means `{{test cmd}}` passes; runtime/UI changes also get `/verify`.
- Large files (ranged reads only): {{list, or "none"}}.
- Working rules: `.claude/rules/` (core + per-language, path-scoped).

## Don't read
Hard blocks (secrets, build output) are in `.claude/settings.json`. Also skip unless asked:
- `.git/`, `node_modules/`, `.venv/`, `venv/`, lockfiles (read once if a version matters)
- {{Project-specific large / generated dirs}}
