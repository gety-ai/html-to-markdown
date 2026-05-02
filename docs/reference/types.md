---
title: "Types Reference"
---

## Types Reference

All types defined by the library, grouped by category. Types are shown using Rust as the canonical representation.

### Result Types

#### ConversionResult

The primary result of HTML conversion and extraction.

Contains the converted text output, optional structured document tree,
metadata, extracted tables, images, and processing warnings.

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `content` | `Option<String>` | `Default::default()` | Converted text output (markdown, djot, or plain text). `None` when `output_format` is set to `OutputFormat.None`, indicating extraction-only mode. |
| `document` | `Option<DocumentStructure>` | `Default::default()` | Structured document tree with semantic elements. Populated when `include_document_structure` is `true` in options. |
| `metadata` | `HtmlMetadata` | — | Extracted HTML metadata (title, OG, links, images, structured data). |
| `tables` | `Vec<TableData>` | `vec![]` | Extracted tables with structured cell data and markdown representation. |
| `images` | `Vec<String>` | `vec![]` | Extracted inline images (data URIs and SVGs). Populated when `extract_images` is `true` in options. |
| `warnings` | `Vec<ProcessingWarning>` | `vec![]` | Non-fatal processing warnings. |

---

### Configuration Types

See [Configuration Reference](configuration.md) for detailed defaults and language-specific representations.

#### ConversionOptions

Main conversion options for HTML to Markdown conversion.

Use `ConversionOptions.builder()` to construct, or `the default constructor` for defaults.

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `heading_style` | `HeadingStyle` | `HeadingStyle::Atx` | Heading style to use in Markdown output (ATX `#` or Setext underline). |
| `list_indent_type` | `ListIndentType` | `ListIndentType::Spaces` | How to indent nested list items (spaces or tab). |
| `list_indent_width` | `usize` | `2` | Number of spaces (or tabs) to use for each level of list indentation. |
| `bullets` | `String` | `"-*+"` | Bullet character(s) to use for unordered list items (e.g. `"-"`, `"*"`). |
| `strong_em_symbol` | `String` | `"*"` | Character used for bold/italic emphasis markers (`*` or `_`). |
| `escape_asterisks` | `bool` | `false` | Escape `*` characters in plain text to avoid unintended bold/italic. |
| `escape_underscores` | `bool` | `false` | Escape `_` characters in plain text to avoid unintended bold/italic. |
| `escape_misc` | `bool` | `false` | Escape miscellaneous Markdown metacharacters (`[]()#` etc.) in plain text. |
| `escape_ascii` | `bool` | `false` | Escape ASCII characters that have special meaning in certain Markdown dialects. |
| `code_language` | `String` | `""` | Default language annotation for fenced code blocks that have no language hint. |
| `autolinks` | `bool` | `true` | Automatically convert bare URLs into Markdown autolinks. |
| `default_title` | `bool` | `false` | Emit a default title when no `<title>` tag is present. |
| `br_in_tables` | `bool` | `false` | Render `<br>` elements inside table cells as literal line breaks. |
| `highlight_style` | `HighlightStyle` | `HighlightStyle::DoubleEqual` | Style used for `<mark>` / highlighted text (e.g. `==text==`). |
| `extract_metadata` | `bool` | `true` | Extract `<meta>` and `<head>` information into the result metadata. |
| `whitespace_mode` | `WhitespaceMode` | `WhitespaceMode::Normalized` | Controls how whitespace is normalised during conversion. |
| `strip_newlines` | `bool` | `false` | Strip all newlines from the output, producing a single-line result. |
| `wrap` | `bool` | `false` | Wrap long lines at `wrap_width` characters. |
| `wrap_width` | `usize` | `80` | Maximum line width when `wrap` is enabled (default `80`). |
| `convert_as_inline` | `bool` | `false` | Treat the entire document as inline content (no block-level wrappers). |
| `sub_symbol` | `String` | `""` | Markdown notation for subscript text (e.g. `"~"`). |
| `sup_symbol` | `String` | `""` | Markdown notation for superscript text (e.g. `"^"`). |
| `newline_style` | `NewlineStyle` | `NewlineStyle::Spaces` | How to encode hard line breaks (`<br>`) in Markdown. |
| `code_block_style` | `CodeBlockStyle` | `CodeBlockStyle::Backticks` | Style used for fenced code blocks (backticks or tilde). |
| `keep_inline_images_in` | `Vec<String>` | `vec![]` | HTML tag names whose `<img>` children are kept inline instead of block. |
| `preprocessing` | `PreprocessingOptions` | — | Pre-processing options applied to the HTML before conversion. |
| `encoding` | `String` | `"utf-8"` | Expected character encoding of the input HTML (default `"utf-8"`). |
| `debug` | `bool` | `false` | Emit debug information during conversion. |
| `strip_tags` | `Vec<String>` | `vec![]` | HTML tag names whose content is stripped from the output entirely. |
| `preserve_tags` | `Vec<String>` | `vec![]` | HTML tag names that are preserved verbatim in the output. |
| `skip_images` | `bool` | `false` | Skip conversion of `<img>` elements (omit images from output). |
| `link_style` | `LinkStyle` | `LinkStyle::Inline` | Link rendering style (inline or reference). |
| `output_format` | `OutputFormat` | `OutputFormat::Markdown` | Target output format (Markdown, plain text, etc.). |
| `include_document_structure` | `bool` | `false` | Include structured document tree in result. |
| `extract_images` | `bool` | `false` | Extract inline images from data URIs and SVGs. |
| `max_image_size` | `u64` | `5242880` | Maximum decoded image size in bytes (default 5MB). |
| `capture_svg` | `bool` | `false` | Capture SVG elements as images. |
| `infer_dimensions` | `bool` | `true` | Infer image dimensions from data. |
| `max_depth` | `Option<usize>` | `None` | Maximum DOM traversal depth. `None` means unlimited. When set, subtrees beyond this depth are silently truncated. |
| `exclude_selectors` | `Vec<String>` | `vec![]` | CSS selectors for elements to exclude entirely (element + all content). Unlike `strip_tags` (which removes the tag wrapper but keeps children), excluded elements and all their descendants are dropped from the output. Supports any CSS selector that `tl` supports: tag names, `.class`, `#id`, `[attribute]`, etc. Invalid selectors are silently skipped at conversion time. Example: `vec![".cookie-banner".into(), "#ad-container".into(), "[role='complementary']".into()]` |
| `visitor` | `Option<VisitorHandle>` | `None` | Optional visitor for custom traversal logic. When set, the visitor's callbacks are invoked for matching HTML elements during conversion, allowing custom output, skipping, or HTML preservation. See `crate.visitor.HtmlVisitor`. |

