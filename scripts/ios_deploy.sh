#!/usr/bin/env bash
set -euo pipefail

MODE="--release"
DEVICE_ID=""

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
    *)
      DEVICE_ID="$1"
      shift
      ;;
  esac
done

if [[ -z "${DEVICE_ID}" ]]; then
  echo "Usage: $(basename "$0") [--debug|--release] <device-id>"
  echo "Tip: flutter devices"
  exit 1
fi

flutter clean
flutter pub get

pushd ios >/dev/null
pod install
popd >/dev/null

flutter run -d "${DEVICE_ID}" "${MODE}"
