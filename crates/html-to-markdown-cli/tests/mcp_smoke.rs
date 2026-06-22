//! End-to-end smoke test for the `html-to-markdown mcp` stdio server.
//!
//! Drives the real binary over the MCP stdio transport (newline-delimited
//! JSON-RPC): initialize, then list tools, prompts, and resources. Asserts the
//! tools carry read-only annotations and the typed config schema, and that the
//! prompt and resource catalogs are advertised. The protocol mechanics are
//! rmcp's responsibility — this is one happy-path wiring check across every
//! capability the server exposes.

#![cfg(feature = "mcp")]

use assert_cmd::Command;
use std::time::Duration;

#[test]
fn test_mcp_stdio_advertises_all_capabilities() {
    // Newline-delimited JSON-RPC frames. Closing stdin (EOF) ends the session.
    let frames = concat!(
        r#"{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"smoke","version":"0"}}}"#,
        "\n",
        r#"{"jsonrpc":"2.0","method":"notifications/initialized"}"#,
        "\n",
        r#"{"jsonrpc":"2.0","id":2,"method":"tools/list","params":{}}"#,
        "\n",
        r#"{"jsonrpc":"2.0","id":3,"method":"prompts/list","params":{}}"#,
        "\n",
        r#"{"jsonrpc":"2.0","id":4,"method":"resources/list","params":{}}"#,
        "\n",
    );

    let output = Command::new(env!("CARGO_BIN_EXE_html-to-markdown"))
        .args(["mcp", "--transport", "stdio"])
        .write_stdin(frames)
        .timeout(Duration::from_secs(15))
        .assert()
        .get_output()
        .clone();

    let stdout = String::from_utf8_lossy(&output.stdout);

    // Both tools advertised.
    assert!(
        stdout.contains("convert_html"),
        "tools/list must include convert_html; got: {stdout}"
    );
    assert!(
        stdout.contains("extract_metadata"),
        "tools/list must include extract_metadata; got: {stdout}"
    );
    // Annotations present (MCP wire form is camelCase).
    assert!(
        stdout.contains("readOnlyHint"),
        "tools must carry annotations; got: {stdout}"
    );
    // Typed config schema is discoverable.
    assert!(
        stdout.contains("heading_style"),
        "convert_html input schema must expose typed config; got: {stdout}"
    );
    // Prompts advertised.
    assert!(
        stdout.contains("convert_to_markdown") && stdout.contains("inspect_metadata"),
        "prompts/list must include the prompt catalog; got: {stdout}"
    );
    // Resources advertised.
    assert!(
        stdout.contains("htmltomarkdown://options-schema"),
        "resources/list must include the options resource; got: {stdout}"
    );
}
