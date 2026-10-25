---
name: init-repo
description: Set up the current repo from Fatih's toolkit — CLAUDE.md, .claude/settings.json, path-scoped rules, and the right stack packs. Run once per repo; run with "refresh" to re-sync later.
disable-model-invocation: true
argument-hint: "[refresh] [portable|plugin]"
---

# init-repo

**CORE** = `${CLAUDE_PLUGIN_ROOT}`. If that still reads as a literal `${…}` (you were pointed at this file from a toolkit clone rather than loaded as a plugin skill), CORE is `<clone>/plugins/core`. Everything below lives under CORE: `templates/`, `rules/`, `skills/`, `agents/`, and `packs/<pack>/` (the optional packs).

Goal: make this repo Claude-ready in one pass, reading as little as possible. You only write config files. Never install dependencies, build, or run tests during init.

## 1. Look before writing (≤ 10 file reads in total)

1. `pwd`, `ls -a`, `git status --short | head`. Note any existing `CLAUDE.md`, `.claude/`, `AGENTS.md`.
2. Detect stacks from the root (and one level down for multi-service repos). Several can match.

| Signal | Stack | CLAUDE.md template | Rules | Settings fragments | Pack |
|---|---|---|---|---|---|
| 2+ service dirs (`backend/` + `frontend/`, `mobile/`, …) | fullstack | `fullstack` | per service | per service | per service |
| `Assets/` + `ProjectSettings/` | Unity | `unity` | `unity-csharp` | `unity`, `game-assets` | gamedev (unity) |
| `project.godot` | Godot | `base` | — | `godot`, `game-assets` | gamedev (godot) |
| `*.uproject` | Unreal | `base` | `cpp` | `unreal`, `game-assets` | gamedev (unreal) |
| `package.json` with `three`, `@react-three/fiber`, `phaser` or `pixi.js` | web game | `web-game` | `typescript` | `node`, `game-assets` | gamedev (web-engines) + web3d if three/R3F |
| `package.json` with `next` | Next.js | `nextjs` | `typescript` | `node` | web |
| other `package.json` / `tsconfig.json` | Node/TS | `base` | `typescript` | `node` | — |
| `pubspec.yaml` | Flutter | `flutter` | `dart-flutter` | `flutter` | mobile |
| Python + (`torch`/`tensorflow`/`jax`/`transformers` in deps, `train.py`, `*.ipynb`) | Python ML | `python-ml` | `python` | `python`, `ml` | ml |
| other Python (`pyproject.toml`, `requirements*.txt`) | Python | `base` | `python` | `python` | — |
| `CMakeLists.txt`, `Makefile` + C/C++ sources | C/C++ | `base` | `cpp` | — | — |

   Read at most: the dependency manifest(s), `README.md` (first 80 lines), one stack config file (`ProjectSettings/ProjectVersion.txt`, `tsconfig.json`, `next.config.*`, `pyproject.toml`, …), and the existing `CLAUDE.md`. For "where does X live" questions use the **Explore** subagent instead of reading more.

3. Pick the delivery mode:
   - Argument `portable` or `plugin` → use it.
   - `echo $CLAUDE_CODE_REMOTE` prints `true` → this is a cloud session, where plugins don't load → **portable**.
   - Otherwise ask (below). Default: **portable**, because it works everywhere, including cloud sessions and the phone.

   | Mode | What lands in the repo | Good for |
   |---|---|---|
   | portable | skills/agents copied into `.claude/skills/` and `.claude/agents/` | any surface, including cloud sessions |
   | plugin | only settings that enable the toolkit plugins | local CLI/desktop with the marketplace added; leanest repo |

4. Ask everything you need in **one** message, each with your default, then wait:
   - Delivery mode (skip if already decided).
   - Existing `CLAUDE.md`: merge (default), replace, or leave alone.
   - Session logging (`notes/daily/` handoff notes + hooks)? Default: no — built-in auto memory covers most of it. Suggest yes only for long multi-week projects.
   - Unity / Godot: set up the editor MCP server too? Default: no (it needs an Editor package / Node).

   If `refresh` was passed: skip questions you already have answers to — read the mode from `.claude/settings.json` (`core@fatih-toolkit: true` means plugin) and keep existing choices.

## 2. CLAUDE.md

- Start from `CORE/templates/claude-md/<template>.md`. Fill every `{{placeholder}}` you can from what you read; leave `{{TODO: what's missing}}` rather than guessing. Delete sections that would be empty.
- **Under 80 lines.** It's a map, not documentation: don't restate the README, list every script, or explain the framework.
- Merge mode: keep the user's existing content, add only the missing sections, and replace any old `## Don't read` list with the new one.
- Repo has `AGENTS.md` but no `CLAUDE.md`: write a short `CLAUDE.md` that starts with `@AGENTS.md` (an import) and adds only the Claude-specific sections, instead of duplicating it.
- Add any large or generated dirs you noticed to `## Don't read`.

