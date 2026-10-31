# Eval results — 2026-10-29

`claude plugin eval` (Claude Code 2.1.310), run in a Linux cloud sandbox. **WITH** = core plugin loaded, **W/OUT** = plain Claude Code, **Δ** = the difference. Scores are the share of graders passed, averaged over runs. `tool_used: Skill` checks are indicators only and aren't scored, so they can't inflate Δ.

## Sonnet 5.5 (default model) — 3 runs per arm

| Case | What it checks | WITH | W/OUT | Δ |
|---|---|---|---|---|
| spec-feature | multi-file feature → spec + plan, stops for approval | 1.00 | 0.11 | **+0.89** |
| vague-interview | "make me a game" → one question with a guess, no building | 0.67 | 0.00 | **+0.67** |
| tdd-order | test written and run before the code | 1.00 | 0.56 | **+0.44** |
| bug-root-cause | fix at the origin (wrong config key), regression test, tests run | 1.00 | 0.67 | **+0.33** |
| web-research | multi-source version research with sources | 0.67 | 0.44 | +0.22 ⚠ |
| small-fix-no-spec | guard: a rename must not trigger spec | 1.00 | 1.00 | 0 ✅ |
| question-no-skill | guard: a question gets an answer, no skill, no edits | 1.00 | 1.00 | 0 ✅ |

Mean Δ **+0.37**. Cost per run is ~10–40% higher with the plugin (skill bodies and extra test runs). Total spend for this run: $3.51 at list price.

## Opus — 2 runs per arm

| Case | WITH | W/OUT | Δ |
|---|---|---|---|
| vague-interview | 0.75 | 0.00 | **+0.75** (and ~3× cheaper: no game gets built) |
| spec-feature | 0.67 | 0.33 | **+0.33** (1 of 2 runs still coded straight away) |
| tdd-order | 1.00 | 0.67 | **+0.33** |
| bug-root-cause | 1.00 | 0.75 | **+0.25** |
| web-research | 0.33 | 0.50 | −0.17 ⚠ |
| guards (both) | 1.00 | 1.00 | 0 ✅ |

Mean Δ **+0.21**. $5.25 at list price.

## Rules A/B (`scope-rules-on` vs `scope-rules-off`, Sonnet, 3 runs)
The same off-by-one fix next to ugly-but-working code, with and without the rest of `core.md` in the system prompt. **Both scored 1.00** (fixed, nothing else touched, verification reported); the rules only added cost ($0.136 vs $0.087 per run). On this task, today's models already keep scope without being told.

## What changed because of these evals
- **`core.md` was trimmed** to the skill routing plus a few safety and context lines (about half the words: 735 → 358), because the general rules showed no effect. `scope-rules-on` now carries the trimmed version.
- **Skill descriptions alone weren't enough.** In the first pass the plugin's skills were loaded but never used (spec 0×, interview 0×, web-researcher 0×), and Claude went straight to building. A "Skill routing" section — in `rules/core.md`, and printed by the core plugin's SessionStart hook in repos that don't have the rules yet — fixed it.
- **Firmer routing wording** ("first action is the Skill call, however small the codebase looks") moved spec from "I'll just implement it" to writing SPEC.md + tasks/plan.md and stopping. The two guard cases confirm it doesn't over-trigger.

## Caveats
- ⚠ **web-research isn't conclusive here**: this sandbox blocks npm and GitHub pages for WebFetch, so both arms work from search snippets. Re-run it locally.
- Eval runs load only the plugin, not repo files, so CLAUDE.md and `.claude/rules/` content is tested only through `append_system_prompt` (the rules A/B).
- Bash in this sandbox can't write to the workspace (the harness runs as root), so some runs couldn't execute the app. That affects both arms the same way.
- 2–3 runs per arm is a small sample; treat ±0.2 as noise.

## Re-run
From `plugins/core/`:
```bash
claude plugin eval . --tag workflow debugging tdd research --runs 3 -j 6 --scaffold --trust-plugin \
  --allow-tools Write Edit Bash WebSearch WebFetch --max-cost-usd 20
claude plugin eval . --tag rules --ablation none --runs 3 --scaffold --trust-plugin --allow-tools Write Edit Bash
```
Add `--model opus` to test Opus. Bash cases need a sandbox backend (`bubblewrap` + `socat` on Linux; built in on macOS).
