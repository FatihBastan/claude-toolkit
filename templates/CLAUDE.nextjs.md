# {{ProjectName}}

{{One-line description.}}

## Stack

- Next.js {{version}} ({{App Router | Pages Router}}), TypeScript
- {{UI lib: Tailwind / shadcn / MUI / etc.}}
- {{State: Zustand / Redux / React Query / Context only}}
- {{Tests: Vitest / Jest / Playwright}}
- {{Mobile wrapper: Capacitor / Expo / none}}
- Deploy: {{Vercel / self-hosted / other}}

## Map

- `app/` — App Router routes (or `pages/` if Pages Router)
- `components/` — UI components
- `lib/` — shared utilities, API clients, helpers
- `hooks/` — React hooks
- `types/` — shared TypeScript types
- `tests/` — {{test framework}} tests
- `public/` — static assets
- {{any project-specific top-level dirs}}

## Commands

- Dev: `npm run dev`
- Build: `npm run build`
- Test: `{{npm test | npx vitest}}`
- Type check: `npx tsc --noEmit`
- Lint: `npm run lint`
- {{Mobile build if Capacitor: `npx cap sync && npx cap open android`}}

## Conventions

- {{Component file naming: PascalCase.tsx?}}
- {{Server vs client components: how marked, where the boundary is}}
- {{API routes: where they live, auth pattern}}
- {{Forms: react-hook-form? server actions?}}

## Working with Claude in this repo

- For "where is X used" / "how is Y wired" questions, spawn the **Explore subagent**.
- For UI changes, run `npm run dev` and verify in a browser before reporting done.
- Prefer Edit over Write for existing components.
- Type-check (`npx tsc --noEmit`) after non-trivial type changes.
- If `notes/daily/` exists, read the latest entry on session start and log to today's file at session end. (See `session-log` skill.)

## Don't read

- `.next/`, `node_modules/`, `node_modules/.cache/`, `.vercel/`
- `package-lock.json`, `tsconfig.tsbuildinfo`
- `coverage/`, `dist/`, `build/`
- `*.map`, `*.min.js`, `*.min.css`
- `android/build/`, `android/app/build/`, `ios/Pods/` (if Capacitor)
- {{Project-specific generated dirs}}
