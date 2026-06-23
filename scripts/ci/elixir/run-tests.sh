#!/usr/bin/env bash
set -euo pipefail

# RUSTLER_PRECOMPILED_FORCE_BUILD_ALL=1: build the NIF from source instead of
# downloading a precompiled artifact. Under MIX_ENV=test the native.ex
# `force_build: ... or Mix.env() in [:dev]` clause does not apply, so without
# this the test compile tries to fetch a precompiled NIF for the current
# (unreleased) version and fails with "the precompiled NIF file does not exist
# in the checksum file". The override skips the checksum/download path entirely.
env MIX_ENV=test RUSTLER_PRECOMPILED_FORCE_BUILD_ALL=1 mix test
