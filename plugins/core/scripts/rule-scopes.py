#!/usr/bin/env python3
"""Show which .claude/rules files apply to which files in a repo, and flag clashes.

Usage:  python3 rule-scopes.py [REPO_DIR]

A rule with `paths:` frontmatter loads only when Claude touches a matching file;
a rule without it loads always. The check fails (exit 1) when a file covered by
`safety-c.md` is also covered by another path-scoped rule, because airborne C
must get the safety rules only.
"""
import os
import re
import subprocess
import sys

EXCLUSIVE = "safety-c.md"


def expand_braces(pattern):
    m = re.search(r"\{([^{}]*)\}", pattern)
    if not m:
        return [pattern]
    head, tail = pattern[: m.start()], pattern[m.end():]
    return [p for alt in m.group(1).split(",") for p in expand_braces(head + alt + tail)]


def glob_to_regex(glob):
    out, i = "", 0
    while i < len(glob):
        if glob.startswith("**/", i):
            out, i = out + "(?:.*/)?", i + 3
        elif glob.startswith("**", i):
            out, i = out + ".*", i + 2
        elif glob[i] == "*":
            out, i = out + "[^/]*", i + 1
        elif glob[i] == "?":
            out, i = out + "[^/]", i + 1
        else:
            out, i = out + re.escape(glob[i]), i + 1
    return re.compile(out + r"\Z")


def rule_paths(path):
    """Return the list of `paths:` globs, or None if the rule has no paths (always loaded)."""
    lines = open(path, encoding="utf-8").read().splitlines()
    if not lines or lines[0].strip() != "---":
        return None
    globs, in_paths = [], False
    for line in lines[1:]:
        if line.strip() == "---":
            break
        if re.match(r"^paths:\s*$", line):
            in_paths = True
            continue
        if in_paths:
            m = re.match(r'^\s+-\s+["\']?([^"\'#]+?)["\']?\s*$', line)
            if m:
                globs.append(m.group(1))
            elif line.strip() and not line.strip().startswith("#"):
                in_paths = False
    return globs or None


def repo_files(root):
    try:
        out = subprocess.run(["git", "-C", root, "ls-files", "--cached", "--others", "--exclude-standard"],
                             capture_output=True, text=True, check=True).stdout.splitlines()
        if out:
            return [f for f in out if not f.startswith(".claude/")]
    except (OSError, subprocess.CalledProcessError):
        pass
    files = []
    for d, dirs, names in os.walk(root):
        dirs[:] = [x for x in dirs if x not in (".git", ".claude", "node_modules", "build")]
        files += [os.path.relpath(os.path.join(d, n), root).replace(os.sep, "/") for n in names]
    return files


def main():
    root = sys.argv[1] if len(sys.argv) > 1 else "."
    rules_dir = os.path.join(root, ".claude", "rules")
    if not os.path.isdir(rules_dir):
        sys.exit(f"no {rules_dir}")
    scoped = {}
    for name in sorted(os.listdir(rules_dir)):
        if name.endswith(".md"):
            globs = rule_paths(os.path.join(rules_dir, name))
            if globs is None:
                print(f"always  {name}")
            else:
                scoped[name] = [glob_to_regex(g) for glob in globs for g in expand_braces(glob)]
    files = repo_files(root)
    hits = {f: [n for n, rx in scoped.items() if any(r.match(f) for r in rx)] for f in files}
    for name in scoped:
        print(f"{sum(name in h for h in hits.values()):5d}  {name}")
    clashes = [(f, h) for f, h in hits.items() if EXCLUSIVE in h and len(h) > 1]
    for f, h in clashes[:20]:
        print(f"CLASH  {f}: {', '.join(h)}")
    if clashes:
        print(f"✗ {len(clashes)} file(s) under {EXCLUSIVE} also get other path-scoped rules")
        sys.exit(1)
    print("✔ no clashes")


if __name__ == "__main__":
    main()