---

#### PreprocessingOptions

HTML preprocessing options for document cleanup before conversion.

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `enabled` | `bool` | `true` | Enable HTML preprocessing globally |
| `preset` | `PreprocessingPreset` | `PreprocessingPreset::Standard` | Preprocessing preset level (Minimal, Standard, Aggressive) |
| `remove_navigation` | `bool` | `true` | Remove navigation elements (nav, breadcrumbs, menus, sidebars) |
| `remove_forms` | `bool` | `true` | Remove form elements (forms, inputs, buttons, etc.) |

---

#### TableGrid

A structured table grid with cell-level data including spans.

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `rows` | `u32` | — | Number of rows. |
| `cols` | `u32` | — | Number of columns. |
| `cells` | `Vec<GridCell>` | `vec![]` | All cells in the table (may be fewer than rows*cols due to spans). |

---

### Metadata Types

#### DocumentMetadata

Document-level metadata extracted from `<head>` and top-level elements.

Contains all metadata typically used by search engines, social media platforms,
and browsers for document indexing and presentation.

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `title` | `Option<String>` | `Default::default()` | Document title from `<title>` tag |
| `description` | `Option<String>` | `Default::default()` | Document description from `<meta name="description">` tag |
| `keywords` | `Vec<String>` | `vec![]` | Document keywords from `<meta name="keywords">` tag, split on commas |
| `author` | `Option<String>` | `Default::default()` | Document author from `<meta name="author">` tag |
| `canonical_url` | `Option<String>` | `Default::default()` | Canonical URL from `<link rel="canonical">` tag |
| `base_href` | `Option<String>` | `Default::default()` | Base URL from `<base href="">` tag for resolving relative URLs |
| `language` | `Option<String>` | `Default::default()` | Document language from `lang` attribute |
| `text_direction` | `Option<TextDirection>` | `Default::default()` | Document text direction from `dir` attribute |
| `open_graph` | `HashMap<String, String>` | `HashMap::new()` | Open Graph metadata (og:* properties) for social media Keys like "title", "description", "image", "url", etc. |
| `twitter_card` | `HashMap<String, String>` | `HashMap::new()` | Twitter Card metadata (twitter:* properties) Keys like "card", "site", "creator", "title", "description", "image", etc. |
| `meta_tags` | `HashMap<String, String>` | `HashMap::new()` | Additional meta tags not covered by specific fields Keys are meta name/property attributes, values are content |

