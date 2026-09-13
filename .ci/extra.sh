#!/usr/bin/env bash
# Repo-specific checks for guildx-site (run by .github/scripts/validate.py)
set -euo pipefail

python3 - <<'PY'
import json, sys

REQUIRED = ["protocolVersion", "name", "description", "url", "version",
            "capabilities", "defaultInputModes", "defaultOutputModes", "skills"]

root = json.load(open("agent-card.json"))
well_known = json.load(open(".well-known/agent-card.json"))

missing = [k for k in REQUIRED if k not in root]
if missing:
    sys.exit(f"agent-card.json is missing required A2A fields: {missing}")
if root != well_known:
    sys.exit("agent-card.json and .well-known/agent-card.json have drifted apart")
print("A2A agent card complete and served copy in sync")
PY

test -s llms.txt
echo "llms.txt present and non-empty"
