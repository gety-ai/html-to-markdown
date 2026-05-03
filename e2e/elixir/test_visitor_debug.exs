defmodule VisitorDebug do
  def test do
    visitor = %{handle_strong: fn _ctx -> "skip" end}
    result = HtmlToMarkdown.convert("<p>Hello <strong>World</strong></p>", %{visitor: visitor})
    IO.inspect(result, label: "Result")
  end
end

VisitorDebug.test()
