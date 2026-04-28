$ErrorActionPreference = "Stop"

$workspace = ridk exec bash -lc "cygpath -au '$env:GITHUB_WORKSPACE'"
$gemdir = "$workspace/packages/ruby"

# Build CLI binary BEFORE vendoring to avoid package collision
Write-Host "Building CLI binary before vendoring..."
ridk exec bash -lc "cd $workspace && export RUSTUP_TOOLCHAIN=stable-gnu && cargo build --release --package html-to-markdown-cli"

# Copy CLI binary into gem
ridk exec bash -lc "cd $workspace && export RUSTUP_TOOLCHAIN=stable-gnu && ruby scripts/prepare_ruby_gem.rb"

# Vendor core crate using Python script (like kreuzberg)
ridk exec bash -lc "cd $workspace && python3 scripts/ci/ruby/vendor-core-crate.py"

# Ensure source gem packages vendor/ — fixes #325
ridk exec bash -lc "cd $gemdir && if grep -q 'Dir.glob(%w\[lib/' html_to_markdown.gemspec && ! grep -q 'vendor/\*\*/\*' html_to_markdown.gemspec; then sed -i.bak 's|Dir.glob(%w\[\([^]]*\)\])|Dir.glob(%w[\1 vendor/**/*])|' html_to_markdown.gemspec && rm -f html_to_markdown.gemspec.bak; fi"

# Build source gem
ridk exec bash -lc "cd $gemdir && export RUSTUP_TOOLCHAIN=stable-gnu CC=x86_64-w64-mingw32-gcc CXX=x86_64-w64-mingw32-g++ && bundle exec rake build"