---

#### HeaderMetadata

Header element metadata with hierarchy tracking.

Captures heading elements (h1-h6) with their text content, identifiers,
and position in the document structure.

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `level` | `u8` | — | Header level: 1 (h1) through 6 (h6) |
| `text` | `String` | — | Normalized text content of the header |
| `id` | `Option<String>` | `None` | HTML id attribute if present |
| `depth` | `usize` | — | Document tree depth at the header element |
| `html_offset` | `usize` | — | Byte offset in original HTML document |

---

#### LinkMetadata

Hyperlink metadata with categorization and attributes.

Represents `<a>` elements with parsed href values, text content, and link type classification.

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `href` | `String` | — | The href URL value |
| `text` | `String` | — | Link text content (normalized, concatenated if mixed with elements) |
| `title` | `Option<String>` | `None` | Optional title attribute (often shown as tooltip) |
| `link_type` | `LinkType` | — | Link type classification |
| `rel` | `Vec<String>` | — | Rel attribute values (e.g., "nofollow", "stylesheet", "canonical") |
| `attributes` | `HashMap<String, String>` | — | Additional HTML attributes |

---

#### ImageMetadata

Image metadata with source and dimensions.

Captures `<img>` elements and inline `<svg>` elements with metadata
for image analysis and optimization.

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `src` | `String` | — | Image source (URL, data URI, or SVG content identifier) |
| `alt` | `Option<String>` | `None` | Alternative text from alt attribute (for accessibility) |
| `title` | `Option<String>` | `None` | Title attribute (often shown as tooltip) |
| `dimensions` | `Vec<u32>` | `None` | Image dimensions as (width, height) if available |
| `image_type` | `ImageType` | — | Image type classification |
| `attributes` | `HashMap<String, String>` | — | Additional HTML attributes |

---

#### HtmlMetadata

Comprehensive metadata extraction result from HTML document.

Contains all extracted metadata types in a single structure,
suitable for serialization and transmission across language boundaries.

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `document` | `DocumentMetadata` | — | Document-level metadata (title, description, canonical, etc.) |
| `headers` | `Vec<HeaderMetadata>` | `vec![]` | Extracted header elements with hierarchy |
| `links` | `Vec<LinkMetadata>` | `vec![]` | Extracted hyperlinks with type classification |
| `images` | `Vec<ImageMetadata>` | `vec![]` | Extracted images with source and dimensions |
| `structured_data` | `Vec<StructuredData>` | `vec![]` | Extracted structured data blocks |

---

### Document Structure

#### DocumentStructure

A structured document tree representing the semantic content of an HTML document.

Uses a flat node array with index-based parent/child references for efficient traversal.

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `nodes` | `Vec<DocumentNode>` | — | All nodes in document reading order. |
| `source_format` | `Option<String>` | `None` | The source format (always "html" for this library). |

---

#### DocumentNode

A single node in the document tree.

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `id` | `String` | — | Deterministic node identifier. |
| `content` | `NodeContent` | — | The semantic content of this node. |
| `parent` | `Option<u32>` | `None` | Index of the parent node (None for root nodes). |
| `children` | `Vec<u32>` | — | Indices of child nodes in reading order. |
| `annotations` | `Vec<TextAnnotation>` | — | Inline formatting annotations (bold, italic, links, etc.) with byte offsets into the text. |
| `attributes` | `HashMap<String, String>` | `None` | Format-specific attributes (e.g. class, id, data-* attributes). |

