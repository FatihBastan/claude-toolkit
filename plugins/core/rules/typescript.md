---
paths:
  - "**/*.{ts,tsx,mts,cts}"
  - "**/*.{js,jsx,mjs,cjs}"
---
# TypeScript / JavaScript

- Strict types: no `any` in app code. External data comes in as `unknown` and gets narrowed or validated at the boundary (zod or whatever the project uses).
- Type exported functions and component props; let locals infer. Prefer string-literal unions over `enum`.
- Use the package manager the lockfile says (npm / pnpm / yarn / bun). Ask before adding a dependency.
- Async: await or deliberately handle every promise — no floating promises. Only `try/catch` where you can actually handle the error.
- React: function components and hooks; hooks at the top level; derive values instead of syncing state through `useEffect`; stable keys. Use the project's existing state and data-fetching libraries.
- No leftover `console.log` / debug code in commits; use the project's logger if it has one.
- After changing types, run the type-check (`tsc --noEmit` or the project's script).
- Security: never pass untrusted data to `dangerouslySetInnerHTML` / `innerHTML`; no secrets in client bundles (`NEXT_PUBLIC_*` / `VITE_*` values are public by design).
