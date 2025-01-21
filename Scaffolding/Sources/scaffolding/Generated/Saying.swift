struct UnicodeText {
  fileprivate var scalars: String
}

struct ParagraphBreakSyntax {
}

struct BulletCharacterSyntax {
}

struct ClosingBraceSyntax {
}

struct ClosingBracketSyntax {
}

struct ClosingParenthesisSyntax {
}

struct ColonCharacterSyntax {
}

struct DownArrowSyntax {
}

struct LeftArrowSyntax {
}

struct LineBreakSyntax {
}

struct LeftChevronQuotationMarkSyntax {
}

struct LowQuotationMarkSyntax {
}

struct NinesQuotationMarkSyntax {
}

struct OpeningParenthesisSyntax {
}

struct OpeningBraceSyntax {
}

struct OpeningBracketSyntax {
}

struct RightChevronQuotationMarkSyntax {
}

struct RightArrowSyntax {
}

struct SixesQuotationMarkSyntax {
}

struct SlashSyntax {
}

struct SpaceSyntax {
}

struct SymbolInsertionMarkSyntax {
}

struct ReplacementParsedBulletCharacterSyntax {
}

struct ReplacementParsedClosingBraceSyntax {
}

struct ReplacementParsedClosingBracketSyntax {
}

struct ReplacementParsedClosingParenthesisSyntax {
}

struct ReplacementParsedColonCharacterSyntax {
}

struct ReplacementParsedDownArrowSyntax {
}

struct ReplacementParsedLeftArrowSyntax {
}

struct ReplacementParsedLineBreakSyntax {
}

struct ReplacementParsedLowQuotationMarkSyntax {
}

struct ReplacementParsedNinesQuotationMarkSyntax {
}

struct ReplacementParsedOpeningBraceSyntax {
}

struct ReplacementParsedOpeningBracketSyntax {
}

struct ReplacementParsedParagraphBreakSyntax {
}

struct ReplacementParsedRightArrowSyntax {
}

struct ReplacementParsedSixesQuotationMarkSyntax {
}

struct ReplacementParsedSlashSyntax {
}

struct ReplacementParsedSpaceSyntax {
}

struct ReplacementParsedSymbolInsertionMarkSyntax {
}

struct ReplacementParsedLeftChevronQuotationMarkSyntax {
}

struct ReplacementParsedOpeningParenthesisSyntax {
}

struct ReplacementParsedRightChevronQuotationMarkSyntax {
}

func compute(_ compute: () -> Set<Unicode.Scalar>, cachingIn cache: inout Set<Unicode.Scalar>?) -> Set<Unicode.Scalar> {
  if let cached = cache {
    return cached
  }
  let result: Set<Unicode.Scalar> = compute()
  cache = (result) as Set<Unicode.Scalar>?
  return result
}

import SDGText

extension StrictString {
  init(_ text: UnicodeText) {
    self.init(text.scalars)
  }
}

extension UnicodeText {
  init(_ string: StrictString) {
    scalars = String(string)
  }
}
