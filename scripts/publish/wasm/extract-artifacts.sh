#!/usr/bin/env bash
set -euo pipefail

# Restore the pkg/{web,bundler,nodejs,deno} layout from the per-target tarballs
# emitted by package-artifacts.sh.
dest="crates/html-to-markdown-wasm/pkg"
mkdir -p "${dest}"
cd wasm-artifacts
for tarball in *.tar.gz; do
  tar -xzf "${tarball}" -C "../${dest}"
done
