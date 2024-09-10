import Foundation

import SDGCollections
import SDGText
import SDGPersistence
import SDGExternalProcess

struct Package {

  var location: URL

  var sourceDirectory: URL {
    return location.appendingPathComponent("Source")
  }
  var constructionDirectory: URL {
    return location.appendingPathComponent(".Construction")
  }
  var cSharpConstructionDirectory: URL {
    return constructionDirectory.appendingPathComponent("C♯")
  }
  var javaScriptConstructionDirectory: URL {
    return constructionDirectory.appendingPathComponent("JavaScript")
  }
  var swiftConstructionDirectory: URL {
    return constructionDirectory.appendingPathComponent("Swift")
  }

  static let ignoredDirectories: Set<String> = [
    ".git"
  ]
  static let ignoredFiles: Set<String> = [
    ".DS_Store",
  ]

  func modules() throws -> [Module] {
    return try FileManager.default.contents(ofDirectory: sourceDirectory)
      .lazy.filter({ $0.lastPathComponent ∉ Package.ignoredFiles })
      .sorted(by: { $0.lastPathComponent < $1.lastPathComponent })
      .map({ Module(directory: $0)})
  }

  func files() throws -> [URL] {
    return try FileManager.default.deepFileEnumeration(in: location)
      .lazy.filter({ $0.path(relativeTo: location).truncated(before: "/") ∉ Package.ignoredDirectories })
      .lazy.filter({ $0.lastPathComponent ∉ Package.ignoredFiles })
      .sorted(by: { $0.path < $1.path })
  }

  func format(reportProgress: (StrictString) -> Void) throws {
    for fileURL in try files() {
      let relativePath = fileURL.path(relativeTo: location)
      switch fileURL.sourceFormat {
      case .utf8(let gitStyle):
        switch gitStyle {
        case false:
          reportProgress("¬\(relativePath)")
        case true:
          reportProgress(" \(relativePath)")
          let file = try File(from: fileURL)
          let formatted = try file.formattedGitStyleSource()
          try formatted.appending("\n").save(to: fileURL)
        }
      }
    }
  }

  func build() throws {
    try buildSwift()
  }

  func prepareCSharp() throws {
    try ([
      "using System;",
      "",
      //try self.modules().lazy.map({ try $0.buildJavaScript() }).joined(separator: "\n\n"),
      //"",
      "class Test",
      "{",
      "  static void Main()",
      "  {",
      //"test();",
      "    Console.WriteLine(\u{22}Hello, world!\u{22});",
      "  }",
      "}",
    ] as [String]).joined(separator: "\n").appending("\n")
      .save(to: cSharpConstructionDirectory.appendingPathComponent("Test.cs"))
    try ([
      "<Project>",
      "  <ItemGroup>",
      "    <Compile Include=\u{22}Test.cs\u{22} />",
      "  </ItemGroup>",
      "  <Target Name=\u{22}Test\u{22}>",
      "    <Csc Sources=\u{22}@(Compile)\u{22} />",
      "  </Target>",
      "</Project>",
    ] as [String]).joined(separator: "\n").appending("\n")
      .save(to: cSharpConstructionDirectory.appendingPathComponent("Project.csproj"))
  }

  func prepareJavaScript() throws {
    try ([
      try self.modules().lazy.map({ try $0.buildJavaScript() }).joined(separator: "\n\n"),
      "",
      "test();",
    ] as [String]).joined(separator: "\n").appending("\n")
      .save(to: javaScriptConstructionDirectory.appendingPathComponent("Package.js"))
    try ([
      "<html>",
      "  <head>",
      "    <script src=\u{22}Package.js\u{22}></script>",
      "  </head>",
      "  <body>",
      "    <script>",
      "      test();",
      "    </script>",
      "  </body>",
      "</html>",
    ] as [String]).joined(separator: "\n").appending("\n")
      .save(to: javaScriptConstructionDirectory.appendingPathComponent("Test.html"))
  }

  func buildJavaScript() throws {
    try prepareJavaScript()
  }

  func prepareSwift() throws {
    try ([
      "// swift-tools-version: 5.7",
      "",
      "import PackageDescription",
      "",
      "let package = Package(",
      "  name: \u{22}Package\u{22},",
      "  targets: [",
      "    .target(name: \u{22}Products\u{22}),",
      "    .executableTarget(",
      "      name: \u{22}test\u{22},",
      "      dependencies: [\u{22}Products\u{22}]",
      "    ),",
      "    .testTarget(",
      "      name: \u{22}WrappedTests\u{22},",
      "      dependencies: [\u{22}Products\u{22}]",
      "    )",
      "  ]",
      ")",
    ] as [String]).joined(separator: "\n").appending("\n")
      .save(to: swiftConstructionDirectory.appendingPathComponent("Package.swift"))
    let source = try self.modules().lazy.map({ try $0.buildSwift() }).joined(separator: "\n\n")
    try source.save(
      to:
        swiftConstructionDirectory
        .appendingPathComponent("Sources")
        .appendingPathComponent("Products")
        .appendingPathComponent("Source.swift")
    )
    try ([
      "@testable import Products",
      "",
      "@main struct Test {",
      "",
      "  static func main() {",
      "    Products.test()",
      "  }",
      "}",
    ] as [String]).joined(separator: "\n").appending("\n")
      .save(
        to:
          swiftConstructionDirectory
          .appendingPathComponent("Sources")
          .appendingPathComponent("test")
          .appendingPathComponent("Test.swift")
      )
    try ([
      "import XCTest",
      "@testable import Products",
      "",
      "class WrappedTests: XCTestCase {",
      "",
      "  func testProject() {",
      "    Products.test()",
      "  }",
      "}",
    ] as [String]).joined(separator: "\n").appending("\n")
      .save(
        to:
          swiftConstructionDirectory
          .appendingPathComponent("Tests")
          .appendingPathComponent("WrappedTests")
          .appendingPathComponent("WrappedTests.swift")
      )
  }

  func buildSwift() throws {
    try prepareSwift()
    _ = try Shell.default.run(
      command: [
        "swift", "build",
        "--package-path", swiftConstructionDirectory.path,
      ],
      reportProgress: { print($0) }
    ).get()
  }

  func test() throws {
    try testSwift()
  }

  func testSwift() throws {
    try prepareSwift()
    _ = try Shell.default.run(
      command: [
        "swift", "run",
        "--package-path", swiftConstructionDirectory.path,
        "test"
      ],
      reportProgress: { print($0) }
    ).get()
  }

  func buildXcode(platform: String) throws {
    try prepareSwift()
    _ = try Shell.default.run(
      command: [
        "xcrun", "xcodebuild", "build",
        "-scheme", "Package",
        "-destination", "generic/platform=\(platform)"
      ],
      in: swiftConstructionDirectory,
      reportProgress: { print($0) }
    ).get()
  }

  func testXcode(platform: String, simulator: String) throws {
    try buildXcode(platform: platform)
    _ = try Shell.default.run(
      command: [
        "xcrun", "xcodebuild", "test",
        "-scheme", "Package",
        "-destination", "platform=\(platform) Simulator,name=\(simulator)"
      ],
      in: swiftConstructionDirectory,
      reportProgress: { print($0) }
    ).get()
  }

  func testIOS() throws {
    try testXcode(platform: "iOS", simulator: "iPhone 14")
  }

  func testTVOS() throws {
    try testXcode(platform: "tvOS", simulator: "Apple TV")
  }

  func testWatchOS() throws {
    try testXcode(platform: "watchOS", simulator: "Apple Watch Series 5 (40mm)")
  }
}
