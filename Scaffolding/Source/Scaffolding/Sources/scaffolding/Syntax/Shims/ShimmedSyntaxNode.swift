import Saying

protocol ShimmedSyntaxNode {
  var type: SyntaxNodeType { get }
}

extension ShimmedSyntaxNode {
  var nodeKind: SyntaxNodeKind {
    return .implemented(type)
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
