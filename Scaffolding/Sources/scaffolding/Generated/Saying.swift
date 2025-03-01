struct ListIndex {
  fileprivate var platform_0020index: Int

  fileprivate init(_ platform_0020index: Int) {
    self.platform_0020index = platform_0020index
  }
}

struct UnicodeText {
  fileprivate var scalars: String

  fileprivate init(_ scalars: String) {
    self.scalars = scalars
  }
}

struct ParagraphBreakSyntax {

  init() {
  }
}

struct BulletCharacterSyntax {

  init() {
  }
}

struct ClosingBraceSyntax {

  init() {
  }
}

struct ClosingBracketSyntax {

  init() {
  }
}

struct ClosingParenthesisSyntax {

  init() {
  }
}

struct ColonCharacterSyntax {

  init() {
  }
}

struct DownArrowSyntax {

  init() {
  }
}

struct LeftArrowSyntax {

  init() {
  }
}

struct LineBreakSyntax {

  init() {
  }
}

struct LeftChevronQuotationMarkSyntax {

  init() {
  }
}

struct LowQuotationMarkSyntax {

  init() {
  }
}

struct NinesQuotationMarkSyntax {

  init() {
  }
}

struct OpeningParenthesisSyntax {

  init() {
  }
}

struct OpeningBraceSyntax {

  init() {
  }
}

struct OpeningBracketSyntax {

  init() {
  }
}

struct RightChevronQuotationMarkSyntax {

  init() {
  }
}

struct RightArrowSyntax {

  init() {
  }
}

struct SixesQuotationMarkSyntax {

  init() {
  }
}

struct SlashSyntax {

  init() {
  }
}

struct SpaceSyntax {

  init() {
  }
}

struct SymbolInsertionMarkSyntax {

  init() {
  }
}

fileprivate struct Unicode_0020segment {
  fileprivate var scalar_0020offset: UInt64
  fileprivate var source: UnicodeText

  fileprivate init(_ scalar_0020offset: UInt64, _ source: UnicodeText) {
    self.scalar_0020offset = scalar_0020offset
    self.source = source
  }
}

struct UnicodeSegments {
  fileprivate var segments: [Unicode_0020segment]

  fileprivate init(_ segments: [Unicode_0020segment]) {
    self.segments = segments
  }
}

extension UnicodeSegments {
  struct Index {
    fileprivate var segment: ListIndex
    fileprivate var scalar: String.UnicodeScalarView.Index?

    fileprivate init(_ segment: ListIndex, _ scalar: String.UnicodeScalarView.Index?) {
      self.segment = segment
      self.scalar = scalar
    }
  }
}

struct ReplacementParsedBulletCharacterSyntax {

  fileprivate init() {
  }
}

struct ReplacementParsedClosingBraceSyntax {

  fileprivate init() {
  }
}

struct ReplacementParsedClosingBracketSyntax {

  fileprivate init() {
  }
}

struct ReplacementParsedClosingParenthesisSyntax {

  fileprivate init() {
  }
}

struct ReplacementParsedColonCharacterSyntax {

  fileprivate init() {
  }
}

struct ReplacementParsedDownArrowSyntax {

  fileprivate init() {
  }
}

struct ReplacementParsedLeftArrowSyntax {

  fileprivate init() {
  }
}

struct ReplacementParsedLineBreakSyntax {

  fileprivate init() {
  }
}

struct ReplacementParsedLowQuotationMarkSyntax {

  fileprivate init() {
  }
}

struct ReplacementParsedNinesQuotationMarkSyntax {

  fileprivate init() {
  }
}

struct ReplacementParsedOpeningBraceSyntax {

  fileprivate init() {
  }
}

struct ReplacementParsedOpeningBracketSyntax {

  fileprivate init() {
  }
}

struct ReplacementParsedParagraphBreakSyntax {

  fileprivate init() {
  }
}

struct ReplacementParsedRightArrowSyntax {

  fileprivate init() {
  }
}

struct ReplacementParsedSixesQuotationMarkSyntax {

  fileprivate init() {
  }
}

struct ReplacementParsedSlashSyntax {

  fileprivate init() {
  }
}

struct ReplacementParsedSpaceSyntax {

  fileprivate init() {
  }
}

struct ReplacementParsedSymbolInsertionMarkSyntax {

  fileprivate init() {
  }
}

struct ReplacementParsedLeftChevronQuotationMarkSyntax {

  fileprivate init() {
  }
}

struct ReplacementParsedOpeningParenthesisSyntax {

  fileprivate init() {
  }
}

struct ReplacementParsedRightChevronQuotationMarkSyntax {

  fileprivate init() {
  }
}

func ==(_ lhs: ListIndex, _ rhs: ListIndex) -> Bool {
  return (lhs.platform_0020index == rhs.platform_0020index)
}

func <(_ lhs: ListIndex, _ rhs: ListIndex) -> Bool {
  return (lhs.platform_0020index < rhs.platform_0020index)
}

func >(_ lhs: ListIndex, _ rhs: ListIndex) -> Bool {
  return (rhs < lhs)
}

func compute(_ compute: () -> Set<Unicode.Scalar>, cachingIn cache: inout Set<Unicode.Scalar>?) -> Set<Unicode.Scalar> {
  if let cached = cache {
    return cached
  }
  let result: Set<Unicode.Scalar> = compute()
  cache = (result) as Set<Unicode.Scalar>?
  return result
}

func ==(_ lhs: UnicodeSegments.Index, _ rhs: UnicodeSegments.Index) -> Bool {
  return ((lhs.segment == rhs.segment) && (lhs.scalar == rhs.scalar))
}

func <(_ lhs: UnicodeSegments.Index, _ rhs: UnicodeSegments.Index) -> Bool {
  if (lhs.segment < rhs.segment) {
    return true
  }
  if (lhs.segment > rhs.segment) {
    return false
  }
  if let first_0020scalar = lhs.scalar {
    if let second_0020scalar = rhs.scalar {
      return (first_0020scalar < second_0020scalar)
    }
    return true
  }
  return false
}

import SDGText

extension ListIndex {
  init(index: Int) {
    self.init(index)
  }
  var int: Int {
    return platform_0020index
  }
}

extension StrictString {
  init(_ text: UnicodeText) {
    self.init(text.scalars)
  }
}

extension UnicodeText {
  init(_ string: StrictString) {
    self.init(String(string))
  }
}

struct UnicodeSegment {
  fileprivate var segment: Unicode_0020segment
}

extension UnicodeSegment {
  init(scalarOffset: UInt64, source: UnicodeText) {
    self.init(segment: Unicode_0020segment(scalarOffset, source))
  }
  var scalarOffset: UInt64 {
    return segment.scalar_0020offset
  }
  var source: UnicodeText {
    return segment.source
  }
}

extension UnicodeSegments.Index {
  init(segment: ListIndex, scalar: String.UnicodeScalarView.Index?) {
    self.init(segment, scalar)
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
    self.init(segments.map({ $0.segment }))
  }
  var segmentIndices: Range<Int> {
    return segments.indices
  }
  func segment(at index: ListIndex) -> UnicodeSegment {
    return UnicodeSegment(segment: segments[index.int])
  }
}
