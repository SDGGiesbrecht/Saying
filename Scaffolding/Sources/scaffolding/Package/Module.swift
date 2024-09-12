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
    return module
  }

  func buildC() throws -> String {
    try build().buildC()
  }

  func buildCSharp() throws -> String {
    try build().buildCSharp()
  }

  func buildJavaScript() throws -> String {
    try build().buildJavaScript()
  }

  func buildSwift() throws -> String {
    try build().buildSwift()
  }
}
