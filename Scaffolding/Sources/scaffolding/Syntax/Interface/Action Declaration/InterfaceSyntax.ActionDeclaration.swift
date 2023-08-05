import SDGCollections
import SDGText

extension InterfaceSyntax {

  struct ActionDeclaration {
    let keyword: ParsedToken
    let documentation: Line<InterfaceSyntax.Documentation>?
    let deferredLines: Line<
      ParsedSeparatedList<ParsedSeparatedNestingNode<Deferred, ParsedToken>, ParsedToken>
    >
  }
}

extension InterfaceSyntax.ActionDeclaration: ManualParsedSyntaxNode {
  var children: [ManualParsedSyntaxNode] {
    var result: [ManualParsedSyntaxNode] = [keyword]
    if let documentation = documentation {
      result.append(documentation)
    }
    result.append(deferredLines)
    return result
  }
}

extension InterfaceSyntax.ActionDeclaration: DerivedLocation {
  var lastChild: ManualParsedSyntaxNode {
    return deferredLines
  }
}

extension InterfaceSyntax.ActionDeclaration: InterfaceSyntaxDeclarationProtocol {

  static let keyword: [Localization: StrictString] = [
    .english: "action"
  ]
  static let keywords = Set(keyword.values)

  static func parseUniqueComponents(
    keyword: ParsedToken,
    documentation: Line<InterfaceSyntax.Documentation>?,
    deferredLines: Line<ParsedSeparatedList<ParsedSeparatedNestingNode<Deferred, ParsedToken>, ParsedToken>>
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
