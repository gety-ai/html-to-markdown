<?php

declare(strict_types=1);

/**
 * html-to-markdown PHP Extension (php-ext) - Comprehensive Test Suite
 *
 * Tests the native PHP extension built with ext-php-rs directly, without
 * the Composer wrapper package. This validates the raw extension function:
 *
 * - Extension loading and function availability
 * - html_to_markdown_convert() - conversion returning markdown string
 * - html_to_markdown_convert() with options - conversion options support
 * - Error handling for invalid inputs
 *
 * Requires PHP 8.2+ with the html_to_markdown extension loaded.
 */

// ---------------------------------------------------------------------------
// Test runner infrastructure
// ---------------------------------------------------------------------------

final class TestRunner
{
    private int $passed = 0;
    private int $failed = 0;
    private int $skipped = 0;
    private int $total = 0;

    public function section(string $name): void
    {
        echo "\n";
        echo str_repeat('=', 72) . "\n";
        echo "  {$name}\n";
        echo str_repeat('=', 72) . "\n";
    }

    public function test(string $description, callable $fn): void
    {
        $this->total++;
        try {
            $fn();
            $this->passed++;
            echo "  PASS  {$description}\n";
        } catch (SkipException $e) {
            $this->skipped++;
            echo "  SKIP  {$description} ({$e->getMessage()})\n";
        } catch (\Throwable $e) {
            $this->failed++;
            $errorMsg = $e->getMessage();
            $file = basename($e->getFile());
            $line = $e->getLine();
            echo "  FAIL  {$description}\n";
            echo "        Error: {$errorMsg} ({$file}:{$line})\n";
        }
    }

    public function summary(): int
    {
        echo "\n";
        echo str_repeat('=', 72) . "\n";
        echo "  TEST SUMMARY\n";
        echo str_repeat('=', 72) . "\n";
        echo "  Total:   {$this->total}\n";
        echo "  Passed:  {$this->passed}\n";
        echo "  Failed:  {$this->failed}\n";
        echo "  Skipped: {$this->skipped}\n";
        echo "\n";

        if ($this->failed === 0) {
            echo "  ALL TESTS PASSED\n";
        } else {
            echo "  SOME TESTS FAILED\n";
        }

        echo str_repeat('=', 72) . "\n";

        return $this->failed > 0 ? 1 : 0;
    }
}

final class SkipException extends \RuntimeException {}

function skip(string $reason): never
{
    throw new SkipException($reason);
}

function assert_true(bool $value, string $message = 'Expected true'): void
{
    if (!$value) {
        throw new \RuntimeException("Assertion failed: {$message}");
    }
}

function assert_false(bool $value, string $message = 'Expected false'): void
{
    if ($value) {
        throw new \RuntimeException("Assertion failed: {$message}");
    }
}

function assert_equals(mixed $expected, mixed $actual, string $message = ''): void
{
    if ($expected !== $actual) {
        $expectedStr = var_export($expected, true);
        $actualStr = var_export($actual, true);
        $msg = $message !== '' ? "{$message}: " : '';
        throw new \RuntimeException("Assertion failed: {$msg}expected {$expectedStr}, got {$actualStr}");
    }
}

function assert_not_empty(mixed $value, string $message = 'Expected non-empty value'): void
{
    if (empty($value)) {
        throw new \RuntimeException("Assertion failed: {$message}");
    }
}

function assert_string_contains(string $needle, string $haystack, string $message = ''): void
{
    if (!str_contains($haystack, $needle)) {
        $msg = $message !== '' ? "{$message}: " : '';
        throw new \RuntimeException("Assertion failed: {$msg}string does not contain '{$needle}'");
    }
}

function assert_string_not_contains(string $needle, string $haystack, string $message = ''): void
{
    if (str_contains($haystack, $needle)) {
        $msg = $message !== '' ? "{$message}: " : '';
        throw new \RuntimeException("Assertion failed: {$msg}string should not contain '{$needle}'");
    }
}

function assert_array_key(string $key, array $array, string $message = ''): void
{
    if (!array_key_exists($key, $array)) {
        $msg = $message !== '' ? "{$message}: " : '';
        throw new \RuntimeException("Assertion failed: {$msg}key '{$key}' not found in array");
    }
}

function assert_greater_than(int|float $expected, int|float $actual, string $message = ''): void
{
    if ($actual <= $expected) {
        $msg = $message !== '' ? "{$message}: " : '';
        throw new \RuntimeException("Assertion failed: {$msg}expected value > {$expected}, got {$actual}");
    }
}

