# {{ProjectName}}

{{One line.}}

## Stack
- Flutter {{version}}, Dart {{version}}
- State: {{Riverpod / Bloc / Provider}} · Navigation: {{go_router / Navigator / auto_route}}
- Backend: {{REST at … / Firebase / local}} · Targets: {{Android / iOS / Web}}

## Map
- `lib/main.dart` — entry · `lib/{{features|screens}}/` — {{feature-first / layer-first}}
- `lib/{{models|domain}}/` · `lib/{{services|data}}/` · `lib/widgets/`
- `test/`, `integration_test/` · `assets/`

## Commands
- `flutter pub get` · `flutter run {{-d <device>}}` · `flutter test` · `flutter analyze` · `dart format lib test`
- Codegen: `{{dart run build_runner build --delete-conflicting-outputs, if used}}`

## Conventions
- {{Where providers live and how DI works}} · {{Theme location}} · {{Localization (ARB?)}}

## Working with Claude here
- Features: `/spec` → `/build` → `/ship` (prefix `core:` when using the plugin); single screens: `flutter-screen` skill.
- After changes: `flutter analyze` + `flutter test`; UI work gets checked on a device/emulator before "done".
- "Where is X used" → **Explore** subagent.
- Working rules: `.claude/rules/` (core + Dart/Flutter, path-scoped).

## Don't read
Hard blocks (`.dart_tool/`, `build/`, Pods, generated `*.g.dart`, secrets) are in `.claude/settings.json`. Also skip unless asked:
- `pubspec.lock`, `.flutter-plugins*`, `android/`/`ios/` native code
- {{Project-specific asset/generated dirs}}
