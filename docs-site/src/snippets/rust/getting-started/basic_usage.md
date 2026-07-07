```rust
use html_to_markdown_rs::convert;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let html = "<h1>Hello</h1><p>This is <strong>fast</strong>!</p>";
    let result = convert(html, None)?;
    let markdown = result.content.unwrap_or_default();
    println!("{markdown}");
    Ok(())
}
```
