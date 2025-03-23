struct UnicodeText {
  fileprivate var scalars: String.UnicodeScalarView

  fileprivate init(_ scalars: String.UnicodeScalarView) {
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
    fileprivate var segment: Int
    fileprivate var scalar: String.UnicodeScalarView.Index?

    fileprivate init(_ segment: Int, _ scalar: String.UnicodeScalarView.Index?) {
      self.segment = segment
      self.scalar = scalar
    }
  }
}

extension UnicodeSegments: Collection {}

struct ParsedBulletCharacterSyntax {
  fileprivate var stored_0020location: Slice<UnicodeSegments>

  fileprivate init(_ stored_0020location: Slice<UnicodeSegments>) {
    self.stored_0020location = stored_0020location
  }
}

struct ParsedClosingBraceSyntax {
  fileprivate var stored_0020location: Slice<UnicodeSegments>

  fileprivate init(_ stored_0020location: Slice<UnicodeSegments>) {
    self.stored_0020location = stored_0020location
  }
}

struct ParsedClosingBracketSyntax {
  fileprivate var stored_0020location: Slice<UnicodeSegments>

  fileprivate init(_ stored_0020location: Slice<UnicodeSegments>) {
    self.stored_0020location = stored_0020location
  }
}

struct ParsedClosingExclamationMarkSyntax {
  fileprivate var stored_0020location: Slice<UnicodeSegments>

  fileprivate init(_ stored_0020location: Slice<UnicodeSegments>) {
    self.stored_0020location = stored_0020location
  }
}

struct ParsedClosingParenthesisSyntax {
  fileprivate var stored_0020location: Slice<UnicodeSegments>

  fileprivate init(_ stored_0020location: Slice<UnicodeSegments>) {
    self.stored_0020location = stored_0020location
  }
}

struct ParsedClosingQuestionMarkSyntax {
  fileprivate var stored_0020location: Slice<UnicodeSegments>

  fileprivate init(_ stored_0020location: Slice<UnicodeSegments>) {
    self.stored_0020location = stored_0020location
  }
}

struct ParsedColonCharacterSyntax {
  fileprivate var stored_0020location: Slice<UnicodeSegments>

  fileprivate init(_ stored_0020location: Slice<UnicodeSegments>) {
    self.stored_0020location = stored_0020location
  }
}

struct ParsedDownArrowSyntax {
  fileprivate var stored_0020location: Slice<UnicodeSegments>

  fileprivate init(_ stored_0020location: Slice<UnicodeSegments>) {
    self.stored_0020location = stored_0020location
  }
}

struct ParsedGreekQuestionMarkSyntax {
  fileprivate var stored_0020location: Slice<UnicodeSegments>

  fileprivate init(_ stored_0020location: Slice<UnicodeSegments>) {
    self.stored_0020location = stored_0020location
  }
}

struct ParsedLeftArrowSyntax {
  fileprivate var stored_0020location: Slice<UnicodeSegments>

  fileprivate init(_ stored_0020location: Slice<UnicodeSegments>) {
    self.stored_0020location = stored_0020location
  }
}

struct ParsedLineBreakSyntax {
  fileprivate var stored_0020location: Slice<UnicodeSegments>

  fileprivate init(_ stored_0020location: Slice<UnicodeSegments>) {
    self.stored_0020location = stored_0020location
  }
}

struct ParsedLowQuotationMarkSyntax {
  fileprivate var stored_0020location: Slice<UnicodeSegments>

  fileprivate init(_ stored_0020location: Slice<UnicodeSegments>) {
    self.stored_0020location = stored_0020location
  }
}

struct ParsedNinesQuotationMarkSyntax {
  fileprivate var stored_0020location: Slice<UnicodeSegments>

  fileprivate init(_ stored_0020location: Slice<UnicodeSegments>) {
    self.stored_0020location = stored_0020location
  }
}

struct ParsedOpeningBraceSyntax {
  fileprivate var stored_0020location: Slice<UnicodeSegments>

  fileprivate init(_ stored_0020location: Slice<UnicodeSegments>) {
    self.stored_0020location = stored_0020location
  }
}

struct ParsedOpeningBracketSyntax {
  fileprivate var stored_0020location: Slice<UnicodeSegments>

