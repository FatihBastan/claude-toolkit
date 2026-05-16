---
name: root-cause
description: Trace a bug backward through the call chain to its original trigger, then fix at the source. Use when an error fires deep in execution and the immediate site is clearly not where the bad value originated (empty string passed five levels down, file written to wrong path, malformed input that should never have arrived).
---

# root-cause

The instinct when an error fires is to fix the line that throws. That's symptom treatment. The real fix is wherever the bad value, bad path, or bad call **first entered the system**. Trace backward until you find it.

## The trace

1. **Observe the symptom.** Capture the actual error: message, file, line, full stack trace.
2. **Find the immediate cause.** What line of code directly produced this error? What value was it operating on?
3. **Walk one level up.** Who called this function? With what arguments? Where did *those* come from?
4. **Repeat step 3.** Keep climbing until the bad value's origin is named — a constructor, a config read, a test fixture, a user input boundary.
5. **Fix at the origin.** Validate, reject, or correct it where it enters. The intermediate layers stay the same.
6. **(Optional) Add defense in depth.** Light validation at intermediate layers so the same class of bug can't recur via a different entry point.

## When you can't trace by reading

Instrument before the failing operation:

```ts
async function dangerousOp(path: string) {
  console.error('TRACE dangerousOp:', {
    path,
    cwd: process.cwd(),
    stack: new Error().stack,
  });
  // ...existing call...
}
```

Run, capture, read the stack. Look for the test name or call site that triggers the bad value. **Use `console.error`** in tests — most loggers get suppressed by the test harness.

## Common patterns

- **Empty string used as a path** → resolves to `process.cwd()` and writes to your source tree. Trace where the empty string came from; usually an uninitialized fixture or accessing a getter before `beforeEach` ran.
- **Bug fires only under certain test order** → shared mutable state. Trace which test mutates and never restores.
- **Bug fires in prod but not dev** → environment difference. Trace which env var or config branch differs.

## Fix at source — what that looks like

Bad value originates at `Project.create(name, dir)` where `dir` is `""`:

- **Symptom-only fix (wrong):** add `if (cwd === "") return` inside the `git init` wrapper deep in the stack.
- **Root-cause fix (right):** `Project.create` rejects `""` (or `setupCoreTest` exposes `dir` as a getter that throws when accessed pre-setup).
- **Plus defense in depth:** intermediate layers also reject empty strings, so the next way someone introduces this bug also gets caught loudly.

## Anti-patterns

- **Catching the exception where it fires** and returning a default. The bad value is still flowing through your system — you've just muted the alarm.
- **Stopping at the first plausible cause.** "It's `dir` being empty" is the immediate cause; "the test accesses tempDir before beforeEach" is the root.
- **Adding validation at every layer without fixing the source.** Defense in depth is a *supplement*, not a replacement. If the source still emits bad values, you're playing whack-a-mole forever.

## Hard rule

```
Never fix only where the error appears.
Find where the bad value first entered the system.
Fix it there.
```
