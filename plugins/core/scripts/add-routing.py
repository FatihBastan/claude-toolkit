#!/usr/bin/env python3
"""Add pack routing lines to the "## Skill routing" section of a repo's core.md.

Usage:  python3 add-routing.py <repo>/.claude/rules/core.md <pack>/routing.md [...]

Idempotent: a line that is already in the section is skipped, so running it
again (or on every refresh) adds nothing. New lines go just before the catch-all
"- Trivial ..." line, or at the end of the section if that line is missing.
"""
import sys

HEADING = "## Skill routing"


def main(argv):
    if len(argv) < 3:
        print(__doc__.strip().splitlines()[2].strip(), file=sys.stderr)
        return 2
    target, sources = argv[1], argv[2:]
    with open(target, encoding="utf-8") as f:
        lines = f.read().splitlines()

    try:
        start = next(i for i, l in enumerate(lines) if l.strip() == HEADING)
    except StopIteration:
        print(f"routing: no '{HEADING}' section in {target}", file=sys.stderr)
        return 1
    end = next((i for i in range(start + 1, len(lines)) if lines[i].startswith("## ")), len(lines))

    seen = {l.strip() for l in lines[start + 1:end]}
    new = []
    for src in sources:
        with open(src, encoding="utf-8") as f:
            for line in f.read().splitlines():
                key = line.strip()
                if key.startswith("- ") and key not in seen:
                    seen.add(key)
                    new.append(key)

    if not new:
        print("routing: up to date")
        return 0

    at = next((i for i in range(start + 1, end) if lines[i].startswith("- Trivial")), None)
    if at is None:
        at = end
        while at > start + 1 and not lines[at - 1].strip():
            at -= 1
    lines[at:at] = new

    with open(target, "w", encoding="utf-8") as f:
        f.write("\n".join(lines) + "\n")
    print(f"routing: added {len(new)} line(s)")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
