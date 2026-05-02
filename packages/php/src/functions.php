<?php

declare(strict_types=1);

namespace {

    use HtmlToMarkdown\HtmlToMarkdown;

    if (!\function_exists('html_to_markdown_convert')) {
        /**
         * Convert HTML to Markdown and return the content string.
         *
         * Delegates to the native Rust extension via the HtmlToMarkdown facade.
         * Options are not currently supported in this convenience wrapper — call
         * HtmlToMarkdown::convert() directly for full control.
         *
         * @param string               $html    The HTML string to convert.
         * @param array<string, mixed> $options Reserved for future use.
         *
         * @throws \HtmlToMarkdown\HtmlToMarkdownException on conversion error.
         */
        function html_to_markdown_convert(string $html, array $options = []): string
        {
            $result = HtmlToMarkdown::convert($html, null);

            return $result->content ?? '';
        }
    }

} // end namespace
