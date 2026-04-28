---
title: html-to-markdown
description: "html-to-markdown — Convert HTML to Markdown, Djot, or plain text. Rust core, 12 native language bindings, 150–280 MB/s."
---

<div class="home-hero" markdown="1">


<p class="home-lead" markdown="1">
Convert HTML to Markdown, Djot, or plain text. One Rust core, 12 native language bindings, identical output on every runtime.
</p>

<div class="home-instruction" markdown="1">

## Start here

1. **[Install a binding](installation.md)** — add the package to your project (versions, feature flags, and verify steps are on that page).
2. **[Run a minimal `convert()`](usage.md#basic-conversion)** — open *Usage → Basic conversion*, choose your language tab, and copy the hello-world snippet.

</div>

</div>

---

## What It Does

<div class="home-feature-grid">
<article class="home-feature-card">
<p class="home-feature-card__title">150–280 MB/s throughput</p>
<p class="home-feature-card__desc">Rust-native parsing and a single-pass DOM walk. 10–80x faster than pure-language alternatives. No JVM, no interpreter overhead.</p>
</article>
<article class="home-feature-card">
<p class="home-feature-card__title">12 language bindings</p>
<p class="home-feature-card__desc">Rust, Python, TypeScript, Go, Ruby, PHP, Java, C#, Elixir, R, C, and WebAssembly. One core — no per-language conversion logic.</p>
</article>
<article class="home-feature-card">
<p class="home-feature-card__title">Three output formats</p>
<p class="home-feature-card__desc">CommonMark, Djot, and plain text via <code>output_format</code>. The same options apply to every format.</p>
</article>
<article class="home-feature-card">
<p class="home-feature-card__title">Metadata extraction</p>
<p class="home-feature-card__desc">Open Graph, Twitter Card, JSON-LD, links, and images in one pass. Enable with <code>extract_metadata: true</code>.</p>
</article>
<article class="home-feature-card">
<p class="home-feature-card__title">Table extraction</p>
<p class="home-feature-card__desc">HTML tables into <code>result.tables</code> (cells, spans, headers) plus rendered Markdown when applicable.</p>
</article>
<article class="home-feature-card">
<p class="home-feature-card__title">Visitor pattern</p>
<p class="home-feature-card__desc">40 callbacks to filter nodes or emit custom output. Zero cost when you do not register a visitor.</p>
</article>
</div>

---

## Getting Help

- **Bugs and feature requests** — [Open an issue on GitHub](https://github.com/kreuzberg-dev/html-to-markdown/issues)
- **Contributing** — [Read the contributor guide](https://github.com/kreuzberg-dev/html-to-markdown/blob/main/CONTRIBUTING.md)

<div class="home-kreuzberg" markdown="1">

### Part of Kreuzberg

html-to-markdown powers the HTML conversion pipeline in [Kreuzberg](https://docs.kreuzberg.dev), a document intelligence library for extracting text and structured data from PDFs, DOCX, images, and other document formats.

</div>
