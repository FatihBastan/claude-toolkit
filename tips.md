# Habits that keep Claude accurate and cheap

The "why" behind the toolkit. Most of it is already encoded in `plugins/core/rules/core.md` and the CLAUDE.md templates.

## 1. Always-on context is the budget that matters
Everything in CLAUDE.md, every rule without `paths:`, and every enabled skill or agent description is paid for in **every** session. Skill and agent *bodies* load only when used.
- Keep CLAUDE.md under ~80 lines: a map, not documentation.
- Path-scope language rules (`paths:` frontmatter) so the Python rules only load when Claude touches `.py` files.
- Write skill descriptions as "Use when … / Not for …" so they fire at the right time and nowhere else. Make a skill user-only (`disable-model-invocation: true`) only if it must never fire on its own.
- Enable stack packs per repo, not globally. `claude plugin details <plugin>` shows the projected cost; `/context` shows what's actually loaded.

## 2. Explore subagent for searching
"Where is X / how is Y wired / what references Z" → have the **Explore** subagent do it. It greps and reads in its own context and returns a summary. Not for code review or cross-file consistency checks — it reads excerpts.

## 3. Plan first, then build in thin slices
For anything non-trivial: approach + files → approval → one slice at a time with tests (`/spec` → `/build`). The most expensive failure is a big build of the wrong thing.

## 4. Give Claude a way to check its work
Tests, a type-check, a screenshot, or `/verify` (run `/run-skill-generator` once per repo so it knows how to launch the app). With feedback Claude iterates to a much better result; without it, it guesses.

## 5. Hard blocks beat polite requests
A "Don't read" line in CLAUDE.md is a suggestion. `permissions.deny` in `.claude/settings.json` is enforced — use it for secrets, binaries and build output. Keep soft skips for things Claude sometimes genuinely needs (`node_modules/` types, lockfile versions, Unity `.meta` GUIDs).

## 6. Use what's built in
Don't rebuild what Claude Code already ships: `/code-review` (bugs), `/simplify` (cleanup), `/security-review`, `/verify`, plan mode, auto memory (`/memory`), `/batch` for wide parallel changes, `/fewer-permission-prompts`, `/context`.

## 7. Ranged reads on big files
When you only need lines 200–280, read with offset/limit. Note very large files in CLAUDE.md.

## 8. Don't paste long output back
Have Claude run the command so the output is captured once, or paste only the ~10 relevant lines.

## 9. Fresh sessions for unrelated work
Carrying feature A's context into bug B is pure tax. CLAUDE.md, rules and auto memory carry what matters across sessions.
