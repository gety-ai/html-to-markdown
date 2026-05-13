```c
#include "html_to_markdown.h"
#include <stdio.h>

/* Each callback returns an int32 status code:
 *   HTM_VISIT_CONTINUE      — use default conversion
 *   HTM_VISIT_SKIP          — drop the element
 *   HTM_VISIT_PRESERVE_HTML — emit the raw HTML
 *   HTM_VISIT_CUSTOM        — replace with the string written to *out
 *   HTM_VISIT_ERROR         — abort conversion with the error in *out
 */
static int32_t visit_heading(const struct HTMNodeContext *ctx,
                             uint32_t level,
                             const char *text,
                             const char *title,
                             char **out,
                             void *user_data) {
    (void)ctx; (void)level; (void)text; (void)title; (void)out; (void)user_data;
    return HTM_VISIT_CONTINUE;
}

int main(void) {
    HTMHtmVisitorCallbacks callbacks = {0};
    callbacks.visit_heading = visit_heading;

    HTMHtmVisitor *visitor = htm_visitor_create(&callbacks);
    HTMConversionOptions *options = htm_conversion_options_default();
    htm_options_set_visitor(options, (struct HTMHtmHtmlVisitorBridge *)visitor);

    HTMConversionResult *result = htm_convert("<h1>Title</h1><p>Content</p>", options);

    htm_conversion_options_free(options);
    htm_visitor_free(visitor);

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
