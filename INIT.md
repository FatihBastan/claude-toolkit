# INIT — set up a repo without the plugin

Use this when the toolkit plugin isn't installed: in a **cloud session** (claude.ai/code, phone, desktop cloud tasks — plugins don't load there), or on a machine where you haven't added the marketplace.

Prompt to paste:

> My toolkit is github.com/FatihBastan/claude-toolkit. Clone it to /tmp/claude-toolkit (or pull if it's there) and follow its INIT.md for this repo.

## Instructions for Claude

1. Get the toolkit:
   ```bash
   git clone --depth 1 https://github.com/FatihBastan/claude-toolkit /tmp/claude-toolkit 2>/dev/null \
     || git -C /tmp/claude-toolkit pull --ff-only
   ```
   It's a private repo. In a cloud session, attach it to the session first (add the repository), then clone.
2. Read `/tmp/claude-toolkit/plugins/core/skills/init-repo/SKILL.md` and follow it for the **current** repo, with `CORE = /tmp/claude-toolkit/plugins/core`.
3. In a cloud session the mode is **portable** (skills and agents get copied into the repo, because plugins don't load). Locally, ask as the skill says.
4. Pass along any argument the user gave (`refresh`, `portable`, `plugin`).

Everything else — detection, what gets written, the hard rules — is in that skill file. Don't improvise extra steps.
