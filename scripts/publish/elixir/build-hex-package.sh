#!/usr/bin/env bash
set -euo pipefail

# With rustler_precompiled, the Hex package only contains Elixir code + checksum file.
# Precompiled NIF binaries are downloaded from GitHub releases at install time.
# No Rust source vendoring needed.
#
# Strip every `target/` directory under native/ before building so we don't
# blow past Hex's 128 MiB uncompressed limit on a previously-built workspace.
find packages/elixir/native -type d -name target -prune -exec rm -rf {} + 2>/dev/null || true

pushd packages/elixir >/dev/null
mix hex.build
popd >/dev/null
