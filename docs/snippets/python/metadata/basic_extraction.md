```python
from html_to_markdown import ConversionOptions, convert

options = ConversionOptions(
    extract_metadata=True,
    extract_images=True,
)
result = convert(html, options)
markdown = result.content
metadata = result.metadata
```
