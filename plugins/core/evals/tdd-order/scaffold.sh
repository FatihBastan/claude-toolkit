#!/usr/bin/env bash
set -e
mkdir -p textutils tests
: > textutils/__init__.py
cat > textutils/core.py <<'PY'
def word_count(text: str) -> int:
    return len(text.split())
PY
cat > tests/test_core.py <<'PY'
from textutils.core import word_count


def test_word_count():
    assert word_count("a b  c") == 3
PY
printf '[pytest]\npythonpath = .\n' > pytest.ini
mkdir -p .claude && : > .claude/no-toolkit   # simulate a set-up repo: silence the init offer
