---
name: build
description: Implement the next task from tasks/plan.md in a thin, test-first slice — or every task with "auto" after one approval. Each slice is tested, verified and committed on its own.
disable-model-invocation: true
argument-hint: "[auto]"
---

# build

Mode: `$ARGUMENTS` — `auto` (or `all`) runs the whole plan; anything else implements the next pending task, then stops.

Needs `tasks/plan.md` (from `/spec`). No plan? For a small, clear task, make a 2–4 line plan inline and confirm it. For anything bigger, tell the user to run `/spec` first — don't invent requirements.

## One slice
1. Read the task's acceptance criteria and only the code it touches. Explore subagent for anything wider.
2. **Red:** write a failing test for the behaviour and run it. It must fail for the right reason (feature missing — not a typo or an import error).
3. **Green:** write the minimum code to pass. No extras, no "while I'm here".
4. Run the full relevant test suite and the build / type-check. Fix only what your change broke.
5. **Verify** beyond tests when behaviour is visible: UI, gameplay, CLI output → `/verify`, dev server, emulator or editor. If you can't verify, say exactly why.
6. Refactor if needed, tests still green.
7. Commit just this task's files (`git add <paths>`, never `-A`) with a clear message, and tick the task off in `tasks/plan.md`.

No test runner in the project? Say so, write the smallest runnable check you can (a script, an assertion, a smoke run), and mention that a test setup is missing.

Build broke and the fix isn't obvious → `build-error-resolver` agent. A behaviour bug → bug-hunt skill. Three failed attempts → stop and report.

## Auto mode
1. Require an approved spec (`SPEC.md`, `docs/SPEC.md` or `spec/`) — a README doesn't count.
2. Clean baseline: if `git status --porcelain` shows unrelated changes, stop and ask (commit, stash, or include).
3. No `tasks/plan.md` yet → draft it, show it, and wait for a clear "go". Hedged answers ("looks ok I guess") aren't approval. Commit the plan on its own.
4. Run every task in dependency order with the full slice loop above — one commit per task, so any point is a clean rollback.
5. **Stop and ask** (don't push through) when: a test can't be made to pass; the spec is ambiguous or silent on a decision; or a task is risky or irreversible (auth/permissions, destructive migrations, payments, deletes, deploys, secrets). The user re-runs `/build auto` to resume.
6. Finish with: tasks done, tests added, commits made, anything skipped or flagged. Then suggest `/ship`.

*Adapted from addyosmani/agent-skills `incremental-implementation` and its `/build` command (MIT).*
