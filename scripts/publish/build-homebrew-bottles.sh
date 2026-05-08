#!/usr/bin/env bash
set -euo pipefail

# Build Homebrew bottles for html-to-markdown + libhtml-to-markdown on the
# current platform. Runs `brew install --build-bottle` (which uses the URL
# blocks in the already-published formula) followed by `brew bottle`. Renames
# bottle artifacts to single-dash convention and uploads them to the GitHub
# release. Also saves the bottle JSON manifests to OUT_DIR for the aggregation
# job to merge.
#
# Usage:
#   TAG=v3.4.0-rc.42 VERSION=3.4.0-rc.42 \
#   TAP=kreuzberg-dev/tap \
#   OUT_DIR=/tmp/bottle-json \
#   GH_TOKEN=... \
#   ./build-homebrew-bottles.sh

tag="${TAG:?TAG is required}"
version="${VERSION:?VERSION is required}"
tap="${TAP:?TAP is required (e.g. kreuzberg-dev/tap)}"
out_dir="${OUT_DIR:?OUT_DIR is required}"

mkdir -p "$out_dir"
work_dir="$(mktemp -d)"
trap 'rm -rf "$work_dir"' EXIT
cd "$work_dir"

echo "::group::brew env"
brew --version
brew config | head -20 || true
echo "::endgroup::"

echo "::group::Tap ${tap}"
brew tap "$tap" --force-auto-update
brew update --quiet || true
echo "::endgroup::"

build_one_bottle() {
  local formula="$1"
  echo "::group::Building bottle for ${formula}"

  brew uninstall --force "${tap}/${formula}" 2>/dev/null || true

  brew install --build-bottle --verbose "${tap}/${formula}"

  brew bottle --json --no-rebuild "${tap}/${formula}"

  local original_tarball
  original_tarball=$(ls "${formula}--${version}".*.bottle.tar.gz 2>/dev/null | head -1)
  if [[ -z "$original_tarball" ]]; then
    echo "ERROR: no bottle tarball produced for ${formula}" >&2
    ls -la
    return 1
  fi

  local renamed_tarball="${original_tarball/--/-}"
  if [[ "$renamed_tarball" != "$original_tarball" ]]; then
    cp "$original_tarball" "$renamed_tarball"
  fi

  local json_file="${formula}--${version}".*.bottle.json
  for jf in $json_file; do
    cp "$jf" "$out_dir/"
  done

  echo "Uploading ${renamed_tarball} to release ${tag}"
  gh release upload "$tag" "$renamed_tarball" --clobber --repo kreuzberg-dev/html-to-markdown

  echo "::endgroup::"
}

build_one_bottle "html-to-markdown"
build_one_bottle "libhtml-to-markdown"

echo "Bottles built; JSON manifests saved to ${out_dir}:"
ls -la "$out_dir"