function assert_throws(string $exceptionClass, callable $fn, string $message = ''): void
{
    try {
        $fn();
        $msg = $message !== '' ? "{$message}: " : '';
        throw new \RuntimeException("Assertion failed: {$msg}expected {$exceptionClass} to be thrown");
    } catch (\Throwable $e) {
        if (!$e instanceof $exceptionClass) {
            $actual = get_class($e);
            $msg = $message !== '' ? "{$message}: " : '';
            throw new \RuntimeException(
                "Assertion failed: {$msg}expected {$exceptionClass}, got {$actual}: {$e->getMessage()}",
            );
        }
    }
}

// ---------------------------------------------------------------------------
// Run tests
// ---------------------------------------------------------------------------

$runner = new TestRunner();

echo str_repeat('=', 72) . "\n";
echo "  html-to-markdown PHP Extension Test Suite\n";
echo str_repeat('=', 72) . "\n";
echo '  PHP Version:      ' . PHP_VERSION . "\n";
echo '  Extension Loaded: ' . (extension_loaded('html_to_markdown') ? 'Yes' : 'No') . "\n";

// =========================================================================
// Section 1: Extension Loading & Function Availability
// =========================================================================

$runner->section('1. Extension Loading & Function Availability');

$runner->test('html_to_markdown extension is loaded', function (): void {
    assert_true(extension_loaded('html_to_markdown'), 'html_to_markdown extension must be loaded');
});

$runner->test('html_to_markdown_convert function exists', function (): void {
    assert_true(function_exists('html_to_markdown_convert'), 'html_to_markdown_convert should be available');
});

// =========================================================================
// Section 2: Basic Conversion (html_to_markdown_convert)
// =========================================================================

$runner->section('2. Basic Conversion');

$runner->test('convert returns string', function (): void {
    $result = html_to_markdown_convert('<p>Hello World</p>');
    assert_true(is_string($result), 'result should be a string');
});

$runner->test('convert simple paragraph', function (): void {
    $result = html_to_markdown_convert('<p>Hello World</p>');
    assert_true(is_string($result), 'content should be a string');
    assert_string_contains('Hello World', $result);
});

$runner->test('convert empty string', function (): void {
    $result = html_to_markdown_convert('');
    assert_true(is_string($result), 'result should be a string');
    assert_equals('', $result, 'empty input should produce empty content');
});

$runner->test('convert heading h1', function (): void {
    $result = html_to_markdown_convert('<h1>Title</h1>');
    assert_string_contains('Title', $result);
});

$runner->test('convert heading h2', function (): void {
    $result = html_to_markdown_convert('<h2>Subtitle</h2>');
    assert_string_contains('Subtitle', $result);
});

$runner->test('convert bold text', function (): void {
    $result = html_to_markdown_convert('<p>Hello <strong>Bold</strong> text</p>');
    assert_string_contains('**Bold**', $result);
});

$runner->test('convert italic text', function (): void {
    $result = html_to_markdown_convert('<p>Hello <em>Italic</em> text</p>');
    assert_string_contains('*Italic*', $result);
});

$runner->test('convert unordered list', function (): void {
    $result = html_to_markdown_convert('<ul><li>Item 1</li><li>Item 2</li></ul>');
    assert_string_contains('Item 1', $result);
    assert_string_contains('Item 2', $result);
});

$runner->test('convert ordered list', function (): void {
    $result = html_to_markdown_convert('<ol><li>First</li><li>Second</li></ol>');
    assert_string_contains('First', $result);
    assert_string_contains('Second', $result);
});

$runner->test('convert link', function (): void {
    $result = html_to_markdown_convert('<a href="https://example.com">Example</a>');
    assert_string_contains('Example', $result);
    assert_string_contains('https://example.com', $result);
});

$runner->test('convert inline code', function (): void {
    $result = html_to_markdown_convert('<code>console.log()</code>');
    assert_string_contains('console.log()', $result);
});

$runner->test('convert code block', function (): void {
    $result = html_to_markdown_convert('<pre><code>function hello() {}</code></pre>');
    assert_string_contains('function hello() {}', $result);
});

$runner->test('convert blockquote', function (): void {
    $result = html_to_markdown_convert('<blockquote>Quote text</blockquote>');
    assert_string_contains('Quote text', $result);
});

