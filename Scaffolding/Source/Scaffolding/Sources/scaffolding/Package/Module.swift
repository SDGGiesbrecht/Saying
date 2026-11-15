import Foundation

import Saying

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
    moduleWideImports: [ModuleIntermediate],
    testedUses: inout Set<HashableSourceLocation>,
    packageURL: URL
  ) throws -> ModuleIntermediate {
    let sourceFiles = try self.sourceFiles()
    var module = ModuleIntermediate()
    for sourceFile in sourceFiles {
      try module.add(
        file: SayingSource(from: sourceFile, packageURL: packageURL).parse(),
        includeDocumentation: mode.includedDocumentation
      )
    }
    if isSayingSyntaxModule {
      try module.unfoldSyntax(includeDocumentation: mode.includedDocumentation)
    }
    try module.resolveExtensions()
    try module.resolveUses(
      externalLookup: moduleWideImports.map({ $0.referenceDictionary }),
      testedUses: &testedUses
    )
    module.resolveTypeIdentifiers(externalReferenceLookup: moduleWideImports.map({ $0.referenceDictionary }))
    module.resolveSpecializedAccess(moduleWideImports: moduleWideImports)
    if mode.hasTestCoverage {
      module.collectTests()
    }
    module.resolveTypes(moduleWideImports: moduleWideImports)
    try module.validateReferences(moduleWideImports: moduleWideImports)
    module.resolveNestedReferenceCounting(externalReferenceLookup: moduleWideImports.map({ $0.referenceDictionary }))
    return module
  }
}
