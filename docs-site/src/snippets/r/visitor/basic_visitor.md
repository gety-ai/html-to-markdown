```r
library(htmltomarkdown)

html <- "<p>Visit <a href='https://example.com'>our site</a> for more!</p>"

opts <- conversion_options(extract_metadata = FALSE)
result <- convert(html, opts)
cat(result$content)
```