  fileprivate init(_ stored_0020location: Slice<UnicodeSegments>) {
    self.stored_0020location = stored_0020location
  }
}

struct ParsedOpeningExclamationMarkSyntax {
  fileprivate var stored_0020location: Slice<UnicodeSegments>

  fileprivate init(_ stored_0020location: Slice<UnicodeSegments>) {
    self.stored_0020location = stored_0020location
  }
}

struct ParsedOpeningParenthesisSyntax {
  fileprivate var stored_0020location: Slice<UnicodeSegments>

  fileprivate init(_ stored_0020location: Slice<UnicodeSegments>) {
    self.stored_0020location = stored_0020location
  }
}

struct ParsedOpeningQuestionMarkSyntax {
  fileprivate var stored_0020location: Slice<UnicodeSegments>

  fileprivate init(_ stored_0020location: Slice<UnicodeSegments>) {
    self.stored_0020location = stored_0020location
  }
}

struct ParsedParagraphBreakSyntax {
  fileprivate var stored_0020location: Slice<UnicodeSegments>

  fileprivate init(_ stored_0020location: Slice<UnicodeSegments>) {
    self.stored_0020location = stored_0020location
  }
}

struct ParsedRightArrowSyntax {
  fileprivate var stored_0020location: Slice<UnicodeSegments>

  fileprivate init(_ stored_0020location: Slice<UnicodeSegments>) {
    self.stored_0020location = stored_0020location
  }
}

struct ParsedRightToLeftQuestionMarkSyntax {
  fileprivate var stored_0020location: Slice<UnicodeSegments>

  fileprivate init(_ stored_0020location: Slice<UnicodeSegments>) {
    self.stored_0020location = stored_0020location
  }
}

struct ParsedSixesQuotationMarkSyntax {
  fileprivate var stored_0020location: Slice<UnicodeSegments>

  fileprivate init(_ stored_0020location: Slice<UnicodeSegments>) {
    self.stored_0020location = stored_0020location
  }
}

struct ParsedSlashSyntax {
  fileprivate var stored_0020location: Slice<UnicodeSegments>

  fileprivate init(_ stored_0020location: Slice<UnicodeSegments>) {
    self.stored_0020location = stored_0020location
  }
}

struct ParsedSpaceSyntax {
  fileprivate var stored_0020location: Slice<UnicodeSegments>

  fileprivate init(_ stored_0020location: Slice<UnicodeSegments>) {
    self.stored_0020location = stored_0020location
  }
}

struct ParsedSymbolInsertionMarkSyntax {
  fileprivate var stored_0020location: Slice<UnicodeSegments>

  fileprivate init(_ stored_0020location: Slice<UnicodeSegments>) {
    self.stored_0020location = stored_0020location
  }
}

struct ParsedLeftChevronQuotationMarkSyntax {
  fileprivate var stored_0020location: Slice<UnicodeSegments>

  fileprivate init(_ stored_0020location: Slice<UnicodeSegments>) {
    self.stored_0020location = stored_0020location
  }
}

struct ParsedRightChevronQuotationMarkSyntax {
  fileprivate var stored_0020location: Slice<UnicodeSegments>

