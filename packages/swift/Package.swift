// swift-tools-version: 6.0
import PackageDescription
import Foundation

// NOTE: Run `cargo build -p html-to-markdown-rs-swift` and then rerun `alef generate`

let rustTargetDir = (#filePath as NSString).deletingLastPathComponent.appending("/../../target")

let package = Package(
  name: "HtmlToMarkdown",
  platforms: [
    .macOS(.v13),
    .iOS(.v16),
  ],
  products: [
    .library(name: "HtmlToMarkdown", targets: ["HtmlToMarkdown"])
  ],
  targets: [
    .target(
      name: "RustBridgeC",
      path: "Sources/RustBridgeC",
      publicHeadersPath: "."
    ),
    .target(
      name: "RustBridge",
      dependencies: ["RustBridgeC"],
      path: "Sources/RustBridge",
      linkerSettings: [
        .unsafeFlags([
          "-L\(rustTargetDir)/release",
          "-L\(rustTargetDir)/debug",
          "-Xlinker", "-rpath", "-Xlinker", "\(rustTargetDir)/release",
          "-Xlinker", "-rpath", "-Xlinker", "\(rustTargetDir)/debug",
        ]),
        .linkedLibrary("html_to_markdown_rs_swift"),
        .linkedLibrary("html_to_markdown_ffi"),
        .linkedFramework("Security", .when(platforms: [.macOS, .iOS])),
        .linkedFramework("CoreFoundation", .when(platforms: [.macOS, .iOS])),
        .linkedFramework("SystemConfiguration", .when(platforms: [.macOS])),
      ]
    ),
    .target(
      name: "HtmlToMarkdown", dependencies: ["RustBridge"],
      path: "Sources/HtmlToMarkdown",
      exclude: ["LICENSE"]),
    .testTarget(
      name: "HtmlToMarkdownTests", dependencies: ["HtmlToMarkdown"],
      path: "Tests/HtmlToMarkdownTests"),
  ]
)
