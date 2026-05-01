# {{ProjectName}}

{{One-line description. If reproducing a paper, include: title, authors, venue/year, arxiv link.}}

## Stack

- Python {{version}}
- PyTorch {{version}} {{+ CUDA / MPS / CPU}}
- Key libs: {{timm, transformers, torchvision, einops, hydra, wandb, etc.}}
- Env manager: {{venv / conda / uv / poetry}}

## Map

- `{{models/ | src/models/}}` — model definitions
- `{{data/ | src/data/}}` — dataset loading & preprocessing
- `{{train.py | src/train.py | scripts/train.py}}` — training entrypoint
- `{{eval.py | scripts/eval.py}}` — evaluation
- `{{configs/}}` — {{Hydra configs / argparse / YAML}}
- `{{notebooks/}}` — exploration (don't read by default — assume stale)
- {{any other top-level dirs}}

## Data

- Location: `{{path}}` ({{format, approximate size}})
- Don't read raw data files — they're listed under "Don't read" below.
- Schema / class list: {{path to a schema file or README section}}

## Commands

- Setup: `python -m venv .venv && source .venv/bin/activate && pip install -r requirements.txt`
- Train (smoke test): `{{cmd with 1 epoch / small batch}}`
- Train (full): `{{cmd}}`
- Eval: `{{cmd}}`
- {{Notebook server / wandb sync / etc.}}

## Reproduction targets

{{If reproducing a paper, list the key numbers you're trying to match. Example:
- ImageNet-1k top-1 acc: 82.3% (paper Table 2)
- Robustness under FGSM ε=4/255: 41.2% (paper Table 5)}}

## Conventions

- {{Random seed handling}}
- {{Checkpoint format & where saved}}
- {{Logging: wandb / tensorboard / stdout}}
- {{Mixed precision / DDP / single-GPU}}

## Working with Claude in this repo

- For paper-faithful changes, anchor edits to specific equations, sections, or paper Table/Figure references.
- Run smoke tests (1 epoch, tiny batch) before full runs — never propose a 12-hour training run untested.
- For "where is X implemented" questions, spawn the **Explore subagent**.
- Don't iterate inside `.venv/` or any data folder.

## Don't read

- `.venv/`, `venv/`, `__pycache__/`, `*.pyc`, `.ipynb_checkpoints/`
- `wandb/`, `outputs/`, `logs/`, `runs/`, `checkpoints/`, `lightning_logs/`
- Model weights: `*.pth`, `*.ckpt`, `*.safetensors`, `*.onnx`, `*.bin`, `*.h5`, `*.pkl`
- Datasets: `*.npy`, `*.npz`, `*.parquet`, `*.arrow`, `*.feather`, `*.tfrecord`
- Bulk image dirs: `imagenet_val/`, `data/raw/`, `datasets/`
- {{Paper PDFs after first read — re-summarize in CLAUDE.md instead of re-reading}}
- {{Project-specific large dirs}}
