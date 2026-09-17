public indirect enum ParsedSyntaxNode {
  case paragraphBreakSyntax(ParsedParagraphBreakSyntax)
  case bulletCharacterSyntax(ParsedBulletCharacterSyntax)
  case closingBraceSyntax(ParsedClosingBraceSyntax)
  case closingBracketSyntax(ParsedClosingBracketSyntax)
  case closingParenthesisSyntax(ParsedClosingParenthesisSyntax)
  case closingQuestionMarkSyntax(ParsedClosingQuestionMarkSyntax)
  case colonCharacterSyntax(ParsedColonCharacterSyntax)
  case downArrowSyntax(ParsedDownArrowSyntax)
  case greekQuestionMarkSyntax(ParsedGreekQuestionMarkSyntax)
  case leftArrowSyntax(ParsedLeftArrowSyntax)
  case lineBreakSyntax(ParsedLineBreakSyntax)
  case leftChevronQuotationMarkSyntax(ParsedLeftChevronQuotationMarkSyntax)
  case lowQuotationMarkSyntax(ParsedLowQuotationMarkSyntax)
  case ninesQuotationMarkSyntax(ParsedNinesQuotationMarkSyntax)
  case openingExclamationMarkSyntax(ParsedOpeningExclamationMarkSyntax)
  case openingQuestionMarkSyntax(ParsedOpeningQuestionMarkSyntax)
  case openingParenthesisSyntax(ParsedOpeningParenthesisSyntax)
  case openingBraceSyntax(ParsedOpeningBraceSyntax)
  case openingBracketSyntax(ParsedOpeningBracketSyntax)
  case rightChevronQuotationMarkSyntax(ParsedRightChevronQuotationMarkSyntax)
  case rightArrowSyntax(ParsedRightArrowSyntax)
  case rightToLeftQuestionMarkSyntax(ParsedRightToLeftQuestionMarkSyntax)
  case closingExclamationMarkSyntax(ParsedClosingExclamationMarkSyntax)
  case sixesQuotationMarkSyntax(ParsedSixesQuotationMarkSyntax)
  case slashSyntax(ParsedSlashSyntax)
  case spaceSyntax(ParsedSpaceSyntax)
  case symbolInsertionMarkSyntax(ParsedSymbolInsertionMarkSyntax)

  public init(_ node: ParsedGreekQuestionMarkSyntax) {
    self = ParsedSyntaxNode.greekQuestionMarkSyntax(node)
  }

  public init(_ node: ParsedBulletCharacterSyntax) {
    self = ParsedSyntaxNode.bulletCharacterSyntax(node)
  }

  public init(_ node: ParsedClosingBraceSyntax) {
    self = ParsedSyntaxNode.closingBraceSyntax(node)
  }

  public init(_ node: ParsedClosingBracketSyntax) {
    self = ParsedSyntaxNode.closingBracketSyntax(node)
  }

  public init(_ node: ParsedClosingParenthesisSyntax) {
    self = ParsedSyntaxNode.closingParenthesisSyntax(node)
  }

  public init(_ node: ParsedClosingQuestionMarkSyntax) {
    self = ParsedSyntaxNode.closingQuestionMarkSyntax(node)
  }

  public init(_ node: ParsedColonCharacterSyntax) {
    self = ParsedSyntaxNode.colonCharacterSyntax(node)
  }

  public init(_ node: ParsedDownArrowSyntax) {
    self = ParsedSyntaxNode.downArrowSyntax(node)
  }

  public init(_ node: ParsedLeftArrowSyntax) {
    self = ParsedSyntaxNode.leftArrowSyntax(node)
  }

  public init(_ node: ParsedLineBreakSyntax) {
    self = ParsedSyntaxNode.lineBreakSyntax(node)
  }

  public init(_ node: ParsedLowQuotationMarkSyntax) {
    self = ParsedSyntaxNode.lowQuotationMarkSyntax(node)
  }

  public init(_ node: ParsedNinesQuotationMarkSyntax) {
    self = ParsedSyntaxNode.ninesQuotationMarkSyntax(node)
  }

  public init(_ node: ParsedOpeningBraceSyntax) {
    self = ParsedSyntaxNode.openingBraceSyntax(node)
  }

  public init(_ node: ParsedOpeningBracketSyntax) {
    self = ParsedSyntaxNode.openingBracketSyntax(node)
  }

  public init(_ node: ParsedParagraphBreakSyntax) {
    self = ParsedSyntaxNode.paragraphBreakSyntax(node)
  }

  public init(_ node: ParsedRightArrowSyntax) {
    self = ParsedSyntaxNode.rightArrowSyntax(node)
  }

  public init(_ node: ParsedRightToLeftQuestionMarkSyntax) {
    self = ParsedSyntaxNode.rightToLeftQuestionMarkSyntax(node)
  }

  public init(_ node: ParsedSixesQuotationMarkSyntax) {
    self = ParsedSyntaxNode.sixesQuotationMarkSyntax(node)
  }

  public init(_ node: ParsedSlashSyntax) {
    self = ParsedSyntaxNode.slashSyntax(node)
  }

  public init(_ node: ParsedSpaceSyntax) {
    self = ParsedSyntaxNode.spaceSyntax(node)
  }

  public init(_ node: ParsedSymbolInsertionMarkSyntax) {
    self = ParsedSyntaxNode.symbolInsertionMarkSyntax(node)
  }

  public init(_ node: ParsedLeftChevronQuotationMarkSyntax) {
    self = ParsedSyntaxNode.leftChevronQuotationMarkSyntax(node)
  }

  public init(_ node: ParsedOpeningExclamationMarkSyntax) {
    self = ParsedSyntaxNode.openingExclamationMarkSyntax(node)
  }

  public init(_ node: ParsedOpeningQuestionMarkSyntax) {
    self = ParsedSyntaxNode.openingQuestionMarkSyntax(node)
  }

  public init(_ node: ParsedOpeningParenthesisSyntax) {
    self = ParsedSyntaxNode.openingParenthesisSyntax(node)
  }

  public init(_ node: ParsedRightChevronQuotationMarkSyntax) {
    self = ParsedSyntaxNode.rightChevronQuotationMarkSyntax(node)
  }

  public init(_ node: ParsedClosingExclamationMarkSyntax) {
    self = ParsedSyntaxNode.closingExclamationMarkSyntax(node)
  }
}
