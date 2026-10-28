#!/usr/bin/env bash
# Fails if a tracking, analytics, ads or crash-reporting package sneaks into
# the dependency tree. CardGuardian sends nothing off the device.
set -euo pipefail
cd "$(dirname "$0")/.."

DENY='firebase|crashlytics|sentry|analytics|amplitude|mixpanel|segment_|appsflyer|adjust_sdk|onesignal|google_mobile_ads|admob|facebook|datadog|bugsnag|newrelic|instabug|posthog|google_fonts|http_tracker'
found=$(grep -E '^  [a-z0-9_]+:$' pubspec.lock | tr -d ' :' | grep -E "$DENY" || true)
if [[ -n "$found" ]]; then
  echo "Denied packages found in pubspec.lock:" >&2
  echo "$found" >&2
  exit 1
fi

# No networking code in our own sources.
if grep -rnE "import 'package:(http|dio)/|HttpClient\(|Socket\.connect|WebSocket" lib packages/cg_core/lib; then
  echo "Network code found in app sources." >&2
  exit 1
fi
echo "Privacy check passed."
