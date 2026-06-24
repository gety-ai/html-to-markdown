```go
package main

import (
    "fmt"
    "log"

    htmltomarkdown "github.com/xberg-io/html-to-markdown/packages/go/v3"
)

func main() {
    html := "<h1>Hello World</h1><p>This is a paragraph.</p>"

    result, err := htmltomarkdown.Convert(html, nil)
    if err != nil {
        log.Fatal(err)
    }

    if result.Content != nil {
        fmt.Println(*result.Content)
    }
}
```
