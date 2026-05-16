---
name: skill-author
description: Write a new SKILL.md in this toolkit's house style. Use when adding a skill to skills/, refactoring an existing skill that has grown verbose, or porting an external skill in. Keeps skills under 80 lines, opinionated, and matched to how this toolkit actually works.
---

# skill-author

A skill in this toolkit is **a map of when to invoke a workflow and how to run it**, not documentation of an idea. It must be short enough that a future Claude session reads it without complaining and specific enough that it changes behavior.

## Test it before you write it (RED phase)

Before adding a skill, prove the gap exists. Run a baseline: ask a fresh Claude session to perform the task *without* the skill. Watch where it fumbles — wrong order, wrong defaults, rationalizing skipping a step. **Those failures are what the skill must close.**

Skip this and you'll write generic best-practice prose that helps no one.

## House style

- **Frontmatter, required:**
  ```yaml
  ---
  name: <kebab-case slug>
  description: <one paragraph — when to use, when to skip, what the skill does. The harness matches against this. Be specific about triggers.>
  ---
  ```
- **Body, target ≤80 lines.** If you're over 100, you're padding.
- **Voice:** direct, opinionated, second-person to Claude. No hedging ("you might want to consider"), no praise, no introductions.
- **No emojis. No marketing copy. No "best practices" preamble.**
- **Concrete over abstract.** A 5-line example beats a 20-line explanation.
- **Anti-patterns section** at the end is usually worth its weight. List the rationalizations Claude will reach for and explicitly close them.

## Required sections (skip any that would be empty)

1. **Opening rule or principle** — one or two sentences. The single most important thing.
2. **The workflow** — numbered steps. Each step is something Claude can act on.
3. **When to skip** — explicit exceptions. Skills that never opt out get ignored under pressure.
4. **Anti-patterns** — the wrong moves, named. Closes loopholes.
5. **Hard rule** — one final invariant in a code block if the skill has a non-negotiable.

## File layout

```
skills/<skill-name>/
├── SKILL.md            (required)
├── scripts/            (optional — only if Claude needs to invoke a reusable script)
└── templates/          (optional — only if Claude copies boilerplate)
```

`SKILL.md` is the only required file. Don't ship `assets/`, `examples/`, or `README.md` — they're noise. If the skill needs supporting files, link to them inline.

## Refactor pass (REFACTOR phase)

After writing, re-test with a subagent. Where it still gets the workflow wrong, the skill is missing a step or letting in a rationalization. Add a targeted line, not a section. **Tighten, don't expand.**

## Anti-patterns

- **Narrative examples tied to a specific incident** ("when I was working on the auth migration last week…"). Generic + abstract beats specific + stale.
- **Multi-language code samples.** Pick one language and show one excellent example.
- **"This skill helps you write better X."** Skills are instructions, not pep talks.
- **Listing every option a tool takes.** That's reference docs. Link to them; don't reproduce them.
- **Vague triggers in the description.** "Use when working on code" never matches. "Use when the user reports a flaky test or a stack trace they don't understand" matches.

## Hard rule

```
A skill that doesn't change behavior is dead weight.
If you can't name what it stops Claude from doing wrong,
it doesn't belong in skills/.
```
