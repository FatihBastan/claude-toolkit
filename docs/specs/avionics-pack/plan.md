# Plan: `avionics` pack

Order: the rules first (they're the core of the change and fix the `cpp` clash), then the pack, then init-repo wiring, then docs and the eval. Each task ends in a commit on branch `avionics-pack`.

## Task 1: Path-scoped rules — `safety-c`, `qualified-tool`, `qt`
Acceptance:
- [ ] `qt.md` states it overrides `cpp.md`'s "no raw `new`" bullet for QObject parent ownership (both apply to `editor/**`).
- [ ] Three files in `plugins/core/rules/`, each ≤ ~15 bullet lines, with placeholder `paths:` (`runtime/**/*.{c,h}`, `codegen/**/*.{cpp,cc,h,hpp}`, `editor/**/*.{cpp,h,hpp,ui}`), commented as "init-repo rewrites these".
- [ ] No MISRA rule text, only rule numbers. Nothing company-specific.
Verify: frontmatter parses (python yaml) · word count per file · `scripts/validate.sh`
Files: `plugins/core/rules/safety-c.md`, `qualified-tool.md`, `qt.md`

## Task 2: Green Hills + Qt settings fragments
Acceptance:
- [ ] `green-hills.json` denies `*.o`, `*.elf`, `*.dbo`, `*.dla`, `*.dnm`, `*.bin` — **not** `*.map`.
- [ ] `qt.json` denies `moc_*.cpp`, `ui_*.h`, `qrc_*.cpp`, `*_autogen/`, and build dirs (`build/`, `build-*/`, `cmake-build-*/`).
Verify: `python3 -m json.tool` · `scripts/validate.sh`
Files: `plugins/core/templates/settings/green-hills.json`, `qt.json`
Depends on: —

**Checkpoint A:** validate passes; rules render.

## Task 3: `avionics` plugin + `requirements` skill
Acceptance:
- [x] Covers DO-178C HLR/LLR **and** DO-330 TOR/TR.
- [x] `plugins/avionics/skills/requirements/SKILL.md` with a "Use when … / Not for …" description (≤ ~300 chars), a body ≤ ~120 lines, and `references/doors-csv.md` + `references/reqif-skeleton.xml` loaded only when exporting.
- [x] `plugins/avionics/routing.md` holds the one routing line.
- [x] Marketplace entry `avionics` with `defaultEnabled: false`; `plugins/core/packs/avionics` symlink.
Verify: `scripts/validate.sh` · `claude plugin details avionics@fatih-toolkit` ≤ 0.15k always-on · install from a local copy and check the skill is listed
Files: `plugins/avionics/**`, `.claude-plugin/marketplace.json`, `plugins/core/packs/avionics`
Depends on: —

## Task 4: init-repo wiring
Acceptance:
- [x] Detection rows: `*.gpj` **or the `avionics` argument** → avionics + `safety-c` + `green-hills`; Qt (`find_package(Qt6`/`Qt5`, `*.pro`) → `cpp` + `qt` + `qt.json`.
- [x] Path rewriting: `safety-c` → runtime dir, `qualified-tool` → asked tool dir, `cpp` → editor + codegen dirs only, `qt` → editor dir. An explicit "no rule on the runtime dir except `safety-c` + `core`" check.
- [x] Pack routing: the lines from each enabled pack's `routing.md` are appended under "## Skill routing" in the repo's `core.md`, re-applied on `refresh`, **idempotent** (running twice adds nothing).
- [x] Portable copy list includes `avionics → requirements` (+ references).
Verify: `plugins/core/scripts/rule-scopes.py` (new, tiny) reports which rules hit which files; dry-run the mechanical steps on a fake repo, run the routing insert twice (no duplicates); (`runtime/app.gpj` + `.c`, `editor/CMakeLists.txt` with `find_package(Qt6`, `codegen/`): the resulting `.claude/rules/*` globs don't overlap on `runtime/**` · validate
Files: `plugins/core/skills/init-repo/SKILL.md`, `plugins/core/scripts/add-routing.py`
Depends on: Tasks 1–3

**Checkpoint B:** a fake repo gets exactly the intended rule set per dir.

## Task 5: README, NOTICE
Acceptance:
- [x] README pack table row (measured cost) + a layout line; NOTICE line: MISRA/RTCA standards referenced by number only, no text reproduced.
Verify: read-through · validate
Files: `README.md`, `NOTICE.md`
Depends on: Task 3

## Task 6: Eval case `requirements-llr`
Acceptance:
- [ ] `plugins/avionics/evals/requirements-llr/`: scaffold with a small C function + 2 parent HLRs; prompt "write the LLRs for this function, CSV for DOORS"; `append_system_prompt` carries the routing line in both arms.
- [ ] Graders: unique-ID regex; one "shall" per row (llm); every row has a parent HLR ID (regex on CSV); verification-method column present; `Skill` indicator (with-only).
- [ ] Run: 3 runs per arm, Sonnet, `--max-cost-usd 2` (≈ $0.5 expected, ≈ 0.75M tokens). Record the result in `plugins/avionics/evals/RESULTS.md`.
Verify: the eval run itself; the guards in core aren't affected (no core change)
Files: `plugins/avionics/evals/**`
Depends on: Task 3

## Task 7: Ship
Acceptance:
- [ ] Move `SPEC.md` + `tasks/plan.md` to `docs/specs/avionics-pack/` (keeps the root clean); open a PR; merge on your OK.
Verify: validate · PR diff review
Depends on: Tasks 1–6
