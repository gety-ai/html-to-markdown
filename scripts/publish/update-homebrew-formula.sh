#!/usr/bin/env bash
set -euo pipefail

# Update Homebrew formula files with new version + SHA256s of pre-built CLI/FFI
# tarballs from the GitHub release. The formula downloads the tarballs at install
# time — no bottle build is needed.
#
# Usage:
#   TAG=v3.4.0-rc.42 VERSION=3.4.0-rc.42 \
#   TAP_DIR=/path/to/homebrew-tap \
#   ./update-homebrew-formula.sh

tag="${TAG:?TAG is required (e.g. v3.4.0-rc.42)}"
version="${VERSION:?VERSION is required (e.g. 3.4.0-rc.42)}"
tap_dir="${TAP_DIR:?TAP_DIR is required (path to homebrew-tap checkout)}"

cli_formula="${tap_dir}/Formula/html-to-markdown.rb"
ffi_formula="${tap_dir}/Formula/libhtml-to-markdown.rb"

[[ -f "$cli_formula" ]] || {
  echo "Missing $cli_formula" >&2
  exit 1
}
[[ -f "$ffi_formula" ]] || {
  echo "Missing $ffi_formula" >&2
  exit 1
}

work_dir="$(mktemp -d)"
trap 'rm -rf "$work_dir"' EXIT

# Required tarball matrix:
#   CLI: aarch64-apple-darwin, x86_64-apple-darwin,
#        aarch64-unknown-linux-gnu, x86_64-unknown-linux-gnu
#   FFI: same 4 triples (uses release-prefix html-to-markdown-rs-ffi-${TAG}-)

compute_sha() {
  local asset="$1"
  echo "Downloading $asset..."
  gh release download "$tag" -p "$asset" -D "$work_dir" --clobber
  shasum -a 256 "$work_dir/$asset" | awk '{print $1}'
}

cli_macos_arm_sha=$(compute_sha "cli-aarch64-apple-darwin.tar.gz")
cli_macos_intel_sha=$(compute_sha "cli-x86_64-apple-darwin.tar.gz")
cli_linux_arm_sha=$(compute_sha "cli-aarch64-unknown-linux-gnu.tar.gz")
cli_linux_intel_sha=$(compute_sha "cli-x86_64-unknown-linux-gnu.tar.gz")

ffi_macos_arm_sha=$(compute_sha "html-to-markdown-rs-ffi-${tag}-aarch64-apple-darwin.tar.gz")
ffi_macos_intel_sha=$(compute_sha "html-to-markdown-rs-ffi-${tag}-x86_64-apple-darwin.tar.gz")
ffi_linux_arm_sha=$(compute_sha "html-to-markdown-rs-ffi-${tag}-aarch64-unknown-linux-gnu.tar.gz")
ffi_linux_intel_sha=$(compute_sha "html-to-markdown-rs-ffi-${tag}-x86_64-unknown-linux-gnu.tar.gz")

write_cli_formula() {
  cat >"$cli_formula" <<EOF
# typed: false
# frozen_string_literal: true

class HtmlToMarkdown < Formula
  desc "High-performance HTML to Markdown converter powered by Rust"
  homepage "https://github.com/kreuzberg-dev/html-to-markdown"
  version "${version}"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/kreuzberg-dev/html-to-markdown/releases/download/v#{version}/cli-aarch64-apple-darwin.tar.gz"
      sha256 "${cli_macos_arm_sha}"
    end

    on_intel do
      url "https://github.com/kreuzberg-dev/html-to-markdown/releases/download/v#{version}/cli-x86_64-apple-darwin.tar.gz"
      sha256 "${cli_macos_intel_sha}"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/kreuzberg-dev/html-to-markdown/releases/download/v#{version}/cli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "${cli_linux_arm_sha}"
    end

    on_intel do
      url "https://github.com/kreuzberg-dev/html-to-markdown/releases/download/v#{version}/cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "${cli_linux_intel_sha}"
    end
  end

  def install
    bin.install "html-to-markdown"
  end

  test do
    (testpath / "test.html").write <<~EOS
      <h1>Hello World</h1>
      <p>This is <strong>bold</strong> text.</p>
    EOS

    output = shell_output("#{bin}/html-to-markdown test.html")
    assert_match "Hello World", output
    assert_match "**bold**", output
  end
end
EOF
}

write_ffi_formula() {
  cat >"$ffi_formula" <<EOF
# typed: false
# frozen_string_literal: true

class LibhtmlToMarkdown < Formula
  desc "C library for HTML to Markdown conversion (FFI bindings)"
  homepage "https://github.com/kreuzberg-dev/html-to-markdown"
  version "${version}"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/kreuzberg-dev/html-to-markdown/releases/download/v#{version}/html-to-markdown-rs-ffi-v#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "${ffi_macos_arm_sha}"
    end

    on_intel do
      url "https://github.com/kreuzberg-dev/html-to-markdown/releases/download/v#{version}/html-to-markdown-rs-ffi-v#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "${ffi_macos_intel_sha}"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/kreuzberg-dev/html-to-markdown/releases/download/v#{version}/html-to-markdown-rs-ffi-v#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "${ffi_linux_arm_sha}"
    end

    on_intel do
      url "https://github.com/kreuzberg-dev/html-to-markdown/releases/download/v#{version}/html-to-markdown-rs-ffi-v#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "${ffi_linux_intel_sha}"
    end
  end

  def install
    include.install "include/html_to_markdown.h"

    if OS.mac?
      lib.install Dir["lib/*.dylib"]
    elsif OS.linux?
      lib.install Dir["lib/*.so"]
    end
    lib.install Dir["lib/*.a"]

    (lib / "pkgconfig").install "share/pkgconfig/html-to-markdown-rs.pc"

    inreplace lib / "pkgconfig/html-to-markdown-rs.pc", /prefix=.*/, "prefix=#{prefix}"

    (lib / "cmake/html-to-markdown-rs").install Dir["lib/cmake/html-to-markdown-rs/*"]
  end

  test do
    (testpath / "test.c").write <<~C
      #include <html_to_markdown.h>
      #include <stdio.h>
      int main(void) {
          const char *v = html_to_markdown_version();
          printf("html-to-markdown %s\\n", v);
          return v ? 0 : 1;
      }
    C

    system ENV.cc, "test.c", "-o", "test",
           "-I#{include}", "-L#{lib}", "-lhtml_to_markdown_ffi"
    assert_match version.to_s, shell_output("./test")
  end
end
EOF
}

write_cli_formula
write_ffi_formula

echo "Updated formulas:"
echo "  $cli_formula"
echo "  $ffi_formula"
