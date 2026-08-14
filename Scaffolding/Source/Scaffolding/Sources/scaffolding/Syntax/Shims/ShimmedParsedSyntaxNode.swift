import Saying

protocol ShimmedParsedSyntaxNode {
  var type: ParsedSyntaxNodeType { get }
  var children: [ParsedSyntaxNodeType] { get }
}

extension ShimmedParsedSyntaxNode {

  var nodeKind: ParsedSyntaxNodeKind {
    return .implemented(type)
  }

  var childNodes: [ParsedSyntaxNode] {
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

extension ParsedDownArrowSyntax: ShimmedParsedSyntaxNode {}
extension ParsedLeftArrowSyntax: ShimmedParsedSyntaxNode {}
extension ParsedRightArrowSyntax: ShimmedParsedSyntaxNode {}
extension ParsedClosingBraceSyntax: ShimmedParsedSyntaxNode {}
extension ParsedOpeningBraceSyntax: ShimmedParsedSyntaxNode {}
extension ParsedClosingBracketSyntax: ShimmedParsedSyntaxNode {}
extension ParsedOpeningBracketSyntax: ShimmedParsedSyntaxNode {}
extension ParsedClosingParenthesisSyntax: ShimmedParsedSyntaxNode {}
extension ParsedOpeningParenthesisSyntax: ShimmedParsedSyntaxNode {}
extension ParsedLineBreakSyntax: ShimmedParsedSyntaxNode {}
extension ParsedParagraphBreakSyntax: ShimmedParsedSyntaxNode {}
extension ParsedBulletCharacterSyntax: ShimmedParsedSyntaxNode {}
extension ParsedOpeningQuestionMarkSyntax: ShimmedParsedSyntaxNode {}
extension ParsedClosingQuestionMarkSyntax: ShimmedParsedSyntaxNode {}
extension ParsedRightToLeftQuestionMarkSyntax: ShimmedParsedSyntaxNode {}
extension ParsedGreekQuestionMarkSyntax: ShimmedParsedSyntaxNode {}
extension ParsedOpeningExclamationMarkSyntax: ShimmedParsedSyntaxNode {}
extension ParsedClosingExclamationMarkSyntax: ShimmedParsedSyntaxNode {}
extension ParsedColonCharacterSyntax: ShimmedParsedSyntaxNode {}
extension ParsedLeftChevronQuotationMarkSyntax: ShimmedParsedSyntaxNode {}
extension ParsedLowQuotationMarkSyntax: ShimmedParsedSyntaxNode {}
extension ParsedNinesQuotationMarkSyntax: ShimmedParsedSyntaxNode {}
extension ParsedRightChevronQuotationMarkSyntax: ShimmedParsedSyntaxNode {}
extension ParsedSixesQuotationMarkSyntax: ShimmedParsedSyntaxNode {}
extension ParsedSlashSyntax: ShimmedParsedSyntaxNode {}
extension ParsedSpaceSyntax: ShimmedParsedSyntaxNode {}
extension ParsedSymbolInsertionMarkSyntax: ShimmedParsedSyntaxNode {}
