public indirect enum SyntaxNode {
  case paragraphBreakSyntax(ParagraphBreakSyntax)
  case bulletCharacterSyntax(BulletCharacterSyntax)
  case closingBraceSyntax(ClosingBraceSyntax)
  case closingBracketSyntax(ClosingBracketSyntax)
  case closingParenthesisSyntax(ClosingParenthesisSyntax)
  case closingQuestionMarkSyntax(ClosingQuestionMarkSyntax)
  case colonCharacterSyntax(ColonCharacterSyntax)
  case downArrowSyntax(DownArrowSyntax)
  case greekQuestionMarkSyntax(GreekQuestionMarkSyntax)
  case leftArrowSyntax(LeftArrowSyntax)
  case lineBreakSyntax(LineBreakSyntax)
  case leftChevronQuotationMarkSyntax(LeftChevronQuotationMarkSyntax)
  case lowQuotationMarkSyntax(LowQuotationMarkSyntax)
  case ninesQuotationMarkSyntax(NinesQuotationMarkSyntax)
  case openingExclamationMarkSyntax(OpeningExclamationMarkSyntax)
  case openingQuestionMarkSyntax(OpeningQuestionMarkSyntax)
  case openingParenthesisSyntax(OpeningParenthesisSyntax)
  case openingBraceSyntax(OpeningBraceSyntax)
  case openingBracketSyntax(OpeningBracketSyntax)
  case rightChevronQuotationMarkSyntax(RightChevronQuotationMarkSyntax)
  case rightArrowSyntax(RightArrowSyntax)
  case rightToLeftQuestionMarkSyntax(RightToLeftQuestionMarkSyntax)
  case closingExclamationMarkSyntax(ClosingExclamationMarkSyntax)
  case sixesQuotationMarkSyntax(SixesQuotationMarkSyntax)
  case slashSyntax(SlashSyntax)
  case spaceSyntax(SpaceSyntax)
  case symbolInsertionMarkSyntax(SymbolInsertionMarkSyntax)

  public init(_ node: ParagraphBreakSyntax) {
    self = SyntaxNode.paragraphBreakSyntax(node)
  }

  public init(_ node: GreekQuestionMarkSyntax) {
    self = SyntaxNode.greekQuestionMarkSyntax(node)
  }

  public init(_ node: LeftArrowSyntax) {
    self = SyntaxNode.leftArrowSyntax(node)
  }

  public init(_ node: LeftChevronQuotationMarkSyntax) {
    self = SyntaxNode.leftChevronQuotationMarkSyntax(node)
  }

  public init(_ node: OpeningExclamationMarkSyntax) {
    self = SyntaxNode.openingExclamationMarkSyntax(node)
  }

  public init(_ node: OpeningBracketSyntax) {
    self = SyntaxNode.openingBracketSyntax(node)
  }

  public init(_ node: OpeningQuestionMarkSyntax) {
    self = SyntaxNode.openingQuestionMarkSyntax(node)
  }

  public init(_ node: OpeningParenthesisSyntax) {
    self = SyntaxNode.openingParenthesisSyntax(node)
  }

  public init(_ node: RightChevronQuotationMarkSyntax) {
    self = SyntaxNode.rightChevronQuotationMarkSyntax(node)
  }

  public init(_ node: RightArrowSyntax) {
    self = SyntaxNode.rightArrowSyntax(node)
  }

  public init(_ node: ClosingExclamationMarkSyntax) {
    self = SyntaxNode.closingExclamationMarkSyntax(node)
  }

  public init(_ node: ClosingQuestionMarkSyntax) {
    self = SyntaxNode.closingQuestionMarkSyntax(node)
  }

  public init(_ node: ClosingParenthesisSyntax) {
    self = SyntaxNode.closingParenthesisSyntax(node)
  }

  public init(_ node: BulletCharacterSyntax) {
    self = SyntaxNode.bulletCharacterSyntax(node)
  }

  public init(_ node: ClosingBraceSyntax) {
    self = SyntaxNode.closingBraceSyntax(node)
  }

  public init(_ node: ClosingBracketSyntax) {
    self = SyntaxNode.closingBracketSyntax(node)
  }

  public init(_ node: ColonCharacterSyntax) {
    self = SyntaxNode.colonCharacterSyntax(node)
  }

  public init(_ node: DownArrowSyntax) {
    self = SyntaxNode.downArrowSyntax(node)
  }

  public init(_ node: LineBreakSyntax) {
    self = SyntaxNode.lineBreakSyntax(node)
  }

  public init(_ node: LowQuotationMarkSyntax) {
    self = SyntaxNode.lowQuotationMarkSyntax(node)
  }

  public init(_ node: OpeningBraceSyntax) {
    self = SyntaxNode.openingBraceSyntax(node)
  }

  public init(_ node: RightToLeftQuestionMarkSyntax) {
    self = SyntaxNode.rightToLeftQuestionMarkSyntax(node)
  }

  public init(_ node: SlashSyntax) {
    self = SyntaxNode.slashSyntax(node)
  }

  public init(_ node: SpaceSyntax) {
    self = SyntaxNode.spaceSyntax(node)
  }

  public init(_ node: SymbolInsertionMarkSyntax) {
    self = SyntaxNode.symbolInsertionMarkSyntax(node)
  }

  public init(_ node: NinesQuotationMarkSyntax) {
    self = SyntaxNode.ninesQuotationMarkSyntax(node)
  }

  public init(_ node: SixesQuotationMarkSyntax) {
    self = SyntaxNode.sixesQuotationMarkSyntax(node)
  }
}
