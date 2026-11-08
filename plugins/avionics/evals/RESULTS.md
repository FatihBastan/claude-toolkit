# Eval results — 2026-11-08

`claude plugin eval` (Claude Code 2.1.316), Sonnet, 3 runs per arm, Linux cloud sandbox. **WITH** = avionics plugin loaded, **W/OUT** = plain Claude Code. Both arms get the same one-line routing row in the system prompt (what `/core:init-repo` adds to `core.md`), so the difference is the skill itself. `tool_used: Skill` is an indicator only, not scored.

Case `requirements-llr`: "Write the low-level requirements for runtime/src/watchdog.c … requirements/llr.csv, I'll import that into DOORS." The repo holds a 40-line C watchdog and two HLRs (`HMI-HLR-010/011`). The start-up state (flag shown from init) has no parent HLR, so it should come out derived.

## Run 1: both arms

| Grader | WITH | W/OUT |
|---|---|---|
| llr.csv written, code untouched | 3/3 | 3/3 |
| IDs follow the project's `HMI-…` scheme | 3/3 | 3/3 |
| every "shall" row has a parent HLR or is flagged derived | 3/3 | 3/3 |
| one "shall" per row | 2/3 | 3/3 |
| Verification Method column | 3/3 | 3/3 |
| **Derived column** | **3/3** | **0/3** |
| **start-up state flagged derived or raised with the user** (LLM judge) | **3/3** | **2/3** |
| **quality**: concrete values, robustness cases (bad CRC, counter wrap), no vague words (LLM judge) | **3/3** | **1/3** |
| Skill fired (indicator) | 3/3 | — |
| **Score** | **0.96** | **0.78** |

Δ **+0.19**. Cost: $0.19 per run with the skill vs $0.10 without (skill body + more requirements written); $0.86 in total.

Without the skill, Claude writes decent single-shall requirements but drops the DO-178C bookkeeping: there's no Derived attribute, one run silently traced the start-up state to `HMI-HLR-010`, and LLR numbers reuse the HLR range (`HMI-LLR-010` next to `HMI-HLR-010`).

## Run 2: WITH only, after a skill fix

Run 1's one failure was real: two rows of the form "shall increment …, and otherwise shall leave it unchanged". The skill now says to split an "otherwise …" or "… and shall not change X" into its own requirement and to check every row before writing the file.

| | Score | one "shall" per row | quality |
|---|---|---|---|
| WITH, 3 runs | **0.97** | 3/3 | 2/3 |

$0.40. The one quality FAIL was on a file that met every listed criterion (values, both robustness cases, derived rows with rationale). The judge seems to have applied the "restates the code line by line" clause, which is noisy for LLRs, since they're meant to be codeable. Read that grader's verdicts with this in mind.

Total spend: $1.25 at list price.
