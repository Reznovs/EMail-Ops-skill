#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

for py in python3 python py; do
  if command -v "$py" >/dev/null 2>&1; then
    exec "$py" "$SCRIPT_DIR/mail_tools.py" "$@"
  fi
done

echo "Error: No Python interpreter found (tried python3, python, py)" >&2
exit 1
