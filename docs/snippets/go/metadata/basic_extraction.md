```go
package main

import (
	"fmt"
	"log"

	htmltomarkdown "github.com/kreuzberg-dev/html-to-markdown/packages/go/v3"
)

func main() {
	html := `<html><head><title>My Page</title></head>
	<body><h1>Hello</h1><a href="https://example.com">Link</a></body></html>`

	// extract_metadata defaults to true; nil options is enough.
	result, err := htmltomarkdown.Convert(html, nil)
	if err != nil {
		log.Fatal(err)
	}

	if result.Content != nil {
		fmt.Println("Markdown:", *result.Content)
	}
	if result.Metadata.Document.Title != nil {
		fmt.Println("Title:", *result.Metadata.Document.Title)
	}
	for _, link := range result.Metadata.Links {
		fmt.Printf("Link: %s (%s)\n", link.Href, link.Text)
	}
}
```
