// @ts-check
import { defineConfig } from "astro/config";
import starlight from "@astrojs/starlight";
import starlightLlmsTxt from "starlight-llms-txt";
// Local link during migration; switch to "^0.1.0" once @xberg-io/docs-theme is published.
import { xbergStarlightConfig } from "@xberg-io/docs-theme";

const API_LANGUAGES = [
  { label: "Rust", slug: "reference/api-rust" },
  { label: "Python", slug: "reference/api-python" },
  { label: "TypeScript", slug: "reference/api-typescript" },
  { label: "Go", slug: "reference/api-go" },
  { label: "Ruby", slug: "reference/api-ruby" },
  { label: "PHP", slug: "reference/api-php" },
  { label: "Java", slug: "reference/api-java" },
  { label: "C#", slug: "reference/api-csharp" },
  { label: "Elixir", slug: "reference/api-elixir" },
  { label: "R", slug: "reference/api-r" },
  { label: "Dart", slug: "reference/api-dart" },
  { label: "Kotlin (Android)", slug: "reference/api-kotlin-android" },
  { label: "Swift", slug: "reference/api-swift" },
  { label: "Zig", slug: "reference/api-zig" },
  { label: "C", slug: "reference/api-c" },
  { label: "WebAssembly", slug: "reference/api-wasm" },
];

// https://astro.build/config
export default defineConfig({
  site: "https://docs.html-to-markdown.xberg.io",
  integrations: [
    starlight(
      xbergStarlightConfig({
        title: "html-to-markdown",
        description:
          "High-performance HTML to Markdown conversion powered by Rust. One core plus 15 " +
          "generated packages, identical output on every runtime.",
        githubUrl: "https://github.com/xberg-io/html-to-markdown",
        editBaseUrl: "https://github.com/xberg-io/html-to-markdown/edit/main/docs-site/",
        plugins: [starlightLlmsTxt()],
        sidebar: [
          { label: "Home", link: "/" },
          {
            label: "Get Started",
            items: [
              { label: "Installation", slug: "installation" },
              { label: "Usage", slug: "usage" },
              { label: "CLI", slug: "cli" },
            ],
          },
          {
            label: "Guides",
            items: [
              { label: "Visitor pattern", slug: "visitor" },
              { label: "Table extraction", slug: "tables" },
              { label: "Error handling", slug: "errors" },
              { label: "AI Coding Assistants", slug: "agent-skills" },
            ],
          },
          {
            label: "Concepts",
            items: [
              { label: "Architecture", slug: "concepts/architecture" },
              { label: "Conversion pipeline", slug: "concepts/pipeline" },
              { label: "Plugin system", slug: "concepts/plugin-system" },
            ],
          },
          {
            label: "Reference",
            items: [
              { label: "Configuration", slug: "configuration" },
              { label: "API reference", slug: "api-reference" },
              { label: "Language guides", slug: "language-guides" },
              { label: "Language APIs", items: API_LANGUAGES },
              { label: "Types", slug: "reference/types" },
              { label: "Configuration (generated)", slug: "reference/configuration" },
              { label: "Error types (generated)", slug: "reference/errors" },
              { label: "CLI (generated)", slug: "reference/cli" },
              { label: "MCP (generated)", slug: "reference/mcp" },
            ],
          },
          {
            label: "More",
            items: [
              { label: "Migration", slug: "migration" },
              { label: "Contributing", slug: "contributing" },
              {
                label: "Changelog",
                link: "https://github.com/xberg-io/html-to-markdown/blob/main/CHANGELOG.md",
              },
              { label: "Ecosystem", slug: "ecosystem" },
            ],
          },
        ],
      }),
    ),
  ],
});
