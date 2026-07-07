```java
import io.xberg.htmltomarkdown.HtmlToMarkdown;
import io.xberg.htmltomarkdown.ConversionResult;

public class Example {
    public static void main(String[] args) {
        String html = "<h1>Hello World</h1><p>This is a <strong>test</strong>.</p>";
        ConversionResult result = HtmlToMarkdown.convert(html);
        System.out.println(result.content());
    }
}
```