$runner->test('convert image', function (): void {
    $result = html_to_markdown_convert('<img src="https://example.com/img.png" alt="Alt text">');
    assert_string_contains('Alt text', $result);
    assert_string_contains('https://example.com/img.png', $result);
});

$runner->test('convert horizontal rule', function (): void {
    $result = html_to_markdown_convert('<p>Above</p><hr><p>Below</p>');
    assert_string_contains('Above', $result);
    assert_string_contains('Below', $result);
});

$runner->test('convert nested HTML', function (): void {
    $html = '<div><h1>Header</h1><p>Paragraph with <strong>bold</strong> and <em>italic</em></p><ul><li>Item</li></ul></div>';
    $result = html_to_markdown_convert($html);
    assert_string_contains('Header', $result);
    assert_string_contains('**bold**', $result);
    assert_string_contains('*italic*', $result);
    assert_string_contains('Item', $result);
});

$runner->test('convert with null options', function (): void {
    $result = html_to_markdown_convert('<p>Test</p>', null);
    assert_string_contains('Test', $result);
});

// =========================================================================
// Section 3: Conversion with Options
// =========================================================================

$runner->section('3. Conversion with Options');

$runner->test('convert with heading_style atx option', function (): void {
    $result = html_to_markdown_convert('<h1>Title</h1>', ['heading_style' => 'atx']);
    assert_true(is_string($result), 'result should be a string');
    assert_string_contains('Title', $result);
});

$runner->test('convert with heading_style atx_closed option', function (): void {
    $result = html_to_markdown_convert('<h1>Title</h1>', ['heading_style' => 'atx_closed']);
    assert_true(is_string($result), 'result should be a string');
    assert_string_contains('Title', $result);
});

$runner->test('convert with code_block_style backticks', function (): void {
    $result = html_to_markdown_convert('<pre><code>code</code></pre>', ['code_block_style' => 'backticks']);
    assert_string_contains('code', $result);
});

$runner->test('convert with escape_asterisks false', function (): void {
    $result = html_to_markdown_convert('<p>Hello World</p>', ['escape_asterisks' => false]);
    assert_string_contains('Hello World', $result);
});

$runner->test('convert with empty options array', function (): void {
    $result = html_to_markdown_convert('<p>Test</p>', []);
    assert_string_contains('Test', $result);
});

$runner->test('convert with autolinks option', function (): void {
    $result = html_to_markdown_convert('<a href="https://example.com">https://example.com</a>', ['autolinks' => true]);
    assert_string_contains('example.com', $result);
});

$runner->test('convert with skip_images option', function (): void {
    $html = '<p>Text <img src="image.png" alt="pic"> more text</p>';
    $result = html_to_markdown_convert($html, ['skip_images' => true]);
    assert_string_contains('Text', $result);
    assert_string_contains('more text', $result);
    assert_string_not_contains('![pic]', $result, 'Image markdown should be removed');
    assert_string_not_contains('image.png', $result, 'Image URL should be removed');
});

$runner->test('convert with strip_tags option', function (): void {
    $html = '<div><nav>Navigation</nav><p>Content</p></div>';
    $result = html_to_markdown_convert($html, ['strip_tags' => ['nav']]);
    assert_string_contains('Content', $result);
});

// =========================================================================
// Section 4: Result Structure
// =========================================================================

$runner->section('4. Result Structure');

$runner->test('result is a string', function (): void {
    $html = '<p>Hello World</p>';
    $result = html_to_markdown_convert($html);
    assert_true(is_string($result), 'result should be a string');
    assert_string_contains('Hello World', $result);
});

$runner->test('result from full HTML document is a string', function (): void {
    $html = <<<'HTML'
        <html lang="en">
            <head>
                <title>Test Article</title>
                <meta name="description" content="A test description">
            </head>
            <body>
                <h1>Main Title</h1>
                <p>Content</p>
            </body>
        </html>
        HTML;

    $result = html_to_markdown_convert($html);
    assert_true(is_string($result), 'result should be a string');
    assert_string_contains('Main Title', $result);
});

// =========================================================================
// Section 5: Multiple Heading Levels
// =========================================================================

$runner->section('5. Multiple Heading Levels');

