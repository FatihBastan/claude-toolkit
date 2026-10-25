---
name: tdd
description: Red-Green-Refactor TDD discipline. Write the failing test first, watch it fail, write minimal code to pass, refactor. Use for any new feature, bug fix, or behavior change where the project has a test runner. Skip for throwaway scripts, prototypes, or generated code.
---

# tdd

Write the test first. Watch it fail. Write the minimal code to pass. Then clean up.

The hard rule: **if you didn't see the test fail, you don't know if it tests the right thing.** A test written after the code passes immediately — that proves nothing.

## The loop

1. **Red — write one failing test.** One behavior, clear name, real code (no mocks unless unavoidable). Run it. Confirm it fails *for the right reason* (feature missing — not a typo, not an import error).
2. **Green — write the minimum code to pass.** No extra features, no "while I'm here" refactors. Run it. Confirm only this test went green and nothing else broke.
3. **Refactor — clean up.** Rename, dedupe, extract helpers. Don't add behavior. Tests stay green.
4. **Repeat** for the next behavior.

If the loop ever skips step 1 or step 2's verification, you're not doing TDD — you're writing code and hoping.

## When the user signals a bug fix

Bug fix means: **write a failing test that reproduces the bug, watch it fail, then fix the code until it passes.** Never patch the bug and add a test afterward. The test must prove the fix works *and* lock in a regression guard.

## When to skip

- Throwaway exploration / spike code (then *delete* it and start TDD fresh — don't keep the spike as "reference" while writing tests, you'll bias toward it).
- Generated code, config files, pure data.
- The project genuinely has no test runner. Say so out loud — don't silently skip.

## Anti-patterns

- **"I'll add tests after."** Tests written after code pass immediately. That's not coverage; it's theater.
- **"Manual test was fine."** Ad-hoc isn't repeatable. Next change, you re-test by hand.
- **"Just one test, the rest later."** No. Each behavior gets its own loop.
- **Over-engineering green-phase code** with options/flags the test doesn't exercise. YAGNI.
- **Mocking everything.** If the code can't be tested without mocking out half the world, the design is too coupled — fix the design, not the test.

## When stuck

- Don't know how to write the test → write the *wished-for* API first, assertions before code. Then build to satisfy it.
- Test feels enormous → the unit under test is too big. Shrink it.
- Test needs huge setup → extract setup helpers, but if it's still painful the design is the problem.

## Hard rule

```
No production code without a failing test first.
```

If the user says "skip TDD just this once," confirm out loud before proceeding. That sentence is almost always rationalization.
