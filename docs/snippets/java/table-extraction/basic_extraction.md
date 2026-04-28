```java
import dev.kreuzberg.htmltomarkdown.HtmlToMarkdown;
import dev.kreuzberg.htmltomarkdown.ConversionOptions;
import dev.kreuzberg.htmltomarkdown.ConversionResult;

String html = """
<table>
    <tr><th>Name</th><th>Age</th></tr>
    <tr><td>Alice</td><td>30</td></tr>
    <tr><td>Bob</td><td>25</td></tr>
</table>
""";

ConversionResult result = HtmlToMarkdown.convert(html, new ConversionOptions());

for (var table : result.tables()) {
    for (var cell : table.grid().cells()) {
        String prefix = cell.isHeader() ? "Header" : "Cell";
        System.out.printf("  %s (r%d,c%d): %s%n", prefix, cell.row(), cell.col(), cell.content());
    }
}
```
