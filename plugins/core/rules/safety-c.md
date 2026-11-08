---
paths:
  # init-repo rewrites this to the repo's runtime (airborne) dir
  - "runtime/**/*.{c,h}"
---
# Safety-critical C (DO-178C airborne code)

The only language rule for this code: `cpp.md` must not load here. Where the project's own coding standard is stricter, it wins.

- MISRA C:2012 with its amendments. A deviation needs the rule number and a recorded justification under the project's deviation procedure; never silence a finding.
- No dynamic memory after initialisation: no `malloc`/`calloc`/`realloc`/`free` in operational code. Allocate statically, or once during init if the project allows it.
- No recursion, direct or indirect.
- Every loop has a fixed, provable upper bound; state it in a comment when it isn't obvious from the code.
- Fixed-width types from `<stdint.h>` for anything whose size matters. Explicit casts; no implicit narrowing, no signed/unsigned mixing.
- No `<stdio.h>` and no other unbounded library calls; report through the platform's logging / health-monitoring path.
- `volatile` for memory-mapped registers and data shared with ISRs; ISRs stay short and never block.
- Every function's header comment names the LLR(s) it implements (`Implements: <LLR-ID>`). No code without a requirement — new behaviour starts with the requirements skill.
- Keep decisions simple enough for MC/DC: no logic hidden in macros, no side effects in conditions, every `switch` has `default`, every `if … else if` chain ends in `else`.
- Initialise every variable before use; check every return value, or cast it to `(void)` with a comment saying why it's safe.
- Generated code is never edited by hand: change the model/input or the generator, then regenerate.
- INTEGRITY: tasks, semaphores and memory through the kernel APIs; respect partition and address-space boundaries; no blocking call where the schedulability analysis doesn't allow one.
