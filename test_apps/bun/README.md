# Bun Smoke Tests

This directory contains smoke tests for the html-to-markdown package running in the Bun runtime.

## Purpose

Validates that the NAPI-RS bindings work correctly in Bun's Node-API compatibility layer without requiring separate Bun-specific bindings.

## Running Tests

```bash
bun install
bun test
```

## Test Coverage

- Basic HTML conversion
- Metadata extraction
- Options handling
- Complex HTML structures (lists, links, images)
- Error handling

## Requirements

- Bun 1.2+
- @xberg-io/html-to-markdown package

## Notes

The existing NAPI-RS `.node` binaries work in Bun without changes due to Bun's 95%+ Node-API compatibility. These tests verify that all core functionality works as expected.
