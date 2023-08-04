import SDGCollections
import SDGText

extension InterfaceSyntax {

  struct ThingDeclaration: ParsedSyntaxNode {
    let keyword: ParsedToken
    let documentation: Line<InterfaceSyntax.Documentation>?
    let deferredLines: Line<
      ParsedSeparatedList<ParsedSeparatedNestingNode<Deferred, ParsedToken>, ParsedToken>
    >
  }
}

extension InterfaceSyntax.ThingDeclaration: DerivedLocation {
  var lastChild: ParsedSyntaxNode {
    return deferredLines
  }
}

extension InterfaceSyntax.ThingDeclaration: InterfaceSyntaxDeclarationProtocol {

  static let keyword: [Localization: StrictString] = [
    .english: "thing"
  ]
  static let keywords = Set(keyword.values)

  static func parseUniqueComponents(
    keyword: ParsedToken,
    documentation: Line<InterfaceSyntax.Documentation>?,
    deferredLines: Line<ParsedSeparatedList<ParsedSeparatedNestingNode<Deferred, ParsedToken>, ParsedToken>>
  ) -> Result<InterfaceSyntax.ThingDeclaration, ParseError> {
    return .success(
      InterfaceSyntax.ThingDeclaration(
        keyword: keyword,
        documentation: documentation,
        deferredLines: deferredLines
      )
    )
  }
}
