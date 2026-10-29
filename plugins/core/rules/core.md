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
