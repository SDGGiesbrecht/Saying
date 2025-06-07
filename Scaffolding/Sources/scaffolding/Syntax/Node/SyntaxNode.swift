protocol SyntaxNode {
  var nodeKind: SyntaxNodeKind { get }
  var children: [SyntaxNode] { get }
  func source() -> UnicodeText

  func parsedNode() -> ParsedSyntaxNode
}

extension SyntaxNode {

  func source() -> UnicodeText {
    return UnicodeText(children.lazy.map({ $0.source() }).joined())
  }

  func formattedGitStyleSource() -> UnicodeText {
    return formattedGitStyleSource(indent: 0)
  }
  private func formattedGitStyleSource(indent: Int) -> UnicodeText {
    switch nodeKind {
    case .paragraphBreakSyntax:
      return UnicodeText("\n\n" + String(repeating: " ", count: indent))
    case .lineBreakSyntax:
      return UnicodeText("\n" + String(repeating: " ", count: indent))
    case .abilityDeclaration, .actionDeclaration, .caseDeclaration, .choiceDeclaration, .enumerationDeclaration, .extensionSyntax, .languageDeclaration, .nativeImport, .nativeIndirectRequirements, .nativeRequiredCode, .parameterDocumentation, .partDeclaration, .requirementDeclaration, .thingDeclaration, .use:
      return UnicodeText(children.lazy.map({ $0.formattedGitStyleSource(indent: indent + 1) }).joined())
    case .spacedNativeRequirementList:
      return UnicodeText(
        [
          children.dropLast(1).map({ $0.formattedGitStyleSource(indent: indent + 1) }).joined(),
          children.suffix(1).map({ $0.formattedGitStyleSource(indent: indent) }).joined(),
        ].joined()
      )
    case .abilityName, .caseName, .cases, .documentation, .fulfillments, .multipleActionNames, .nonEmptyBracedStatementList, .parameterDetails, .paragraph, .partName, .provisions, .requirements, .sourceThingImplementation, .thingName:
      return UnicodeText(
        [
          children.dropLast(2).map({ $0.formattedGitStyleSource(indent: indent + 1) }).joined(),
          children.suffix(2).map({ $0.formattedGitStyleSource(indent: indent) }).joined(),
        ].joined()
      )
    default:
      if self is SyntaxLeaf {
        return source()
      } else {
        return UnicodeText(
          children.lazy.map({ $0.formattedGitStyleSource(indent: indent) }).joined()
        )
      }
    }
  }
}
