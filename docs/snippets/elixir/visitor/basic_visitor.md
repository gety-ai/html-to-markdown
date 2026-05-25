# Visitor Pattern - Elixir

Customize HTML to Markdown conversion by passing a visitor map to
`HtmlToMarkdown.convert/2`. Each entry maps a callback name (as a
string) to a one-arity function that receives the JSON-decoded
arguments.

The bridge spawns a system thread for the conversion, then sends
`{:visitor_callback, ref_id, callback_name, args_json}` messages back
to the calling process. `HtmlToMarkdown.convert/2` runs a receive loop
that dispatches each message against your visitor map and calls
`HtmlToMarkdown.Native.visitor_reply/2` to unblock the worker.

## Basic Visitor Example

```elixir
visitor = %{
  "visit_link" => fn args ->
    # args is a list: [ctx, href, text, title_or_nil]
    [_ctx, _href, text, _title] = args
    {:custom, text}
  end,
  "visit_image" => fn _args -> :skip end
}

html = "<p>Visit <a href='https://example.com'>our site</a> for more!</p>"
{:ok, result} = HtmlToMarkdown.convert(html, %{visitor: visitor})
IO.puts(result.content)
# => Visit our site for more!
```

## Visitor Return Values

Each function must return one of:

- `:continue` — proceed with default conversion
- `:skip` — omit this element entirely
- `:preserve_html` — include the raw HTML verbatim
- `{:custom, markdown_string}` — replace this element's output with the given string
- A bare string — treated as a custom replacement

Anything else falls back to `:continue`.

## Callback Names

The bridge accepts any of the `visit_*` callbacks defined by the Rust
`HtmlVisitor` trait. The frequently-overridden ones:

- `visit_text` — text nodes (~100+ per document; keep it cheap)
- `visit_link` — `<a>` elements: `[ctx, href, text, title_or_nil]`
- `visit_image` — `<img>` elements: `[ctx, src, alt, title_or_nil]`
- `visit_heading` — headings: `[ctx, level, text, id_or_nil]`
- `visit_code_block` — `<pre><code>`: `[ctx, lang_or_nil, code]`
- `visit_element_start` / `visit_element_end` — generic enter/leave hooks

Omit a callback to fall through to the default Rust implementation.

## Node Context

The first argument (`ctx`) in every callback is a JSON-decoded map:

```elixir
%{
  "node_type" => "Link",
  "tag_name" => "a",
  "depth" => 2,
  "index_in_parent" => 0,
  "parent_tag" => "p"
}
```

## Combining Options and Visitor

Pass the visitor as a value under the `:visitor` key alongside any
other `ConversionOptions` fields:

```elixir
{:ok, result} = HtmlToMarkdown.convert(html, %{
  visitor: %{"visit_link" => fn _ -> :skip end},
  output_format: "github",
  extract_metadata: true
})
```

`HtmlToMarkdown.convert/2` pops the `:visitor` key, JSON-encodes the
remaining options, and dispatches to `convert_with_visitor`.
