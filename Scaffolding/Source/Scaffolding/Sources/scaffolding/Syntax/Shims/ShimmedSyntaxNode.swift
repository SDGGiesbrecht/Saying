import Saying

protocol ShimmedSyntaxNode {
  var node: SyntaxNode { get }
  var children: [SyntaxNode] { get }
}

extension ShimmedSyntaxNode {

  var nodeKind: SyntaxNodeKind {
    return .implemented(node)
  }

  var childNodes: [SyntaxNodeProtocol] {
    return children.map { child in
      switch child {
      case .paragraphBreakSyntax(let node):
        return node
      case .bulletCharacterSyntax(let node):
        return node
      case .closingBraceSyntax(let node):
        return node
      case .closingBracketSyntax(let node):
        return node
      case .closingParenthesisSyntax(let node):
        return node
      case .closingQuestionMarkSyntax(let node):
        return node
      case .colonCharacterSyntax(let node):
        return node
      case .downArrowSyntax(let node):
        return node
      case .greekQuestionMarkSyntax(let node):
        return node
      case .leftArrowSyntax(let node):
        return node
      case .lineBreakSyntax(let node):
        return node
      case .leftChevronQuotationMarkSyntax(let node):
        return node
      case .lowQuotationMarkSyntax(let node):
        return node
      case .ninesQuotationMarkSyntax(let node):
        return node
      case .openingExclamationMarkSyntax(let node):
        return node
      case .openingQuestionMarkSyntax(let node):
        return node
      case .openingParenthesisSyntax(let node):
        return node
      case .openingBraceSyntax(let node):
        return node
      case .openingBracketSyntax(let node):
        return node
      case .rightChevronQuotationMarkSyntax(let node):
        return node
      case .rightArrowSyntax(let node):
        return node
      case .rightToLeftQuestionMarkSyntax(let node):
        return node
      case .closingExclamationMarkSyntax(let node):
        return node
      case .sixesQuotationMarkSyntax(let node):
        return node
      case .slashSyntax(let node):
        return node
      case .spaceSyntax(let node):
        return node
      case .symbolInsertionMarkSyntax(let node):
        return node
      }
    }
  }
}

extension DownArrowSyntax: ShimmedSyntaxNode {
  var node: SyntaxNode { SyntaxNode(self) }
}
extension LeftArrowSyntax: ShimmedSyntaxNode {
  var node: SyntaxNode { SyntaxNode(self) }
}
extension RightArrowSyntax: ShimmedSyntaxNode {
  var node: SyntaxNode { SyntaxNode(self) }
}
extension ClosingBraceSyntax: ShimmedSyntaxNode {
  var node: SyntaxNode { SyntaxNode(self) }
}
extension OpeningBraceSyntax: ShimmedSyntaxNode {
  var node: SyntaxNode { SyntaxNode(self) }
}
extension ClosingBracketSyntax: ShimmedSyntaxNode {
  var node: SyntaxNode { SyntaxNode(self) }
}
extension OpeningBracketSyntax: ShimmedSyntaxNode {
  var node: SyntaxNode { SyntaxNode(self) }
}
extension ClosingParenthesisSyntax: ShimmedSyntaxNode {
  var node: SyntaxNode { SyntaxNode(self) }
}
extension OpeningParenthesisSyntax: ShimmedSyntaxNode {
  var node: SyntaxNode { SyntaxNode(self) }
}
extension LineBreakSyntax: ShimmedSyntaxNode {
  var node: SyntaxNode { SyntaxNode(self) }
}
extension ParagraphBreakSyntax: ShimmedSyntaxNode {
  var node: SyntaxNode { SyntaxNode(self) }
}
extension BulletCharacterSyntax: ShimmedSyntaxNode {
  var node: SyntaxNode { SyntaxNode(self) }
}
extension OpeningQuestionMarkSyntax: ShimmedSyntaxNode {
  var node: SyntaxNode { SyntaxNode(self) }
}
extension ClosingQuestionMarkSyntax: ShimmedSyntaxNode {
  var node: SyntaxNode { SyntaxNode(self) }
}
extension RightToLeftQuestionMarkSyntax: ShimmedSyntaxNode {
  var node: SyntaxNode { SyntaxNode(self) }
}
extension GreekQuestionMarkSyntax: ShimmedSyntaxNode {
  var node: SyntaxNode { SyntaxNode(self) }
}
extension OpeningExclamationMarkSyntax: ShimmedSyntaxNode {
  var node: SyntaxNode { SyntaxNode(self) }
}
extension ClosingExclamationMarkSyntax: ShimmedSyntaxNode {
  var node: SyntaxNode { SyntaxNode(self) }
}
extension ColonCharacterSyntax: ShimmedSyntaxNode {
  var node: SyntaxNode { SyntaxNode(self) }
}
extension LeftChevronQuotationMarkSyntax: ShimmedSyntaxNode {
  var node: SyntaxNode { SyntaxNode(self) }
}
extension LowQuotationMarkSyntax: ShimmedSyntaxNode {
  var node: SyntaxNode { SyntaxNode(self) }
}
extension NinesQuotationMarkSyntax: ShimmedSyntaxNode {
  var node: SyntaxNode { SyntaxNode(self) }
}
extension RightChevronQuotationMarkSyntax: ShimmedSyntaxNode {
  var node: SyntaxNode { SyntaxNode(self) }
}
extension SixesQuotationMarkSyntax: ShimmedSyntaxNode {
  var node: SyntaxNode { SyntaxNode(self) }
}
extension SlashSyntax: ShimmedSyntaxNode {
  var node: SyntaxNode { SyntaxNode(self) }
}
extension SpaceSyntax: ShimmedSyntaxNode {
  var node: SyntaxNode { SyntaxNode(self) }
}
extension SymbolInsertionMarkSyntax: ShimmedSyntaxNode {
  var node: SyntaxNode { SyntaxNode(self) }
}
