defmodule ConvertDebug do
  def test do
    result = HtmlToMarkdown.convert("<p>Hello</p>")
    IO.inspect(result, label: "Result")
  end
end

ConvertDebug.test()
