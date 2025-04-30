struct UnicodeText {
  fileprivate var scalars: String.UnicodeScalarView

  fileprivate init(_ scalars: String.UnicodeScalarView) {
    self.scalars = scalars
  }

  func index(after i: String.UnicodeScalarView.Index) -> String.UnicodeScalarView.Index {
    return self.scalars.index(after: i)
  }

  subscript(_ position: String.UnicodeScalarView.Index) -> Unicode.Scalar {
    return self.scalars[position]
  }

  var endIndex: String.UnicodeScalarView.Index {
    return self.scalars.endIndex
  }

  var startIndex: String.UnicodeScalarView.Index {
    return self.scalars.startIndex
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

struct ClosingQuestionMarkSyntax {

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

struct GreekQuestionMarkSyntax {

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

struct OpeningExclamationMarkSyntax {

  init() {
  }
}

struct OpeningQuestionMarkSyntax {

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

struct RightToLeftQuestionMarkSyntax {

  init() {
  }
}

struct ClosingExclamationMarkSyntax {

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
  fileprivate let scalar_0020offset: UInt64
  fileprivate let source: UnicodeText

  fileprivate init(_ scalar_0020offset: UInt64, _ source: UnicodeText) {
    self.scalar_0020offset = scalar_0020offset
    self.source = source
  }
}

struct UnicodeSegments {
  fileprivate let segments: [Unicode_0020segment]

  fileprivate init(_ segments: [Unicode_0020segment]) {
    self.segments = segments
  }

  func index(after i: UnicodeSegments.Index) -> UnicodeSegments.Index {
    let segment_0020list: [Unicode_0020segment] = self.segments
    let segment_0020index: Int = i.segment
    let segment: UnicodeText = segment_0020list[segment_0020index].source
    if let scalar_0020index = i.scalar {
      let next_0020scalar: String.UnicodeScalarView.Index = segment.index(after: scalar_0020index)
      if next_0020scalar == segment.endIndex {
        let next_0020segment_0020index: Int = segment_0020list.index(after: segment_0020index)
        if next_0020segment_0020index == segment_0020list.endIndex {
          return UnicodeSegments.Index(next_0020segment_0020index, nil)
        }
        return UnicodeSegments.Index(next_0020segment_0020index, segment_0020list[next_0020segment_0020index].source.startIndex)
      }
      return UnicodeSegments.Index(segment_0020index, next_0020scalar)
    }
    fatalError()
  }

  subscript(_ position: UnicodeSegments.Index) -> Unicode.Scalar {
    if let scalar_0020index = position.scalar {
      return self.segments[position.segment].source[scalar_0020index]
    }
    fatalError()
  }

  var endIndex: UnicodeSegments.Index {
    return UnicodeSegments.Index(self.segments.endIndex, nil)
  }

  var startIndex: UnicodeSegments.Index {
    let segment_0020list: [Unicode_0020segment] = self.segments
    let segment_0020index: Int = segment_0020list.startIndex
    if let first_0020segment = segment_0020list.first {
      return UnicodeSegments.Index(segment_0020index, first_0020segment.source.startIndex)
    }
    return UnicodeSegments.Index(segment_0020index, nil)
  }
}

extension UnicodeSegments {
  struct Index {
    fileprivate let segment: Int
    fileprivate let scalar: String.UnicodeScalarView.Index?

    fileprivate init(_ segment: Int, _ scalar: String.UnicodeScalarView.Index?) {
      self.segment = segment
      self.scalar = scalar
    }
  }
}

extension UnicodeSegments: Collection {}
extension UnicodeSegments.Index: Comparable {}

struct ParsedBulletCharacterSyntax {
  let location: Slice<UnicodeSegments>

  fileprivate init(_ location: Slice<UnicodeSegments>) {
    self.location = location
  }
}

struct ParsedClosingBraceSyntax {
  let location: Slice<UnicodeSegments>

  fileprivate init(_ location: Slice<UnicodeSegments>) {
    self.location = location
  }
}

struct ParsedClosingBracketSyntax {
  let location: Slice<UnicodeSegments>

  fileprivate init(_ location: Slice<UnicodeSegments>) {
    self.location = location
  }
}

struct ParsedClosingExclamationMarkSyntax {
  let location: Slice<UnicodeSegments>

  fileprivate init(_ location: Slice<UnicodeSegments>) {
    self.location = location
  }
}

struct ParsedClosingParenthesisSyntax {
  let location: Slice<UnicodeSegments>

  fileprivate init(_ location: Slice<UnicodeSegments>) {
    self.location = location
  }
}

struct ParsedClosingQuestionMarkSyntax {
  let location: Slice<UnicodeSegments>

  fileprivate init(_ location: Slice<UnicodeSegments>) {
    self.location = location
  }
}

struct ParsedColonCharacterSyntax {
  let location: Slice<UnicodeSegments>

  fileprivate init(_ location: Slice<UnicodeSegments>) {
    self.location = location
  }
}

struct ParsedDownArrowSyntax {
  let location: Slice<UnicodeSegments>

  fileprivate init(_ location: Slice<UnicodeSegments>) {
    self.location = location
  }
}

struct ParsedGreekQuestionMarkSyntax {
  let location: Slice<UnicodeSegments>

  fileprivate init(_ location: Slice<UnicodeSegments>) {
    self.location = location
  }
}

struct ParsedLeftArrowSyntax {
  let location: Slice<UnicodeSegments>

  fileprivate init(_ location: Slice<UnicodeSegments>) {
    self.location = location
  }
}

struct ParsedLineBreakSyntax {
  let location: Slice<UnicodeSegments>

  fileprivate init(_ location: Slice<UnicodeSegments>) {
    self.location = location
  }
}

struct ParsedLowQuotationMarkSyntax {
  let location: Slice<UnicodeSegments>

  fileprivate init(_ location: Slice<UnicodeSegments>) {
    self.location = location
  }
}

struct ParsedNinesQuotationMarkSyntax {
  let location: Slice<UnicodeSegments>

  fileprivate init(_ location: Slice<UnicodeSegments>) {
    self.location = location
  }
}

struct ParsedOpeningBraceSyntax {
  let location: Slice<UnicodeSegments>

  fileprivate init(_ location: Slice<UnicodeSegments>) {
    self.location = location
  }
}

struct ParsedOpeningBracketSyntax {
  let location: Slice<UnicodeSegments>

  fileprivate init(_ location: Slice<UnicodeSegments>) {
    self.location = location
  }
}

struct ParsedOpeningExclamationMarkSyntax {
  let location: Slice<UnicodeSegments>

  fileprivate init(_ location: Slice<UnicodeSegments>) {
    self.location = location
  }
}

struct ParsedOpeningParenthesisSyntax {
  let location: Slice<UnicodeSegments>

  fileprivate init(_ location: Slice<UnicodeSegments>) {
    self.location = location
  }
}

struct ParsedOpeningQuestionMarkSyntax {
  let location: Slice<UnicodeSegments>

  fileprivate init(_ location: Slice<UnicodeSegments>) {
    self.location = location
  }
}

struct ParsedParagraphBreakSyntax {
  let location: Slice<UnicodeSegments>

  fileprivate init(_ location: Slice<UnicodeSegments>) {
    self.location = location
  }
}

struct ParsedRightArrowSyntax {
  let location: Slice<UnicodeSegments>

  fileprivate init(_ location: Slice<UnicodeSegments>) {
    self.location = location
  }
}

struct ParsedRightToLeftQuestionMarkSyntax {
  let location: Slice<UnicodeSegments>

  fileprivate init(_ location: Slice<UnicodeSegments>) {
    self.location = location
  }
}

struct ParsedSixesQuotationMarkSyntax {
  let location: Slice<UnicodeSegments>

  fileprivate init(_ location: Slice<UnicodeSegments>) {
    self.location = location
  }
}

struct ParsedSlashSyntax {
  let location: Slice<UnicodeSegments>

  fileprivate init(_ location: Slice<UnicodeSegments>) {
    self.location = location
  }
}

struct ParsedSpaceSyntax {
  let location: Slice<UnicodeSegments>

  fileprivate init(_ location: Slice<UnicodeSegments>) {
    self.location = location
  }
}

struct ParsedSymbolInsertionMarkSyntax {
  let location: Slice<UnicodeSegments>

  fileprivate init(_ location: Slice<UnicodeSegments>) {
    self.location = location
  }
}

struct ParsedLeftChevronQuotationMarkSyntax {
  let location: Slice<UnicodeSegments>

  fileprivate init(_ location: Slice<UnicodeSegments>) {
    self.location = location
  }
}

struct ParsedRightChevronQuotationMarkSyntax {
  let location: Slice<UnicodeSegments>

  fileprivate init(_ location: Slice<UnicodeSegments>) {
    self.location = location
  }
}

func compute(_ compute: () -> Set<Unicode.Scalar>, cachingIn cache: inout Set<Unicode.Scalar>?) -> Set<Unicode.Scalar> {
  if let cached = cache {
    return cached
  }
  let result: Set<Unicode.Scalar> = compute()
  cache = result
  return result
}

func ==(_ lhs: UnicodeSegments.Index, _ rhs: UnicodeSegments.Index) -> Bool {
  return lhs.segment == rhs.segment && lhs.scalar == rhs.scalar
}

func <(_ lhs: UnicodeSegments.Index, _ rhs: UnicodeSegments.Index) -> Bool {
  if lhs.segment < rhs.segment {
    return true
  }
  if lhs.segment > rhs.segment {
    return false
  }
  if let first_0020scalar = lhs.scalar {
    if let second_0020scalar = rhs.scalar {
      return first_0020scalar < second_0020scalar
    }
    return true
  }
  return false
}

import SDGText

extension UnicodeText {
  init(_ string: StrictString) {
    self.init(String(string).unicodeScalars)
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
  init(segment: Int, scalar: String.UnicodeScalarView.Index?) {
    self.init(segment, scalar)
  }
  var segmentIndex: Int {
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
  func segment(at index: Int) -> UnicodeSegment {
    return UnicodeSegment(segment: segments[index])
  }
}

extension ParsedDownArrowSyntax {
  init(location: Slice<UnicodeSegments>) {
    self.init(location)
  }
}

extension ParsedLeftArrowSyntax {
  init(location: Slice<UnicodeSegments>) {
    self.init(location)
  }
}

extension ParsedRightArrowSyntax {
  init(location: Slice<UnicodeSegments>) {
    self.init(location)
  }
}

extension ParsedClosingBraceSyntax {
  init(location: Slice<UnicodeSegments>) {
    self.init(location)
  }
}

extension ParsedOpeningBraceSyntax {
  init(location: Slice<UnicodeSegments>) {
    self.init(location)
  }
}

extension ParsedClosingBracketSyntax {
  init(location: Slice<UnicodeSegments>) {
    self.init(location)
  }
}

extension ParsedOpeningBracketSyntax {
  init(location: Slice<UnicodeSegments>) {
    self.init(location)
  }
}

extension ParsedClosingParenthesisSyntax {
  init(location: Slice<UnicodeSegments>) {
    self.init(location)
  }
}

extension ParsedOpeningParenthesisSyntax {
  init(location: Slice<UnicodeSegments>) {
    self.init(location)
  }
}

extension ParsedLineBreakSyntax {
  init(location: Slice<UnicodeSegments>) {
    self.init(location)
  }
}

extension ParsedParagraphBreakSyntax {
  init(location: Slice<UnicodeSegments>) {
    self.init(location)
  }
}

extension ParsedBulletCharacterSyntax {
  init(location: Slice<UnicodeSegments>) {
    self.init(location)
  }
}

extension ParsedOpeningQuestionMarkSyntax {
  init(location: Slice<UnicodeSegments>) {
    self.init(location)
  }
}

extension ParsedClosingQuestionMarkSyntax {
  init(location: Slice<UnicodeSegments>) {
    self.init(location)
  }
}

extension ParsedRightToLeftQuestionMarkSyntax {
  init(location: Slice<UnicodeSegments>) {
    self.init(location)
  }
}

extension ParsedGreekQuestionMarkSyntax {
  init(location: Slice<UnicodeSegments>) {
    self.init(location)
  }
}

extension ParsedOpeningExclamationMarkSyntax {
  init(location: Slice<UnicodeSegments>) {
    self.init(location)
  }
}

extension ParsedClosingExclamationMarkSyntax {
  init(location: Slice<UnicodeSegments>) {
    self.init(location)
  }
}

extension ParsedColonCharacterSyntax {
  init(location: Slice<UnicodeSegments>) {
    self.init(location)
  }
}

extension ParsedLeftChevronQuotationMarkSyntax {
  init(location: Slice<UnicodeSegments>) {
    self.init(location)
  }
}

extension ParsedLowQuotationMarkSyntax {
  init(location: Slice<UnicodeSegments>) {
    self.init(location)
  }
}

extension ParsedNinesQuotationMarkSyntax {
  init(location: Slice<UnicodeSegments>) {
    self.init(location)
  }
}

extension ParsedRightChevronQuotationMarkSyntax {
  init(location: Slice<UnicodeSegments>) {
    self.init(location)
  }
}

extension ParsedSixesQuotationMarkSyntax {
  init(location: Slice<UnicodeSegments>) {
    self.init(location)
  }
}

extension ParsedSlashSyntax {
  init(location: Slice<UnicodeSegments>) {
    self.init(location)
  }
}

extension ParsedSpaceSyntax {
  init(location: Slice<UnicodeSegments>) {
    self.init(location)
  }
}

extension ParsedSymbolInsertionMarkSyntax {
  init(location: Slice<UnicodeSegments>) {
    self.init(location)
  }
}
