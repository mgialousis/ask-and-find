#!/usr/bin/env bash
set -euo pipefail

mode="release"
no_tree_shake="false"
DART_DEFINES=()
POSTHOG_KEY=""
POSTHOG_HOST=""
POSTHOG_DEBUG="true"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --debug)
      mode="debug"
      shift
      ;;
    --release)
      mode="release"
      shift
      ;;
    --no-tree-shake-icons)
      no_tree_shake="true"
      shift
      ;;
    --posthog-key)
      POSTHOG_KEY="$2"
      shift 2
      ;;
    --posthog-host)
      POSTHOG_HOST="$2"
      shift 2
      ;;
    --posthog-debug)
      POSTHOG_DEBUG="true"
      shift
      ;;
    -h|--help)
      echo "Usage: scripts/android_build.sh [--release|--debug] [--no-tree-shake-icons] [--posthog-key <key>] [--posthog-host <host>] [--posthog-debug]"
      exit 0
      ;;
    *)
      echo "Unknown flag: $1" >&2
      echo "Usage: scripts/android_build.sh [--release|--debug] [--no-tree-shake-icons] [--posthog-key <key>] [--posthog-host <host>] [--posthog-debug]" >&2
      exit 1
      ;;
  esac
 done

flutter clean
flutter pub get

cmd=(flutter build apk "--$mode")
if [[ "$no_tree_shake" == "true" ]]; then
  cmd+=("--no-tree-shake-icons")
fi
if [[ -n "${POSTHOG_KEY}" ]]; then
  DART_DEFINES+=("--dart-define=POSTHOG_API_KEY=${POSTHOG_KEY}")
elif [[ -n "${POSTHOG_API_KEY:-}" ]]; then
  DART_DEFINES+=("--dart-define=POSTHOG_API_KEY=${POSTHOG_API_KEY}")
fi
if [[ -n "${POSTHOG_HOST}" ]]; then
  DART_DEFINES+=("--dart-define=POSTHOG_HOST=${POSTHOG_HOST}")
elif [[ -n "${POSTHOG_HOST:-}" ]]; then
  DART_DEFINES+=("--dart-define=POSTHOG_HOST=${POSTHOG_HOST}")
fi
if [[ -n "${POSTHOG_DEBUG}" ]]; then
  DART_DEFINES+=("--dart-define=POSTHOG_ALLOW_DEBUG=true")
elif [[ -n "${POSTHOG_ALLOW_DEBUG:-}" ]]; then
  DART_DEFINES+=("--dart-define=POSTHOG_ALLOW_DEBUG=${POSTHOG_ALLOW_DEBUG}")
fi

"${cmd[@]}" "${DART_DEFINES[@]}"
