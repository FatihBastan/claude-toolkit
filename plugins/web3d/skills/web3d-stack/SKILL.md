---
name: web3d-stack
description: Pick and wire the browser 3D/game stack — three.js / React Three Fiber with drei, Rapier physics, postprocessing, three.quarks particles, Yuka NPC AI and Colyseus multiplayer — plus frame-budget rules. Use when building or extending a web game or 3D scene in JS/TS.
---

# web3d-stack

Default stack for browser 3D games, and what each piece is for. Libraries move fast — check the installed versions and the docs before writing APIs from memory (source-driven skill). Per-library notes and starter snippets are in `references/libraries.md`; read only the section you need.

## Pick the pieces

| Need | Use | Package(s) | Notes |
|---|---|---|---|
| Rendering, React app | React Three Fiber | `three`, `@react-three/fiber` | Declarative scene graph; the R3F major must match your React major |
| Rendering, no React | plain three.js | `three` | Own the render loop; same libs minus the `@react-three/*` wrappers |
| Camera controls, env/sky, shadows, loaders, text, HTML overlays | drei | `@react-three/drei` | `OrbitControls`, `Environment`, `Sky`, `ContactShadows`, `useGLTF`, `Html`, `Bvh`, `PerformanceMonitor` … |
| Physics (rigid bodies, colliders, joints) | Rapier | `@react-three/rapier` | WASM, deterministic, fast; don't hand-roll collision |
| Bloom, DOF, grain, vignette, tone mapping | postprocessing | `@react-three/postprocessing` (wraps `postprocessing`) | One merged effect pass; much cheaper than chained three/examples passes |
| Particles / VFX (sparks, smoke, magic trails) | three.quarks | `three.quarks` | Batched renderer; has a visual editor (quarks.art) and imports Unity Shuriken systems |
| NPC behaviour (steering, pathfinding, perception, FSM, fuzzy logic) | Yuka | `yuka` | Engine-agnostic, MIT — but **no commits since Jan 2023**. Fine for steering/FSM; for navmesh-heavy games also consider `recast-navigation-js` |
| Multiplayer (rooms, matchmaking, reconnection, state sync) | Colyseus | server `colyseus`, client `@colyseus/sdk` (React: `@colyseus/react`) | Authoritative server; check the major — the client became `@colyseus/sdk` in 0.17 (was `colyseus.js`) and the state-callback API changed |
| 2D game instead | Phaser / PixiJS | `phaser`, `pixi.js` | Use the gamedev router's web-engine skills instead |

Don't add a library the task doesn't need. Each one costs bundle size and frame time.

## Frame-budget rules (60 fps = 16.6 ms; mobile web is ~3–5× slower)
- Nothing allocates per frame: no `new Vector3()`, object literals, arrays or closures in `useFrame` / the render loop. Reuse module-level temporaries.
- Never call React `setState` from `useFrame`; mutate refs. Keep game state in a store (zustand) or ECS and read it in the loop.
- Draw calls are the usual bottleneck: share materials and geometries, use `InstancedMesh` (drei `<Instances>`) for repeats, merge static geometry, and use `<Bvh>` for raycasting.
- Assets: glTF/GLB with Draco or Meshopt compression and KTX2 textures; preload with `useGLTF.preload`; dispose of what you unload.
- Turn things down adaptively: `PerformanceMonitor` + `AdaptiveDpr`, cap `dpr={[1, 2]}`, shadows only where they matter, and postprocessing effects that scale down on mobile.
- Physics: a fixed timestep (Rapier's default); never move dynamic bodies by setting positions every frame — apply impulses/velocities or use kinematic bodies.
- Measure before optimizing: `r3f-perf` or `stats.js`, and the browser performance panel.

## Verify
Run the dev server and look at it in a browser (`/verify`, or the in-app browser). Check: the scene renders, input works, there are no console errors, and the frame time holds on a throttled CPU. Type-checks say nothing about frame rate.

## Licenses
All MIT: three, R3F, drei, Rapier bindings, postprocessing, three.quarks, Yuka, Colyseus.
