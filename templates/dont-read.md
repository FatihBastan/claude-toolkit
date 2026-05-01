# Don't-read patterns

Two ways to tell Claude not to read paths. Use both, depending on the goal.

## Mechanism 1 — CLAUDE.md "Don't read" section (preferred)

Just list paths under a `## Don't read` heading in CLAUDE.md. Claude reads CLAUDE.md every session, sees the rule, follows it. This is the right tool for **token saving** — paths that are useless, not paths that are sensitive.

The templates in this folder all include a `## Don't read` section already. Project-specific dirs go there.

## Mechanism 2 — `.claude/settings.json` deny rules (for secrets)

When you need *enforcement* (Claude literally cannot read the file even if asked), use permission deny rules. This is the right tool for **secrets**: `.env`, credential files, private keys.

Create `.claude/settings.json` in the project root:

```json
{
  "permissions": {
    "deny": [
      "Read(./.env)",
      "Read(./.env.*)",
      "Read(./secrets/**)",
      "Read(./*.key)",
      "Read(./*.pem)"
    ]
  }
}
```

Docs: https://code.claude.com/docs/en/configuration.md

---

## Patterns library — copy what fits

### Universal (every project)

```
.git/
.DS_Store
*.log
```

### Node / TypeScript / Next.js

```
node_modules/
.next/
.vercel/
dist/
build/
out/
coverage/
.cache/
package-lock.json
yarn.lock
pnpm-lock.yaml
tsconfig.tsbuildinfo
*.map
*.min.js
*.min.css
```

### Python

```
.venv/
venv/
env/
__pycache__/
*.pyc
.ipynb_checkpoints/
.pytest_cache/
.mypy_cache/
.ruff_cache/
*.egg-info/
poetry.lock
uv.lock
```

### Python ML / data science

```
wandb/
outputs/
logs/
runs/
checkpoints/
lightning_logs/
mlruns/
*.pth
*.ckpt
*.safetensors
*.onnx
*.bin
*.h5
*.pkl
*.npy
*.npz
*.parquet
*.arrow
*.feather
*.tfrecord
```

### Flutter / Dart

```
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies
build/
ios/Pods/
ios/build/
android/build/
android/app/build/
pubspec.lock
*.g.dart
*.freezed.dart
*.gr.dart
*.config.dart
```

### Docker / infra

```
postgres-data/
redis-data/
minio-data/
.terraform/
*.tfstate
*.tfstate.backup
```

### Secrets (use deny rules, not just CLAUDE.md)

```
.env
.env.*
secrets/
*.key
*.pem
credentials.json
```
