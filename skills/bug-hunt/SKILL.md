---
name: bug-hunt
description: Systematic debugging methodology. Investigate root cause before proposing any fix; change one thing at a time; after three failed fixes, step back and question the design instead of patching. Use whenever the user reports a bug, a test fails unexpectedly, or production behavior diverges from intent.
---

# bug-hunt

The first rule: **no fixes without root-cause investigation.** Patching the symptom without understanding the cause produces a fix that holds for ten minutes and a related bug a week later.

## Phase 1 — Understand the symptom

1. **Read the actual error.** Full message, full stack trace. Don't paraphrase it back to yourself.
2. **Reproduce it reliably.** If you can't trigger it on demand, you can't verify a fix. If it's flaky, that *is* the bug — investigate the non-determinism.
3. **Check recent changes.** `git log -p` on the affected file. New bugs usually live in new commits.
4. **Gather evidence at boundaries.** What goes in, what comes out, what state mutates between. Multi-component systems: log at every hand-off.

## Phase 2 — Find the diff

Locate similar code that *works*. Compare carefully against the broken code. The bug is almost always in the difference, and the difference is almost always smaller than you think.

## Phase 3 — Hypothesize, then test

State the hypothesis out loud: *"I think X causes Y because Z."* Change **one variable** to test it. Multi-variable changes invalidate the experiment — you won't know which one moved the needle.

If the hypothesis was wrong, that's data. Update and try again. Don't shotgun fixes.

## Phase 4 — Write the test, then fix

Once you have a reliable repro, encode it as a failing test (use the [[tdd]] loop). Fix until green. Now the bug is locked out by a regression guard.

## Phase 5 — Trace to the root, not just the symptom

If the error fires deep in a call chain, the fix probably belongs higher up. See [[root-cause]] for the explicit trace-back method. Patching only where the error surfaces ("validate this here too") is symptom treatment — useful as defense in depth, not as the primary fix.

## The three-strike rule

After **three failed fix attempts** on the same bug, stop. Don't try a fourth. Step back and ask:

- Am I solving the wrong problem? (Re-read the error.)
- Is the architecture forcing this bug? (Same shape bug keeps recurring → design issue, not implementation.)
- Should this code exist at all? (Sometimes the answer is delete.)

Recurring bugs in unrelated areas of the same system usually mean the architecture is wrong, not the code.

## Anti-patterns

- **Proposing the fix before investigating.** "Maybe try X" before you've read the stack trace = guessing.
- **Multiple simultaneous changes.** One variable per experiment, always.
- **Wrapping the symptom in try/catch.** That's hiding the bug, not fixing it.
- **Adding `if (x == null) return` without asking why x is null.** The null came from somewhere — find it.
- **"It works on my machine."** Investigate the environment diff. Don't ship until you understand why.

## Output expectation

When reporting a fix, the user wants three things:
1. **What was the root cause** (one sentence).
2. **What you changed** (file paths + line numbers).
3. **The test that locks it in.**

Skip 1 and the fix won't stick. Skip 3 and the bug returns.
