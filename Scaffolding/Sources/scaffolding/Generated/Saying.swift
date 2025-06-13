import Foundation


struct UnicodeText {
  fileprivate var scalars: String.UnicodeScalarView

  fileprivate init(skippingNormalizationOf scalars: String.UnicodeScalarView) {
    self.scalars = scalars
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(self.scalars)
  }

  func index(after i: String.UnicodeScalarView.Index) -> String.UnicodeScalarView.Index {
    return self.scalars.index(after: i)
  }

  subscript(_ position: String.UnicodeScalarView.Index) -> Unicode.Scalar {
    return self.scalars[position]
  }

  init(_ scalars: String.UnicodeScalarView) {
    self = UnicodeText(skippingNormalizationOf: String(scalars).decomposedStringWithCompatibilityMapping.unicodeScalars)
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

enum SayingSourceCode {
  case utf8(UnicodeSegments)
}

enum SayingSourceCodeSlice {
  case utf8(Slice<UnicodeSegments>)
}

struct SayingSourceSlice {
  let origin: UnicodeText
  let code: SayingSourceCodeSlice

  fileprivate init(_ origin: UnicodeText, _ code: SayingSourceCodeSlice) {
    self.origin = origin
    self.code = code
  }
}

struct ParsedLeftChevronQuotationMarkSyntax {
  let location: SayingSourceSlice

  fileprivate init(_ location: SayingSourceSlice) {
    self.location = location
  }
}

struct ParsedRightChevronQuotationMarkSyntax {
  let location: SayingSourceSlice

  fileprivate init(_ location: SayingSourceSlice) {
    self.location = location
  }
}

struct ParsedBulletCharacterSyntax {
  let location: SayingSourceSlice

  fileprivate init(_ location: SayingSourceSlice) {
    self.location = location
  }
}

struct ParsedClosingBraceSyntax {
  let location: SayingSourceSlice

  fileprivate init(_ location: SayingSourceSlice) {
    self.location = location
  }
}

struct ParsedClosingBracketSyntax {
  let location: SayingSourceSlice

  fileprivate init(_ location: SayingSourceSlice) {
    self.location = location
  }
}

struct ParsedClosingExclamationMarkSyntax {
  let location: SayingSourceSlice

  fileprivate init(_ location: SayingSourceSlice) {
    self.location = location
  }
}

struct ParsedClosingParenthesisSyntax {
  let location: SayingSourceSlice

  fileprivate init(_ location: SayingSourceSlice) {
    self.location = location
  }
}

struct ParsedClosingQuestionMarkSyntax {
  let location: SayingSourceSlice

  fileprivate init(_ location: SayingSourceSlice) {
    self.location = location
  }
}

struct ParsedColonCharacterSyntax {
  let location: SayingSourceSlice

  fileprivate init(_ location: SayingSourceSlice) {
    self.location = location
  }
}

struct ParsedDownArrowSyntax {
  let location: SayingSourceSlice

  fileprivate init(_ location: SayingSourceSlice) {
    self.location = location
  }
}

struct ParsedGreekQuestionMarkSyntax {
  let location: SayingSourceSlice

  fileprivate init(_ location: SayingSourceSlice) {
    self.location = location
  }
}

struct ParsedLeftArrowSyntax {
  let location: SayingSourceSlice

  fileprivate init(_ location: SayingSourceSlice) {
    self.location = location
  }
}

struct ParsedLineBreakSyntax {
  let location: SayingSourceSlice

  fileprivate init(_ location: SayingSourceSlice) {
    self.location = location
  }
}

struct ParsedLowQuotationMarkSyntax {
  let location: SayingSourceSlice

  fileprivate init(_ location: SayingSourceSlice) {
    self.location = location
  }
}

struct ParsedNinesQuotationMarkSyntax {
  let location: SayingSourceSlice

  fileprivate init(_ location: SayingSourceSlice) {
    self.location = location
  }
}

struct ParsedOpeningBraceSyntax {
  let location: SayingSourceSlice

  fileprivate init(_ location: SayingSourceSlice) {
    self.location = location
  }
}

struct ParsedOpeningBracketSyntax {
  let location: SayingSourceSlice

  fileprivate init(_ location: SayingSourceSlice) {
    self.location = location
  }
}

struct ParsedOpeningExclamationMarkSyntax {
  let location: SayingSourceSlice

  fileprivate init(_ location: SayingSourceSlice) {
    self.location = location
  }
}

struct ParsedOpeningParenthesisSyntax {
  let location: SayingSourceSlice

  fileprivate init(_ location: SayingSourceSlice) {
    self.location = location
  }
}

struct ParsedOpeningQuestionMarkSyntax {
  let location: SayingSourceSlice

  fileprivate init(_ location: SayingSourceSlice) {
    self.location = location
  }
}

struct ParsedParagraphBreakSyntax {
  let location: SayingSourceSlice

  fileprivate init(_ location: SayingSourceSlice) {
    self.location = location
  }
}

struct ParsedRightArrowSyntax {
  let location: SayingSourceSlice

  fileprivate init(_ location: SayingSourceSlice) {
    self.location = location
  }
}

struct ParsedRightToLeftQuestionMarkSyntax {
  let location: SayingSourceSlice

  fileprivate init(_ location: SayingSourceSlice) {
    self.location = location
  }
}

struct ParsedSixesQuotationMarkSyntax {
  let location: SayingSourceSlice

  fileprivate init(_ location: SayingSourceSlice) {
    self.location = location
  }
}

struct ParsedSlashSyntax {
  let location: SayingSourceSlice

  fileprivate init(_ location: SayingSourceSlice) {
    self.location = location
  }
}

struct ParsedSpaceSyntax {
  let location: SayingSourceSlice

  fileprivate init(_ location: SayingSourceSlice) {
    self.location = location
  }
}

struct ParsedSymbolInsertionMarkSyntax {
  let location: SayingSourceSlice

  fileprivate init(_ location: SayingSourceSlice) {
    self.location = location
  }
}

struct SayingSource {
  let origin: UnicodeText
  let code: SayingSourceCode

  init(origin: UnicodeText, code: SayingSourceCode) {
    self.origin = origin
    self.code = code
  }
}

public func ==(_ lhs: String.UnicodeScalarView, _ rhs: String.UnicodeScalarView) -> Bool {
  return lhs.elementsEqual(rhs)
}

func ==(_ lhs: UnicodeText, _ rhs: UnicodeText) -> Bool {
  return lhs.scalars == rhs.scalars
}

func compute(_ compute: () -> Set<Unicode.Scalar>, cachingIn cache: inout Set<Unicode.Scalar>?) -> Set<Unicode.Scalar> {
  if let cached = cache {
    return cached
  }
  let result: Set<Unicode.Scalar> = compute()
  cache = result
  return result
}

extension String.UnicodeScalarView {
  public func hash(into hasher: inout Hasher) {
    for scalar in self {
      hasher.combine(scalar)
    }
  }
}

extension String.UnicodeScalarView: Hashable {}

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

extension SayingSourceSlice {
  init(origin: UnicodeText, code: SayingSourceCodeSlice) {
    self.init(origin, code)
  }
}

extension ParsedDownArrowSyntax {
  init(location: SayingSourceSlice) {
    self.init(location)
  }
}

extension ParsedLeftArrowSyntax {
  init(location: SayingSourceSlice) {
    self.init(location)
  }
}

extension ParsedRightArrowSyntax {
  init(location: SayingSourceSlice) {
    self.init(location)
  }
}

extension ParsedClosingBraceSyntax {
  init(location: SayingSourceSlice) {
    self.init(location)
  }
}

extension ParsedOpeningBraceSyntax {
  init(location: SayingSourceSlice) {
    self.init(location)
  }
}

extension ParsedClosingBracketSyntax {
  init(location: SayingSourceSlice) {
    self.init(location)
  }
}

extension ParsedOpeningBracketSyntax {
  init(location: SayingSourceSlice) {
    self.init(location)
  }
}

extension ParsedClosingParenthesisSyntax {
  init(location: SayingSourceSlice) {
    self.init(location)
  }
}

extension ParsedOpeningParenthesisSyntax {
  init(location: SayingSourceSlice) {
    self.init(location)
  }
}

extension ParsedLineBreakSyntax {
  init(location: SayingSourceSlice) {
    self.init(location)
  }
}

extension ParsedParagraphBreakSyntax {
  init(location: SayingSourceSlice) {
    self.init(location)
  }
}

extension ParsedBulletCharacterSyntax {
  init(location: SayingSourceSlice) {
    self.init(location)
  }
}

extension ParsedOpeningQuestionMarkSyntax {
  init(location: SayingSourceSlice) {
    self.init(location)
  }
}

extension ParsedClosingQuestionMarkSyntax {
  init(location: SayingSourceSlice) {
    self.init(location)
  }
}

extension ParsedRightToLeftQuestionMarkSyntax {
  init(location: SayingSourceSlice) {
    self.init(location)
  }
}

extension ParsedGreekQuestionMarkSyntax {
  init(location: SayingSourceSlice) {
    self.init(location)
  }
}

extension ParsedOpeningExclamationMarkSyntax {
  init(location: SayingSourceSlice) {
    self.init(location)
  }
}

extension ParsedClosingExclamationMarkSyntax {
  init(location: SayingSourceSlice) {
    self.init(location)
  }
}

extension ParsedColonCharacterSyntax {
  init(location: SayingSourceSlice) {
    self.init(location)
  }
}

extension ParsedLeftChevronQuotationMarkSyntax {
  init(location: SayingSourceSlice) {
    self.init(location)
  }
}

extension ParsedLowQuotationMarkSyntax {
  init(location: SayingSourceSlice) {
    self.init(location)
  }
}

extension ParsedNinesQuotationMarkSyntax {
  init(location: SayingSourceSlice) {
    self.init(location)
  }
}

extension ParsedRightChevronQuotationMarkSyntax {
  init(location: SayingSourceSlice) {
    self.init(location)
  }
}

extension ParsedSixesQuotationMarkSyntax {
  init(location: SayingSourceSlice) {
    self.init(location)
  }
}

extension ParsedSlashSyntax {
  init(location: SayingSourceSlice) {
    self.init(location)
  }
}

extension ParsedSpaceSyntax {
  init(location: SayingSourceSlice) {
    self.init(location)
  }
}

extension ParsedSymbolInsertionMarkSyntax {
  init(location: SayingSourceSlice) {
    self.init(location)
  }
}
