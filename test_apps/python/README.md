# Python Test App for html-to-markdown

Tests the published html-to-markdown package from PyPI.

## Setup

```bash
uv sync --no-install-project --no-install-workspace
```

## Run Tests

```bash
# Smoke tests (fast)
uv run --no-sync pytest smoke_test.py -v

# Comprehensive tests
uv run --no-sync pytest comprehensive_test.py -v

# All tests
uv run --no-sync pytest -v
```
