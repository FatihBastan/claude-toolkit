#!/usr/bin/env bash
set -e
mkdir -p todo tests
cat > todo/__init__.py <<'PY'
PY
cat > todo/store.py <<'PY'
import json
from pathlib import Path

DB = Path("todos.json")


def load():
    if not DB.exists():
        return []
    return json.loads(DB.read_text())


def save(items):
    DB.write_text(json.dumps(items, indent=2))
PY
cat > todo/cli.py <<'PY'
import argparse
from todo import store


def main(argv=None):
    p = argparse.ArgumentParser(prog="todo")
    sub = p.add_subparsers(dest="cmd", required=True)
    a = sub.add_parser("add"); a.add_argument("title")
    sub.add_parser("list")
    d = sub.add_parser("done"); d.add_argument("index", type=int)
    args = p.parse_args(argv)
    items = store.load()
    if args.cmd == "add":
        items.append({"title": args.title, "done": False})
    elif args.cmd == "list":
        for i, t in enumerate(items):
            print(f"{i}. [{'x' if t['done'] else ' '}] {t['title']}")
    elif args.cmd == "done":
        items[args.index]["done"] = True
    store.save(items)


if __name__ == "__main__":
    main()
PY
cat > tests/test_store.py <<'PY'
from todo import store


def test_roundtrip(tmp_path, monkeypatch):
    monkeypatch.setattr(store, "DB", tmp_path / "t.json")
    store.save([{"title": "a", "done": False}])
    assert store.load() == [{"title": "a", "done": False}]
PY
printf '[pytest]\npythonpath = .\n' > pytest.ini
mkdir -p .claude && : > .claude/no-toolkit   # simulate a set-up repo: silence the init offer
