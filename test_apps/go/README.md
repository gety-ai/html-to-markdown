# Go Test App for html-to-markdown

Comprehensive test suite for the html-to-markdown Go module. Tests the FFI bindings and validates that all major features work correctly, including basic HTML-to-Markdown conversion, metadata extraction, error handling, and memory safety.

## Overview

This test app validates:

- **Basic HTML conversion** via FFI bindings
- **Metadata extraction** (title, description, headers, links, images)
- **Complex HTML structures** (nested lists, tables, code blocks, etc.)
- **Error handling** and edge cases
- **Memory safety** through repeated conversions
- **Large document handling** and performance
- **Consistency** across multiple conversions
- **Unicode and special characters** support
- **FFI version information** access

Total: 51 test cases across 19 test functions.

## Setup

```bash
# Install Go 1.25+
go mod download
```

## Run Tests

```bash
# All tests with verbose output
go test -v

# Run specific test function
go test -v -run TestVersion

# Run smoke tests only
go test -v -run Smoke

# Run feature tests only
go test -v -run Feature

# Run metadata tests only
go test -v -run Metadata

# Run with short timeout (will fail if not immediate)
go test -v -short

# Show test coverage
go test -cover
```

## Test Structure

### Smoke Tests (`smoke_test.go`)

- Package imports work correctly
- Basic HTML to Markdown conversion
- Heading conversion validation
- Empty input handling

### Comprehensive Tests (`comprehensive_test.go`)

- Fixture-driven tests loading from JSON
- Basic HTML conversions (paragraphs, headings, links, etc.)

### Feature Tests (`feature_test.go`)

- **API Tests**: Version information, MustConvert panic behavior
- **Conversion Tests**: Complex HTML structures (nested lists, tables, code blocks, images, etc.)
- **Error Handling**: Valid HTML, malformed HTML, empty strings, whitespace
- **Metadata Extraction**: Headers, links, images, document metadata
- **Memory Safety**: Repeated conversions to ensure no memory leaks
- **Large Documents**: Handling HTML with 100+ elements
- **Consistency**: Multiple conversions produce identical output
- **Special Characters**: HTML entities, Unicode, emoji, special symbols
- **Regression Tests**: Content preservation across conversions

## Test Coverage by Feature

| Feature              | Tests | Coverage                                           |
| -------------------- | ----- | -------------------------------------------------- |
| Basic Conversion     | 15    | Basic paragraphs, headings, lists, formatting      |
| Metadata Extraction  | 6     | Headers, links, images, document metadata          |
| Error Handling       | 4     | Valid/malformed HTML, empty input                  |
| Complex HTML         | 8     | Nested structures, tables, code blocks             |
| Special Characters   | 4     | Entities, Unicode, emoji, symbols                  |
| Memory & Performance | 3     | Repeated conversions, large documents, consistency |
| API Features         | 3     | Version, MustConvert, sequential operations        |
| Regression           | 4     | Content preservation, mixed formats                |

## Module Dependencies

- Go 1.25+
- `github.com/kreuzberg-dev/html-to-markdown/packages/go/v2` (v2.24.1)

The `go.mod` file uses a local `replace` directive for development. This can be removed and the module can be published to pkg.go.dev for external consumption.

## Expected Output

All 51 tests should pass:

```text
ok  	github.com/kreuzberg-dev/html-to-markdown-test-app	0.3s
```

## Notes

- Tests use the FFI bindings (cgo) to call the Rust core
- All conversions are performed synchronously (Go's HTML parsing is blocking-compatible)
- Memory is automatically managed by the FFI layer
- Tests are deterministic and do not depend on external resources
