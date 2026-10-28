#!/usr/bin/env bash
# Runs a build command, and on failure reports the important log lines as
# GitHub annotations so they're readable from the checks API.
# Usage: ci_annotate.sh <logfile> <command...>
set -uo pipefail
log="$1"; shift
"$@" 2>&1 | tee "$log"
status=${PIPESTATUS[0]}
if [ "$status" -ne 0 ]; then
  lines=$(grep -E "error:|Error:|e: |What went wrong|FAILURE|Exception|Execution failed|> " "$log" | grep -v "^\s*at " | head -60)
  [ -z "$lines" ] && lines=$(tail -60 "$log")
  msg=$(printf '%s' "$lines" | sed -e 's/%/%25/g' | awk '{printf "%s%%0A", $0}')
  echo "::error title=$1 failed::$msg"
fi
exit "$status"
