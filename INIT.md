# INIT — Instructions for Claude

You are reading this because Fatih pointed you at his personal Claude Code toolkit. Your job: make the **current project** Claude-ready, fast, and with **minimal token waste**.

Follow these steps in order. Do not skip steps. Do not improvise extra exploration — the whole point of this file is to keep your context lean.

---

## Step 1 — Confirm working directory

Run `pwd` and `ls`. The working directory is the project to be initialized. The toolkit lives elsewhere (probably `~/claude-toolkit` or `/tmp/claude-toolkit`).

If the project already has a `CLAUDE.md`, read it first (one Read call). Then ask Fatih: *"There's an existing CLAUDE.md. Replace it, merge into it, or leave it alone?"* Don't overwrite without confirmation.

---

## Step 2 — Detect project type

Inspect the project root with `ls`. Match top-down — first match wins:

| Signal | Project type | Template |
|---|---|---|
| Has multiple top-level service dirs (e.g. `backend/` + `frontend/` + `flutter_frontend/`, or `backend/` + `mobile/`) | Full-stack | `templates/CLAUDE.fullstack.md` |
| Has `pubspec.yaml` | Flutter | `templates/CLAUDE.flutter.md` |
| Has `package.json` AND (`next.config.*` OR `app/` OR `pages/`) | Next.js | `templates/CLAUDE.nextjs.md` |
| Has `pyproject.toml` / `requirements*.txt` / `.venv` AND (PyTorch / `transformers` / `timm` / `*.ipynb` / a `models/` or `train.py`) | Python ML | `templates/CLAUDE.python-ml.md` |
| Anything else | Generic | `templates/CLAUDE.base.md` |

If unsure between two, ask Fatih in one short question.

---

## Step 3 — Read at most these files (no more)

You have a hard budget of **8 file reads** for the whole init. Pick from this list as relevant:

- The chosen template (1)
- `templates/dont-read.md` (1)
- `package.json` / `pyproject.toml` / `requirements.txt` / `pubspec.yaml` (1)
- `README.md` of the project, **first 100 lines only** (1)
- `tsconfig.json` / `next.config.*` / `vite.config.*` if Next.js (1)
- One representative source file **only if** you genuinely can't fill the template otherwise (1)

For "where does X live" questions while filling the template, **spawn the Explore subagent** — do not grep yourself. Explore returns a summary; your context stays lean.

Do **not** read: `node_modules/`, `.venv/`, `.next/`, `dist/`, `build/`, `.git/`, lockfiles, generated `tsconfig.tsbuildinfo`, anything in `templates/dont-read.md`.

---

## Step 4 — Fill the template

The template has `{{double_braces}}` placeholders. Fill each one based on what you read in Step 3. If you cannot fill a placeholder confidently, leave it as `{{TODO: <what's missing>}}` rather than guessing — Fatih will fix it later.

Keep the resulting CLAUDE.md **under 80 lines**. If you're tempted to add more, you're padding. The goal is a map, not documentation.

---

## Step 5 — Write CLAUDE.md to the project root

Use the Write tool. Path: `<project_root>/CLAUDE.md`.

Then append a `## Don't read` section at the bottom that includes:
- Generic patterns from `templates/dont-read.md`.
- Anything project-specific you noticed (e.g. `imagenet_val/`, `model_checkpoints/`, large data dirs, generated build artifacts).

---

## Step 6 — Suggest skills

Look at `skills/` in the toolkit. Pick **2–4 skills** that match this project type. List them to Fatih with one line each on what they do, and ask which to install. Do not auto-install — copying files into `~/.claude/skills/` is a global change.

Default suggestions by project type:

- **Next.js** → `nextjs-feature`, `tight-claude-md`, `token-budget`
- **Python ML** → `ml-paper-repro`, `tight-claude-md`, `token-budget`
- **Flutter** → `flutter-screen`, `tight-claude-md`, `token-budget`
- **Full-stack** → all of the above that match the sub-services
- **Generic** → `tight-claude-md`, `token-budget`

To install a chosen skill:
```bash
cp -r ~/claude-toolkit/skills/<skill-name> ~/.claude/skills/
```

---

## Step 7 — Report

One short paragraph (5–8 lines max). Cover:
- Project type detected
- Path to the new CLAUDE.md
- Skills suggested and which were installed
- Anything that surprised you (missing README, no test setup, ambiguous structure)

Do **not** summarize the project itself — Fatih wrote it, he knows. Only report what *you* did and what *you* noticed.

---

## Hard rules

- **8 reads max during init.** If you need more, stop and ask.
- **Never run** build/test/install commands during init — only inspect.
- **Use Explore** for grep-style questions, never grep directly during init.
- **Don't write** anything other than the project's `CLAUDE.md`. No README edits, no `.gitignore` changes, no setup scripts. The user controls those.
- **If anything is ambiguous, ask** — one sharp question beats five wrong assumptions.
