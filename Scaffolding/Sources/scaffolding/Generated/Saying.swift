struct ListIndex {
  fileprivate var index: Int
}

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

fileprivate struct Unicode_0020segment {
  fileprivate var scalar_0020offset: UInt64
  fileprivate var source: UnicodeText
}

struct UnicodeSegments {
  fileprivate var segments: [Unicode_0020segment]
}

extension UnicodeSegments {
  struct Index {
    fileprivate var segment: ListIndex
    fileprivate var scalar: String.UnicodeScalarView.Index?
  }
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

extension ListIndex {
  init(int: Int) {
    self.index = int
  }
  var int: Int {
    return index
  }
}

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

struct UnicodeSegment {
  fileprivate var segment: Unicode_0020segment
}

extension UnicodeSegment {
  init(scalarOffset: UInt64, source: UnicodeText) {
    self.init(segment: Unicode_0020segment(scalar_0020offset: scalarOffset, source: source))
  }
  var scalarOffset: UInt64 {
    return segment.scalar_0020offset
  }
  var source: UnicodeText {
    return segment.source
  }
}

extension UnicodeSegments.Index {
  init(_ segment: ListIndex, _ scalar: String.UnicodeScalarView.Index?) {
    self.init(segment: segment, scalar: scalar)
  }
  var segmentIndex: ListIndex {
    return segment
  }
  var scalarIndex: String.UnicodeScalarView.Index? {
    return scalar
  }
}

extension UnicodeSegments {
  init(segments: [UnicodeSegment]) {
    self.init(segments: segments.map({ $0.segment }))
  }
  var segmentIndices: Range<Int> {
    return segments.indices
  }
  func segment(at index: ListIndex) -> UnicodeSegment {
    return UnicodeSegment(segment: segments[index.int])
  }
}
