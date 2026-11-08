---
type: regex
target: { source: file, path: requirements/llr.csv }
pattern: '\bshall\b[^\n]*\bshall\b'
match: not_contains
---
