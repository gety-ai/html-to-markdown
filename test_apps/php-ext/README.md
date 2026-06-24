# PHP Extension Test App for html-to-markdown

Comprehensive test suite validating the native `html_to_markdown` PHP extension built with ext-php-rs.

This test app exercises the **raw extension functions** directly (e.g. `html_to_markdown_convert()`), without the Composer wrapper package. For tests of the Composer package (`xberg-io/html-to-markdown`), see `tests/test_apps/php/`.

## What This Test Suite Covers

### Test Organization

The test suite (`main.php`) is organized into 8 sections:

1. **Extension Loading & Function Availability** - Verifies the extension is loaded and all exported functions exist
2. **Basic Conversion** - Tests `html_to_markdown_convert()` with headings, paragraphs, lists, links, code, blockquotes, images
3. **Conversion with Options** - Tests options arrays (heading_style, code_block_style, autolinks, skip_images, strip_tags)
4. **Inline Image Extraction** - Tests `html_to_markdown_convert_with_inline_images()` return structure and base64 image handling
5. **Metadata Extraction** - Tests `html_to_markdown_convert_with_metadata()` for document, headers, links, images, Open Graph, structured data
6. **Multiple Heading Levels** - Tests h1-h6 conversion and metadata extraction
7. **Complex HTML Structures** - Tests nested lists, tables, mixed formatting, special characters, unicode
8. **Error Handling** - Tests malformed HTML, deeply nested HTML, script/style stripping, invalid options

## Requirements

- PHP 8.2+
- The `html_to_markdown` native extension (compiled from `crates/html-to-markdown-php`)

No Composer dependencies are required. This test app is self-contained.

## Building the Extension

```bash
# From the repository root
cargo build --release -p html-to-markdown-php
```

## Running Tests

```bash
# Using the test runner script (auto-detects extension location)
bash run_tests.sh

# Or directly with PHP (if extension is in php.ini)
php main.php

# Or directly with PHP (loading extension via -d flag)
php -d extension=/path/to/libhtml_to_markdown_php.dylib main.php   # macOS
php -d extension=/path/to/libhtml_to_markdown_php.so main.php      # Linux
```

## Expected Output

```text
========================================================================
  TEST SUMMARY
========================================================================
  Total:   50+
  Passed:  50+
  Failed:  0
  Skipped: 0

  ALL TESTS PASSED
========================================================================
```

## Extension Functions Tested

```php
// Basic conversion
html_to_markdown_convert(string $html, ?array $options = null): string

// Conversion with inline image extraction
html_to_markdown_convert_with_inline_images(
    string $html,
    ?array $options = null,
    ?array $imageConfig = null
): array  // ['markdown' => string, 'inline_images' => array, 'warnings' => array]

// Conversion with metadata extraction
html_to_markdown_convert_with_metadata(
    string $html,
    ?array $options = null,
    ?array $metadataConfig = null
): array  // ['markdown' => string, 'metadata' => array]
```

### Conversion Options

Options are passed as associative arrays:

```php
$options = [
    'heading_style' => 'atx',          // 'atx', 'atx_closed', 'underlined'
    'code_block_style' => 'backticks', // 'backticks', 'tildes', 'indented'
    'escape_asterisks' => true,
    'autolinks' => true,
    'skip_images' => false,
    'strip_tags' => ['nav', 'footer'],
    // ... and many more (see packages/php-ext/README.md)
];
```

## Differences from php/ Test App

| Aspect         | `php/` (Composer package)                     | `php-ext/` (Native extension)        |
| -------------- | --------------------------------------------- | ------------------------------------ |
| Dependency     | `xberg-io/html-to-markdown` via Composer | Raw `.so`/`.dylib` extension         |
| Functions      | Namespaced: `HtmlToMarkdown\convert()`        | Global: `html_to_markdown_convert()` |
| Test framework | PHPUnit                                       | Self-contained test runner           |
| Types          | Typed objects (ConversionOptions, etc.)       | Associative arrays                   |
| Requires       | Composer install                              | Cargo build only                     |