---

#### GridCell

A single cell in a table grid.

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `content` | `String` | — | The text content of the cell. |
| `row` | `u32` | — | 0-indexed row position. |
| `col` | `u32` | — | 0-indexed column position. |
| `row_span` | `u32` | — | Number of rows this cell spans (default 1). |
| `col_span` | `u32` | — | Number of columns this cell spans (default 1). |
| `is_header` | `bool` | — | Whether this is a header cell (`<th>`). |

---

#### TableData

A top-level extracted table with both structured data and markdown representation.

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `grid` | `TableGrid` | — | The structured table grid. |
| `markdown` | `String` | — | The markdown rendering of this table. |

---

#### NodeContext

Context information passed to all visitor methods.

Provides comprehensive metadata about the current node being visited,
including its type, attributes, position in the DOM tree, and parent context.

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `node_type` | `NodeType` | — | Coarse-grained node type classification |
| `tag_name` | `String` | — | Raw HTML tag name (e.g., "div", "h1", "custom-element") |
| `attributes` | `HashMap<String, String>` | — | All HTML attributes as key-value pairs |
| `depth` | `usize` | — | Depth in the DOM tree (0 = root) |
| `index_in_parent` | `usize` | — | Index among siblings (0-based) |
| `parent_tag` | `Option<String>` | `None` | Parent element's tag name (None if root) |
| `is_inline` | `bool` | — | Whether this element is treated as inline vs block |

---

### Other Types

#### StructuredData

Structured data block (JSON-LD, Microdata, or RDFa).

Represents machine-readable structured data found in the document.
JSON-LD blocks are collected as raw JSON strings for flexibility.

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `data_type` | `StructuredDataType` | — | Type of structured data (JSON-LD, Microdata, RDFa) |
| `raw_json` | `String` | — | Raw JSON string (for JSON-LD) or serialized representation |
| `schema_type` | `Option<String>` | `None` | Schema type if detectable (e.g., "Article", "Event", "Product") |

---

#### ConversionOptionsBuilder

Builder for `ConversionOptions`.

All fields start with default values. Call `.build()` to produce the final options.

*Opaque type — fields are not directly accessible.*

---

#### TextAnnotation

An inline text annotation with byte-range offsets.

Annotations describe formatting (bold, italic, etc.) and links within a node's text content.

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `start` | `u32` | — | Start byte offset (inclusive) into the parent node's text. |
| `end` | `u32` | — | End byte offset (exclusive) into the parent node's text. |
| `kind` | `AnnotationKind` | — | The type of annotation. |

---

#### ProcessingWarning

A non-fatal warning generated during HTML processing.

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `message` | `String` | — | Human-readable warning message. |
| `kind` | `WarningKind` | — | The category of warning. |

---

#### VisitorHandle

Type alias for a visitor handle (Rc-wrapped `RefCell` for interior mutability).

This allows visitors to be passed around and shared while still being mutable.

*Opaque type — fields are not directly accessible.*

---

#### HtmlVisitor

Visitor trait for HTML→Markdown conversion.

Implement this trait to customize the conversion behavior for any HTML element type.
All methods have default implementations that return `VisitResult.Continue`, allowing
selective override of only the elements you care about.

## Method Naming Convention

- `visit_*_start`: Called before entering an element (pre-order traversal)
- `visit_*_end`: Called after exiting an element (post-order traversal)
- `visit_*`: Called for specific element types (e.g., `visit_link`, `visit_image`)

## Execution Order

For a typical element like `<div><p>text</p></div>`:

1. `visit_element_start` for `<div>`
2. `visit_element_start` for `<p>`
3. `visit_text` for "text"
4. `visit_element_end` for `<p>`
5. `visit_element_end` for `</div>`

## Performance Notes

- `visit_text` is the most frequently called method (~100+ times per document)
- Return `VisitResult.Continue` quickly for elements you don't need to customize
- Avoid heavy computation in visitor methods; consider caching if needed

*Opaque type — fields are not directly accessible.*

---
