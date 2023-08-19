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

  func buildSwift() throws {
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
  }

  func test() throws {
    try testSwift()
  }

  func testSwift() throws {
    try buildSwift()
    _ = try Shell.default.run(
      command: [
        "swift", "run",
        "--package-path", swiftConstructionDirectory.path,
        "test"
      ],
      reportProgress: { print($0) }
    ).get()
  }

  func testXcode(platform: String) throws {
    try buildSwift()
    _ = try Shell.default.run(
      command: [
        "xcrun", "xcodebuild", "build",
        "-destination", "generic/platform=iOS",
        "-scheme", "Package",
      ],
      in: swiftConstructionDirectory,
      reportProgress: { print($0) }
    ).get()
  }
  func testIOS() throws {
    return try testXcode(platform: "iOS")
  }
}
