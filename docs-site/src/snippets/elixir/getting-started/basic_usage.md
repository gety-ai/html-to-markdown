```elixir
{:ok, result} = HtmlToMarkdown.convert("<h1>Hello</h1><p>This is <strong>fast</strong>!</p>")
IO.puts(result.content)
```
