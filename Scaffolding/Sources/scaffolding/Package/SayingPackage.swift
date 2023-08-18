import Foundation

import SDGCollections
import SDGText
import SDGPersistence

struct Package {

  var location: URL

  var sourceDirectory: URL {
    return location.appendingPathComponent("Source")
  }
  var constructionDirectory: URL {
    return location.appendingPathComponent(".Construction")
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
    let construction = self.constructionDirectory.appendingPathComponent("Swift")
    let source = try self.modules().lazy.map({ try $0.buildSwift() }).joined(separator: "\n\n")
    try source.save(
      to:
        construction
        .appendingPathComponent("Sources")
        .appendingPathComponent("Products")
        .appendingPathComponent("Source.swift")
    )
  }

  func test() throws {
    try build()
  }
}
