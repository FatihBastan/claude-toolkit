# Library notes

Read only the section you need. These snippets show the shape of each API; confirm exact props against the installed version's docs or `.d.ts` files before relying on them.

## React Three Fiber + drei
- Docs: r3f.docs.pmnd.rs · pmndrs.github.io/drei
- R3F majors track React majors (R3F 9 ↔ React 19). Mismatches fail at runtime with confusing reconciler errors.
- drei uses `three-stdlib`, not `three/examples/jsm` — import loaders and controls from drei rather than mixing in both.
- Typical scene skeleton:
  ```tsx
  <Canvas dpr={[1, 2]} shadows camera={{ position: [0, 2, 6], fov: 50 }}>
    <Suspense fallback={null}>
      <Environment preset="city" />
      <Model />            {/* useGLTF('/model.glb') inside */}
      <ContactShadows />
    </Suspense>
    <OrbitControls makeDefault />
  </Canvas>
  ```
- `Html` and `Loader` exist only in the web entry, not `@react-three/drei/native`.

## @react-three/rapier
- Docs: the pmndrs/react-three-rapier README and its demos.
- Wrap the physics part of the scene in `<Physics>` (inside `<Suspense>` — Rapier loads WASM). Bodies: `<RigidBody type="dynamic|fixed|kinematicPosition">`; colliders are auto-generated from meshes or explicit (`<CuboidCollider>`, `<BallCollider>`, …).
- Move things with `rigidBody.current.applyImpulse(...)`, `setLinvel(...)` or kinematic `setNextKinematicTranslation(...)` — not `mesh.position.set` on dynamic bodies.
- Collision events: `onCollisionEnter`, `onIntersectionEnter` (with `sensor` colliders) for triggers.
- `<Physics debug>` draws the colliders while you tune.
- Addons (`@react-three/rapier-addons`): attractors and similar helpers.

## @react-three/postprocessing
- `<EffectComposer>` with effects as children: `<Bloom luminanceThreshold intensity mipmapBlur />`, `<DepthOfField />`, `<Noise />`, `<Vignette />`, `<ToneMapping />`, `<SMAA />`.
- Effects are merged into as few passes as possible. Bloom needs emissive materials or `toneMapped={false}` colours above 1 to glow selectively.
- On mobile, gate expensive effects (DOF, SSAO) behind a quality setting or `PerformanceMonitor`.

## three.quarks
- Docs: quarks.art (guides + visual editor).
- One `BatchedRenderer` added to the scene, systems registered with it, and `batchRenderer.update(delta)` every frame:
  ```ts
  const batch = new BatchedRenderer(); scene.add(batch);
  const ps = new ParticleSystem({ /* duration, looping, startLife, startSpeed, emissionOverTime, shape, material */ });
  batch.addSystem(ps); scene.add(ps.emitter);
  // in the loop: batch.update(delta);
  ```
- Design effects in the visual editor and load the exported JSON with `QuarksLoader` instead of hand-tuning numbers in code.
- In R3F: create the systems in a `useMemo`/`useEffect`, call `update` from `useFrame`, and dispose of them on unmount.

## Yuka
- Docs: mugen87.github.io/yuka (API + examples). Unmaintained since Jan 2023 — stable, but expect no fixes.
- An `EntityManager` updates `GameEntity`/`Vehicle` objects with a `Time` delta. Sync each entity to its mesh with `entity.setRenderComponent(mesh, sync)`, or copy the matrix every frame.
- Steering: `SeekBehavior`, `ArriveBehavior`, `WanderBehavior`, `ObstacleAvoidanceBehavior`, `FollowPathBehavior`.
- Navigation: `NavMeshLoader` (from a glTF navmesh) → `navMesh.findPath(from, to)`. Bake the navmesh in Blender or with Recast.
- Decisions: `StateMachine` for simple NPCs; `Think` + goals for goal-driven agents; `Vision` + `MemorySystem` for perception.

## Colyseus
- Docs: docs.colyseus.io. Check the installed major before writing code — recent majors renamed things: the client is `@colyseus/sdk` since 0.17 (older projects use `colyseus.js`), and state listeners go through `Callbacks.get(room)` / `getStateCallbacks(room)` instead of `room.state.players.onAdd`.
- Server: define a `Room` with a `Schema` state class; mutate state on the server only and let Colyseus sync patches to clients. Use `onJoin`, `onLeave`, `onMessage`; `allowReconnection` for dropped clients.
- Client: `new Client(url)` → `client.joinOrCreate("room_name")` → listen to state through the callbacks API. Send **inputs**, not positions; the server is authoritative.
- Netcode basics: server tick at a fixed rate (`setSimulationInterval`); clients interpolate remote entities and predict only their own player. 0.18 ships an experimental client-prediction library (`@colyseus/sdk/predict`) for exactly that — check its status before depending on it.
- Rooms are per-process; scaling out needs the Redis presence/driver.

## TripoSR (not included)
Image → 3D mesh model (Python, GPU). Useful for prop *prototypes* outside the repo — not runtime tooling and not final art. Keep generated meshes out of the repo until they're cleaned up.
