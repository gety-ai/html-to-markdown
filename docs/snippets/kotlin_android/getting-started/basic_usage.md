```kotlin
import io.xberg.android.HtmlToMarkdownRs

val html = "<h1>Hello</h1><p>This is <strong>fast</strong>!</p>"
val result = HtmlToMarkdownRs.convert(html)
val markdown: String? = result.content
```
