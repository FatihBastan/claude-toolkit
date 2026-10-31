---
name: interview
description: Use when a request is too vague to build well — missing who it's for, why, what success looks like, or the key constraint ("build me X", "make it faster"): ask one question at a time with a best guess until the goal is clear.
argument-hint: "<the ask>"
---

# interview

The ask: $ARGUMENTS (if empty, the request being discussed)

What people ask for and what they want differ. The cheapest moment to find the gap is before anything exists. Needs a live user — in an unattended run, list the open questions as blockers instead.

## 1. Hypothesis + confidence
Write your current read in one sentence plus an honest confidence number. Below ~70%, say what's missing:
```
HYPOTHESIS: You want a quick way to see "are we on track?" in standup; "dashboard" is the convention that came to mind.
CONFIDENCE: ~30% — missing: who reads it, what success looks like
```

## 2. One question at a time, each with a guess
```
Q: <one focused question>
GUESS: <your best answer, and why>
```
Wait for the answer before the next question. The user reacts to a wrong guess faster than they write an answer from scratch, and each answer changes what the next question should be. Now and then guess in a direction you expect them to push back on, so they don't just agree to be polite.

Cover, in roughly this order: who it's for → why now → what success looks like (a number or an observable behaviour) → the binding constraint (time, platform, budget, performance) → what's out of scope.

## 3. Watch for "should want"
Best-practice talk without specifics ("scalable", "clean", "the standard way") hides the real goal. Ask: *"If you didn't have to justify this to anyone, what would you actually want?"*

## 4. Stop and restate
Stop once you could predict their next three answers (~95% confidence), or after ~7 questions — then say what's still uncertain. Restate in their words:
```
Outcome:      …
For:          …
Why now:      …
Success:      …
Constraint:   …
Out of scope: …
Yes / no / refine?
```
After a "yes", hand off to the spec skill for features, or just do it if it's small.

*Adapted from addyosmani/agent-skills `interview-me` (MIT).*
