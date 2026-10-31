---
name: token-budget
description: Use when the user says Claude is slow, expensive or reading junk in this repo, or asks for a context/token health check: audits what burns tokens and proposes deny rules and CLAUDE.md trims.
---

# token-budget

Find what silently costs tokens here and propose targeted fixes. Listings only — never open the suspicious files themselves.

## Steps

1. **Inventory big things:**
   ```bash
   du -sh -- */ .[!.]*/ 2>/dev/null | sort -h | tail -20
   find . -type f -not -path './.git/*' -size +1M 2>/dev/null | head -30
   ```
2. **Spot generated, build, dependency and binary paths** by name — build output, caches, model weights, datasets, engine caches (`Library/`, `.godot/`, `Intermediate/`), generated code (`*.g.dart`, `*.min.js`, `*.map`), lockfiles. The fragments in `${CLAUDE_PLUGIN_ROOT}/templates/settings/` list the usual suspects per stack.
3. **Check what's already covered:** `permissions.deny` in `.claude/settings.json` and the `## Don't read` section of `CLAUDE.md`.
4. **Check secrets:** `.env*` (except `.env.example`), `*.pem`, `*.key`, keystores, `credentials*.json`, service-account files. These need deny rules — a CLAUDE.md line isn't enforcement.
5. **Check always-on context cost:** run `/context` (or ask the user to). Flag a CLAUDE.md over ~80 lines, rules without `paths:` that only matter for one language, and plugins or skills that don't fit this repo.
6. **Report three lists:**
   - **Hard deny** → `.claude/settings.json` (secrets, binaries, build output Claude never needs).
   - **Soft skip** → CLAUDE.md `## Don't read` (things Claude occasionally does need: `node_modules/` for library types, lockfiles for versions, `.meta` for GUID bugs).
   - **Context trims** → CLAUDE.md lines to cut, rules to path-scope, plugins/skills to disable here.
7. Show the diff and apply it only after the user says yes.

## Don't
- Deny-read source code that's merely big — note it for ranged reads instead.
- Hide tests, docs, or anything the user actively works in.
- Deny `node_modules/` or `.venv/` outright: debugging sometimes needs library source. Soft-skip them.
