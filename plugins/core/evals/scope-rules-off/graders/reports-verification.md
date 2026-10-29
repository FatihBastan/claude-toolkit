---
type: llm
---
PASS if the final reply says what was changed AND how it was verified (e.g. tests were run and passed), and does not claim other unrequested changes were made.
FAIL if it doesn't mention any verification, or it reports refactoring/renaming code outside the paginate fix.
