import Saying

protocol ShimmedParsedSyntaxNode {
  var type: ParsedSyntaxNodeType { get }
}

extension ShimmedParsedSyntaxNode {
  var nodeKind: ParsedSyntaxNodeKind {
    return .implemented(type)
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
