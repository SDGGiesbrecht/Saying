import SDGText

protocol SyntaxNode {
  var nodeKind: SyntaxNodeKind { get }
  var children: [SyntaxNode] { get }
  func source() -> UnicodeText

  func parsedNode() -> ParsedSyntaxNode
}

extension SyntaxNode {

  func source() -> UnicodeText {
    return UnicodeText(children.lazy.map({ StrictString($0.source()) }).joined())
  }

  func formattedGitStyleSource() -> UnicodeText {
    return formattedGitStyleSource(indent: 0)
  }
  private func formattedGitStyleSource(indent: Int) -> UnicodeText {
    switch nodeKind {
    case .paragraphBreakSyntax:
      return UnicodeText("\n\n" + StrictString(repeating: " ", count: indent))
    case .lineBreakSyntax:
      return UnicodeText("\n" + StrictString(repeating: " ", count: indent))
    case .abilityDeclaration, .actionDeclaration, .caseDeclaration, .choiceDeclaration, .enumerationDeclaration, .extensionSyntax, .languageDeclaration, .parameterDocumentation, .partDeclaration, .requirementDeclaration, .thingDeclaration, .use:
      return UnicodeText(children.lazy.map({ StrictString($0.formattedGitStyleSource(indent: indent + 1)) }).joined())
    case .abilityName, .bracedStatementList, .caseName, .cases, .documentation, .fulfillments, .multipleActionNames, .parameterDetails, .paragraph, .partName, .provisions, .requirements, .sourceThingImplementation, .thingName:
      return UnicodeText(
        [
          children.dropLast(2).map({ StrictString($0.formattedGitStyleSource(indent: indent + 1)) }).joined(),
          children.suffix(2).map({ StrictString($0.formattedGitStyleSource(indent: indent)) }).joined(),
        ].joined()
      )
    default:
      if self is SyntaxLeaf {
        return source()
      } else {
        return UnicodeText(
          children.lazy.map({ StrictString($0.formattedGitStyleSource(indent: indent)) }).joined()
        )
      }
    }
  }
}
