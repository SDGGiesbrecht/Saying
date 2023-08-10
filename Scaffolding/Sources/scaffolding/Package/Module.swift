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
    #error("Debugging...")
    let node = ThingDeclaration(
      keyword: ThingKeyword(text: "thing"),
      name: ThingName(
        names: ThingNameList(
          first: ThingNameEntry(
            language: UninterruptedIdentifier(
              first: IdentifierComponent(text: "English"),
              continuations: []
            ),
            colon: SpacedColon(),
            name: UninterruptedIdentifier(
              first: IdentifierComponent(text: "truth"),
              continuations: []
            )
          ),
          continuations: []
        )
      ),
      implementation: ThingImplementation(
        language: UninterruptedIdentifier(
          first: IdentifierComponent(text: "Swift"),
          continuations: []
        ),
        colon: SpacedColon(),
        type: UninterruptedIdentifier(
          first: IdentifierComponent(text: "Bool"),
          continuations: []
        )
      )
    )
    let source: StrictString = node.source()
    assert((try? ParsedThingDeclaration.diagnosticParse(source: source).get())?.source() == source)
    assert(ParsedThingDeclaration.fastParse(source: source)?.source() == source)

    let sourceFiles = try self.sourceFiles()
    for sourceFile in sourceFiles {
      let loaded = try File(from: sourceFile)
      switch loaded.contents {
      case .utf8(let source):
        let fileInterface = try InterfaceSyntax.File.parse(source: source).get()
        for declaration in fileInterface.declarations.combinedEntries {
          switch declaration {
          case .thing(let thing):
            let names = thing.name.names.combinedEntries
              .map({ $0.definition.identifierText() })
              .joined(separator: ", ")
            let source = thing.deferredLines.content.combinedEntries
              .map({ $0.source() })
              .joined(separator: "\n  ")
            print("thing (\(thing.location.underlyingScalarOffsetOfStart())): \(names)\n \(source)")
          case .action(let action):
            let source = action.deferredLines.content.combinedEntries
              .map({ $0.source() })
              .joined(separator: "\n ")
            print("action (\(action.location.underlyingScalarOffsetOfStart())):\n \(source)")
          }
        }
      }
    }
  }
}
