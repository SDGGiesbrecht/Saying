import Saying

protocol ShimmedParsedSyntaxNode {
  var node: ParsedSyntaxNode { get }
  var children: [ParsedSyntaxNode] { get }
}

extension ShimmedParsedSyntaxNode {

  var nodeKind: ParsedSyntaxNodeKind {
    return .implemented(node)
  }

  var childNodes: [ParsedSyntaxNodeProtocol] {
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

extension ParsedDownArrowSyntax: ShimmedParsedSyntaxNode {
  var node: ParsedSyntaxNode { ParsedSyntaxNode(self) }
}
extension ParsedLeftArrowSyntax: ShimmedParsedSyntaxNode {
  var node: ParsedSyntaxNode { ParsedSyntaxNode(self) }
}
extension ParsedRightArrowSyntax: ShimmedParsedSyntaxNode {
  var node: ParsedSyntaxNode { ParsedSyntaxNode(self) }
}
extension ParsedClosingBraceSyntax: ShimmedParsedSyntaxNode {
  var node: ParsedSyntaxNode { ParsedSyntaxNode(self) }
}
extension ParsedOpeningBraceSyntax: ShimmedParsedSyntaxNode {
  var node: ParsedSyntaxNode { ParsedSyntaxNode(self) }
}
extension ParsedClosingBracketSyntax: ShimmedParsedSyntaxNode {
  var node: ParsedSyntaxNode { ParsedSyntaxNode(self) }
}
extension ParsedOpeningBracketSyntax: ShimmedParsedSyntaxNode {
  var node: ParsedSyntaxNode { ParsedSyntaxNode(self) }
}
extension ParsedClosingParenthesisSyntax: ShimmedParsedSyntaxNode {
  var node: ParsedSyntaxNode { ParsedSyntaxNode(self) }
}
extension ParsedOpeningParenthesisSyntax: ShimmedParsedSyntaxNode {
  var node: ParsedSyntaxNode { ParsedSyntaxNode(self) }
}
extension ParsedLineBreakSyntax: ShimmedParsedSyntaxNode {
  var node: ParsedSyntaxNode { ParsedSyntaxNode(self) }
}
extension ParsedParagraphBreakSyntax: ShimmedParsedSyntaxNode {
  var node: ParsedSyntaxNode { ParsedSyntaxNode(self) }
}
extension ParsedBulletCharacterSyntax: ShimmedParsedSyntaxNode {
  var node: ParsedSyntaxNode { ParsedSyntaxNode(self) }
}
extension ParsedOpeningQuestionMarkSyntax: ShimmedParsedSyntaxNode {
  var node: ParsedSyntaxNode { ParsedSyntaxNode(self) }
}
extension ParsedClosingQuestionMarkSyntax: ShimmedParsedSyntaxNode {
  var node: ParsedSyntaxNode { ParsedSyntaxNode(self) }
}
extension ParsedRightToLeftQuestionMarkSyntax: ShimmedParsedSyntaxNode {
  var node: ParsedSyntaxNode { ParsedSyntaxNode(self) }
}
extension ParsedGreekQuestionMarkSyntax: ShimmedParsedSyntaxNode {
  var node: ParsedSyntaxNode { ParsedSyntaxNode(self) }
}
extension ParsedOpeningExclamationMarkSyntax: ShimmedParsedSyntaxNode {
  var node: ParsedSyntaxNode { ParsedSyntaxNode(self) }
}
extension ParsedClosingExclamationMarkSyntax: ShimmedParsedSyntaxNode {
  var node: ParsedSyntaxNode { ParsedSyntaxNode(self) }
}
extension ParsedColonCharacterSyntax: ShimmedParsedSyntaxNode {
  var node: ParsedSyntaxNode { ParsedSyntaxNode(self) }
}
extension ParsedLeftChevronQuotationMarkSyntax: ShimmedParsedSyntaxNode {
  var node: ParsedSyntaxNode { ParsedSyntaxNode(self) }
}
extension ParsedLowQuotationMarkSyntax: ShimmedParsedSyntaxNode {
  var node: ParsedSyntaxNode { ParsedSyntaxNode(self) }
}
extension ParsedNinesQuotationMarkSyntax: ShimmedParsedSyntaxNode {
  var node: ParsedSyntaxNode { ParsedSyntaxNode(self) }
}
extension ParsedRightChevronQuotationMarkSyntax: ShimmedParsedSyntaxNode {
  var node: ParsedSyntaxNode { ParsedSyntaxNode(self) }
}
extension ParsedSixesQuotationMarkSyntax: ShimmedParsedSyntaxNode {
  var node: ParsedSyntaxNode { ParsedSyntaxNode(self) }
}
extension ParsedSlashSyntax: ShimmedParsedSyntaxNode {
  var node: ParsedSyntaxNode { ParsedSyntaxNode(self) }
}
extension ParsedSpaceSyntax: ShimmedParsedSyntaxNode {
  var node: ParsedSyntaxNode { ParsedSyntaxNode(self) }
}
extension ParsedSymbolInsertionMarkSyntax: ShimmedParsedSyntaxNode {
  var node: ParsedSyntaxNode { ParsedSyntaxNode(self) }
}
