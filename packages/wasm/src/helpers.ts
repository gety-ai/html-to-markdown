import {
  convert as wasmConvert,
  WasmConversionOptions,
  type WasmConversionResult,
  type WasmHeadingStyle,
  type WasmListIndentType,
  type WasmWhitespaceMode,
  type WasmNewlineStyle,
  type WasmCodeBlockStyle,
  type WasmHighlightStyle,
  type WasmLinkStyle,
  type WasmOutputFormat,
  type WasmPreprocessingOptions,
  WasmVisitorHandle,
} from "./wasm";

/**
 * HTML visitor interface for customizing element traversal.
 * Implement visitor methods to customize how specific HTML elements are converted.
 */
export interface HtmlVisitor {
  [key: string]:
    | ((ctx?: any, ...args: any[]) => string | { custom: string } | undefined)
    | undefined;
}

/**
 * Plain-object options for HTML to Markdown conversion.
 * All fields are optional — omitted fields use sensible defaults.
 */
export interface ConversionOptions {
  headingStyle?: WasmHeadingStyle | null;
  listIndentType?: WasmListIndentType | null;
  listIndentWidth?: number | null;
  bullets?: string | null;
  strongEmSymbol?: string | null;
  escapeAsterisks?: boolean | null;
  escapeUnderscores?: boolean | null;
  escapeMisc?: boolean | null;
  escapeAscii?: boolean | null;
  codeLanguage?: string | null;
  autolinks?: boolean | null;
  defaultTitle?: boolean | null;
  brInTables?: boolean | null;
  highlightStyle?: WasmHighlightStyle | null;
  extractMetadata?: boolean | null;
  whitespaceMode?: WasmWhitespaceMode | null;
  stripNewlines?: boolean | null;
  wrap?: boolean | null;
  wrapWidth?: number | null;
  convertAsInline?: boolean | null;
  subSymbol?: string | null;
  supSymbol?: string | null;
  newlineStyle?: WasmNewlineStyle | null;
  codeBlockStyle?: WasmCodeBlockStyle | null;
  keepInlineImagesIn?: string[] | null;
  preprocessing?: WasmPreprocessingOptions | null;
  encoding?: string | null;
  debug?: boolean | null;
  stripTags?: string[] | null;
  preserveTags?: string[] | null;
  skipImages?: boolean | null;
  linkStyle?: WasmLinkStyle | null;
  outputFormat?: WasmOutputFormat | null;
  includeDocumentStructure?: boolean | null;
  extractImages?: boolean | null;
  maxImageSize?: bigint | null;
  captureSvg?: boolean | null;
  inferDimensions?: boolean | null;
  maxDepth?: number | null;
  excludeSelectors?: string[] | null;
  visitor?: HtmlVisitor | null;
}

/**
 * Convert HTML to Markdown.
 *
 * Accepts an optional plain-object options parameter — no need to construct
 * a `WasmConversionOptions` class instance.
 *
 * @example
 * ```ts
 * import { convert } from "@kreuzberg/html-to-markdown-wasm";
 *
 * const result = convert("<h1>Hello</h1>", { headingStyle: "Atx" });
 * console.log(result.content);
 * ```
 */
export function convert(html: string, options?: ConversionOptions | null): WasmConversionResult {
  if (!options) {
    return wasmConvert(html);
  }

  const wasmOpts = new WasmConversionOptions(
    options.headingStyle,
    options.listIndentType,
    options.listIndentWidth,
    options.bullets,
    options.strongEmSymbol,
    options.escapeAsterisks,
    options.escapeUnderscores,
    options.escapeMisc,
    options.escapeAscii,
    options.codeLanguage,
    options.autolinks,
    options.defaultTitle,
    options.brInTables,
    options.highlightStyle,
    options.extractMetadata,
    options.whitespaceMode,
    options.stripNewlines,
    options.wrap,
    options.wrapWidth,
    options.convertAsInline,
    options.subSymbol,
    options.supSymbol,
    options.newlineStyle,
    options.codeBlockStyle,
    options.keepInlineImagesIn,
    options.preprocessing,
    options.encoding,
    options.debug,
    options.stripTags,
    options.preserveTags,
    options.skipImages,
    options.linkStyle,
    options.outputFormat,
    options.includeDocumentStructure,
    options.extractImages,
    options.maxImageSize,
    options.captureSvg,
    options.inferDimensions,
    options.excludeSelectors,
    options.maxDepth,
  );

  try {
    return wasmConvert(html, wasmOpts);
  } finally {
    wasmOpts.free();
  }
}
