#!/usr/bin/env bash
set -e
mkdir -p utils tests
: > utils/__init__.py
cat > utils/paging.py <<'PY'
def paginate(items, page, per_page):
    """Return the items on 1-based page `page`."""
    start = (page - 1) * per_page
    return items[start:start + per_page - 1]


def legacyFmt(x):
    # old formatter, still used by the export job
    s = ""
    for i in range(len(x)):
        s = s + str(x[i]) + ","
    return s[:-1]
PY
cat > utils/other.py <<'PY'
def doStuff(a,b):
    return a+b
PY
cat > tests/test_paging.py <<'PY'
from utils.paging import paginate


def test_first_page_full():
    assert paginate(list(range(10)), 1, 3) == [0, 1, 2]
PY
printf '[pytest]\npythonpath = .\n' > pytest.ini
mkdir -p .claude && : > .claude/no-toolkit   # simulate a set-up repo: silence the init offer
