---
name: ml-paper-repro
description: Help reproduce a research paper end-to-end using existing PyTorch scaffolding. Use when working in a paper-reproduction repo (the user is implementing a paper's method, matching reported numbers). Anchors changes to specific paper sections/equations and runs smoke tests before full training.
---

# ml-paper-repro

Reproduce a paper faithfully, with paper-anchored decisions and smoke-tested changes. Designed for the kind of work in CENG 502 / Guided / similar paper-repro projects.

## Steps

1. **Locate the paper.** Look for a PDF in the project root. If absent, ask the user for an arxiv link or paper title. Read it once, summarize **into CLAUDE.md** (key contributions, architecture, loss, training recipe, key numbers to match), then don't re-read it — re-read your summary instead.

2. **Map paper → code.** For each major component (model, loss, dataset, training loop, eval), find where it lives in the existing repo. Use the **Explore subagent** for "where is X" questions; do not grep in main context.

3. **Identify gaps.** Make a numbered list:
   - Components that exist and look correct.
   - Components that exist but diverge from the paper.
   - Components missing entirely.
   
   For each gap, cite the paper section/equation it relates to.

4. **Propose a plan.** Smallest unit of work first — no "rewrite the model from scratch" energy. Each task should be:
   - Anchored to a paper section (e.g. *"Match attention dropout schedule from §4.2"*)
   - Verifiable (e.g. *"shape check passes"* or *"smoke run loss decreases over 10 steps"*)
   - Reversible (one clear file diff, not a refactor)

5. **Smoke test before full runs.** Before any non-trivial training run, do a tiny version:
   - 1 epoch (or 50 steps), tiny batch, small subset of data
   - Confirm: loss decreases, gradients flow, no NaN/Inf, eval pipeline produces a number
   
   Only then propose a full run. Never propose a 12-hour training run without a smoke test passing first.

6. **Track reproduction targets.** Maintain a small table in CLAUDE.md:
   ```
   | Metric | Paper | Ours | Notes |
   |---|---|---|---|
   | Top-1 acc | 82.3% | TBD | |
   ```
   Update as runs complete.

## Hard rules

- Never read raw datasets (ImageNet, etc.). Reference the path, don't open files.
- Never read model checkpoints (`*.pth`, `*.ckpt`, `*.safetensors`).
- Never read `wandb/`, `outputs/`, `logs/`, `runs/` — they're noisy, large, and stale.
- For paper-faithful changes, **cite the paper section/equation** in commit messages and CLAUDE.md.
- If a paper detail is ambiguous (common!), ask the user how to interpret it rather than guessing — paper repros fail on these tiny choices.

## What "done" looks like

Reproduction is "done" when:
- The smoke test passes for every component.
- A full run produces the key metric within ~1% of the paper (or the gap is documented with a hypothesis).
- CLAUDE.md has the metric table filled in.
