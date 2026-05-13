```rust
use html_to_markdown_rs::visitor::{HtmlVisitor, NodeContext, VisitResult, VisitorHandle};
use html_to_markdown_rs::{ConversionOptions, convert};
use std::cell::RefCell;
use std::rc::Rc;

#[derive(Debug)]
struct LinkRewriter;

impl HtmlVisitor for LinkRewriter {
    fn visit_link(
        &mut self,
        _ctx: &NodeContext,
        href: &str,
        text: &str,
        _title: Option<&str>,
    ) -> VisitResult {
        VisitResult::Custom(format!("[{text}](https://track.example.com?url={href})"))
    }
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let html = r#"<a href="https://example.com">Click here</a>"#;
    let visitor: VisitorHandle = Rc::new(RefCell::new(LinkRewriter));
    let options = ConversionOptions::builder().visitor(Some(visitor)).build();
    let result = convert(html, Some(options))?;
    println!("{}", result.content.unwrap_or_default());
    Ok(())
}
```
