---
paths:
  # init-repo rewrites this to the DO-330 qualified tool's dir (source + tests)
  - "codegen/**/*.{c,cc,cpp,cxx,h,hh,hpp,hxx}"
---
# Qualified tool code (DO-330)

This tool's output goes into airborne software, so its behaviour must be specified, deterministic and tested. Applies on top of `cpp.md`.

- Deterministic: the same input and options give byte-identical output on every run and machine. No timestamps, no ordering from hash maps, pointers or directory listings, stable sorts only, no locale-dependent formatting, no absolute paths in the output.
- Fail loudly: on any error, report it with the input location, exit non-zero, and leave no partial output (write to a temp file, rename at the end).
- Validate every input (models, options, config) against its specification; reject anything unspecified instead of guessing.
- No new third-party dependency (library, generator, script) without explicit approval — it becomes part of the qualification.
- Every tool requirement has at least one test, and each test names the requirement IDs it verifies (test name or tag). Code that implements a requirement cites its ID in a comment.
- No hidden behaviour: every option and transformation is in the tool requirements — no undocumented flags or environment-variable switches.
- Generated files carry the tool version and an input checksum in their header (never a build date), and say which input element produced each emitted unit.
