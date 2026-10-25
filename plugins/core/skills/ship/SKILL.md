---
name: ship
description: Pre-merge gate — run tests and build, review the diff with the built-in /code-review, /simplify and /security-review, verify the running app, then commit and open a PR.
disable-model-invocation: true
argument-hint: "[base-branch]"
---

# ship

Base branch: `$ARGUMENTS` (default: the repo's default branch).

Get the current work merge-ready. This orchestrates built-in commands — it doesn't reimplement them. Stop at the first gate that fails, fix it, and resume from that gate.

Invoke the built-ins through the Skill tool where it offers them (`/security-review`, and `/code-review` and `/simplify` where available). Some only run when the user types them — `/verify` is one. For those, do the equivalent yourself (below) and tell the user they can run the real command for a deeper pass.

## Gates
1. **Scope:** `git status` and `git diff --stat <base>...HEAD`. Unrelated changes in the diff → ask whether to split them out.
2. **Tests + build:** run the project's test, type-check/lint and build commands (from CLAUDE.md). All green, or explain each failure.
3. **Bugs:** `/code-review` on the branch. If you can't invoke it, review the diff yourself for correctness (or delegate to a fresh-context subagent) and suggest the user run `/code-review`. Fix real findings; list anything you deliberately left.
4. **Cleanup:** `/simplify`, and apply what's clearly better. Skip churn.
5. **Security:** if the diff touches auth, user input, file/network I/O, secrets or dependencies → `/security-review`.
6. **Runtime:** anything user-visible (UI, gameplay, CLI, API) → run it yourself (dev server + browser, emulator, editor, smoke script) and report what you actually observed. Suggest `/verify` to the user for the full check.
7. **Docs:** update CLAUDE.md commands/map, `SPEC.md` or the README only if this change made them wrong.
8. **Commit + PR:** small logical commits (no `git add -A`); push the branch; open a PR with *what / why / how it was verified / follow-ups*. Never push to the default branch directly, and ask before pushing at all if the user hasn't said to ship.

## Report
One line per gate: ✅ passed · 🔧 fixed (what) · ⏭ skipped (why). Then the PR link.
