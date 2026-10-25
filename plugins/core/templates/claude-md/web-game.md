# {{ProjectName}}

{{One line: the game, genre, and platform (browser / mobile web / PWA).}}

## Stack
- {{three.js r___ / React Three Fiber ___ / Phaser ___ / PixiJS ___}}, {{TypeScript / JS}}, bundler {{Vite / Next / none}}
- {{Physics: Rapier / cannon-es / Arcade}} · {{Effects: postprocessing / three.quarks}} · {{Multiplayer: Colyseus / none}}

## Map
- `{{src/game|src/scenes}}/` — {{game loop, scenes, systems}}
- `{{src/components}}/` — {{R3F components / UI}}
- `{{public/assets|assets}}/` — models, textures, audio (binary — don't read)
- {{server/ — multiplayer rooms, if any}}

## Commands
- Dev: `{{npm run dev}}` · Build: `{{npm run build}}` · Test: `{{cmd or "none yet"}}` · Typecheck: `{{npx tsc --noEmit}}`

## Conventions
- {{Fixed timestep vs frame-delta logic; where game state lives (store / ECS / scene graph)}}
- {{Asset pipeline: glTF + Draco/KTX2? where models are loaded}}

## Working with Claude here
- Features: `/spec` → `/build` → `/ship` (prefix `core:` when using the plugin). Library choices: `web3d-stack` skill; engine patterns: gamedev `router`.
- Visual changes: run the dev server and check in a browser (`/verify`) — a passing type-check says nothing about how it looks or runs.
- Watch frame time: no allocations or `setState` inside per-frame loops.
- Working rules: `.claude/rules/` (core + TypeScript, path-scoped).

## Don't read
Hard blocks (binary assets, build output, secrets) are in `.claude/settings.json`. Also skip unless asked:
- `node_modules/`, `dist/`, lockfiles
- {{Project-specific large dirs}}
