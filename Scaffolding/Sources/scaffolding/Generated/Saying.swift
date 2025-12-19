import Foundation

struct UnicodeText {
  fileprivate var scalars: String.UnicodeScalarView

  init(skippingNormalizationOf scalars: String.UnicodeScalarView) {
    self.scalars = scalars
  }

  var isEmpty: Bool {
    return self.scalars.isEmpty
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

  init(_ other: Slice<UnicodeText>) {
    self = UnicodeText(skippingNormalizationOf: String.UnicodeScalarView(Slice(base: other.base.scalars, bounds: { let slice = other; return slice.startIndex ..< slice.endIndex }())))
  }

  init(_ other: UnicodeText) {
    self = other
  }

  init(_ scalars: String.UnicodeScalarView) {
    self = UnicodeText(skippingNormalizationOf: scalars.compatibilityDecomposition())
  }

  mutating func append(contentsOf newElements: UnicodeText) {
    self.scalars += newElements.scalars
    self.scalars.decomposeAccordingToCompatibilityDecomposition()
  }

  var endIndex: String.UnicodeScalarView.Index {
    return self.scalars.endIndex
  }

  subscript(entryIndex index: String.UnicodeScalarView.Index) -> Unicode.Scalar {
    return self.scalars[index]
  }

  func indexSkippingBoundsCheck(afterBoundary boundary: String.UnicodeScalarView.Index) -> String.UnicodeScalarView.Index {
    return boundary
  }

  mutating func replaceSubrange(_ subrange: Range<String.UnicodeScalarView.Index>, with newElements: UnicodeText) {
    let end: String.UnicodeScalarView.Index = self.endIndex
    let after: UnicodeText = UnicodeText(Slice(base: self, bounds: subrange.upperBound ..< end))
    self.scalars.removeSubrange(subrange.lowerBound ..< end)
    self.append(contentsOf: newElements)
    self.append(contentsOf: after)
  }

  var startIndex: String.UnicodeScalarView.Index {
    return self.scalars.startIndex
  }
}

extension UnicodeText: Collection {}

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

struct GitStyleSayingSource {
  let origin: UnicodeText
  let code: UnicodeText

