import SDGText

protocol SyntaxNode {
  var nodeKind: SyntaxNodeKind { get }
  var children: [SyntaxNode] { get }
  func source() -> StrictString

  func parsedNode() -> ParsedSyntaxNode
}

extension SyntaxNode {

  func source() -> StrictString {
    return children.lazy.map({ $0.source() }).joined()
  }

  func formattedGitStyleSource() -> StrictString {
    return formattedGitStyleSource(indent: 0)
  }
  private func formattedGitStyleSource(indent: Int) -> StrictString {
    switch nodeKind {
    case .paragraphBreakSyntax:
      return "\n\n" + StrictString(repeating: " ", count: indent)
    case .lineBreakSyntax:
      return "\n" + StrictString(repeating: " ", count: indent)
    case .abilityDeclaration, .actionDeclaration, .caseDeclaration, .choiceDeclaration, .enumerationDeclaration, .extensionSyntax, .languageDeclaration, .parameterDocumentation, .requirementDeclaration, .thingDeclaration, .use:
      return children.lazy.map({ $0.formattedGitStyleSource(indent: indent + 1) }).joined()
    case .abilityName, .caseName, .cases, .documentation, .flowArgument, .fulfillments, .longTestImplementation, .multipleActionNames, .parameterDetails, .paragraph, .provisions, .requirements, .sourceActionImplementation, .thingName:
      return [
        children.dropLast(2).map({ $0.formattedGitStyleSource(indent: indent + 1) }).joined(),
        children.suffix(2).map({ $0.formattedGitStyleSource(indent: indent) }).joined(),
      ].joined()
    default:
      if self is SyntaxLeaf {
        return source()
      } else {
        return children.lazy.map({ $0.formattedGitStyleSource(indent: indent) }).joined()
      }
    }
  }
}
