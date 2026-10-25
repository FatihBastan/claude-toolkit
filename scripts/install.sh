#!/usr/bin/env bash
# One-time setup on a machine: add the marketplace, install core, enable the built-in "You Should Know" plugin.
# Packs are enabled per repo by /core:init-repo, not here.
set -euo pipefail
claude plugin marketplace add FatihBastan/claude-toolkit
claude plugin install core@fatih-toolkit
claude plugin enable cc-plugin-you-should-know@builtin || echo "(You Should Know not available in this Claude Code version — skipped)"
cat <<'MSG'

Done. Next:
  • In Claude Code: /plugin → Marketplaces → fatih-toolkit → Enable auto-update
  • In each repo:   /core:init-repo
MSG
