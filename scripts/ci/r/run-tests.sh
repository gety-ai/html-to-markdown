#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "${script_dir}/../../.." && pwd)"

cd "${repo_root}/packages/r"

Rscript -e 'if (!requireNamespace("devtools", quietly = TRUE)) install.packages("devtools", repos = "https://cran.r-project.org")'

Rscript -e 'devtools::test()'
