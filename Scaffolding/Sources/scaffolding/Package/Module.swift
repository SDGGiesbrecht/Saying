import Foundation

import SDGCollections
import SDGText

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
      let syntax = try loaded.parse()
      for declaration in [[syntax.first], syntax.continuations.lazy.map({ $0.declaration })].joined() {
        switch declaration {
        case .thing(let thing):
          let names = thing.name.names.names
            .map({ $0.name.identifierText() })
            .joined(separator: ", ")
          print("thing (\(thing.location.underlyingScalarOffsetOfStart())): \(names)")
        case .action(let action):
          let source = action.name.names.names
            .map({ $0.name.name() })
            .joined(separator: ", ")
          print("action (\(action.location.underlyingScalarOffsetOfStart())): \(source)")
        }
      }
    }
  }
}
