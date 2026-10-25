---
name: spec
description: Write a spec and an ordered task plan before coding a feature — surface assumptions, define testable success criteria, slice the work vertically, then stop for approval.
disable-model-invocation: true
argument-hint: "<feature or idea>"
---

# spec

Feature: $ARGUMENTS

Code without a spec is guessing. This produces `SPEC.md` (what and why) and `tasks/plan.md` (how, in order), then **stops** for the user's approval. `/build` executes it.

If the ask is vague (no clear who, why, success criterion or constraint), run `/interview` first, or ask the 1–3 questions that matter most, each with your best guess attached.

## 1. Assumptions first
Before writing anything, list what you're assuming and invite correction:
```
ASSUMPTIONS
1. Web only, no native mobile.
2. Reuses the existing auth session.
3. No new dependencies.
→ Correct me now, or I'll proceed with these.
```

## 2. Write `SPEC.md` (short — a page, not a document)
```markdown
# Spec: <name>
## Objective      — what, for whom, why now
## Success criteria — specific and testable ("p95 load < 500 ms", "jump buffer 100 ms", not "faster")
## Scope          — in / explicitly out
## Design notes   — data shapes, interfaces, where it lives in the codebase (Explore subagent for this)
## Boundaries     — Always / Ask first (schema changes, new deps, CI) / Never (secrets, vendored code)
## Open questions
```
Turn vague requirements into success criteria and ask if they're the right targets. If the project already has a spec system (OpenSpec, ADRs, `docs/`), use its format and location instead.

If the request bundles several independently shippable capabilities, first propose a small module map (module id → responsibility → depends on, plus build order), get it approved, then write one spec per module.

## 3. Write `tasks/plan.md`
- Map dependencies; build foundations first; put high-risk tasks early (fail fast).
- **Slice vertically:** each task is one thin, working path through the stack ("user can create an account": schema + API + UI), not a layer ("all the endpoints").
- Each task touches ≤ ~5 files and fits one focused session.
- Add a checkpoint after every 2–3 tasks (all tests pass, app builds and runs).

```markdown
## Task 3: <title>
Acceptance: - [ ] <testable condition>
Verify:     <test command> · <build command> · <manual / /verify check>
Depends on: Task 1
Files:      src/…, tests/…
```

## 4. Stop
Summarize the spec in ≤ 5 lines, list the open questions, and ask for approval. **End your turn.** No code, no scaffolding, no "quick start" on task 1. Implementation starts with `/build` after the user approves.

Keep the spec alive: when a decision changes during the build, update `SPEC.md` first, then the code.

*Adapted from addyosmani/agent-skills `spec-driven-development` and `planning-and-task-breakdown` (MIT).*