  init(origin: UnicodeText, code: UnicodeText) {
    self.origin = origin
    self.code = code
  }
}

fileprivate struct Git_2010style_0020parsing_0020cursor {
  fileprivate let cursor: String.UnicodeScalarView.Index
  fileprivate let offset: UInt64

  fileprivate init(_ cursor: String.UnicodeScalarView.Index, _ offset: UInt64) {
    self.cursor = cursor
    self.offset = offset
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

extension UnicodeSegments {
  struct EntryIndex {
    fileprivate let segment: Int
    fileprivate let scalar: String.UnicodeScalarView.Index

    fileprivate init(_ segment: Int, _ scalar: String.UnicodeScalarView.Index) {
      self.segment = segment
      self.scalar = scalar
    }
  }
}

extension UnicodeSegments {
  struct Boundary {
    fileprivate let segment: Int
    fileprivate let scalar: String.UnicodeScalarView.Index?

    fileprivate init(_ segment: Int, _ scalar: String.UnicodeScalarView.Index?) {
      self.segment = segment
      self.scalar = scalar
    }
  }
}

extension UnicodeSegments.Boundary: Comparable {}

struct UnicodeSegments {
  fileprivate let segments: [Unicode_0020segment]

  fileprivate init(_ segments: [Unicode_0020segment]) {
    self.segments = segments
  }

  func index(after i: UnicodeSegments.Boundary) -> UnicodeSegments.Boundary {
    let segment_0020list: [Unicode_0020segment] = self.segments
    let segment_0020cursor: Int = i.segment
    let segment: UnicodeText = segment_0020list[segment_0020cursor].source
    if let scalar_0020cursor = i.scalar {
      let next_0020scalar: String.UnicodeScalarView.Index = segment.index(after: scalar_0020cursor)
      if next_0020scalar == segment.endIndex {
        let next_0020segment_0020cursor: Int = segment_0020list.index(after: segment_0020cursor)
        if next_0020segment_0020cursor == segment_0020list.endIndex {
          return UnicodeSegments.Boundary(next_0020segment_0020cursor, nil)
        }
        return UnicodeSegments.Boundary(next_0020segment_0020cursor, segment_0020list[next_0020segment_0020cursor].source.startIndex)
      }
      return UnicodeSegments.Boundary(segment_0020cursor, next_0020scalar)
    }
    fatalError()
  }

  subscript(_ position: UnicodeSegments.Boundary) -> Unicode.Scalar {
    return self[accordingToDefaultUseAsList: position]
  }

  subscript(accordingToDefaultUseAsList position: UnicodeSegments.Boundary) -> Unicode.Scalar {
    return self[entryIndex: self.indexSkippingBoundsCheck(afterBoundary: position)]
  }

  var endIndex: UnicodeSegments.Boundary {
    return UnicodeSegments.Boundary(self.segments.endIndex, nil)
  }

  subscript(entryIndex index: UnicodeSegments.EntryIndex) -> Unicode.Scalar {
    return self.segments[index.segment].source[entryIndex: index.scalar]
  }

  func indexSkippingBoundsCheck(afterBoundary boundary: UnicodeSegments.Boundary) -> UnicodeSegments.EntryIndex {
    if let scalar_0020boundary = boundary.scalar {
      let segment_0020list: [Unicode_0020segment] = self.segments
      let segment_0020index: Int = boundary.segment
      return UnicodeSegments.EntryIndex(segment_0020index, segment_0020list[segment_0020index].source.indexSkippingBoundsCheck(afterBoundary: scalar_0020boundary))
    }
    fatalError()
  }

  var startIndex: UnicodeSegments.Boundary {
    let segment_0020list: [Unicode_0020segment] = self.segments
    let segment_0020cursor: Int = segment_0020list.startIndex
    if let first_0020segment = segment_0020list.first {
      return UnicodeSegments.Boundary(segment_0020cursor, first_0020segment.source.startIndex)
    }
    return UnicodeSegments.Boundary(segment_0020cursor, nil)
  }
}

extension UnicodeSegments: Collection {}

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

extension Slice<UnicodeText> {
  var isNotEmpty: Bool {
    return self.isNotEmptyAccordingToDefaultUseAsList
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

extension String.UnicodeScalarView {
  func compatibilityDecomposition() -> String.UnicodeScalarView {
    ensureUnicodeResourcesHaveLoaded
    return String(self).decomposedStringWithCompatibilityMapping.unicodeScalars
  }
}

extension String.UnicodeScalarView {
  mutating func decomposeAccordingToCompatibilityDecomposition() {
    self = self.compatibilityDecomposition()
  }
}

extension String.UnicodeScalarView {
  public func hash(into hasher: inout Hasher) {
    for scalar in self {
      hasher.combine(scalar)
    }
  }
}

func compare(_ first: Int, to second: Int) -> Bool? {
  if first < second {
    return true
  }
  if first > second {
    return false
  }
  return nil
}

private let ensureUnicodeResourcesHaveLoaded: Void = { _ = Locale.current }()

extension String.UnicodeScalarView: Hashable {}

extension Slice<UnicodeText> {
  var isNotEmptyAccordingToDefaultUseAsList: Bool {
    return !self.isEmpty
  }
}

func ==(_ lhs: UnicodeSegments.Boundary, _ rhs: UnicodeSegments.Boundary) -> Bool {
  return lhs.segment == rhs.segment && lhs.scalar == rhs.scalar
}

func <(_ lhs: UnicodeSegments.Boundary, _ rhs: UnicodeSegments.Boundary) -> Bool {
  if let result = compare(lhs.segment, to: rhs.segment) {
    return result
  }
  if let first_0020scalar = lhs.scalar {
    if let second_0020scalar = rhs.scalar {
      return first_0020scalar < second_0020scalar
    }
    return true
  }
  return false
}

fileprivate func parse_0020line_0020in_0020_0028_0029_0020from_0020_0028_0029_0020to_0020_0028_0029_0020into_0020_0028_0029_003AGitStyleSayingSource_003A_0028_003Aoptional_0020_0028_0029_003AGit_2010style_0020parsing_0020cursor_003A_0029_003AGit_2010style_0020parsing_0020cursor_003A_0028_003Alist_0020of_0020_0028_0029_003AUnicode_0020segment_003A_0029_003A(_ source: GitStyleSayingSource, _ beginning: inout Git_2010style_0020parsing_0020cursor?, _ end: Git_2010style_0020parsing_0020cursor, _ segments: inout [Unicode_0020segment]) {
  if let start = beginning {
    var adjusted_0020offset: UInt64 = start.offset
    var segment: Slice<UnicodeText> = Slice(base: source.code, bounds: start.cursor ..< end.cursor)
    while segment.first == " " {
      segment.removeFirst()
      adjusted_0020offset += 1
    }
    if segment.isNotEmpty {
      segments.append(Unicode_0020segment(adjusted_0020offset, UnicodeText(segment)))
    }
  }
  beginning = nil
}

fileprivate func shim_0020unit_0020access_0020to_0020Git_2010style_0020line_0020parsing_003A() {
  let source_0020text: UnicodeText = UnicodeText(skippingNormalizationOf: " ...".unicodeScalars)
  let source: GitStyleSayingSource = GitStyleSayingSource(origin: UnicodeText(skippingNormalizationOf: "".unicodeScalars), code: source_0020text)
  var beginning: Git_2010style_0020parsing_0020cursor? = Git_2010style_0020parsing_0020cursor(source_0020text.startIndex, 0) as Git_2010style_0020parsing_0020cursor?
  let end: Git_2010style_0020parsing_0020cursor = Git_2010style_0020parsing_0020cursor(source_0020text.endIndex, 1)
  var segments: [Unicode_0020segment] = []
  parse_0020line_0020in_0020_0028_0029_0020from_0020_0028_0029_0020to_0020_0028_0029_0020into_0020_0028_0029_003AGitStyleSayingSource_003A_0028_003Aoptional_0020_0028_0029_003AGit_2010style_0020parsing_0020cursor_003A_0029_003AGit_2010style_0020parsing_0020cursor_003A_0028_003Alist_0020of_0020_0028_0029_003AUnicode_0020segment_003A_0029_003A(source, &beginning, end, &segments)
}

func shimAccessToGitStyleLineParsing() {
  shim_0020unit_0020access_0020to_0020Git_2010style_0020line_0020parsing_003A()
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

extension UnicodeSegments.Boundary {
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

struct GitStyleParsingCursor {
  fileprivate var value: Git_2010style_0020parsing_0020cursor
}

extension GitStyleParsingCursor {
  init(index: String.UnicodeScalarView.Index, offset: UInt64) {
    self.init(value: Git_2010style_0020parsing_0020cursor(index, offset))
  }
}

func parseLine(
  in source: GitStyleSayingSource,
  from beginning: inout GitStyleParsingCursor?,
  to end: GitStyleParsingCursor,
  into segments: inout [UnicodeSegment]
) {
  var mappedBeginning = beginning?.value
  defer {
    beginning = mappedBeginning.map { GitStyleParsingCursor(value: $0) }
  }
  var mappedSegments = segments.map { $0.segment }
  defer {
    segments = mappedSegments.map { UnicodeSegment(segment: $0) }
  }
  parse_0020line_0020in_0020_0028_0029_0020from_0020_0028_0029_0020to_0020_0028_0029_0020into_0020_0028_0029_003AGitStyleSayingSource_003A_0028_003Aoptional_0020_0028_0029_003AGit_2010style_0020parsing_0020cursor_003A_0029_003AGit_2010style_0020parsing_0020cursor_003A_0028_003Alist_0020of_0020_0028_0029_003AUnicode_0020segment_003A_0029_003A(
    source,
    &mappedBeginning,
    end.value,
    &mappedSegments
  )
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
