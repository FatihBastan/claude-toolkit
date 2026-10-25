---
paths:
  - "Assets/**/*.cs"
  - "Packages/**/*.cs"
---
# Unity C#

- Lifecycle: cache component references in `Awake`; subscribe in `OnEnable` and unsubscribe in `OnDisable`; physics in `FixedUpdate`; camera follow in `LateUpdate`.
- Hot paths (`Update`, per-frame callbacks): no `GetComponent`, `Find*`, `Camera.main` lookups, LINQ, string building or `new` collections. Cache, pool, reuse.
- `[SerializeField] private` instead of public fields. ScriptableObjects for shared config and data. Don't add static singletons unless the project already uses them.
- `UnityEngine.Object` null checks use `== null` or the implicit bool — never `?.` or `??` (Unity's fake-null).
- Never edit `.meta`, `*.csproj`, `*.sln` or anything in `Library/`, `Temp/`. Moving or renaming assets outside the Editor breaks GUID references — do it in the Editor (or through MCP Unity), or move the `.meta` file with the asset.
- `.unity` / `.prefab` / `.asset` are large YAML: ranged reads only, and don't hand-edit them unless asked — prefer code or Editor tooling.
- Tests: Unity Test Framework — EditMode for logic, PlayMode for runtime behaviour. Keep game logic in plain C# classes so it's EditMode-testable.
- Match the project's input system (legacy Input Manager vs Input System package) and render pipeline; never mix them.
