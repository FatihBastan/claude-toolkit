# Token-efficient habits with Claude Code

Things I've learned that save input tokens without dropping accuracy. The CLAUDE.md template encodes most of these implicitly — this file is the "why" behind the rules.

## 1. The Explore subagent is the single biggest win

For any "where is X / how is Y wired / which files reference Z" question, ask Claude to **spawn the Explore subagent**.

What it does: runs grep/find/read in its own isolated context window, returns a short summary. Your main session never sees the raw output.

When to use it:
- "Find every place we call the auth API"
- "Map the data flow from upload to transcription"
- "Which components use the `useToneFlowStore` hook?"

When **not** to use it:
- Code review — Explore reads excerpts, will miss content past its window
- Cross-file consistency checks
- Open-ended "tell me about this codebase" — too vague, will dump too much back

How to invoke:
- *"Use the Explore subagent to find …"*
- *"Spawn Explore on `backend/`, look for …"*

## 2. Hand-write CLAUDE.md, don't `/init`

`/init` produces a verbose, generic CLAUDE.md that often doubles as documentation. That's not what you want — you want a **map**, not docs.

A good CLAUDE.md:
- Under 80 lines
- Stack + map + commands + 2–3 conventions + don't-read list
- Says "for X type of question, use Explore"

A bad CLAUDE.md:
- Reproduces the README
- Lists every npm script
- Explains what TypeScript is

The toolkit's INIT.md is built around this principle.

## 3. Ranged reads on big files

When you know you only need lines 200–280, ask Claude to read with offset/limit instead of slurping the whole file. Note in CLAUDE.md which files are large enough to warrant this — usually anything over ~800 lines.

## 4. Don't-read list does heavy lifting

Every project has dirs that *exist* but should never be read. They burn input tokens for zero accuracy gain:
- `node_modules/`, `.venv/`, `.next/`, `dist/` — always
- Lockfiles — read once if dep versions matter, then never again
- Generated `*.g.dart`, `*.freezed.dart`, `tsconfig.tsbuildinfo`
- Model weights, datasets, raw images

Put them in CLAUDE.md's `## Don't read` section. See `templates/dont-read.md` for ready-made lists per stack.

## 5. Secrets get `.claude/settings.json` deny rules, not just CLAUDE.md

CLAUDE.md is a *suggestion* — Claude can still be asked to read those paths. For real enforcement (env files, credentials), use `permissions.deny` in `.claude/settings.json`. See `templates/dont-read.md` for the format.

## 6. Don't paste long output back

When a tool produces a 500-line log, don't paste the whole thing into the chat asking "what's wrong?". Either:
- Run the command via Claude so the output is captured once and never re-sent.
- Or grep the relevant ~10 lines and paste those.

The second one is what you'd do with a colleague. Same here.

## 7. Long-running work in subagents

For anything that'll take a lot of reads/writes (paper repro, big refactor, cross-service feature), spawn a subagent rather than doing it inline. The subagent's context isolation means your main session doesn't accumulate the noise. You get back a clean summary, can ask follow-ups, and your main context stays usable for hours instead of minutes.

## 8. Fresh sessions for unrelated tasks

If you've been deep in feature A for an hour, then want to look at unrelated bug B — start a new session. Carrying feature-A context into bug-B work is pure tax with no benefit. Memory + CLAUDE.md handle continuity for the things that matter.
