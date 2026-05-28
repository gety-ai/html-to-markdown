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
fi
