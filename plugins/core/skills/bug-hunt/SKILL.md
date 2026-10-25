---
name: bug-hunt
description: Systematic debugging — reproduce, find the root cause (tracing bad values back to where they entered), fix it there, lock it with a test. Use when a bug is reported, a test fails unexpectedly, or behaviour diverges from intent. After three failed fixes, stop and question the design.
---

# bug-hunt

First rule: **no fix without a root cause.** A symptom patch holds for ten minutes and comes back as a related bug a week later.

## 1. Understand the symptom
1. Read the actual error — full message and stack trace. Don't paraphrase it to yourself.
2. Reproduce it on demand. If you can't, you can't verify a fix. If it's flaky, the non-determinism *is* the bug.
3. Check recent changes: `git log -p -- <file>`. New bugs usually live in new commits.
4. Gather evidence at boundaries: what goes in, what comes out, what state changes in between. In multi-component systems, log every hand-off.

## 2. Find the difference
Find similar code that works and compare it closely with the broken code. The bug is almost always in the difference, and the difference is usually smaller than you think.

## 3. Hypothesize, then test one variable
Say it out loud: *"X causes Y because Z."* Change **one** thing to test it. A wrong hypothesis is data — update and try again. Never shotgun several changes at once.

## 4. Trace back to the origin
When the error fires deep in a call chain, the fix belongs where the bad value **first entered the system**, not where it exploded.
1. Name the immediate cause: which line failed, on what value.
2. Walk one level up: who called this, with what arguments, and where did *those* come from?
3. Repeat until you reach the origin — a constructor, a config read, a fixture, an input boundary.
4. Fix it there. Optionally add light validation at intermediate layers (defense in depth) — as a supplement, never instead of the fix.

Can't trace by reading? Instrument right before the failing operation (log the inputs, `cwd`, and `new Error().stack` / `traceback.print_stack()`), run, and read where the bad value came from. In tests, log to stderr — harnesses often swallow normal logs.

Common origins: an empty string used as a path (resolves to cwd), test-order dependence (shared mutable state), prod-only failures (an env/config branch that differs).

## 5. Lock it in, then fix
Turn the repro into a failing test (tdd loop), fix until green. Now a regression guard exists.

## The three-strike rule
After **three failed fixes** on the same bug, stop. Ask:
- Am I solving the wrong problem? Re-read the error.
- Is the architecture forcing this bug? The same shape recurring means a design issue.
- Should this code exist at all?

## Anti-patterns
- Proposing a fix before reading the stack trace.
- Wrapping the symptom in try/catch, or `if (x == null) return` without asking why x is null.
- Several changes in one experiment.
- "Works on my machine" — find the environment difference before shipping.

## Report
1. Root cause, in one sentence.
2. What changed (paths + lines).
3. The test that locks it in.
