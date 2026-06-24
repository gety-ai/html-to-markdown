```go
package main

import (
    "fmt"
    "log"

    htmltomarkdown "github.com/xberg-io/html-to-markdown/packages/go/v3"
)

func main() {
    html := "<h1>Hello</h1><p>Welcome</p>"

    width := uint(80)
    opts := htmltomarkdown.ConversionOptions{
        Wrap:      true,
        WrapWidth: &width,
    }

    result, err := htmltomarkdown.Convert(html, &opts)
    if err != nil {
        log.Fatalf("Conversion failed: %v", err)
    }

    if result.Content != nil {
        fmt.Println(*result.Content)
    }
}
```
