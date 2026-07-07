```rust
use html_to_markdown_rs::{convert, ConversionOptions};

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let html = r#"<html><head><title>My Page</title></head>
    <body><h1>Hello</h1><a href="https://example.com">Link</a></body></html>"#;

    let options = ConversionOptions::builder()
        .extract_metadata(true)
        .build();
    let result = convert(html, Some(options))?;
    let markdown = result.content.unwrap_or_default();
    println!("Markdown: {}", markdown);
    println!("Title: {:?}", result.metadata.as_ref().and_then(|m| m.title.as_deref()));
    println!("Links: {:?}", result.metadata.as_ref().map(|m| &m.links));
    Ok(())
}
```
