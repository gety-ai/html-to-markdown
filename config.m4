dnl Configuration for Rust-based PHP extension via ext-php-rs.
dnl Allows phpize to recognize this extension during source compilation (PIE fallback).

PHP_ARG_ENABLE([html_to_markdown],
  [whether to enable the html_to_markdown extension],
  [AS_HELP_STRING([--enable-html_to_markdown],
    [Enable html_to_markdown extension support])],
  [yes])

if test "$PHP_HTML_TO_MARKDOWN_ENABLED" = "yes"; then
  dnl Recognize the extension directory for phpize/make
  PHP_NEW_EXTENSION(html_to_markdown, [], $ext_shared)

  dnl Invoke cargo build to compile the Rust FFI library
  AC_CONFIG_COMMANDS([cargo-build], [
    if test -f "crates/html-to-markdown-rs-php/Cargo.toml"; then
      cargo build --release --manifest-path crates/html-to-markdown-rs-php/Cargo.toml || exit 1
      cargo_output_dir="crates/html-to-markdown-rs-php/target/release"
      ext_soname="html_to_markdown"

      dnl Detect output filename based on platform
      if test -f "${cargo_output_dir}/libhtml-to-markdown_php.dylib"; then
        cargo_lib="${cargo_output_dir}/libhtml-to-markdown_php.dylib"
      elif test -f "${cargo_output_dir}/libhtml-to-markdown_php.so"; then
        cargo_lib="${cargo_output_dir}/libhtml-to-markdown_php.so"
      else
        AC_MSG_ERROR([cargo build succeeded but .so/.dylib not found])
      fi

      dnl Copy the compiled library to modules/ directory for phpize to install
      cp "${cargo_lib}" "modules/${ext_soname}.so" || exit 1
    else
      AC_MSG_ERROR([crates/html-to-markdown-rs-php/Cargo.toml not found])
    fi
  ], [
    extension_name=html_to_markdown
  ])
fi
