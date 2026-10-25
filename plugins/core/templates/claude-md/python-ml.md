# {{ProjectName}}

{{One line. Paper repro: title, authors, venue/year, arXiv link.}}

## Stack
- Python {{version}}, PyTorch {{version}} on {{CUDA x / MPS / CPU}}
- Key libs: {{timm / transformers / einops / hydra / wandb / …}} · Env: {{uv / venv / conda / poetry}}

## Map
- `{{src/models}}/` — models · `{{src/data}}/` — datasets & transforms
- `{{train.py}}` / `{{eval.py}}` — entry points · `{{configs/}}` — {{hydra / yaml / argparse}}
- `{{notebooks/}}` — exploration (assume stale)

## Data
- `{{path}}` — {{format, size}}. Never open raw data files; reference paths only.

## Commands
- Setup: `{{uv sync / pip install -r requirements.txt}}`
- Smoke run (always first): `{{train cmd with 1 epoch / 50 steps / tiny batch}}`
- Full train: `{{cmd}}` · Eval: `{{cmd}}`

## Reproduction targets
| Metric | Paper | Ours | Notes |
|---|---|---|---|
| {{metric}} | {{value (Table N)}} | TBD | |

## Conventions
- {{Seeds}} · {{Checkpoint format + location}} · {{Logging: wandb / tensorboard}} · {{AMP / DDP}}

## Working with Claude here
- Paper work: `ml-paper-repro` skill. Anchor changes to paper sections/equations and cite them.
- Never propose a long run without a passing smoke run. Crashes in training → `pytorch-build-resolver` agent; correctness review → `ml-reviewer` agent.
- "Where is X implemented" → **Explore** subagent.
- Working rules: `.claude/rules/` (core + Python, path-scoped).

## Don't read
Hard blocks (weights, datasets, wandb/mlruns, checkpoints, secrets) are in `.claude/settings.json`. Also skip unless asked:
- `.venv/`, `outputs/`, `logs/`, `runs/`, notebook outputs
- Paper PDF after the first read — use the summary above instead
- {{Project-specific data dirs}}
