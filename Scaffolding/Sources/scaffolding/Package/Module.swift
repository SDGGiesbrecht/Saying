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

  func build() throws -> ModuleIntermediate {
    let sourceFiles = try self.sourceFiles()
    var module = ModuleIntermediate()
    for sourceFile in sourceFiles {
      try module.add(file: File(from: sourceFile).parse())
    }
    module.addMagicSymbols()
    try module.validateReferences()
    return module.applyingTestCoverageTracking()
  }

  func buildC() throws -> String {
    try C.build(module: build())
  }

  func buildCSharp() throws -> String {
    try CSharp.build(module: build())
  }

  func buildJavaScript() throws -> String {
    try JavaScript.build(module: build())
  }

  func buildSwift() throws -> String {
    try Swift.build(module: build())
  }
}