$runner->test('convert all heading levels h1-h6', function (): void {
    $html = '<h1>H1</h1><h2>H2</h2><h3>H3</h3><h4>H4</h4><h5>H5</h5><h6>H6</h6>';
    $result = html_to_markdown_convert($html);
    assert_string_contains('H1', $result);
    assert_string_contains('H2', $result);
    assert_string_contains('H3', $result);
    assert_string_contains('H4', $result);
    assert_string_contains('H5', $result);
    assert_string_contains('H6', $result);
});

// =========================================================================
// Section 6: Complex HTML Structures
// =========================================================================

$runner->section('6. Complex HTML Structures');

$runner->test('convert nested lists', function (): void {
    $html = '<ul><li>Parent<ul><li>Child 1</li><li>Child 2</li></ul></li></ul>';
    $result = html_to_markdown_convert($html);
    assert_string_contains('Parent', $result);
    assert_string_contains('Child 1', $result);
    assert_string_contains('Child 2', $result);
});

$runner->test('convert table', function (): void {
    $html = '<table><thead><tr><th>Name</th><th>Value</th></tr></thead><tbody><tr><td>A</td><td>1</td></tr></tbody></table>';
    $result = html_to_markdown_convert($html);
    assert_string_contains('Name', $result);
    assert_string_contains('Value', $result);
    assert_string_contains('A', $result);
});

$runner->test('convert mixed inline formatting', function (): void {
    $html = '<p>Text with <strong>bold</strong>, <em>italic</em>, and <code>code</code></p>';
    $result = html_to_markdown_convert($html);
    assert_string_contains('**bold**', $result);
    assert_string_contains('*italic*', $result);
    assert_string_contains('`code`', $result);
});

$runner->test('convert complex document structure', function (): void {
    $html = <<<'HTML'
        <div>
            <h1>Header</h1>
            <p>Paragraph with <strong>bold</strong> and <em>italic</em></p>
            <ul>
                <li>Item 1</li>
                <li>Item 2</li>
            </ul>
            <blockquote>Quote</blockquote>
            <pre><code>code snippet</code></pre>
        </div>
        HTML;

    $result = html_to_markdown_convert($html);
    assert_string_contains('Header', $result);
    assert_string_contains('**bold**', $result);
    assert_string_contains('*italic*', $result);
    assert_string_contains('Item 1', $result);
    assert_string_contains('Item 2', $result);
    assert_string_contains('Quote', $result);
    assert_string_contains('code snippet', $result);
});

$runner->test('convert HTML with special characters', function (): void {
    $html = '<p>Ampersand &amp; less-than &lt; greater-than &gt;</p>';
    $result = html_to_markdown_convert($html);
    assert_string_contains('Ampersand', $result);
});

$runner->test('convert HTML with unicode content', function (): void {
    $html = '<p>Unicode: cafe, naive, resume</p>';
    $result = html_to_markdown_convert($html);
    assert_string_contains('Unicode', $result);
    assert_string_contains('cafe', $result);
});

// =========================================================================
// Section 7: Error Handling
// =========================================================================

$runner->section('7. Error Handling');

$runner->test('convert handles malformed HTML gracefully', function (): void {
    $html = '<p>Unclosed paragraph<div>And a div</p></div>';
    $result = html_to_markdown_convert($html);
    assert_true(is_string($result), 'should still return a string');
});

$runner->test('convert handles deeply nested HTML', function (): void {
    $depth = 50;
    $html = str_repeat('<div>', $depth) . 'Content' . str_repeat('</div>', $depth);
    $result = html_to_markdown_convert($html);
    assert_string_contains('Content', $result);
});

$runner->test('convert handles HTML with only whitespace', function (): void {
    $result = html_to_markdown_convert('   ');
    assert_true(is_string($result), 'should return a string');
});

$runner->test('convert handles script tags (should be stripped)', function (): void {
    $html = '<p>Text</p><script>alert("xss")</script><p>More</p>';
    $result = html_to_markdown_convert($html);
    assert_string_contains('Text', $result);
    assert_string_contains('More', $result);
});

$runner->test('convert handles style tags (should be stripped)', function (): void {
    $html = '<style>body { color: red; }</style><p>Visible</p>';
    $result = html_to_markdown_convert($html);
    assert_string_contains('Visible', $result);
});

$runner->test('convert with invalid heading_style throws exception', function (): void {
    assert_throws(
        \Exception::class,
        static fn() => html_to_markdown_convert('<h1>Title</h1>', ['heading_style' => 'invalid']),
        'invalid heading_style',
    );
});

// =========================================================================
// Print summary
// =========================================================================

exit($runner->summary());
