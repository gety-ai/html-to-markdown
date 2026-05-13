```php
use HtmlToMarkdown\HtmlToMarkdown;
use HtmlToMarkdown\ConversionOptions;

$options = ConversionOptions::builder()
    ->headingStyle('atx')
    ->listIndentWidth(2)
    ->build();

$result = HtmlToMarkdown::convert('<h1>Hello</h1>', $options);
echo $result->content;
```
