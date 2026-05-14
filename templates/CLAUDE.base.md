# {{ProjectName}}

{{One-line description of what this project is and why it exists.}}

## Stack

- {{Primary language(s) and version}}
- {{Key frameworks / libraries}}
- {{Runtime / deployment target if relevant}}

## Map

- `{{path}}/` — {{what lives here}}
- `{{path}}/` — {{what lives here}}
- `{{path}}/` — {{what lives here}}

## Commands

- Install: `{{cmd}}`
- Run: `{{cmd}}`
- Test: `{{cmd}}`
- Lint/format: `{{cmd}}`

## Conventions

{{Anything non-obvious about how code is organized or named.
Skip if there's nothing surprising — empty is better than padded.}}

## Working with Claude in this repo

- For "where is X" / "how is Y wired" questions, spawn the **Explore subagent** rather than grepping in the main session.
- Prefer ranged Read calls (offset/limit) over slurping large files. Files >800 lines: {{list any}}.
- For UI changes, run the dev server and verify in a browser before reporting done.
- If `notes/daily/` exists, read the latest entry on session start and log to today's file at session end. (See `session-log` skill.)

## Don't read

These paths burn input tokens without helping accuracy. Skip them unless explicitly asked:

- `.git/`, `node_modules/`, `.venv/`, `venv/`, `__pycache__/`
- Build outputs: `dist/`, `build/`, `out/`, `.next/`, `coverage/`
- Lockfiles: `package-lock.json`, `yarn.lock`, `pnpm-lock.yaml`, `poetry.lock`, `uv.lock`
- Generated: `tsconfig.tsbuildinfo`, `*.map`, `*.min.js`, `*.min.css`
- {{Project-specific large dirs go here}}
