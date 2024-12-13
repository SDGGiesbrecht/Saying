import Foundation

import SDGCollections
import SDGText
import SDGPersistence

struct Module {

  var directory: URL

  func sourceFiles() throws -> [URL] {
    return try FileManager.default.deepFileEnumeration(in: directory)
      .lazy.filter({ $0.lastPathComponent ∉ Package.ignoredFiles })
      .sorted(by: { $0.path < $1.path })
  }

  func build() throws -> ModuleIntermediate {
    let sourceFiles = try self.sourceFiles()
    var module = ModuleIntermediate()
    for sourceFile in sourceFiles {
      try module.add(file: File(from: sourceFile).parse())
    }
    try module.resolveExtensions()
    try module.resolveUses()
    module.resolveTypeIdentifiers()
    module.resolveTypes()
    try module.validateReferences()
    return module.applyingTestCoverageTracking()
  }
}
