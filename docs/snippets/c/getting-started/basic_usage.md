```c
#include "html_to_markdown.h"
#include <stdio.h>

int main(void) {
    HTMConversionResult *result = htm_convert("<h1>Hello</h1><p>World</p>", NULL);
    if (result == NULL) {
        fprintf(stderr, "convert failed (code %d): %s\n",
                htm_last_error_code(), htm_last_error_context());
        return 1;
    }

    char *content = htm_conversion_result_content(result);
    if (content != NULL) {
        printf("%s\n", content);
        htm_free_string(content);
    }

    htm_conversion_result_free(result);
    return 0;
}
```
