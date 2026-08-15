import Saying

protocol SyntaxNode {
  var nodeKind: SyntaxNodeKind { get }
  var childNodes: [SyntaxNode] { get }
  func source() -> UnicodeText

  func parsedNode() -> ParsedSyntaxNode
}

extension SyntaxNode {

  func source() -> UnicodeText {
    return childNodes.map({ $0.source() }).joined()
  }

  func formattedGitStyleSource() -> UnicodeText {
    return formattedGitStyleSource(indent: 0)
  }
  private func formattedGitStyleSource(indent: Int) -> UnicodeText {
    var stack: [SyntaxNode] = [self]
    var accumulator: String = ""
    while !stack.isEmpty {
      let node = stack.removeLast()
      switch node.nodeKind {
      case .implemented(.paragraphBreakSyntax):
        accumulator.append(contentsOf: "\n\n")
        accumulator.append(contentsOf: String(repeating: " ", count: indent))
      case .implemented(.lineBreakSyntax):
        accumulator.append("\n")
        accumulator.append(contentsOf: String(repeating: " ", count: indent))
      case .abilityDeclaration, .actionDeclaration, .caseDeclaration, .choiceDeclaration, .enumerationDeclaration, .extensionSyntax, .languageDeclaration, .nativeImport, .nativeIndirectRequirements, .nativeRequiredCode, .parameterDocumentation, .partDeclaration, .requirementAbilityDeclaration, .requirementDeclaration, .thingDeclaration, .use:
        accumulator.append(
          contentsOf: node.childNodes
            .lazy.map({ String($0.formattedGitStyleSource(indent: indent + 1)) })
            .joined()
        )
      case .spacedImportList, .spacedNativeRequirementList:
        accumulator.append(
          contentsOf: node.childNodes.dropLast(1)
            .map({ String($0.formattedGitStyleSource(indent: indent + 1)) })
            .joined()
        )
        stack.append(contentsOf: node.childNodes.suffix(1).reversed())
      case .abilityName, .caseName, .cases, .documentation, .fulfillments, .multipleActionNames, .nonEmptyBracedStatementList, .parameterDetails, .paragraph, .partName, .provisions, .requirements, .sourceThingImplementation, .thingName:
        accumulator.append(
          contentsOf: node.childNodes.dropLast(2)
            .map({ String($0.formattedGitStyleSource(indent: indent + 1)) })
            .joined()
        )
        stack.append(contentsOf: node.childNodes.suffix(2).reversed())
      default:
        if node is SyntaxLeaf {
          accumulator.append(contentsOf: String(node.source()))
        } else {
          stack.append(contentsOf: node.childNodes.reversed())
        }
      }
    }
    return UnicodeText(accumulator)
  }
}
