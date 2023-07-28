import SDGCollections
import SDGText

extension InterfaceSyntax {

  struct ThingDeclaration: ParsedSyntaxNode {
    let keyword: ParsedToken
    let unparsedTokens: [ParsedToken]
    let location: Slice<UTF8Segments>
  }
}

extension InterfaceSyntax.ThingDeclaration: InterfaceSyntaxDeclarationProtocol {

  static let keyword: [Localization: StrictString] = [
    .english: "thing"
  ]
  static let keywords = Set(keyword.values)
}
