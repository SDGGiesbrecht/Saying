import Foundation

import SDGText
import SDGPersistence

struct Module {

  var directory: URL

  var isSayingModule: Bool {
    return directory.lastPathComponent == "Saying"
  }
  var isSayingSyntaxModule: Bool {
    return directory.lastPathComponent == "Saying Syntax"
  }

  func sourceFiles() throws -> [URL] {
    return try FileManager.default.deepFileEnumeration(in: directory)
      .lazy.filter({ !Package.ignoredFiles.contains($0.lastPathComponent) })
      .lazy.filter({ $0.isSaying })
      .sorted(by: { $0.path < $1.path })
  }

  func build(
    mode: CompilationMode,
    entryPoints: Set<StrictString>?,
    moduleWideImports: [ModuleIntermediate]
  ) throws -> ModuleIntermediate {
    let sourceFiles = try self.sourceFiles()
    var module = ModuleIntermediate()
    for sourceFile in sourceFiles {
      try module.add(file: File(from: sourceFile).parse())
    }
    if isSayingSyntaxModule {
      try module.unfoldSyntax()
    }
    try module.resolveExtensions()
    try module.resolveUses()
    module.resolveTypeIdentifiers()
    module.resolveTypes()
    try module.validateReferences(moduleWideImports: moduleWideImports)
    switch mode {
    case .testing:
      return module.applyingTestCoverageTracking()
    case .debugging, .dependency:
      return module
    case .release:
      return module.removingUnreachable(fromEntryPoints: entryPoints)
    }
  }
}
