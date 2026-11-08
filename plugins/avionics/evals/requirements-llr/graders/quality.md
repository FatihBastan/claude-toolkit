---
type: llm
focus: { source: file, path: requirements/llr.csv }
---
PASS if the LLRs in this CSV are detailed enough to code and test from: they state the concrete values from the code (the 150 ms timeout and the 3 consecutive valid frames), give the abnormal cases their own requirements (a frame with a bad CRC resets the valid-frame count; the timeout stays correct when the 32-bit millisecond counter wraps around), use no vague words ("appropriate", "robust", "handle", "etc."), and contain no C code.
FAIL if any of the concrete values is missing, or neither abnormal case is covered, or the requirements are vague or restate the code line by line.
