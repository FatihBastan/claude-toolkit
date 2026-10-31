#!/usr/bin/env bash
set -e
cat > greet.py <<'PY'
def greet(usr):
    if not usr:
        return "Hello, stranger"
    return f"Hello, {usr}!"
PY
mkdir -p .claude && : > .claude/no-toolkit   # simulate a set-up repo: silence the init offer
