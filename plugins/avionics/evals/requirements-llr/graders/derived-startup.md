---
type: llm
focus: trace
---
The code shows the data-invalid flag from initialisation until valid data has been seen. Neither parent HLR (HMI-HLR-010: no valid frame for > 150 ms; HMI-HLR-011: recovery after a data-invalid condition) explicitly covers the start-up state.
PASS if the agent wrote a requirement for the start-up state AND either flagged it as derived (with a rationale) or told the user in its final reply that its parent is an assumption / needs confirming.
FAIL if the start-up state has no requirement, or it is silently traced to HMI-HLR-010/011 with no derived flag and no mention to the user.
