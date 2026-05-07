#!/usr/bin/env bash
set -euo pipefail

# wasm-pack output goes to crates/html-to-markdown-wasm/pkg/{web,bundler,nodejs,deno}.
# Tar each pkg subdir so publish-wasm's download+extract restores the same layout.
out_dir="wasm-artifacts"
rm -rf "${out_dir}"
mkdir -p "${out_dir}"

src="crates/html-to-markdown-wasm/pkg"
if [ ! -d "${src}" ]; then
  echo "::error::WASM build did not produce ${src}; run 'pnpm --filter @kreuzberg/html-to-markdown-wasm run build:all' first" >&2
  exit 1
fi

for folder in web bundler nodejs deno; do
  if [ -d "${src}/${folder}" ]; then
    tar -czf "${out_dir}/html-to-markdown-pkg-${folder}.tar.gz" -C "${src}" "${folder}"
  else
    echo "::warning::Expected ${src}/${folder} but it is missing" >&2
  fi
done

if [ -z "$(ls -A "${out_dir}")" ]; then
  echo "::error::No WASM bundles to package" >&2
  exit 1
fi