  fileprivate init(_ stored_0020location: Slice<UnicodeSegments>) {
    self.stored_0020location = stored_0020location
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

extension UnicodeText {
  func index(after i: String.UnicodeScalarView.Index) -> String.UnicodeScalarView.Index {
    return self.scalars.index(after: i)
  }
}

extension UnicodeText {
  subscript(_ index: String.UnicodeScalarView.Index) -> Unicode.Scalar {
    return self.scalars[index]
  }
}

extension UnicodeText {
  var endIndex: String.UnicodeScalarView.Index {
    return self.scalars.endIndex
  }
}

extension UnicodeText {
  var startIndex: String.UnicodeScalarView.Index {
    return self.scalars.startIndex
  }
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

extension UnicodeSegments {
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
}

extension UnicodeSegments {
  subscript(_ index: UnicodeSegments.Index) -> Unicode.Scalar {
    if let scalar_0020index = index.scalar {
      return self.segments[index.segment].source[scalar_0020index]
    }
    fatalError()
  }
}

extension UnicodeSegments {
  var endIndex: UnicodeSegments.Index {
    return UnicodeSegments.Index(self.segments.endIndex, nil)
  }
}

extension ParsedBulletCharacterSyntax {
  var location: Slice<UnicodeSegments> {
    return self.stored_0020location
  }
}

extension ParsedClosingBraceSyntax {
  var location: Slice<UnicodeSegments> {
    return self.stored_0020location
  }
}

extension ParsedClosingBracketSyntax {
  var location: Slice<UnicodeSegments> {
    return self.stored_0020location
  }
}

extension ParsedClosingExclamationMarkSyntax {
  var location: Slice<UnicodeSegments> {
    return self.stored_0020location
  }
}

extension ParsedClosingParenthesisSyntax {
  var location: Slice<UnicodeSegments> {
    return self.stored_0020location
  }
}

extension ParsedClosingQuestionMarkSyntax {
  var location: Slice<UnicodeSegments> {
    return self.stored_0020location
  }
}

extension ParsedColonCharacterSyntax {
  var location: Slice<UnicodeSegments> {
    return self.stored_0020location
  }
}

extension ParsedDownArrowSyntax {
  var location: Slice<UnicodeSegments> {
    return self.stored_0020location
  }
}

extension ParsedGreekQuestionMarkSyntax {
  var location: Slice<UnicodeSegments> {
    return self.stored_0020location
  }
}

extension ParsedLeftArrowSyntax {
  var location: Slice<UnicodeSegments> {
    return self.stored_0020location
  }
}

extension ParsedLineBreakSyntax {
  var location: Slice<UnicodeSegments> {
    return self.stored_0020location
  }
}

extension ParsedLowQuotationMarkSyntax {
  var location: Slice<UnicodeSegments> {
    return self.stored_0020location
  }
}

extension ParsedNinesQuotationMarkSyntax {
  var location: Slice<UnicodeSegments> {
    return self.stored_0020location
  }
}

extension ParsedOpeningBraceSyntax {
  var location: Slice<UnicodeSegments> {
    return self.stored_0020location
  }
}

extension ParsedOpeningBracketSyntax {
  var location: Slice<UnicodeSegments> {
    return self.stored_0020location
  }
}

extension ParsedOpeningExclamationMarkSyntax {
  var location: Slice<UnicodeSegments> {
    return self.stored_0020location
  }
}

extension ParsedOpeningParenthesisSyntax {
  var location: Slice<UnicodeSegments> {
    return self.stored_0020location
  }
}

extension ParsedOpeningQuestionMarkSyntax {
  var location: Slice<UnicodeSegments> {
    return self.stored_0020location
  }
}

extension ParsedParagraphBreakSyntax {
  var location: Slice<UnicodeSegments> {
    return self.stored_0020location
  }
}

extension ParsedRightArrowSyntax {
  var location: Slice<UnicodeSegments> {
    return self.stored_0020location
  }
}

extension ParsedRightToLeftQuestionMarkSyntax {
  var location: Slice<UnicodeSegments> {
    return self.stored_0020location
  }
}

extension ParsedSixesQuotationMarkSyntax {
  var location: Slice<UnicodeSegments> {
    return self.stored_0020location
  }
}

extension ParsedSlashSyntax {
  var location: Slice<UnicodeSegments> {
    return self.stored_0020location
  }
}

extension ParsedSpaceSyntax {
  var location: Slice<UnicodeSegments> {
    return self.stored_0020location
  }
}

extension ParsedSymbolInsertionMarkSyntax {
  var location: Slice<UnicodeSegments> {
    return self.stored_0020location
  }
}

extension ParsedLeftChevronQuotationMarkSyntax {
  var location: Slice<UnicodeSegments> {
    return self.stored_0020location
  }
}

extension ParsedRightChevronQuotationMarkSyntax {
  var location: Slice<UnicodeSegments> {
    return self.stored_0020location
  }
}

extension UnicodeSegments {
  var startIndex: UnicodeSegments.Index {
    let segment_0020list: [Unicode_0020segment] = self.segments
    let segment_0020index: Int = segment_0020list.startIndex
    if let first_0020segment = segment_0020list.first {
      return UnicodeSegments.Index(segment_0020index, first_0020segment.source.startIndex)
    }
    return UnicodeSegments.Index(segment_0020index, nil)
  }
}

import SDGText

extension StrictString {
  init(_ text: UnicodeText) {
    self.init(text.scalars)
  }
}

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