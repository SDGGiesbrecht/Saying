import Foundation

import SDGCollections

struct Module {

  var directory: URL

  func sourceFiles() throws -> [URL] {
    return try FileManager.default.contents(ofDirectory: directory)
      .lazy.filter({ $0.lastPathComponent ∉ Package.ignoredFiles })
      .sorted(by: { $0.lastPathComponent < $1.lastPathComponent })
  }

  func build() throws {
    let sourceFiles = try self.sourceFiles()
    for sourceFile in sourceFiles {
      let loaded = try File(from: sourceFile)
      switch loaded.contents {
      case .utf8(let source):
        let interface = InterfaceSyntax.parse(source: source)
        for token in interface.tokens {
          print("\(token.location.underlyingScalarOffsetOfStart()): “\(token.token.source)”")
        }
      }
    }
  }
}
