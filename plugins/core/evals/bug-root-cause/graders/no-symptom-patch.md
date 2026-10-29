---
type: regex
target: { source: file, path: app/report.py }
pattern: 'if not out_dir|out_dir or |or "reports"|or ''reports''|== ""'
match: not_contains
---
