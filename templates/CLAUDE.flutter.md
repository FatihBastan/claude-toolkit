# {{ProjectName}}

{{One-line description.}}

## Stack

- Flutter {{version}}, Dart {{version}}
- State management: {{Riverpod / Bloc / Provider / setState}}
- Navigation: {{go_router / Navigator 2.0 / auto_route}}
- Backend: {{REST API at X / GraphQL / Firebase / local-only}}
- Targets: {{Android / iOS / Web / Desktop}}

## Map

- `lib/` — Dart source
  - `lib/main.dart` — entrypoint
  - `lib/{{features|screens}}/` — {{feature-first | layer-first}}
  - `lib/{{models|domain}}/` — data models
  - `lib/{{services|data}}/` — API clients, repositories
  - `lib/widgets/` — shared widgets
- `test/` — unit & widget tests
- `integration_test/` — integration tests
- `assets/` — images, fonts, JSON
- `android/`, `ios/` — platform code (rarely touched)

## Commands

- Get deps: `flutter pub get`
- Run: `flutter run` ({{add `-d <device-id>` to target a specific device}})
- Build APK: `flutter build apk --release`
- Build iOS: `flutter build ios --release`
- Test: `flutter test`
- Analyze: `flutter analyze`
- Format: `dart format lib/ test/`

## Conventions

- {{Widget naming: feature-prefixed?}}
- {{State management pattern: where providers live, how DI works}}
- {{Theme: where colors/typography are defined}}
- {{Localization: ARB files? Where?}}

## Working with Claude in this repo

- After non-trivial changes, run `flutter analyze` and `flutter test`.
- For UI work, run on a device/emulator and verify visually before reporting done.
- For "where is X used" questions, spawn the **Explore subagent**.
- Don't touch `android/` or `ios/` native code unless explicitly asked.

## Don't read

- `.dart_tool/`, `.flutter-plugins`, `.flutter-plugins-dependencies`
- `build/`, `android/build/`, `android/app/build/`, `ios/Pods/`, `ios/build/`
- `pubspec.lock` (read once if dep versions matter, then skip)
- Generated files: `*.g.dart`, `*.freezed.dart`, `*.gr.dart`, `*.config.dart`
- `coverage/`, `.idea/`, `.vscode/`
- {{Project-specific generated/asset dirs}}
