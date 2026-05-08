#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$SCRIPT_DIR/../../.."

# Clean up any vendored files and build artifacts from previous runs
rm -rf packages/ruby/vendor/html-to-markdown-rs packages/ruby/vendor/Cargo.toml packages/ruby/pkg
git restore \
  packages/ruby/ext/html_to_markdown_rb/Cargo.toml \
  packages/ruby/ext/html_to_markdown_rb/native/Cargo.toml \
  2>/dev/null || true

# Build CLI binary BEFORE vendoring to avoid package collision
echo "Building CLI binary before vendoring..."
cargo build --release --package html-to-markdown-cli

# Copy CLI binary into gem
ruby "$REPO_ROOT/scripts/prepare_ruby_gem.rb"

# Vendor core crate using Python script (like kreuzberg)
echo "Vendoring core crate..."
python3 "$REPO_ROOT/scripts/ci/ruby/vendor-core-crate.py"

pushd packages/ruby >/dev/null
bundle install

# Ensure source gem packages the vendored crate so end-users on platforms
# without a precompiled gem (e.g., aarch64-linux fallback) can build from
# source. The alef-generated gemspec only globs lib/ ext/ sig/, missing
# vendor/. Inject a one-line glob extension before rake build.
# Fixes #325.
if grep -q "Dir.glob(%w\[lib/" html_to_markdown.gemspec && ! grep -q "vendor/\*\*/\*" html_to_markdown.gemspec; then
  sed -i.bak 's|Dir.glob(%w\[\([^]]*\)\])|Dir.glob(%w[\1 vendor/**/*])|' html_to_markdown.gemspec
  rm -f html_to_markdown.gemspec.bak
fi

# Build source gem
bundle exec rake build

# Build native platform gem with precompiled extension
bundle exec rake compile
popd >/dev/null

# Detect platform for build-native-gem.rb
case "$(uname -s)-$(uname -m)" in
Linux-x86_64) PLATFORM="x86_64-linux" ;;
Linux-aarch64) PLATFORM="aarch64-linux" ;;
Darwin-arm64) PLATFORM="arm64-darwin" ;;
Darwin-x86_64) PLATFORM="x86_64-darwin" ;;
*)
  echo "WARNING: Unknown platform, skipping native gem build"
  exit 0
  ;;
esac

ruby "$SCRIPT_DIR/build-native-gem.rb" "$PLATFORM"
