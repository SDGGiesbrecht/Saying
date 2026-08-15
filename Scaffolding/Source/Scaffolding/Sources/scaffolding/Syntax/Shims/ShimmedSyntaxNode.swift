import Saying

protocol ShimmedSyntaxNode {
  var type: SyntaxNodeType { get }
  var children: [SyntaxNodeType] { get }
}

extension ShimmedSyntaxNode {

  var nodeKind: SyntaxNodeKind {
    return .implemented(type)
  }

  var childNodes: [SyntaxNode] {
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

extension DownArrowSyntax: ShimmedSyntaxNode {}
extension LeftArrowSyntax: ShimmedSyntaxNode {}
extension RightArrowSyntax: ShimmedSyntaxNode {}
extension ClosingBraceSyntax: ShimmedSyntaxNode {}
extension OpeningBraceSyntax: ShimmedSyntaxNode {}
extension ClosingBracketSyntax: ShimmedSyntaxNode {}
extension OpeningBracketSyntax: ShimmedSyntaxNode {}
extension ClosingParenthesisSyntax: ShimmedSyntaxNode {}
extension OpeningParenthesisSyntax: ShimmedSyntaxNode {}
extension LineBreakSyntax: ShimmedSyntaxNode {}
extension ParagraphBreakSyntax: ShimmedSyntaxNode {}
extension BulletCharacterSyntax: ShimmedSyntaxNode {}
extension OpeningQuestionMarkSyntax: ShimmedSyntaxNode {}
extension ClosingQuestionMarkSyntax: ShimmedSyntaxNode {}
extension RightToLeftQuestionMarkSyntax: ShimmedSyntaxNode {}
extension GreekQuestionMarkSyntax: ShimmedSyntaxNode {}
extension OpeningExclamationMarkSyntax: ShimmedSyntaxNode {}
extension ClosingExclamationMarkSyntax: ShimmedSyntaxNode {}
extension ColonCharacterSyntax: ShimmedSyntaxNode {}
extension LeftChevronQuotationMarkSyntax: ShimmedSyntaxNode {}
extension LowQuotationMarkSyntax: ShimmedSyntaxNode {}
extension NinesQuotationMarkSyntax: ShimmedSyntaxNode {}
extension RightChevronQuotationMarkSyntax: ShimmedSyntaxNode {}
extension SixesQuotationMarkSyntax: ShimmedSyntaxNode {}
extension SlashSyntax: ShimmedSyntaxNode {}
extension SpaceSyntax: ShimmedSyntaxNode {}
extension SymbolInsertionMarkSyntax: ShimmedSyntaxNode {}
