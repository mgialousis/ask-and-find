#!/usr/bin/env bash
set -euo pipefail

mode="release"
no_tree_shake="false"
run_icons="false"
DART_DEFINES=()
POSTHOG_KEY_ARG=""
POSTHOG_HOST_ARG=""
POSTHOG_DEBUG_ARG="true"
ENV_FILE="${ENV_FILE:-.env}"

if [[ -f "${ENV_FILE}" ]]; then
  set -a
  # shellcheck disable=SC1090
  source "${ENV_FILE}"
  set +a
fi

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
    --icons)
      run_icons="true"
      shift
      ;;
    --posthog-key)
      POSTHOG_KEY_ARG="$2"
      shift 2
      ;;
    --posthog-host)
      POSTHOG_HOST_ARG="$2"
      shift 2
      ;;
    --posthog-debug)
      POSTHOG_DEBUG_ARG="true"
      shift
      ;;
    -h|--help)
      echo "Usage: scripts/android_build.sh [--release|--debug] [--no-tree-shake-icons] [--icons] [--posthog-key <key>] [--posthog-host <host>] [--posthog-debug]"
      exit 0
      ;;
    *)
      echo "Unknown flag: $1" >&2
      echo "Usage: scripts/android_build.sh [--release|--debug] [--no-tree-shake-icons] [--icons] [--posthog-key <key>] [--posthog-host <host>] [--posthog-debug]" >&2
      exit 1
      ;;
  esac
 done

flutter clean
flutter pub get
if [[ "$run_icons" == "true" && -f "assets/icons/app_icon_source.png" ]]; then
  flutter pub run flutter_launcher_icons:main
fi

cmd=(flutter build apk "--$mode")
if [[ "$no_tree_shake" == "true" ]]; then
  cmd+=("--no-tree-shake-icons")
fi
if [[ -n "${POSTHOG_KEY_ARG}" ]]; then
  DART_DEFINES+=("--dart-define=POSTHOG_API_KEY=${POSTHOG_KEY_ARG}")
elif [[ -n "${POSTHOG_API_KEY:-}" ]]; then
  DART_DEFINES+=("--dart-define=POSTHOG_API_KEY=${POSTHOG_API_KEY}")
fi
if [[ -n "${POSTHOG_HOST_ARG}" ]]; then
  DART_DEFINES+=("--dart-define=POSTHOG_HOST=${POSTHOG_HOST_ARG}")
elif [[ -n "${POSTHOG_HOST:-}" ]]; then
  DART_DEFINES+=("--dart-define=POSTHOG_HOST=${POSTHOG_HOST}")
fi
if [[ -n "${POSTHOG_DEBUG_ARG}" ]]; then
  DART_DEFINES+=("--dart-define=POSTHOG_ALLOW_DEBUG=true")
elif [[ -n "${POSTHOG_ALLOW_DEBUG:-}" ]]; then
  DART_DEFINES+=("--dart-define=POSTHOG_ALLOW_DEBUG=${POSTHOG_ALLOW_DEBUG}")
fi

"${cmd[@]}" "${DART_DEFINES[@]}"
