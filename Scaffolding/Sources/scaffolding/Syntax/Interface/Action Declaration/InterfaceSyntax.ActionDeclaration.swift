import SDGCollections
import SDGText

extension InterfaceSyntax {

  struct ActionDeclaration: ParsedSyntaxNode {

    let keyword: ParsedToken
    let unparsedTokens: [ParsedToken]
    let location: Slice<UTF8Segments>
  }
}

extension InterfaceSyntax.ActionDeclaration: InterfaceSyntaxDeclarationProtocol {

  static let keyword: [Localization: StrictString] = [
    .english: "action"
  ]
  static let keywords = Set(keyword.values)
}
