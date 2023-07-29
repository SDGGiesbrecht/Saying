import SDGCollections
import SDGText

extension InterfaceSyntax {

  struct ThingDeclaration: ParsedSyntaxNode {
    let keyword: ParsedToken
    let lineBreakAfterKeyword: ParsedToken
    let deferredLines: ParsedSeparatedList<ParsedSeparatedNestingNode<Deferred, ParsedToken>, ParsedToken>
    let location: Slice<UTF8Segments>
  }
}

extension InterfaceSyntax.ThingDeclaration: InterfaceSyntaxDeclarationProtocol {

  static let keyword: [Localization: StrictString] = [
    .english: "thing"
  ]
  static let keywords = Set(keyword.values)
}
