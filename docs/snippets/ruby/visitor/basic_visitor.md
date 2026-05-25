```ruby
require 'html_to_markdown'

# A visitor is any Ruby object that responds to `visit_*` methods. The
# bridge calls `respond_to?(name, false)` and dispatches via `funcall`,
# so plain methods on a class (or any object) work.
class MyVisitor
  # `ctx` is a Hash: { node_type:, tag_name:, depth:, index_in_parent:, ... }
  def visit_link(ctx, href, text, title = nil)
    # Return a custom output by wrapping it in `{ custom: ... }`. Any
    # other Hash without :custom is treated as `:continue`.
    { custom: "[#{text}](#{href})" }
  end

  def visit_image(ctx, src, alt, title = nil)
    # Return :skip (or the string "skip") to drop the element.
    # Other accepted directives: :continue, :preserve_html.
    :skip
  end

  # `visit_text` is invoked ~100+ times per document — keep it cheap.
  def visit_text(ctx, text)
    :continue
  end
end

html = "<p><a href='https://example.com'>Link</a><img src='x.png'></p>"
# The visitor is passed as the second positional argument. The Ruby
# binding currently does NOT support combining the visitor with a
# `ConversionOptions` Hash in a single call — pick one. To use both,
# build the options on the Rust side via the FFI directly.
result = HtmlToMarkdown.convert(html, MyVisitor.new)
puts result.content
```
