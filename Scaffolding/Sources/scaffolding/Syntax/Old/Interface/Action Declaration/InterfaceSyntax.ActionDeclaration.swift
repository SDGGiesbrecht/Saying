import SDGCollections
import SDGText

extension InterfaceSyntax {

  struct ActionDeclaration {
    let keyword: OldParsedToken
    let documentation: Line<InterfaceSyntax.Documentation>?
    let deferredLines: Line<
      ParsedSeparatedList<ParsedSeparatedNestingNode<Deferred, OldParsedToken>, OldParsedToken>
    >
  }
}

extension InterfaceSyntax.ActionDeclaration: ParsedSyntaxNode {
  var children: [ParsedSyntaxNode] {
    var result: [ParsedSyntaxNode] = [keyword]
    if let documentation = documentation {
      result.append(documentation)
    }
    result.append(deferredLines)
    return result
  }
}

extension InterfaceSyntax.ActionDeclaration: DerivedLocation {
  var lastChild: ParsedSyntaxNode {
    return deferredLines
  }
}

extension InterfaceSyntax.ActionDeclaration: InterfaceSyntaxDeclarationProtocol {

  static let keyword: [Localization: StrictString] = [
    .english: "action"
  ]
  static let keywords = Set(keyword.values)

  static func parseUniqueComponents(
    keyword: OldParsedToken,
    documentation: Line<InterfaceSyntax.Documentation>?,
    deferredLines: Line<ParsedSeparatedList<ParsedSeparatedNestingNode<Deferred, OldParsedToken>, OldParsedToken>>
  ) -> Result<InterfaceSyntax.ActionDeclaration, ParseError> {
    return .success(
      InterfaceSyntax.ActionDeclaration(
        keyword: keyword,
        documentation: documentation,
        deferredLines: deferredLines
      )
    )
  }
}