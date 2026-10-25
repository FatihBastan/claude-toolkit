---
paths:
  - "**/*.dart"
---
# Dart / Flutter

- `dart format`; respect `analysis_options.yaml`; run `flutter analyze` after changes.
- `const` constructors and widgets where possible; `final` locals; split big `build` methods into small widgets.
- Null safety: avoid `!` unless null would be a programming error; avoid `late` unless initialisation is guaranteed.
- Async: `await` or wrap in `unawaited()`; check `mounted` (or `context.mounted`) before using a `BuildContext` after an `await`.
- State: use the project's approach (Riverpod / Bloc / Provider). Don't mix `setState` into shared state.
- Errors: `on SpecificException catch (e)`; never catch `Error` subtypes.
- Generated files (`*.g.dart`, `*.freezed.dart`, `*.gr.dart`): regenerate with `dart run build_runner build`; never hand-edit or read them.
- Leave `android/` and `ios/` native code alone unless the task needs it.
