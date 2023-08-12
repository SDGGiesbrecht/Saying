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
    var module = ModuleIntermediate()
    for sourceFile in sourceFiles {
      try module.add(file: File(from: sourceFile).parse())
    }
    for thing in module.things.sorted(by: { $0.key < $1.key }) {
      print("\(thing.key):", StrictString(thing.value.names.sorted().joined(separator: "/".scalars)))
    }
  }
}
