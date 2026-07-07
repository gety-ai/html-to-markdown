```ruby
require 'html_to_markdown'

html = <<~HTML
  <table>
      <tr><th>Name</th><th>Age</th></tr>
      <tr><td>Alice</td><td>30</td></tr>
      <tr><td>Bob</td><td>25</td></tr>
  </table>
HTML

result = HtmlToMarkdown.convert(html, extract_tables: true)

result[:tables].each do |table|
  table[:cells].each_with_index do |row, i|
    prefix = table[:is_header_row][i] ? "Header" : "Row"
    puts "  #{prefix}: #{row.join(', ')}"
  end
end
```
