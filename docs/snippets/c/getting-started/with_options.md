```c
#include "html_to_markdown.h"
#include <stdio.h>

int main(void) {
    /* Build an options update from JSON, apply onto defaults. */
    HTMConversionOptionsUpdate *update =
        htm_conversion_options_update_from_json("{\"heading_style\":\"atx\",\"wrap\":true}");
    HTMConversionOptions *options = htm_conversion_options_default();
    htm_conversion_options_apply_update(options, update);
    htm_conversion_options_update_free(update);

    HTMConversionResult *result = htm_convert("<h1>Title</h1><p>Paragraph</p>", options);
    htm_conversion_options_free(options);

    if (result == NULL) {
        fprintf(stderr, "convert failed: %s\n", htm_last_error_context());
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
