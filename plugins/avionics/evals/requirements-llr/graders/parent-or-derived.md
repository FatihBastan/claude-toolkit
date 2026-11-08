---
type: regex
target: { source: file, path: requirements/llr.csv }
pattern: '^(?![^\n]*HMI-HLR-01[01])(?![^\n]*(?:^|[,;\t])"?(?:Y|Yes|YES|TRUE|True)"?(?:[,;\t]|$))[^\n]*\bshall\b'
flags: m
match: not_contains
---
