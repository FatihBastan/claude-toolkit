---
name: setup
description: Wire a game repo to the upstream gamedev skills (router + the right engine bundle) and, optionally, the Unity or Godot editor MCP server. Called by /core:init-repo; run it directly to add or change engines later.
disable-model-invocation: true
argument-hint: "[portable|plugin] [engine]"
---

# gamedev setup

Upstream: [gamedev-skills/awesome-gamedev-agent-skills](https://github.com/gamedev-skills/awesome-gamedev-agent-skills) (Apache-2.0) — 76 engine/discipline/genre skills behind a `router` that detects the engine and loads only what the task needs. We **reference** it rather than copy it, so it stays current.

## 1. Engine → bundle

| Detected | Bundle(s) | Always-on cost* |
|---|---|---|
| `project.godot` | `godot` | ~1.6k tok |
| `Assets/` + `ProjectSettings/` | `unity` | ~0.7k |
| `*.uproject` | `unreal` | ~0.6k |
| `package.json` with `phaser` / `pixi.js` / `three` | `web-engines` | ~0.7k |
| `go.mod` with ebiten | `ebitengine` | ~0.1k |
| Bevy, pygame, LÖVE, Defold, Roblox | `other-engines` | ~1.2k |

Always add `router` (~0.2k). Default extra: `disciplines` (~1.6k — game feel, cameras, input, saves, AI, procedural gen, shaders, UI/UX, performance). Offer `genres` (~0.4k) when the genre is known, and `workflows` (~0.3k) for game jams or Steam/itch publishing.
*Skill-description tokens loaded every session; skill bodies load only when used.

## 2a. Plugin mode → merge into `.claude/settings.json`
```json
"extraKnownMarketplaces": {
  "awesome-gamedev-agent-skills": {
    "source": { "source": "github", "repo": "gamedev-skills/awesome-gamedev-agent-skills" },
    "autoUpdate": true
  }
},
"enabledPlugins": {
  "router@awesome-gamedev-agent-skills": true,
  "<engine-bundle>@awesome-gamedev-agent-skills": true,
  "disciplines@awesome-gamedev-agent-skills": true
}
```
The marketplace loads after the folder is trusted. Plugins don't load in cloud sessions — use portable mode there.

## 2b. Portable mode → copy skills into `.claude/skills/`
Preferred, when Node ≥ 22.20 is available (the upstream installer writes project-local skills):
```bash
npx skills add gamedev-skills/awesome-gamedev-agent-skills -a claude-code \
  --skill router --skill <each skill in the chosen bundles>
```
Fallback with plain git (works anywhere):
```bash
tmp="$(mktemp -d)"
git clone -q --depth 1 --filter=blob:none --sparse https://github.com/gamedev-skills/awesome-gamedev-agent-skills "$tmp/gd"
git -C "$tmp/gd" sparse-checkout set router skills/<engine-dir> skills/disciplines
mkdir -p .claude/skills
cp -R "$tmp/gd/router" .claude/skills/router
for d in "$tmp/gd"/skills/<engine-dir>/*/ "$tmp/gd"/skills/disciplines/*/; do cp -R "$d" .claude/skills/; done
cp "$tmp/gd/LICENSE" .claude/skills/router/LICENSE.gamedev-skills   # Apache-2.0 attribution travels with the copy
[ -f "$tmp/gd/NOTICE" ] && cp "$tmp/gd/NOTICE" .claude/skills/router/NOTICE.gamedev-skills
rm -rf "$tmp"
```
`<engine-dir>` is `godot`, `unity`, `unreal`, `web-engines`, `ebitengine` or `other-engines`. For `other-engines` and `web-engines`, copy only the skills for the engine actually in use (e.g. just `phaser-*`). Refresh later by re-running this step.

## 3. Editor MCP (only if the user asked)
**Unity — [MCP Unity](https://github.com/CoderGamester/mcp-unity)** (MIT; Unity 6+, Node 18+). Lets Claude build scenes, edit GameObjects, assign materials, run tests and read the console.
1. With the user's OK, add to `Packages/manifest.json` → `dependencies`:
   `"com.gamelovers.mcp-unity": "https://github.com/CoderGamester/mcp-unity.git"`
2. The user opens the project in Unity → **Tools → MCP Unity → Server Window → Configure Claude Code (Project)**. That writes `.mcp.json` with the right project-relative path (it contains a package-cache hash, so don't hand-write it).
3. Restart Claude Code in the repo and approve the `mcp-unity` server.

**Godot — [godot-mcp](https://github.com/Coding-Solo/godot-mcp)** (MIT; quieter upstream — last commit April 2026). Run `claude mcp add --scope project godot -- npx @coding-solo/godot-mcp` (add `-e GODOT_PATH=/path/to/godot` if Godot isn't on PATH), which writes a committed `.mcp.json`.

## 4. Report
Bundles enabled or copied, the always-on token estimate, the MCP steps left for the user, and: "Ask gamedev questions normally — the router picks the skills."
