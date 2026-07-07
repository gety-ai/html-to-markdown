```c
#include "html_to_markdown.h"
#include <stdio.h>

int main(void) {
    const char *html =
        "<table>"
        "<tr><th>Name</th><th>Age</th></tr>"
        "<tr><td>Alice</td><td>30</td></tr>"
        "<tr><td>Bob</td><td>25</td></tr>"
        "</table>";

    /* Tables are extracted by default. The simplest way to inspect them in
     * C is to serialise the result to JSON and parse it with your JSON lib. */
    HTMConversionResult *result = htm_convert(html, NULL);
    if (result == NULL) {
        fprintf(stderr, "convert failed: %s\n", htm_last_error_context());
        return 1;
    }

    char *json = htm_conversion_result_to_json(result);
    if (json != NULL) {
        printf("%s\n", json);  /* contains a "tables" array */
        htm_free_string(json);
    }

    htm_conversion_result_free(result);
    return 0;
}
```
