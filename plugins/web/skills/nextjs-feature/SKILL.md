---
name: nextjs-feature
description: Add a feature to a Next.js + TypeScript project end-to-end (component, hook/state, types, test, type-check, dev-server verification). Use when the user asks for a new feature/page/component in a Next.js codebase like ToneFlow.
---

# nextjs-feature

Ship a Next.js feature with the full loop: code → types → test → type-check → manual verification.

## Steps

1. **Clarify the feature in 2–3 questions, max.** What does it do, where does it live (route/component), and any UI reference (existing component to match, design link)? Don't ask more — start coding once you know enough to begin.

2. **Locate the right home.** App Router projects: `app/<route>/`. Components: `components/`. Hooks: `hooks/`. Shared types: `types/`. Use the **Explore subagent** to find similar existing features for naming/style consistency — don't grep in main context.

3. **Implement in this order** (each is reversible and verifiable):
   - Types in `types/` if any new shape is involved.
   - Hook / state / data fetcher in `hooks/` or `lib/`.
   - Component in `components/<Feature>.tsx`.
   - Wire into the route or parent component.

4. **Write at least one test.** Match the project's existing test setup (Vitest in ToneFlow). Cover the golden path. Don't write 5 tests — write the one that would catch the most likely break.

5. **Type-check.** `npx tsc --noEmit`. Fix any errors caused by your changes. Don't fix unrelated errors.

6. **Run it and verify in a browser** — `/verify`, or `npm run dev` plus the browser. Check the golden path and 1–2 obvious edge cases. Do not report the task as done if you couldn't actually use the feature in a browser. Say so explicitly instead.

7. **Report** in 5 lines:
   - Files added/changed (paths)
   - Test command + result
   - Type-check result
   - Manual verification result (or "could not verify, here's why")
   - One follow-up the user might want (e.g. "no a11y review yet", "no error states")

## Anti-patterns to refuse

- Adding state management libs (Zustand, Redux, Jotai) without checking if the project already has one — match what's there.
- Inventing UI primitives when `components/ui/` already has them.
- Writing tests with mocked dependencies that wouldn't exist in production. Tests should hit real adapters where reasonable.
- Adding error handling for impossible cases. Validate at boundaries (form input, API response), trust internal code.
- "Refactoring while I'm here." Stay scoped to the feature.

## Mobile note

If the project has Capacitor (e.g. ToneFlow), most web-only changes work on Android via `npx cap sync`. Only worry about mobile-specific code if the feature touches device APIs (camera, audio, file system, push).
