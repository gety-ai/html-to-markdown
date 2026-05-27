---
priority: critical
---

- Files in `packages/*/` and binding crates are generated or managed by Alef — check `alef.toml` before editing
- `alef.toml` defines: output paths, module names, rename mappings, e2e call overrides, README templates
- Run `task alef:generate` after changing `alef.toml`; it must run `alef all --clean --format=false`
- Run `task alef:format` explicitly when Alef post-generation formatting is needed; `task format` excludes Alef formatting
- Use `task build:bindings` or `task build:all` explicitly when bindings must be built
- Never hand-edit generated files; modify `alef.toml` or the Rust source instead
- Fixtures under `fixtures/` feed `tools/e2e-generator/` — never add tests to `e2e/` directly
- Canonical e2e tasks are `task e2e:generate`, `task e2e:build`, `task e2e:test`, and `task e2e:all`; do not add legacy aliases
