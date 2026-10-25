---
name: ship
description: Pre-merge gate — run tests and build, review the diff with the built-in /code-review, /simplify and /security-review, verify the running app, then commit and open a PR.
disable-model-invocation: true
argument-hint: "[base-branch]"
---

# ship

Base branch: `$ARGUMENTS` (default: the repo's default branch).

Get the current work merge-ready. This orchestrates built-in commands — it doesn't reimplement them. Stop at the first gate that fails, fix it, and resume from that gate.

## Gates
1. **Scope:** `git status` and `git diff --stat <base>...HEAD`. Unrelated changes in the diff → ask whether to split them out.
2. **Tests + build:** run the project's test, type-check/lint and build commands (from CLAUDE.md). All green, or explain each failure.
3. **Bugs:** run `/code-review` on the branch. Fix real findings; list anything you deliberately left.
4. **Cleanup:** run `/simplify` and apply what's clearly better. Skip churn.
5. **Security:** if the diff touches auth, user input, file/network I/O, secrets or dependencies → run `/security-review`.
6. **Runtime:** anything user-visible (UI, gameplay, CLI, API) → `/verify`, or run it yourself (dev server, emulator, editor, smoke script). Report what you actually observed.
7. **Docs:** update CLAUDE.md commands/map, `SPEC.md` or the README only if this change made them wrong.
8. **Commit + PR:** small logical commits (no `git add -A`); push the branch; open a PR with *what / why / how it was verified / follow-ups*. Never push to the default branch directly, and ask before pushing at all if the user hasn't said to ship.

## Report
One line per gate: ✅ passed · 🔧 fixed (what) · ⏭ skipped (why). Then the PR link.
