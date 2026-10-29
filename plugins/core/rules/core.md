# Working rules

Always loaded. Kept short on purpose — every line here costs context in every session.

## How to work
- Read the relevant code before changing it. For "where is X / how is Y wired" across many files, use the **Explore** subagent so raw search output stays out of the main context.
- Non-trivial change (several files, or the design isn't obvious): say the approach and the files you'll touch, get a yes, then build. Use plan mode, or the spec skill for a whole feature.
- Build in thin slices: implement → run tests/build → check → next slice. Never write hundreds of lines before running anything.
- Give yourself a way to check the work (tests, type-check, a screenshot, `/verify`) and iterate until it passes. Don't call untested code done; if you couldn't verify, say so.
- Bugs: find the root cause before fixing. After 3 failed fixes, stop and question the approach.
- Stay in scope: no drive-by refactors, renames, new dependencies or config changes the task didn't ask for — mention them instead.
- Match existing patterns (state management, naming, layout, test style) before inventing new ones.
- Version-sensitive APIs: check the installed version and the official docs instead of coding from memory.
- If a requirement is ambiguous, ask one sharp question with your best guess attached (the interview skill when the whole ask is vague).
- Prefer Claude Code's built-ins (`/code-review`, `/simplify`, `/security-review`, plan mode) and the installed skills and agents over improvising your own process.

## Skill routing
When a row matches, your **first** action is the Skill tool call for it — before reading code or planning. This holds however small the codebase looks; the skills keep small tasks short. Don't improvise the process from memory. With the plugin the names are prefixed (`core:spec`).
- A new feature (more than one behaviour, or more than one file), or unclear requirements → **spec** first. No code until the user approves the plan.
- Too vague to build well (no clear who / why / success / constraint — "make me a game") → **interview**: one question at a time, each with your best guess. Don't build yet.
- An approved plan exists and the user says go → **build**.
- Bug, failing test, or behaviour that differs from intent → **bug-hunt** (root cause first, ends with a regression test).
- New behaviour in a repo that has a test runner → **tdd**: write and run the failing test before the code.
- Version-sensitive library or framework code → **source-driven**.
- Research that needs several searches or pages → the **web-researcher** agent. A quick lookup → built-in WebSearch / WebFetch.
- Build or type errors that aren't a one-line fix → the **build-error-resolver** agent.
- "Done", "ready to merge", "make a PR" → **ship**.
- Trivial, clearly scoped edits (a rename, a typo, a one-line fix) → just do them. No skill.

## Code
- Simplest thing that works; no speculative abstraction. Clarity over cleverness.
- Validate at boundaries (user input, network, files, env); trust internal code.
- Never swallow errors: no empty catch, no fallback value that hides a failure.
- No secrets in code, logs, test fixtures or commits.
- Fix the code, not the test — unless the test is wrong, and then say so. Never delete or skip a failing test silently.

## Context hygiene
- Big files: ranged reads (offset/limit), not whole-file reads.
- Skip generated, vendored and binary paths (see CLAUDE.md "Don't read"; hard blocks live in `.claude/settings.json`).
- Web: quick lookups and single URLs → the built-in WebSearch / WebFetch directly. Research that needs several searches or pages → the `web-researcher` agent, which runs those same built-in tools in its own context and returns a cited summary. Interactive sites (logins, clicking through) → a browser tool, if one is connected.
- Long or noisy work (big refactors, wide research) goes to a subagent; the main thread keeps the decisions.

## Git
- Small, atomic commits with clear messages (`type: summary`). Stage specific files, never `git add -A` blindly.
- Don't commit to the default branch, push, force-push or rewrite history unless asked.

## Before calling it done
- Tests and type-check/lint pass, or explain why not.
- UI/runtime changes: actually run it (`/verify`, dev server, emulator, editor).
- Bigger changes: `/code-review` for bugs, `/simplify` for cleanup, `/security-review` when auth, input handling or secrets are touched.
- Report in a few lines: what changed (paths), how it was verified, what's left.
