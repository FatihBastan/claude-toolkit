# claude-toolkit

My Claude Code setup, packaged so every repo starts with the same good defaults: a lean always-on **core**, opt-in **packs** per stack, and one command — `/core:init-repo` — that wires a repo up.

Design rules: one skill per job, nothing that Claude Code already does built in, and as little always-on context as possible.

## Quick start

**Once per machine** (local CLI / desktop):
```bash
scripts/install.sh
# or by hand:
claude plugin marketplace add FatihBastan/claude-toolkit
claude plugin install core@fatih-toolkit
claude plugin enable cc-plugin-you-should-know@builtin
```
Then in `/plugin` → Marketplaces → `fatih-toolkit` → **Enable auto-update**, so pushes to this repo reach every machine.

**Once per repo:** run `/core:init-repo` in the repo. It detects the stack and writes:
- `CLAUDE.md` — a ≤ 80-line map from the matching template
- `.claude/settings.json` — deny rules for secrets/binaries/build output, plus the right packs
- `.claude/rules/` — `core.md` plus path-scoped language rules (`python`, `typescript`, `cpp`, `qt`, `unity-csharp`, `dart-flutter`; avionics adds `safety-c` and `qualified-tool`)
- in **portable** mode, copies of the skills and agents, so the repo also works in cloud sessions

You don't have to remember this: in a repo that isn't set up yet, a session-start check tells Claude to offer it.

**Cloud sessions** (claude.ai/code, phone) don't load plugins. Paste this instead:
> My toolkit is github.com/FatihBastan/claude-toolkit. Clone it to /tmp/claude-toolkit (or pull if it's there) and follow its INIT.md for this repo.

## What's inside

| Plugin | Enabled | Contents | Always-on cost* |
|---|---|---|---|
| `core` | everywhere | `/core:init-repo` `/core:spec` `/core:build` `/core:ship` `/core:interview` `/core:token-budget` · skills `tdd`, `bug-hunt`, `source-driven` · agents `build-error-resolver`, `silent-failure-hunter`, `web-researcher` | ~1.0k tok |
| `gamedev` | game repos | `/gamedev:setup` → upstream [gamedev skills](https://github.com/gamedev-skills/awesome-gamedev-agent-skills) (router + engine bundle) and optional Unity/Godot editor MCP | ~0.1k + upstream bundles (router 0.3k + Unity 1.2k; disciplines +2.6k) |
| `web3d` | three.js / R3F repos | `web3d-stack`: drei, Rapier, postprocessing, three.quarks, Yuka, Colyseus + frame-budget rules | ~0.1k |
| `web` | Next.js repos | `nextjs-feature` | ~0.1k |
| `mobile` | Flutter repos | `flutter-screen` | ~0.1k |
| `ml` | PyTorch / research repos | `ml-paper-repro` · agents `pytorch-build-resolver`, `ml-reviewer` | ~0.3k |
| `avionics` | DO-178C / DO-330 repos (`*.gpj`, or `/core:init-repo avionics`) | `requirements`: HLR/LLR + TOR/TR, trace checks, DOORS CSV/ReqIF export · init-repo adds the `safety-c` (MISRA C runtime), `qualified-tool` (code generator) and `qt` rules, each scoped to its own dir | ~0.1k |
| `session-log` | long projects, opt-in | `notes/daily/` handoff notes + resume/log hooks | ~0.1k |

\*From `claude plugin details`: descriptions loaded in every session. Bodies load only when used. Packs are `defaultEnabled: false` — they only turn on where a repo's settings enable them.

Turn a pack on in one repo by hand: add `"web3d@fatih-toolkit": true` under `enabledPlugins` in that repo's `.claude/settings.json` (packs install disabled; `/plugin install web3d --marketplace FatihBastan/claude-toolkit` just makes one available).

### The feature workflow
Claude picks these up by itself from what you say ("let's add X" → spec, "go" → build, "ready to merge" → ship); typing the commands also works.

`/core:interview` (vague idea) → `/core:spec` (SPEC.md + tasks/plan.md, stops for approval) → `/core:build` or `/core:build auto` (test-first slices, one commit each) → `/core:ship` (tests, `/code-review`, `/simplify`, `/security-review`, `/verify`, PR).

### Built into Claude Code — deliberately not duplicated
`/code-review` (bugs, multi-agent) · `/simplify` (cleanup) · `/security-review` · `/verify` + `/run-skill-generator` · plan mode / `/plan` · auto memory (`/memory`) · `/batch` (wide parallel changes) · `/fewer-permission-prompts` · `/context` · the built-in **You Should Know** plugin.

## Does it help? (evals)
`plugins/core/evals/` holds a `claude plugin eval` suite that runs each case with and without the plugin. Latest results ([RESULTS.md](plugins/core/evals/RESULTS.md)): on Sonnet 5.5 the plugin adds **+0.37** on average (spec +0.89, interview +0.67, tdd +0.44, bug-hunt +0.33) and **+0.21** on Opus, with no over-triggering on the guard cases. The key ingredient is the **Skill routing** section in `rules/core.md`, which the core plugin's SessionStart hook also injects in repos that aren't set up yet.

The `avionics` pack has its own case ([RESULTS.md](plugins/avionics/evals/RESULTS.md)): LLRs for a small C watchdog as a DOORS CSV scored **0.96 vs 0.78** on Sonnet. Without the skill there's no Derived attribute, and an un-traced start-up state gets silently pinned to an HLR.

## Layout
```
.claude-plugin/marketplace.json   the catalog (marketplace "fatih-toolkit")
plugins/
  core/
    skills/  agents/              always-on workflow
    rules/                        copied to <repo>/.claude/rules/ by init-repo
    scripts/                      session-start hook, rule-scopes.py (which rule hits which file), add-routing.py (pack routing lines)
    templates/claude-md/          CLAUDE.md per stack
    templates/settings/           permissions.deny fragments per stack
    packs/ → ../<pack>            symlinks so init-repo can copy pack files (dereferenced in the plugin cache)
  gamedev/ web3d/ web/ mobile/ ml/ avionics/ session-log/   packs (a pack's routing.md is added to the repo's Skill routing)
INIT.md                           no-plugin entry point (cloud sessions)
NOTICE.md                         credits and licenses
tips.md                           the habits behind the rules
scripts/install.sh, validate.sh
```

## Changing things
- Edit a skill → `scripts/validate.sh` → push. With auto-update on, machines pick it up; run `/reload-plugins` in an open session.
- Re-sync a repo after toolkit changes: `/core:init-repo refresh`.
- New skill: put it in the plugin it belongs to. Write the description as "Use when … / Not for …" so Claude triggers it at the right time; set `disable-model-invocation: true` only for things that must never fire on their own.
- Check cost: `claude plugin details core@fatih-toolkit`.

Credits: [NOTICE.md](NOTICE.md).
