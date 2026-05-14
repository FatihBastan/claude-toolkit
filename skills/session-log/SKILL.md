---
name: session-log
description: Maintain a per-project session log so future Claude sessions resume with fresh context. Two modes — "log this session" writes notes/daily/YYYY-MM-DD.md at session end; "resume" reads recent daily notes at session start. Use when the user wants context to carry across sessions in a long-running project. Skip for one-off tasks.
---

# session-log

Keep `notes/daily/YYYY-MM-DD.md` so a fresh Claude session in a multi-week project doesn't start cold. This is the *only* piece of the "agent memory" pattern that genuinely compounds for code projects — everything else (raw/, outputs/, wiki-links) is cosmetic.

## Mode 1 — Log this session

Trigger phrases: *"log this session"*, *"wrap up"*, *"save what we did"*, or at the end when the user signals done ("done", "thanks", "that's it for today").

1. **Check the folder exists.** If `notes/daily/` doesn't exist, ask once: *"Set up session logging for this project? I'll create `notes/daily/` and add it to .gitignore unless you want it committed."* Wait for confirmation. Don't auto-scaffold.

2. **Compute today's date** with `date +%Y-%m-%d`. File path: `notes/daily/<date>.md`. If it exists, append a new session block; otherwise create with a `# YYYY-MM-DD` heading.

3. **Write a session block** with this exact structure:
   ```
   ## Session — <HH:MM>

   **What changed:** <1–3 bullets, file paths included>
   **What's broken or open:** <bullets, or "nothing">
   **Next:** <1–2 bullets — what the next session should pick up>
   **Decisions:** <only non-obvious ones — design choices, ruled-out approaches>
   ```

4. **Cap each session block at ~15 lines.** Anything longer is a transcript, not a log. The git diff covers the *what*; this file covers the *why* and *next*.

## Mode 2 — Resume

Trigger phrases: *"resume"*, *"what did we do last time"*, *"read the daily note"*. Also implicitly on session start if a populated `notes/daily/` exists and CLAUDE.md opts in.

1. List `notes/daily/` and read **only the most recent 1–2 entries** (sorted by filename). Do not read the whole folder.

2. Summarize back in 3–5 lines: last session's "Next" bullets, anything still open, anything decided. That's the handoff — don't paraphrase the whole log.

3. If the latest entry is older than 14 days, flag it: *"Last session was N days ago — context may be stale; want me to re-scan the repo state?"*

## Anti-patterns

- **Decisions and next steps only — not a transcript.** If a session block exceeds ~15 lines, you're dumping the conversation. Cut until it fits.
- **Don't restate the diff.** "Edited foo.ts to add X" is in git. Write the *why* and what blocked next, not the *what*.
- **No `[[wiki-links]]`.** Claude doesn't traverse them as a graph; they're plain text. Write `notes/wiki/auth.md` if that's what you mean.
- **Don't read more than 2 daily notes on resume.** If older context is needed, the user will ask.
- **Don't auto-log on every response.** Only at session boundaries.

## Setup note

By default, add `notes/raw/` and `notes/daily/` to `.gitignore` — session logs are personal and noisy. `notes/wiki/` (if used) *should* be committed; codified knowledge travels with the repo. Ask the user which they want before deciding.
