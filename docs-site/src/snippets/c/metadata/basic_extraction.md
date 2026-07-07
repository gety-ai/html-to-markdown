```c
#include "html_to_markdown.h"
#include <stdio.h>

int main(void) {
    const char *html =
        "<html><head><title>Page</title></head><body><h1>Hello</h1></body></html>";

    /* extract_metadata is true by default. */
    HTMConversionResult *result = htm_convert(html, NULL);
    if (result == NULL) {
        fprintf(stderr, "convert failed: %s\n", htm_last_error_context());
        return 1;
    }

    HTMHtmlMetadata *meta = htm_conversion_result_metadata(result);
    if (meta != NULL) {
        HTMDocumentMetadata *doc = htm_html_metadata_document(meta);
        char *title = htm_document_metadata_title(doc);
        if (title != NULL) {
            printf("Title: %s\n", title);
            htm_free_string(title);
        }
        htm_document_metadata_free(doc);
        htm_html_metadata_free(meta);
    }

    htm_conversion_result_free(result);
    return 0;
}
```
