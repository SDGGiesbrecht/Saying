import Foundation

import SDGCollections
import SDGPersistence

struct Package {

  var location: URL

  var sourceDirectory: URL {
    return location.appendingPathComponent("Source")
  }

  static let ignoredFiles: Set<String> = [".DS_Store"]

  func modules() throws -> [Module] {
    return try FileManager.default.contents(ofDirectory: sourceDirectory)
      .lazy.filter({ $0.lastPathComponent ∉ Package.ignoredFiles })
      .sorted(by: { $0.lastPathComponent < $1.lastPathComponent })
      .map({ Module(directory: $0)})
  }

  func files() throws -> [URL] {
    return try FileManager.default.deepFileEnumeration(in: sourceDirectory)
      .lazy.filter({ $0.lastPathComponent ∉ Package.ignoredFiles })
      .sorted(by: { $0.path < $1.path })
  }

  func format() throws {
    for fileURL in try files() {
      switch fileURL.sourceFormat {
      case .utf8(let gitStyle):
        switch gitStyle {
        case false:
          break
        case true:
          let file = try File(from: fileURL)
          let formatted = try file.formattedGitStyleSource()
          try formatted.save(to: fileURL)
        }
      }
    }
  }

  func build() throws {
    let modules = try self.modules()
    for module in modules {
      try module.build()
    }
  }

  func test() throws {
    try build()
  }
}
