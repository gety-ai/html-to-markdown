defmodule ConvertWithMetadata do
  def test do
    result = HtmlToMarkdown.convert("<title>Test</title><p>Hello</p>")
    IO.inspect(result, label: "Result with metadata")
  end
end

ConvertWithMetadata.test()
