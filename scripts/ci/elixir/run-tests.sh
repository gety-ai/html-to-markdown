#!/usr/bin/env bash
set -euo pipefail

# (unreleased) version and fails with "the precompiled NIF file does not exist
env MIX_ENV=test RUSTLER_PRECOMPILED_FORCE_BUILD_ALL=1 mix test
