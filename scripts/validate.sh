#!/usr/bin/env bash
# Validate the marketplace, every plugin, the settings fragments and the pack symlinks.
# Usage: scripts/validate.sh            (needs the `claude` CLI on PATH, or set CLAUDE_BIN)
set -euo pipefail
cd "$(dirname "$0")/.."
CLAUDE_BIN="${CLAUDE_BIN:-claude}"
fail=0

echo "▸ marketplace + plugins"
"$CLAUDE_BIN" plugin validate . >/dev/null || { echo "  ✗ marketplace"; fail=1; }
# Plugins: errors fail, warnings are fine (no "version" on purpose — omitting it lets machines track commits).
for p in plugins/*/; do
  "$CLAUDE_BIN" plugin validate "$p" >/dev/null || { echo "  ✗ $p"; fail=1; }
done

echo "▸ settings fragments are valid JSON"
for f in plugins/core/templates/settings/*.json; do
  python3 -m json.tool "$f" >/dev/null || { echo "  ✗ $f"; fail=1; }
done

echo "▸ core/packs symlinks resolve"
for l in plugins/core/packs/*; do
  [ -e "$l" ] || { echo "  ✗ broken link: $l"; fail=1; }
done

echo "▸ every SKILL.md has a name and a description"
while IFS= read -r f; do
  head -12 "$f" | grep -q '^name:' && head -12 "$f" | grep -q '^description:' || { echo "  ✗ $f"; fail=1; }
done < <(find -L plugins -name SKILL.md -not -path '*/packs/*')

[ "$fail" -eq 0 ] && echo "✔ all good" || { echo "✗ problems found"; exit 1; }
