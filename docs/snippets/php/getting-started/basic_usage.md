```php
use HtmlToMarkdown\HtmlToMarkdown;

$result = HtmlToMarkdown::convert('<h1>Hello</h1><p>This is <strong>fast</strong>!</p>');
echo $result->content;
```