## 3. `.claude/settings.json`

Merge, never clobber:
1. Start from the existing file if there is one, otherwise `{}`.
2. Merge `CORE/templates/settings/base.json` plus each fragment the detected stacks need. Union the `permissions.deny` arrays without duplicates. Keep every key the file already has.
3. For a fullstack repo, prefix the fragment paths with each service dir (`Read(./frontend/.next/**)`) instead of using the root-anchored ones.
4. Plugin mode → add:
   ```json
   "extraKnownMarketplaces": {
     "fatih-toolkit": { "source": { "source": "github", "repo": "FatihBastan/claude-toolkit" }, "autoUpdate": true }
   },
   "enabledPlugins": { "core@fatih-toolkit": true, "<pack>@fatih-toolkit": true }
   ```
   Portable mode → add `"enabledPlugins": { "core@fatih-toolkit": false }`, so a user-level install of the plugin doesn't duplicate the copied skills.
5. Validate the result with `python3 -m json.tool .claude/settings.json > /dev/null` (or `node -e` if there's no Python).

## 4. Rules → `.claude/rules/`

Copy `CORE/rules/core.md` plus each detected language rule (`python`, `typescript`, `unity-csharp`, `dart-flutter`, `cpp`). If a stack lives in a subdirectory (e.g. the Unity project is in `game/`), rewrite the rule's `paths:` globs to start with that dir. Don't copy rules for languages the repo doesn't use.

## 5. Skills, agents, packs

**Portable** — copy into the repo:
- Core skills: `CORE/skills/{tdd,bug-hunt,source-driven,spec,build,ship,interview}` → `.claude/skills/`. (Not `init-repo` or `token-budget` — those need the toolkit itself.)
- Core agents: `CORE/agents/*.md` → `.claude/agents/`.
- Packs for the detected stacks:
  - web → `CORE/packs/web/skills/nextjs-feature`
  - mobile → `CORE/packs/mobile/skills/flutter-screen`
  - ml → `CORE/packs/ml/skills/ml-paper-repro` + `CORE/packs/ml/agents/*.md`
  - web3d → `CORE/packs/web3d/skills/web3d-stack` (the whole folder, `references/` included)
  - gamedev → follow `CORE/packs/gamedev/skills/setup/SKILL.md` in portable mode.
- Use `cp -RL` (the packs are symlinks in a clone). A first run never overwrites a file that already exists and differs — ask. On `refresh`, toolkit-owned copies (the skills, agents and rules listed here) are updated in place; list what changed.

**Plugin** — list the packs under `enabledPlugins` (step 3); copy nothing. For gamedev, still follow `CORE/packs/gamedev/skills/setup/SKILL.md`, which adds the upstream gamedev marketplace.

**Session logging (only if the user said yes):**
- `mkdir -p notes/daily`, and suggest adding `notes/daily/` to `.gitignore` (personal noise).
- Plugin mode: add `"session-log@fatih-toolkit": true` to `enabledPlugins`.
- Portable mode: copy `CORE/packs/session-log/skills/session-log` → `.claude/skills/` and `CORE/packs/session-log/scripts/*.sh` → `.claude/hooks/` (`chmod +x` them), then merge into settings:
  ```json
  "hooks": {
    "SessionStart": [{ "hooks": [{ "type": "command", "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/session-start-resume.sh" }] }],
    "Stop": [{ "hooks": [{ "type": "command", "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/stop-session-log.sh" }] }]
  }
  ```

## 6. Report (5–8 lines)

- Stacks detected, mode, template used.
- Files written or changed (paths).
- Packs enabled or copied.
- `{{TODO}}` markers left in CLAUDE.md.
- Next steps, only those that apply: run `/run-skill-generator` once so `/verify` knows how to launch the app; plugin mode on a new machine → trust the folder so the marketplace loads; run `/fewer-permission-prompts` after a few sessions.
- Don't summarize the project back to the user — they wrote it.

## Hard rules
- ≤ 10 file reads. Explore subagent for anything wider.
- Write only: `CLAUDE.md`, `.claude/**`, `notes/daily/` (if opted in). No README, `.gitignore` or source edits — suggest those instead.
- Never overwrite an existing `CLAUDE.md`, rule or skill without the user's OK.
- Don't commit; leave the changes for the user to review.
