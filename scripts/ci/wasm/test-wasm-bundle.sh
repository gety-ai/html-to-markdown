#!/usr/bin/env bash
set -euo pipefail

if ! find . -name '*.spec.ts' -o -name '*.test.ts' | grep -q .; then
  echo "No test files found, skipping vitest (tests are in e2e/)"
  exit 0
fi

VITEST_TIMEOUT_MS="${VITEST_TIMEOUT_MS:-60000}"

pnpm vitest run \
  --reporter=verbose \
  --pool=threads \
  --maxWorkers=1 \
  --exclude=".venv/**" \
  --test-timeout="${VITEST_TIMEOUT_MS}"
