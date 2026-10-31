#!/usr/bin/env bash
set -e
mkdir -p app tests
: > app/__init__.py
cat > app/config.py <<'PY'
import json
from pathlib import Path

DEFAULTS = {"output_dir": "reports", "title": "Report"}


def load(path="settings.json"):
    data = dict(DEFAULTS)
    p = Path(path)
    if p.exists():
        data.update(json.loads(p.read_text()))
    return data
PY
cat > app/report.py <<'PY'
from pathlib import Path


def write_report(out_dir: str, name: str, body: str) -> Path:
    path = Path(out_dir) / name
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(body)
    return path
PY
cat > app/main.py <<'PY'
from app import config, report


def run():
    cfg = config.load()
    out = cfg.get("output", "")
    return report.write_report(out, "report.txt", f"{cfg['title']}\n")


if __name__ == "__main__":
    print(run())
PY
cat > settings.json <<'JSON'
{"output_dir": "reports", "title": "Weekly report"}
JSON
cat > tests/test_report.py <<'PY'
from app.report import write_report


def test_writes_into_dir(tmp_path):
    p = write_report(str(tmp_path / "out"), "r.txt", "x")
    assert p.read_text() == "x"
PY
printf '[pytest]\npythonpath = .\n' > pytest.ini
mkdir -p .claude && : > .claude/no-toolkit   # simulate a set-up repo: silence the init offer
