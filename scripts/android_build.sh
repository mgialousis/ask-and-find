#!/usr/bin/env bash
set -euo pipefail

mode="release"
no_tree_shake="false"

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
    -h|--help)
      echo "Usage: scripts/android_build.sh [--release|--debug] [--no-tree-shake-icons]"
      exit 0
      ;;
    *)
      echo "Unknown flag: $1" >&2
      echo "Usage: scripts/android_build.sh [--release|--debug] [--no-tree-shake-icons]" >&2
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

"${cmd[@]}"
