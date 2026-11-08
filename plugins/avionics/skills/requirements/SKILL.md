---
name: requirements
description: Use when writing, reviewing or tracing DO-178C requirements (HLR, LLR) or DO-330 tool requirements (TOR, TR), checking trace between requirements, code and tests, or exporting requirements for DOORS (CSV / ReqIF). Not for feature plans or product specs — that's spec.
---

# requirements

One requirement = one ID, one verifiable "shall", at least one parent (or flagged as derived). This skill writes them, checks them, and exports them.

## 0. Conventions first
- Look for an existing set: `requirements/`, `reqs/`, `*.csv` / `*.reqif` exports, DOORS dumps, and the plans (PSAC/SDP/SVP for the software, TQP for the tool). Match their ID scheme, attributes and wording exactly. If nothing exists, ask once, then use the defaults below.
- Default IDs: `<PROJ>-HLR-NNN`, `<PROJ>-<COMP>-LLR-NNN`, `<TOOL>-TOR-NNN`, `<TOOL>-TR-NNN` (three digits, zero-padded).
- IDs are permanent: never reuse or renumber. A removed requirement gets status `Deleted` and its ID is retired.

## 1. Levels
| Level | Standard | Says | Parent | Verified by |
|---|---|---|---|---|
| HLR | DO-178C | what the software does | system requirement | requirements-based tests |
| LLR | DO-178C | how a component does it — detailed enough to code from without more information | HLR | low-level (unit) tests, plus review/analysis |
| TOR | DO-330 | what the tool must do in its operational environment: inputs, outputs, options, error handling | the qualification need in the PSAC / TQP | tests in the operational environment |
| TR | DO-330 | the tool's functional requirements | TOR | tool tests |

How deep the tool levels go depends on the TQL (the less rigorous TQLs need only TORs; the stricter ones add tool requirements and, below them, tool design / low-level requirements). Confirm against the Tool Qualification Plan before writing them.

**Derived** requirements (not traceable to a parent: design decisions, robustness, partitioning) get `Derived = Y` plus a rationale, and must be passed to the system safety assessment. Never invent a parent to avoid the flag.

## 2. Writing rules — check every requirement
- Exactly one "shall". An "otherwise …" branch or an "… and shall not change X" is a requirement of its own: split it, and check every row for a second "shall" before writing the file.
- No "and/or", "etc.", "as appropriate", "user-friendly", "fast", "robust", "support", "handle", "minimize", "if possible".
- Verifiable: a test, analysis, review or inspection gives pass or fail. Quantify: units, ranges, tolerances, timing, rates, states.
- Pattern: *When <condition/mode>, the <component> shall <response> [within <time>].*
- HLR and TOR say *what*; LLR and TR may say *how* (data, algorithm, sequence) — but no code.
- Abnormal cases are requirements too: out-of-range or invalid input, timeouts, failures, resets. Each gets its own requirement.
- Same names everywhere: signals, modes and units from the project glossary / ICD.

## 3. Attributes (defaults — use the project's set if it has one)
`ID` · `Text` · `Parent` (`;`-separated) · `Verification Method` (Test / Analysis / Review / Inspection) · `Derived` (Y/N) · `Derivation Rationale` (required when Y) · `Safety Related` (Y/N) · `Change Ref` · `Status` (Draft / Reviewed / Released / Deleted)

## 4. Trace check — on review, and after adding a batch
Grep, don't guess:
```bash
grep -rhoE '[A-Z][A-Z0-9]*(-[A-Z0-9]+)*-(HLR|LLR|TOR|TR)-[0-9]+' --include='*.[ch]' --include='*.[ch]pp' --include='*.cc' . | sort | uniq -c
```
- **Up:** every LLR → an existing HLR; every TR → an existing TOR; no dangling parent IDs (derived ones are flagged instead).
- **Down:** every HLR has ≥ 1 LLR, or a note why (allocated to hardware, implemented by generated code, …). Every TOR has ≥ 1 TR, at the depth the TQL needs.
- **Code:** every `Implements: <ID>` tag names an existing LLR/TR, and every LLR/TR is implemented somewhere.
- **Tests:** every LLR/TR is named by ≥ 1 test.
Report a short table — `ID · problem · fix` — and stop there. Fix only what the user asks for.

## 5. Export for DOORS
- **CSV** (DOORS Classic spreadsheet import; DOORS Next also reads it): format rules in `references/doors-csv.md`.
- **ReqIF 1.2** (DOORS Next, or Classic's ReqIF import): fill `references/reqif-skeleton.xml`.
- Read the reference only when exporting. Write exports with a script (Python `csv` / an XML writer), never by hand, to `requirements/export/` or the project's location. The requirement source file is the single source of truth — regenerate exports, never edit them.

## 6. Output
- Write to the project's requirement source (e.g. `requirements/llr.csv`): one row per requirement, in ID order.
- Show the user a table of the new/changed requirements, any derived ones with their rationale, and anything open (unknown parents, unquantified values). Ask rather than inventing a parent or a number.
