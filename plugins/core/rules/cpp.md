---
paths:
  - "**/*.{c,h}"
  - "**/*.{cc,cpp,cxx,hh,hpp,hxx}"
---
# C / C++

- Follow the existing standard and style (check `CMAKE_CXX_STANDARD`, `.clang-format`). C files stay C.
- C++: RAII; smart pointers and standard containers instead of raw `new`/`delete`, `malloc`/`free` and C arrays; `const`/`constexpr` by default.
- Bounds and lifetimes: no unchecked indexing from external input; watch iterator/reference invalidation; never return references to locals.
- Use fixed-width integer types (`uint32_t`, …) for protocol and hardware data; watch signed/unsigned mixing and overflow.
- Concurrency: shared state behind a mutex or atomics; make thread ownership explicit.
- Build with warnings on (`-Wall -Wextra`) and don't silence warnings without a reason. Reach for ASan/UBSan when chasing memory bugs.
- Embedded / real-time code: no heap allocation or blocking calls in ISRs or hot loops unless the code already does it; go through the existing HAL/driver layers.
- Never edit generated code or vendored SDKs.
