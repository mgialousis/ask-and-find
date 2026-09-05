#!/usr/bin/env bash
set -euo pipefail

MODE="--release"
DEVICE_ID=""
DART_DEFINES=()
POSTHOG_KEY_ARG=""
POSTHOG_HOST_ARG=""
POSTHOG_DEBUG_ARG=""
SUBMISSIONS_ENDPOINT_ARG=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --debug)
      MODE="--debug"
      shift
      ;;
    --release)
      MODE="--release"
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
    --submissions-endpoint)
      SUBMISSIONS_ENDPOINT_ARG="$2"
      shift 2
      ;;
    *)
      DEVICE_ID="$1"
      shift
      ;;
  esac
done

if [[ -z "${DEVICE_ID}" ]]; then
  echo "Usage: $(basename "$0") [--debug|--release] [--submissions-endpoint <url>] [--posthog-key <key>] [--posthog-host <host>] [--posthog-debug] <device-id>"
  echo "Tip: flutter devices"
  exit 1
fi

if [[ -n "${SUBMISSIONS_ENDPOINT_ARG}" ]]; then
  DART_DEFINES+=("--dart-define=SUBMISSIONS_ENDPOINT_URL=${SUBMISSIONS_ENDPOINT_ARG}")
elif [[ -n "${SUBMISSIONS_ENDPOINT_URL:-}" ]]; then
  DART_DEFINES+=("--dart-define=SUBMISSIONS_ENDPOINT_URL=${SUBMISSIONS_ENDPOINT_URL}")
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

flutter clean
flutter pub get

pushd ios >/dev/null
pod install
popd >/dev/null

flutter run -d "${DEVICE_ID}" "${MODE}" ${DART_DEFINES[@]+"${DART_DEFINES[@]}"}


# RELEASE APK -  flutter build apk --release
