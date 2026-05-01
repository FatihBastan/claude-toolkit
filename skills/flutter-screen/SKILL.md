---
name: flutter-screen
description: Scaffold a Flutter screen end-to-end (widget, state, route, test, analyze). Use when the user wants to add a new screen/page to a Flutter app (e.g. brify mobile frontend).
---

# flutter-screen

Add a Flutter screen with the full loop: widget → state → route → test → analyze → manual verification.

## Steps

1. **Clarify in 2–3 questions, max.** What does the screen show, what state does it need, what route reaches it, what does it navigate to next?

2. **Match existing conventions.** Use the **Explore subagent** to find a similar existing screen — copy its structure (state pattern, file layout, naming). Don't invent a new pattern.

3. **Implement in order**:
   - Model / DTO in `lib/models/` (or `lib/domain/`) if new shapes are involved.
   - Repository / service in `lib/services/` (or `lib/data/`) if there's IO.
   - State (Riverpod provider / Bloc / Cubit / Notifier) — match what the project uses.
   - Screen widget in `lib/<features>/<feature>/<feature>_screen.dart`.
   - Route registration (`go_router` config / `Navigator` route table).

4. **Write at least one widget test.** Renders the screen with a mock state, asserts a key element is visible. Match the project's existing test patterns.

5. **Run static checks**:
   - `flutter analyze` — fix issues caused by your changes.
   - `flutter test` — confirm the new test (and existing tests) pass.

6. **Run on a device/emulator** and verify the screen renders, navigates, and handles its primary interaction. Do not report done if you couldn't actually open the screen. Say so explicitly instead.

7. **Report** in 5 lines:
   - Files added/changed
   - Analyze + test results
   - Manual verification (or why it's missing)
   - One follow-up (e.g. "no error state UI yet", "loading skeleton not designed")

## Anti-patterns to refuse

- Introducing a new state management approach when the project uses one. Match.
- Touching `android/` or `ios/` native code unless the feature genuinely needs it.
- Adding `setState` inside a Riverpod project (or vice versa).
- Building a "container + presenter" split when the project's existing screens are a single widget.
- Generating a wall of `*.g.dart` boilerplate when a simple class would do.

## Generated-code note

Projects using `freezed` / `json_serializable` / `riverpod_generator` need `dart run build_runner build` after adding annotated classes. Run it once after adding the model; don't read the generated files.
