# Spec: `avionics` pack

## Objective
Make the toolkit safe and useful for a DO-178C project: a VAPS-like HMI display tool with three parts, each under different rules:

| Part | Language | Assurance | Rules that must load |
|---|---|---|---|
| Editor | Qt 6 / C++ | not airborne, not qualified | `cpp` + `qt` |
| Code generator CLI | C++ | DO-330 qualified tool (TQL TBD) | `cpp` + `qualified-tool` |
| Runtime | MISRA C on INTEGRITY (MULTI `*.gpj`) | DO-178C airborne (DAL TBD) | `safety-c` **only** |

Today `rules/cpp.md` globs `**/*.{c,h}` and says "smart pointers, no raw `new`, `malloc`/`free` → containers". That's wrong for airborne C and contradicts Qt's parent-ownership idiom.

## Success criteria
1. In an avionics repo, the runtime's `.c`/`.h` files load `safety-c` and **not** `cpp`. Editor files load `cpp` + `qt`, and codegen files load `cpp` + `qualified-tool`. No rule's `paths:` overlaps another's in a way that gives contradictory guidance.
2. `/core:init-repo` on a repo with `*.gpj` + a Qt `CMakeLists.txt`/`*.pro` enables the avionics pack, copies the right rules with paths rewritten to the real dirs, and adds the `green-hills` deny fragment — asking only for what it can't detect (the qualified-tool dir).
3. The `requirements` skill produces HLR/LLR/tool requirements with unique stable IDs, exactly one verifiable "shall" each, a parent trace, a verification method and a derived flag — and exports CSV and ReqIF that DOORS can import.
4. Non-avionics repos pay **zero** extra always-on tokens. Avionics repos pay ≈ 0.1–0.15k (one skill description + one routing line). Rules load only when Claude touches matching files.
5. `scripts/validate.sh` passes. One eval case shows the `requirements` skill beats plain Claude on requirement quality (≥ +0.3 Δ, 3 runs per arm, Sonnet, ≈ $0.5).

## Scope
**In**
- `plugins/core/rules/safety-c.md`, `qualified-tool.md`, `qt.md`. They sit next to `cpp.md`, so init-repo copies all rules from one place.
- `plugins/core/templates/settings/green-hills.json`.
- `plugins/avionics/`: the `requirements` skill (+ `references/` for the CSV columns and a ReqIF skeleton, loaded on demand) and `routing.md` (its one skill-routing line).
- Marketplace entry (`defaultEnabled: false`) and the `core/packs/avionics` symlink.
- init-repo: detection rows, path rewriting, no-overlap rule, pack routing line, portable copy list.
- README table + layout, NOTICE note, one eval case, RESULTS.

**Out:** a CLAUDE.md template for avionics (`base` is enough for now); agents (a MISRA checker belongs to the real static analyser, not an LLM); any MISRA rule text; INTEGRITY/MULTI API docs; a tool-qualification plan or other lifecycle documents.

## Design notes
- **Rule content (≤ ~15 lines each, imperative):**
  - `safety-c`: MISRA C:2012 (+ amendments), deviations only with a rule number + documented justification; no dynamic memory after init; no recursion; every loop has a provable fixed bound; `<stdint.h>` fixed-width types; no `<stdio.h>`; `volatile` for HW registers; every function header traces to an LLR ID (`Implements: <LLR-ID>`); write for MC/DC-reachable structure (simple decisions, no logic hidden in macros); generated code is never hand-edited — change the generator or its input; the project's own coding standard wins where it's stricter.
  - `qualified-tool`: deterministic, byte-identical output (no timestamps, no hash/pointer iteration order, stable sorts, no locale or absolute paths); fail loudly — non-zero exit and no partial output on any error; validate every input; no new third-party dependency without approval; every tool requirement has ≥ 1 test, and requirement IDs appear in code comments and test names/tags; generated code is traceable back to its input.
  - `qt`: parent-owned `new QWidget(parent)` is correct (the object tree deletes it — don't wrap it in smart pointers or `delete` it); `deleteLater()` for live QObjects; new-style `connect` (function pointers); keep Qt types at the UI boundary; never edit or read `moc_*`, `ui_*.h`, `qrc_*`.
- **Path ownership (init-repo):** runtime dir → `safety-c`; codegen dir → `qualified-tool`; `cpp` gets rewritten to the C++ dirs only (editor + codegen) instead of `**`; `qt` → editor dir. Rules have no negative globs, so the overlap is avoided by listing dirs, not by excluding them.
- **Detection:** `*.gpj` → avionics pack + `safety-c` (runtime dir = the dir holding the top-level `.gpj` or its source tree); `find_package(Qt6`/`Qt5` in `CMakeLists.txt`, or `*.pro` → `cpp` + `qt` for that dir. The qualified-tool dir can't be detected → ask (default guess: the non-Qt C++ target dir, e.g. `codegen/`, `tools/`).
- **Routing:** descriptions alone don't trigger skills (evals). The pack ships `routing.md` with one line (`requirements` for writing/reviewing HLR/LLR/TOR, trace checks, DOORS export). init-repo appends it under "Skill routing" in the repo's `.claude/rules/core.md` and re-applies it on `refresh`. That works in both plugin and portable mode, and the core rule stays free of avionics text.
- **`requirements` skill:** follow the project's existing ID scheme and DOORS attributes when they exist (ask once); default `<PROJ>-HLR-NNN` / `<PROJ>-<COMP>-LLR-NNN` / `<TOOL>-TOR-NNN` / `<TOOL>-TR-NNN`. Default attributes: ID, Text, Parent ID(s), Verification method (test / analysis / review / inspection), Derived (Y/N) + rationale, Safety-related (Y/N), Change ref, Status. Includes a quality checklist (no "and/or", no vague words, quantified, one shall) and a trace check (orphans, untested reqs, `Implements:` tags in code vs requirement set). Exports: CSV (UTF-8, one row per requirement) and ReqIF 1.2 skeleton. IDs are never reused or renumbered.
- **Delivery:** the target is likely a closed network → **portable mode** is the default for these repos (rules/skills copied in, no GitHub marketplace needed).

## Boundaries
- **Always:** cite MISRA rules by number only; keep every rule file short and path-scoped.
- **Ask first:** changing `cpp.md`'s default globs for non-avionics repos (not planned — only avionics repos get rewritten paths).
- **Never:** reproduce MISRA/DO-178C/DO-330 text; put company-internal names, IDs or attributes into the toolkit (defaults stay generic).

## Open questions
1. DOORS flavour — Classic (CSV import) or DOORS Next (ReqIF)? Plan: both exports, CSV first.
2. Deny `*.map`? You asked for it. Map files are sometimes needed for memory/stack-usage analysis — keep it denied, or move it to "Don't read" (soft skip)?
3. OK that the rules live in `core/rules/` next to `cpp.md` (one place for init-repo to copy from), while the skill + routing live in `plugins/avionics/`?
4. ID default: generic `<PROJ>-HLR-NNN` style, with init-repo asking for the real scheme — fine?
