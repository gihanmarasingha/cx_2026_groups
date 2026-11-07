#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.."

retry_download() {
  local attempt
  for attempt in 1 2 3; do
    if "$@"; then
      return 0
    fi
    if [ "$attempt" -lt 3 ]; then
      echo "Download failed (attempt $attempt/3); retrying in 5 seconds..." >&2
      sleep 5
    fi
  done
  echo "Setup failed. Read the error above; check disk space for 'No space left on device', or the connection for network errors." >&2
  echo "After fixing the problem, rerun: bash .devcontainer/setup.sh" >&2
  return 1
}

# Lake uses lean-toolchain and lake-manifest.json from this checkout.
# Keep downloaded archives on the workspace's Linux build volume.
export MATHLIB_CACHE_DIR="$PWD/.lake/mathlib-cache"
# Fetch only the course's imports, rather than the entire Mathlib library.
echo "Installing the project's Lean toolchain..."
retry_download elan toolchain install "$(tr -d '\r\n' < lean-toolchain)"
echo "Downloading Mathlib and its precompiled artifacts..."
retry_download python3 .devcontainer/fetch_mathlib_cache.py
echo "Checking the course..."
lake build
echo "Setup complete. Open Cx2026Groups/Week1/Week1_0.lean to get started."
