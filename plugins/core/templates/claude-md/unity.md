# {{ProjectName}}

{{One line: the game and its genre.}}

## Stack
- Unity {{version from ProjectSettings/ProjectVersion.txt}}, C#
- Render pipeline: {{Built-in / URP / HDRP}} · Input: {{Input Manager / Input System}}
- Networking: {{none / Netcode / Mirror / …}} · Targets: {{PC / Android / iOS / WebGL}}

## Map
- `Assets/Scripts/` — {{gameplay, systems, UI}}
- `Assets/Scenes/` — {{main scenes; bootstrap scene if any}}
- `Assets/Prefabs/`, `Assets/{{Data|ScriptableObjects}}/` — {{prefabs, config assets}}
- `Assets/Tests/` — EditMode / PlayMode tests
- `Packages/manifest.json` — UPM deps · `*.asmdef` — assembly boundaries

## Commands
- EditMode tests: `{{Unity path}} -batchmode -nographics -projectPath . -runTests -testPlatform EditMode -testResults editmode.xml -quit`
- PlayMode tests: same with `-testPlatform PlayMode -testResults playmode.xml`
- Build: `{{… -executeMethod BuildScript.Build -quit, or "Editor only"}}`

## Conventions
- {{Architecture: feature folders vs layers; DI (VContainer/Zenject) or none}}
- {{Scene setup: single scene vs bootstrap + additive}}

## Working with Claude here
- Features: `/spec` → `/build` → `/ship` (prefix `core:` when using the plugin). Gamedev skills route through the gamedev `router`.
- "Which prefab/scene uses X" spans `.cs`, `.unity`, `.prefab`, `.asset` → **Explore** subagent.
- Runtime changes need a PlayMode test or a run in the Editor{{ (MCP Unity is set up: use it to inspect scenes and read the console)}}.
- Working rules: `.claude/rules/` (core + Unity C#, path-scoped).

## Don't read
Hard blocks (Library/, Temp/, builds, secrets) are in `.claude/settings.json`. Also skip unless asked:
- `*.meta` (only for GUID / missing-reference debugging), `*.csproj`, `*.sln`, `Packages/packages-lock.json`
- Binary art/audio (`*.fbx`, `*.psd`, `*.wav`, …); scenes/prefabs only with ranged reads
- {{Project-specific large dirs}}
