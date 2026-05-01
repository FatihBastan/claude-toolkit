# {{ProjectName}}

{{One-line description of the product.}}

## Services

This is a multi-service repo. Each service has its own conventions — treat them as separate codebases that share a goal.

| Service | Path | Stack | Owner of |
|---|---|---|---|
| {{Backend}} | `{{backend/}}` | {{Python+FastAPI / Node+Express / Go}} | {{API, business logic, DB}} |
| {{Web frontend}} | `{{frontend/}}` | {{Next.js + TS}} | {{Web UI}} |
| {{Mobile}} | `{{flutter_frontend/ | mobile/}}` | {{Flutter / React Native}} | {{Mobile UI}} |
| {{Other}} | `{{TTS/ | ir/ | etc.}}` | {{stack}} | {{purpose}} |

## How to navigate

When Fatih asks about a feature, **first ask which service** unless it's obvious from the path. Don't assume cross-service knowledge — the boundaries are real.

For each sub-service, look for its own `CLAUDE.md` first. If one exists, prefer it over this top-level file for service-specific work.

## Top-level commands

- {{Compose up: `docker-compose up`}}
- {{Run all dev: `make dev` / individual `npm run dev` per service}}
- {{Tests across services: `make test`}}

## Cross-service contracts

- {{API: REST / GraphQL / gRPC — where is the schema?}}
- {{Auth: how do services authenticate to each other?}}
- {{Shared types: are TS types generated from backend? where?}}

## Working with Claude in this repo

- **Always identify the service first** before making changes. A change in `frontend/` shouldn't read `backend/` source unless the API contract is involved.
- For cross-service changes, work service-by-service, not file-by-file.
- For "where is X" questions, spawn the **Explore subagent** scoped to the relevant service: *"Use Explore on `backend/` to find …"*.

## Don't read

- All standard build/install dirs across services:
  - `**/node_modules/`, `**/.next/`, `**/.venv/`, `**/__pycache__/`
  - `**/build/`, `**/dist/`, `**/out/`
  - `**/.dart_tool/`, `**/android/build/`, `**/ios/Pods/`
- `**/coverage/`, `**/*.lock`, `**/*.tsbuildinfo`
- Docker volumes: `**/postgres-data/`, `**/redis-data/`, `**/minio-data/`
- Model weights & data: `**/*.pth`, `**/*.ckpt`, `**/*.safetensors`, `**/data/raw/`
- {{Project-specific large dirs}}
