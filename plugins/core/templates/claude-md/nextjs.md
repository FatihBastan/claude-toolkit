# {{ProjectName}}

{{One line.}}

## Stack
- Next.js {{version}} ({{App Router / Pages Router}}), TypeScript
- UI: {{Tailwind / shadcn / …}} · State/data: {{Zustand / React Query / server actions / …}}
- Tests: {{Vitest / Jest / Playwright}} · Mobile wrapper: {{Capacitor / none}} · Deploy: {{Vercel / …}}

## Map
- `app/` — routes {{or `pages/`}} · `components/` — UI · `lib/` — clients & helpers
- `hooks/` · `types/` · `tests/` · `public/`
- {{project-specific dirs}}

## Commands
- Dev: `npm run dev` · Build: `npm run build` · Test: `{{cmd}}` · Typecheck: `npx tsc --noEmit` · Lint: `npm run lint`
- {{Capacitor: `npx cap sync && npx cap open android`}}

## Conventions
- {{Server vs client component boundary; where API routes live; auth pattern}}
- {{Forms: react-hook-form / server actions}}

## Working with Claude here
- Features: `/spec` → `/build` → `/ship` (prefix `core:` when using the plugin); single features: `nextjs-feature` skill.
- UI changes: run the dev server and check in a browser (`/verify`) before reporting done.
- "Where is X used" → **Explore** subagent.
- Working rules: `.claude/rules/` (core + TypeScript, path-scoped).

## Don't read
Hard blocks (`.next/`, coverage, secrets) are in `.claude/settings.json`. Also skip unless asked:
- `node_modules/`, `package-lock.json`, `android/build/`, `ios/Pods/` (Capacitor)
- {{Project-specific generated dirs}}
