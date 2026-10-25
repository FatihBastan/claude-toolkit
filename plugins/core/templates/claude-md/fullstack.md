# {{ProjectName}}

{{One line: the product.}}

## Services
Separate codebases sharing one goal. Each may have its own `CLAUDE.md` — prefer it for service-specific work.

| Service | Path | Stack | Owns |
|---|---|---|---|
| {{Backend}} | `{{backend/}}` | {{FastAPI / Express / Go}} | {{API, business logic, DB}} |
| {{Web}} | `{{frontend/}}` | {{Next.js + TS}} | {{web UI}} |
| {{Mobile}} | `{{mobile/}}` | {{Flutter}} | {{mobile UI}} |
| {{Other}} | `{{…}}` | {{…}} | {{…}} |

## Commands
- {{`docker compose up` / `make dev` / per-service dev commands}}
- {{Tests per service or `make test`}}

## Cross-service contracts
- API: {{REST / GraphQL / gRPC — where the schema lives}}
- Auth: {{how services and clients authenticate}}
- Shared types: {{generated from the backend? where?}}

## Working with Claude here
- Identify the service first; ask if the path doesn't make it obvious. Don't read across services unless the contract is involved.
- Cross-service features: `/spec` once, then `/build` service by service (prefix `core:` when using the plugin).
- "Where is X" → **Explore** subagent scoped to one service.
- Working rules: `.claude/rules/` (core + per-language, path-scoped).

## Don't read
Hard blocks (build output, caches, secrets) are in `.claude/settings.json`. Also skip unless asked:
- `**/node_modules/`, `**/.venv/`, lockfiles, Docker volume dirs (`**/postgres-data/`, …)
- {{Project-specific large dirs}}
