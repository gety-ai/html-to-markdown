// ~keep Rust inner attributes below are crate-level attributes, not a shell shebang.
#![allow(missing_docs)]

//! Tests for the `max_depth` recursion-safety option.

use html_to_markdown_rs::ConversionOptions;

fn convert_with_options(html: &str, options: ConversionOptions) -> String {
    html_to_markdown_rs::convert(html, Some(options))
        .expect("conversion should not fail")
        .content
        .unwrap_or_default()
}

/// With the default `max_depth: None`, ordinary nesting below the native stack
/// safety limit should be fully converted.
#[test]
fn test_max_depth_none_converts_reasonably_nested_content() {
    let mut html = String::from("<p>deep</p>");
    for _ in 0..32 {
        html = format!("<div>{html}</div>");
    }

    let options = ConversionOptions {
        extract_metadata: false,
        max_depth: None,
        ..Default::default()
    };

    let result = convert_with_options(&html, options);
    assert!(
        result.contains("deep"),
        "Deeply nested text should be present when max_depth is None. Got:\n{result}"
    );
}

/// With `max_depth: Some(2)`, block elements at depth 2 are not visited, so
/// their text content is excluded from the output.
#[test]
fn test_max_depth_truncates_at_limit() {
    let html = "<div><p>shallow</p><div><p>deep</p></div></div>";

    let options = ConversionOptions {
        extract_metadata: false,
        max_depth: Some(3),
        ..Default::default()
    };

    let result = convert_with_options(html, options);
    assert!(
        result.contains("shallow"),
        "Content at depth < max_depth should be present. Got:\n{result}"
    );
    assert!(
        !result.contains("deep"),
        "Content at depth >= max_depth should be absent. Got:\n{result}"
    );
}

/// Span pass-through should still count toward max_depth.
#[test]
fn test_max_depth_truncates_nested_spans() {
    let html = "<span><span><span><span><span>deep</span></span></span></span></span>";

    let options = ConversionOptions {
        extract_metadata: false,
        max_depth: Some(3),
        ..Default::default()
    };

    let result = convert_with_options(html, options);
    assert!(
        !result.contains("deep"),
        "Content inside spans at depth >= max_depth should be absent. Got:\n{result}"
    );
}

/// Deep span-only trees should be cut off by max_depth before stack growth becomes unsafe.
#[test]
fn test_max_depth_prevents_stack_overflow_on_deep_spans() {
    let levels = 10_000;
    let mut html = String::with_capacity(levels * "<span></span>".len() + "deep".len());
    for _ in 0..levels {
        html.push_str("<span>");
    }
    html.push_str("deep");
    for _ in 0..levels {
        html.push_str("</span>");
    }

    let options = ConversionOptions {
        extract_metadata: false,
        max_depth: Some(64),
        ..Default::default()
    };

    let result = convert_with_options(&html, options);
    assert!(
        !result.contains("deep"),
        "Content past max_depth should be absent in very deep span trees. Got:\n{result}"
    );
}

/// With `max_depth: Some(0)`, no nodes are processed and the output is empty or whitespace only.
#[test]
fn test_max_depth_zero_produces_empty() {
    let html = "<p>hello</p>";

    let options = ConversionOptions {
        extract_metadata: false,
        max_depth: Some(0),
        ..Default::default()
    };

    let result = convert_with_options(html, options);
    assert!(
        result.trim().is_empty(),
        "max_depth: Some(0) should produce no output. Got:\n{result}"
    );
}
