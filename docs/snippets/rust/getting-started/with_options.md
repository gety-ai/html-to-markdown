```rust
use html_to_markdown_rs::{ConversionOptions, HeadingStyle, convert};

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let options = ConversionOptions::builder()
        .heading_style(HeadingStyle::Atx)
        .skip_images(true)
        .build();
    let result = convert("<h1>Hello</h1><img src='pic.jpg'>", Some(options))?;
    println!("{}", result.content.unwrap_or_default());
    Ok(())
}
```
