---
name: token-budget
description: Audit the current project for what's likely burning input tokens with low accuracy benefit, and propose updates to CLAUDE.md's "Don't read" section and/or `.claude/settings.json` deny rules. Use when a project feels slow/expensive in Claude Code, or as a quick health check on a fresh repo.
---

# token-budget

Find what's silently costing tokens in this project and propose targeted skip rules.

## Steps

1. **Inventory large dirs and files.** Run:
   ```bash
   du -sh */ 2>/dev/null | sort -h | tail -20
   find . -type f -not -path './.git/*' -size +1M 2>/dev/null | head -30
   ```
   Don't read the contents — just the listing.

2. **Detect generated / build / dependency dirs** by name pattern. Common offenders:
   - `node_modules/`, `.next/`, `dist/`, `build/`, `.vercel/`, `coverage/`
   - `.venv/`, `venv/`, `__pycache__/`, `wandb/`, `outputs/`, `runs/`, `checkpoints/`
   - `.dart_tool/`, `ios/Pods/`, `android/build/`, `android/app/build/`
   - `*.tsbuildinfo`, `*.map`, `*.min.{js,css}`, lockfiles
   - Generated Dart: `*.g.dart`, `*.freezed.dart`, `*.gr.dart`
   - Model weights & data: `*.pth`, `*.ckpt`, `*.safetensors`, `*.onnx`, `*.npy`, `*.npz`, `*.parquet`

3. **Check existing CLAUDE.md** for a `## Don't read` section. Note what's already covered vs missing.

4. **Check for secrets** that should be in deny rules, not just don't-read:
   - `.env`, `.env.*`, `secrets/`, `*.key`, `*.pem`, `credentials.*`
   
   These need `.claude/settings.json` permissions deny — a CLAUDE.md instruction is not enforcement.

5. **Produce a report** with three sections:

   **Already covered:** what's in CLAUDE.md and looks fine.
   
   **Add to CLAUDE.md `## Don't read`:** specific paths/patterns from this project, with one-line reasons. Group by category (build/data/generated/etc.).
   
   **Add to `.claude/settings.json` deny rules:** any secret-bearing paths found.

6. **Offer to apply** the changes — but make the edits only after the user confirms. Show the proposed diff first.

## What this skill is NOT for

- Don't propose ignoring source code that's "just big" (e.g. a 2000-line component). Ranged reads handle that — note it under "files that warrant offset/limit reads" instead.
- Don't recommend ignoring tests, docs, or anything Fatih actively works in.
- The goal is "stop reading what doesn't help", not "shrink the context to nothing".
