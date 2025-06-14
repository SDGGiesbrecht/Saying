import Foundation

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
    entryPoints: inout Set<UnicodeText>?,
    moduleWideImports: [ModuleIntermediate]
  ) throws -> ModuleIntermediate {
    let sourceFiles = try self.sourceFiles()
    var module = ModuleIntermediate()
    for sourceFile in sourceFiles {
      try module.add(file: SayingSource(from: sourceFile).parse())
    }
    if isSayingSyntaxModule {
      try module.unfoldSyntax()
    }
    try module.resolveExtensions()
    try module.resolveUses(externalLookup: moduleWideImports.map({ $0.referenceDictionary }))
    module.resolveTypeIdentifiers(externalReferenceLookup: moduleWideImports.map({ $0.referenceDictionary }))
    module.resolveTypes(moduleWideImports: moduleWideImports)
    module.resolveSpecializedAccess(moduleWideImports: moduleWideImports)
    try module.validateReferences(moduleWideImports: moduleWideImports)
    switch mode {
    case .testing:
      return module.applyingTestCoverageTracking(externalReferenceLookup: moduleWideImports.map({ $0.referenceDictionary }))
    case .debugging, .dependency:
      return module
    case .release:
      guard var entries = entryPoints else {
        fatalError("General reachability checks without specifying entry points are not implemented yet.")
      }
      let result = module.removingUnreachable(
        fromEntryPoints: &entries,
        externalReferenceLookup: moduleWideImports.map({ $0.referenceDictionary })
      )
      entryPoints = entries
      return result
    }
  }
}
