import Foundation

struct UnicodeText {
  fileprivate var scalars: String.UnicodeScalarView

  init(skippingNormalizationOf scalars: String.UnicodeScalarView) {
    self.scalars = scalars
  }

  var isEmpty: Bool {
    return self.scalars.isEmpty
  }

  func formIndex(after i: inout String.UnicodeScalarView.Index) {
    self.scalars.formIndex(after: &i)
  }

  func formIndex(before i: inout String.UnicodeScalarView.Index) {
    self.scalars.formIndex(before: &i)
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(self.scalars)
  }

  func index(after i: String.UnicodeScalarView.Index) -> String.UnicodeScalarView.Index {
    return self.scalars.index(after: i)
  }

  func index(before i: String.UnicodeScalarView.Index) -> String.UnicodeScalarView.Index {
    return self.scalars.index(before: i)
  }

  mutating func removeSubrangeAccordingToListInsertion(_ bounds: Range<String.UnicodeScalarView.Index>) {
    self.replaceSubrange(bounds, with: .empty)
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
    if let next = newElements.first {
      if let previous = self.last {
        let next_0020class: Unicode.CanonicalCombiningClass = next.combiningClass
        if next_0020class == .notReordered || previous.combiningClass <= next_0020class {
          self.scalars += newElements.scalars
        } else {
          var seam_0020start: String.UnicodeScalarView.Index = self.endIndex
          while scalar_0020before_0020_0028_0029_0020in_0020_0028_0029_0020is_0020reordrant_003AUnicode_0020scalar_0020boundary_003AUnicodeText_003Aערך_0020אמת(seam_0020start, self) {
            self.formIndex(before: &seam_0020start)
          }
          let seam_0020overlap: Range<String.UnicodeScalarView.Index> = seam_0020start ..< self.endIndex
          var seam: String.UnicodeScalarView = String.UnicodeScalarView(Slice(base: self.scalars, bounds: seam_0020overlap))
          self.removeSubrange(seam_0020overlap)
          var seam_0020end: String.UnicodeScalarView.Index = newElements.startIndex
          while scalar_0020after_0020_0028_0029_0020in_0020_0028_0029_0020is_0020reordrant_003AUnicode_0020scalar_0020boundary_003AUnicodeText_003Aערך_0020אמת(seam_0020end, newElements) {
            newElements.formIndex(after: &seam_0020end)
          }
          seam.append(contentsOf: Slice(base: newElements.scalars, bounds: newElements.startIndex ..< seam_0020end))
          seam.reorderCanonically()
          self.scalars += seam
          self.scalars.append(contentsOf: Slice(base: newElements.scalars, bounds: seam_0020end ..< newElements.endIndex))
        }
        return
      }
      self = newElements
    }
  }

  func boundary(beforeBoundary cursor: String.UnicodeScalarView.Index) -> String.UnicodeScalarView.Index? {
    if cursor > self.startIndex {
      return self.index(before: cursor)
    }
    return nil
  }

  var endIndex: String.UnicodeScalarView.Index {
    return self.scalars.endIndex
  }

  subscript(entryIndex index: String.UnicodeScalarView.Index) -> Unicode.Scalar {
    return self.scalars[index]
  }

  var first: Unicode.Scalar? {
    return self.scalars.first
  }

  func indexSkippingBoundsCheck(afterBoundary boundary: String.UnicodeScalarView.Index) -> String.UnicodeScalarView.Index {
    return boundary
  }

  func entryIndex(afterBoundary boundary: String.UnicodeScalarView.Index) -> String.UnicodeScalarView.Index? {
    if boundary < self.endIndex {
      return self.indexSkippingBoundsCheck(afterBoundary: boundary)
    }
    return nil
  }

  func indexSkippingBoundsCheck(beforeBoundary boundary: String.UnicodeScalarView.Index) -> String.UnicodeScalarView.Index {
    return self.indexSkippingBoundsCheck(afterBoundary: self.index(before: boundary))
  }

  func entryIndex(beforeBoundary boundary: String.UnicodeScalarView.Index) -> String.UnicodeScalarView.Index? {
    if boundary > self.startIndex {
      return self.indexSkippingBoundsCheck(beforeBoundary: boundary)
    }
    return nil
  }

  var last: Unicode.Scalar? {
    return self.scalars.last
  }

  mutating func removeSubrange(_ bounds: Range<String.UnicodeScalarView.Index>) {
    self.removeSubrangeAccordingToListInsertion(bounds)
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

  func index(before i: UnicodeSegments.Boundary) -> UnicodeSegments.Boundary {
    let segment_0020cursor: Int = i.segment
    if let scalar_0020cursor = i.scalar {
      let segment_0020list: [Unicode_0020segment] = self.segments
      let segment: UnicodeText = segment_0020list[segment_0020cursor].source
      if scalar_0020cursor == segment.startIndex {
        return before_0020end_0020of_0020segment_0020before_0020_0028_0029_0020in_0020_0028_0029_002C_0020skipping_0020bounds_0020check_003Alist_0020boundary_003AUnicodeSegments_003AUnicodeSegments_002EBoundary(segment_0020cursor, self)
      }
      return UnicodeSegments.Boundary(segment_0020cursor, segment.boundary(beforeBoundary: scalar_0020cursor))
    }
    return before_0020end_0020of_0020segment_0020before_0020_0028_0029_0020in_0020_0028_0029_002C_0020skipping_0020bounds_0020check_003Alist_0020boundary_003AUnicodeSegments_003AUnicodeSegments_002EBoundary(segment_0020cursor, self)
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

fileprivate func _0028_0029_0020reordered_0020canonically_002C_0020skipping_0020necessity_0020check_003AUnicode_0020scalars_003AUnicode_0020scalars(_ scalars: String.UnicodeScalarView) -> String.UnicodeScalarView {
  var reordered: String.UnicodeScalarView = "".unicodeScalars
  for scalar in scalars {
    let clas_0073: Unicode.CanonicalCombiningClass = scalar.combiningClass
    if clas_0073 == .notReordered {
      reordered.append(scalar)
    } else {
      var cursor: String.UnicodeScalarView.Index = reordered.endIndex
      while scalar_0020before_0020_0028_0029_0020in_0020_0028_0029_0020belongs_0020after_0020_0028_0029_003AUnicode_0020scalar_0020boundary_003AUnicode_0020scalars_003AUnicodeCombiningClass_003Aערך_0020אמת(cursor, reordered, clas_0073) {
        reordered.formIndex(before: &cursor)
      }
      reordered.insert(scalar, at: cursor)
    }
  }
  return reordered
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
  public func hash(into hasher: inout Hasher) {
    if_0020most_0020efficient_002C_0020hash_0020key_0020_0028_0029_0020with_0020_0028_0029_0020by_0020iteration_003AUnicode_0020scalars_003Ahasher_003A(self, &hasher)
  }
}

extension String.UnicodeScalarView {
  func isOrderedCanonically() -> Bool {
    var previous: Unicode.CanonicalCombiningClass = .notReordered
    for scalar in self {
      let clas_0073: Unicode.CanonicalCombiningClass = scalar.combiningClass
      if clas_0073 != .notReordered {
        if clas_0073 < previous {
          return false
        }
      }
      previous = clas_0073
    }
    return true
  }
}

extension String.UnicodeScalarView {
  mutating func reorderCanonically() {
    if self.isOrderedCanonically() {
      return
    }
    self = _0028_0029_0020reordered_0020canonically_002C_0020skipping_0020necessity_0020check_003AUnicode_0020scalars_003AUnicode_0020scalars(self)
  }
}

extension UInt64 {
  static var arithmeticZero: UInt64 {
    return 0
  }
}

extension UInt64 {
  static var one: UInt64 {
    return 1
  }
}

fileprivate func canonical_0020combining_0020class_0020of_0020_0028_0029_003AUnicode_0020scalar_0020numerical_0020value_003A8_2010bit_0020natural_0020number(_ scalar: UInt32) -> UInt8 {
  if scalar <= 0x02FF {
    return 0
  }
  if scalar <= 0x0314 {
    return 230
  }
  if scalar <= 0x0315 {
    return 232
  }
  if scalar <= 0x0319 {
    return 220
  }
  if scalar <= 0x031A {
    return 232
  }
  if scalar <= 0x031B {
    return 216
  }
  if scalar <= 0x0320 {
    return 220
  }
  if scalar <= 0x0322 {
    return 202
  }
  if scalar <= 0x0326 {
    return 220
  }
  if scalar <= 0x0328 {
    return 202
  }
  if scalar <= 0x0333 {
    return 220
  }
  if scalar <= 0x0338 {
    return 1
  }
  if scalar <= 0x033C {
    return 220
  }
  if scalar <= 0x0344 {
    return 230
  }
  if scalar <= 0x0345 {
    return 240
  }
  if scalar <= 0x0346 {
    return 230
  }
  if scalar <= 0x0349 {
    return 220
  }
  if scalar <= 0x034C {
    return 230
  }
  if scalar <= 0x034E {
    return 220
  }
  if scalar <= 0x034F {
    return 0
  }
  if scalar <= 0x0352 {
    return 230
  }
  if scalar <= 0x0356 {
    return 220
  }
  if scalar <= 0x0357 {
    return 230
  }
  if scalar <= 0x0358 {
    return 232
  }
  if scalar <= 0x035A {
    return 220
  }
  if scalar <= 0x035B {
    return 230
  }
  if scalar <= 0x035C {
    return 233
  }
  if scalar <= 0x035E {
    return 234
  }
  if scalar <= 0x035F {
    return 233
  }
  if scalar <= 0x0361 {
    return 234
  }
  if scalar <= 0x0362 {
    return 233
  }
  if scalar <= 0x036F {
    return 230
  }
  if scalar <= 0x0482 {
    return 0
  }
  if scalar <= 0x0487 {
    return 230
  }
  if scalar <= 0x0590 {
    return 0
  }
  if scalar <= 0x0591 {
    return 220
  }
  if scalar <= 0x0595 {
    return 230
  }
  if scalar <= 0x0596 {
    return 220
  }
  if scalar <= 0x0599 {
    return 230
  }
  if scalar <= 0x059A {
    return 222
  }
  if scalar <= 0x059B {
    return 220
  }
  if scalar <= 0x05A1 {
    return 230
  }
  if scalar <= 0x05A7 {
    return 220
  }
  if scalar <= 0x05A9 {
    return 230
  }
  if scalar <= 0x05AA {
    return 220
  }
  if scalar <= 0x05AC {
    return 230
  }
  if scalar <= 0x05AD {
    return 222
  }
  if scalar <= 0x05AE {
    return 228
  }
  if scalar <= 0x05AF {
    return 230
  }
  if scalar <= 0x05B0 {
    return 10
  }
  if scalar <= 0x05B1 {
    return 11
  }
  if scalar <= 0x05B2 {
    return 12
  }
  if scalar <= 0x05B3 {
    return 13
  }
  if scalar <= 0x05B4 {
    return 14
  }
  if scalar <= 0x05B5 {
    return 15
  }
  if scalar <= 0x05B6 {
    return 16
  }
  if scalar <= 0x05B7 {
    return 17
  }
  if scalar <= 0x05B8 {
    return 18
  }
  if scalar <= 0x05BA {
    return 19
  }
  if scalar <= 0x05BB {
    return 20
  }
  if scalar <= 0x05BC {
    return 21
  }
  if scalar <= 0x05BD {
    return 22
  }
  if scalar <= 0x05BE {
    return 0
  }
  if scalar <= 0x05BF {
    return 23
  }
  if scalar <= 0x05C0 {
    return 0
  }
  if scalar <= 0x05C1 {
    return 24
  }
  if scalar <= 0x05C2 {
    return 25
  }
  if scalar <= 0x05C3 {
    return 0
  }
  if scalar <= 0x05C4 {
    return 230
  }
  if scalar <= 0x05C5 {
    return 220
  }
  if scalar <= 0x05C6 {
    return 0
  }
  if scalar <= 0x05C7 {
    return 18
  }
  if scalar <= 0x060F {
    return 0
  }
  if scalar <= 0x0617 {
    return 230
  }
  if scalar <= 0x0618 {
    return 30
  }
  if scalar <= 0x0619 {
    return 31
  }
  if scalar <= 0x061A {
    return 32
  }
  if scalar <= 0x064A {
    return 0
  }
  if scalar <= 0x064B {
    return 27
  }
  if scalar <= 0x064C {
    return 28
  }
  if scalar <= 0x064D {
    return 29
  }
  if scalar <= 0x064E {
    return 30
  }
  if scalar <= 0x064F {
    return 31
  }
  if scalar <= 0x0650 {
    return 32
  }
  if scalar <= 0x0651 {
    return 33
  }
  if scalar <= 0x0652 {
    return 34
  }
  if scalar <= 0x0654 {
    return 230
  }
  if scalar <= 0x0656 {
    return 220
  }
  if scalar <= 0x065B {
    return 230
  }
  if scalar <= 0x065C {
    return 220
  }
  if scalar <= 0x065E {
    return 230
  }
  if scalar <= 0x065F {
    return 220
  }
  if scalar <= 0x066F {
    return 0
  }
  if scalar <= 0x0670 {
    return 35
  }
  if scalar <= 0x06D5 {
    return 0
  }
  if scalar <= 0x06DC {
    return 230
  }
  if scalar <= 0x06DE {
    return 0
  }
  if scalar <= 0x06E2 {
    return 230
  }
  if scalar <= 0x06E3 {
    return 220
  }
  if scalar <= 0x06E4 {
    return 230
  }
  if scalar <= 0x06E6 {
    return 0
  }
  if scalar <= 0x06E8 {
    return 230
  }
  if scalar <= 0x06E9 {
    return 0
  }
  if scalar <= 0x06EA {
    return 220
  }
  if scalar <= 0x06EC {
    return 230
  }
  if scalar <= 0x06ED {
    return 220
  }
  if scalar <= 0x0710 {
    return 0
  }
  if scalar <= 0x0711 {
    return 36
  }
  if scalar <= 0x072F {
    return 0
  }
  if scalar <= 0x0730 {
    return 230
  }
  if scalar <= 0x0731 {
    return 220
  }
  if scalar <= 0x0733 {
    return 230
  }
  if scalar <= 0x0734 {
    return 220
  }
  if scalar <= 0x0736 {
    return 230
  }
  if scalar <= 0x0739 {
    return 220
  }
  if scalar <= 0x073A {
    return 230
  }
  if scalar <= 0x073C {
    return 220
  }
  if scalar <= 0x073D {
    return 230
  }
  if scalar <= 0x073E {
    return 220
  }
  if scalar <= 0x0741 {
    return 230
  }
  if scalar <= 0x0742 {
    return 220
  }
  if scalar <= 0x0743 {
    return 230
  }
  if scalar <= 0x0744 {
    return 220
  }
  if scalar <= 0x0745 {
    return 230
  }
  if scalar <= 0x0746 {
    return 220
  }
  if scalar <= 0x0747 {
    return 230
  }
  if scalar <= 0x0748 {
    return 220
  }
  if scalar <= 0x074A {
    return 230
  }
  if scalar <= 0x07EA {
    return 0
  }
  if scalar <= 0x07F1 {
    return 230
  }
  if scalar <= 0x07F2 {
    return 220
  }
  if scalar <= 0x07F3 {
    return 230
  }
  if scalar <= 0x07FC {
    return 0
  }
  if scalar <= 0x07FD {
    return 220
  }
  if scalar <= 0x0815 {
    return 0
  }
  if scalar <= 0x0819 {
    return 230
  }
  if scalar <= 0x081A {
    return 0
  }
  if scalar <= 0x0823 {
    return 230
  }
  if scalar <= 0x0824 {
    return 0
  }
  if scalar <= 0x0827 {
    return 230
  }
  if scalar <= 0x0828 {
    return 0
  }
  if scalar <= 0x082D {
    return 230
  }
  if scalar <= 0x0858 {
    return 0
  }
  if scalar <= 0x085B {
    return 220
  }
  if scalar <= 0x0896 {
    return 0
  }
  if scalar <= 0x0898 {
    return 230
  }
  if scalar <= 0x089B {
    return 220
  }
  if scalar <= 0x089F {
    return 230
  }
  if scalar <= 0x08C9 {
    return 0
  }
  if scalar <= 0x08CE {
    return 230
  }
  if scalar <= 0x08D3 {
    return 220
  }
  if scalar <= 0x08E1 {
    return 230
  }
  if scalar <= 0x08E2 {
    return 0
  }
  if scalar <= 0x08E3 {
    return 220
  }
  if scalar <= 0x08E5 {
    return 230
  }
  if scalar <= 0x08E6 {
    return 220
  }
  if scalar <= 0x08E8 {
    return 230
  }
  if scalar <= 0x08E9 {
    return 220
  }
  if scalar <= 0x08EC {
    return 230
  }
  if scalar <= 0x08EF {
    return 220
  }
  if scalar <= 0x08F0 {
    return 27
  }
  if scalar <= 0x08F1 {
    return 28
  }
  if scalar <= 0x08F2 {
    return 29
  }
  if scalar <= 0x08F5 {
    return 230
  }
  if scalar <= 0x08F6 {
    return 220
  }
  if scalar <= 0x08F8 {
    return 230
  }
  if scalar <= 0x08FA {
    return 220
  }
  if scalar <= 0x08FF {
    return 230
  }
  if scalar <= 0x093B {
    return 0
  }
  if scalar <= 0x093C {
    return 7
  }
  if scalar <= 0x094C {
    return 0
  }
  if scalar <= 0x094D {
    return 9
  }
  if scalar <= 0x0950 {
    return 0
  }
  if scalar <= 0x0951 {
    return 230
  }
  if scalar <= 0x0952 {
    return 220
  }
  if scalar <= 0x0954 {
    return 230
  }
  if scalar <= 0x09BB {
    return 0
  }
  if scalar <= 0x09BC {
    return 7
  }
  if scalar <= 0x09CC {
    return 0
  }
  if scalar <= 0x09CD {
    return 9
  }
  if scalar <= 0x09FD {
    return 0
  }
  if scalar <= 0x09FE {
    return 230
  }
  if scalar <= 0x0A3B {
    return 0
  }
  if scalar <= 0x0A3C {
    return 7
  }
  if scalar <= 0x0A4C {
    return 0
  }
  if scalar <= 0x0A4D {
    return 9
  }
  if scalar <= 0x0ABB {
    return 0
  }
  if scalar <= 0x0ABC {
    return 7
  }
  if scalar <= 0x0ACC {
    return 0
  }
  if scalar <= 0x0ACD {
    return 9
  }
  if scalar <= 0x0B3B {
    return 0
  }
  if scalar <= 0x0B3C {
    return 7
  }
  if scalar <= 0x0B4C {
    return 0
  }
  if scalar <= 0x0B4D {
    return 9
  }
  if scalar <= 0x0BCC {
    return 0
  }
  if scalar <= 0x0BCD {
    return 9
  }
  if scalar <= 0x0C3B {
    return 0
  }
  if scalar <= 0x0C3C {
    return 7
  }
  if scalar <= 0x0C4C {
    return 0
  }
  if scalar <= 0x0C4D {
    return 9
  }
  if scalar <= 0x0C54 {
    return 0
  }
  if scalar <= 0x0C55 {
    return 84
  }
  if scalar <= 0x0C56 {
    return 91
  }
  if scalar <= 0x0CBB {
    return 0
  }
  if scalar <= 0x0CBC {
    return 7
  }
  if scalar <= 0x0CCC {
    return 0
  }
  if scalar <= 0x0CCD {
    return 9
  }
  if scalar <= 0x0D3A {
    return 0
  }
  if scalar <= 0x0D3C {
    return 9
  }
  if scalar <= 0x0D4C {
    return 0
  }
  if scalar <= 0x0D4D {
    return 9
  }
  if scalar <= 0x0DC9 {
    return 0
  }
  if scalar <= 0x0DCA {
    return 9
  }
  if scalar <= 0x0E37 {
    return 0
  }
  if scalar <= 0x0E39 {
    return 103
  }
  if scalar <= 0x0E3A {
    return 9
  }
  if scalar <= 0x0E47 {
    return 0
  }
  if scalar <= 0x0E4B {
    return 107
  }
  if scalar <= 0x0EB7 {
    return 0
  }
  if scalar <= 0x0EB9 {
    return 118
  }
  if scalar <= 0x0EBA {
    return 9
  }
  if scalar <= 0x0EC7 {
    return 0
  }
  if scalar <= 0x0ECB {
    return 122
  }
  if scalar <= 0x0F17 {
    return 0
  }
  if scalar <= 0x0F19 {
    return 220
  }
  if scalar <= 0x0F34 {
    return 0
  }
  if scalar <= 0x0F35 {
    return 220
  }
  if scalar <= 0x0F36 {
    return 0
  }
  if scalar <= 0x0F37 {
    return 220
  }
  if scalar <= 0x0F38 {
    return 0
  }
  if scalar <= 0x0F39 {
    return 216
  }
  if scalar <= 0x0F70 {
    return 0
  }
  if scalar <= 0x0F71 {
    return 129
  }
  if scalar <= 0x0F72 {
    return 130
  }
  if scalar <= 0x0F73 {
    return 0
  }
  if scalar <= 0x0F74 {
    return 132
  }
  if scalar <= 0x0F79 {
    return 0
  }
  if scalar <= 0x0F7D {
    return 130
  }
  if scalar <= 0x0F7F {
    return 0
  }
  if scalar <= 0x0F80 {
    return 130
  }
  if scalar <= 0x0F81 {
    return 0
  }
  if scalar <= 0x0F83 {
    return 230
  }
  if scalar <= 0x0F84 {
    return 9
  }
  if scalar <= 0x0F85 {
    return 0
  }
  if scalar <= 0x0F87 {
    return 230
  }
  if scalar <= 0x0FC5 {
    return 0
  }
  if scalar <= 0x0FC6 {
    return 220
  }
  if scalar <= 0x1036 {
    return 0
  }
  if scalar <= 0x1037 {
    return 7
  }
  if scalar <= 0x1038 {
    return 0
  }
  if scalar <= 0x103A {
    return 9
  }
  if scalar <= 0x108C {
    return 0
  }
  if scalar <= 0x108D {
    return 220
  }
  if scalar <= 0x135C {
    return 0
  }
  if scalar <= 0x135F {
    return 230
  }
  if scalar <= 0x1713 {
    return 0
  }
  if scalar <= 0x1715 {
    return 9
  }
  if scalar <= 0x1733 {
    return 0
  }
  if scalar <= 0x1734 {
    return 9
  }
  if scalar <= 0x17D1 {
    return 0
  }
  if scalar <= 0x17D2 {
    return 9
  }
  if scalar <= 0x17DC {
    return 0
  }
  if scalar <= 0x17DD {
    return 230
  }
  if scalar <= 0x18A8 {
    return 0
  }
  if scalar <= 0x18A9 {
    return 228
  }
  if scalar <= 0x1938 {
    return 0
  }
  if scalar <= 0x1939 {
    return 222
  }
  if scalar <= 0x193A {
    return 230
  }
  if scalar <= 0x193B {
    return 220
  }
  if scalar <= 0x1A16 {
    return 0
  }
  if scalar <= 0x1A17 {
    return 230
  }
  if scalar <= 0x1A18 {
    return 220
  }
  if scalar <= 0x1A5F {
    return 0
  }
  if scalar <= 0x1A60 {
    return 9
  }
  if scalar <= 0x1A74 {
    return 0
  }
  if scalar <= 0x1A7C {
    return 230
  }
  if scalar <= 0x1A7E {
    return 0
  }
  if scalar <= 0x1A7F {
    return 220
  }
  if scalar <= 0x1AAF {
    return 0
  }
  if scalar <= 0x1AB4 {
    return 230
  }
  if scalar <= 0x1ABA {
    return 220
  }
  if scalar <= 0x1ABC {
    return 230
  }
  if scalar <= 0x1ABD {
    return 220
  }
  if scalar <= 0x1ABE {
    return 0
  }
  if scalar <= 0x1AC0 {
    return 220
  }
  if scalar <= 0x1AC2 {
    return 230
  }
  if scalar <= 0x1AC4 {
    return 220
  }
  if scalar <= 0x1AC9 {
    return 230
  }
  if scalar <= 0x1ACA {
    return 220
  }
  if scalar <= 0x1ADC {
    return 230
  }
  if scalar <= 0x1ADD {
    return 220
  }
  if scalar <= 0x1ADF {
    return 0
  }
  if scalar <= 0x1AE5 {
    return 230
  }
  if scalar <= 0x1AE6 {
    return 220
  }
  if scalar <= 0x1AEA {
    return 230
  }
  if scalar <= 0x1AEB {
    return 234
  }
  if scalar <= 0x1B33 {
    return 0
  }
  if scalar <= 0x1B34 {
    return 7
  }
  if scalar <= 0x1B43 {
    return 0
  }
  if scalar <= 0x1B44 {
    return 9
  }
  if scalar <= 0x1B6A {
    return 0
  }
  if scalar <= 0x1B6B {
    return 230
  }
  if scalar <= 0x1B6C {
    return 220
  }
  if scalar <= 0x1B73 {
    return 230
  }
  if scalar <= 0x1BA9 {
    return 0
  }
  if scalar <= 0x1BAB {
    return 9
  }
  if scalar <= 0x1BE5 {
    return 0
  }
  if scalar <= 0x1BE6 {
    return 7
  }
  if scalar <= 0x1BF1 {
    return 0
  }
  if scalar <= 0x1BF3 {
    return 9
  }
  if scalar <= 0x1C36 {
    return 0
  }
  if scalar <= 0x1C37 {
    return 7
  }
  if scalar <= 0x1CCF {
    return 0
  }
  if scalar <= 0x1CD2 {
    return 230
  }
  if scalar <= 0x1CD3 {
    return 0
  }
  if scalar <= 0x1CD4 {
    return 1
  }
  if scalar <= 0x1CD9 {
    return 220
  }
  if scalar <= 0x1CDB {
    return 230
  }
  if scalar <= 0x1CDF {
    return 220
  }
  if scalar <= 0x1CE0 {
    return 230
  }
  if scalar <= 0x1CE1 {
    return 0
  }
  if scalar <= 0x1CE8 {
    return 1
  }
  if scalar <= 0x1CEC {
    return 0
  }
  if scalar <= 0x1CED {
    return 220
  }
  if scalar <= 0x1CF3 {
    return 0
  }
  if scalar <= 0x1CF4 {
    return 230
  }
  if scalar <= 0x1CF7 {
    return 0
  }
  if scalar <= 0x1CF9 {
    return 230
  }
  if scalar <= 0x1DBF {
    return 0
  }
  if scalar <= 0x1DC1 {
    return 230
  }
  if scalar <= 0x1DC2 {
    return 220
  }
  if scalar <= 0x1DC9 {
    return 230
  }
  if scalar <= 0x1DCA {
    return 220
  }
  if scalar <= 0x1DCC {
    return 230
  }
  if scalar <= 0x1DCD {
    return 234
  }
  if scalar <= 0x1DCE {
    return 214
  }
  if scalar <= 0x1DCF {
    return 220
  }
  if scalar <= 0x1DD0 {
    return 202
  }
  if scalar <= 0x1DF5 {
    return 230
  }
  if scalar <= 0x1DF6 {
    return 232
  }
  if scalar <= 0x1DF8 {
    return 228
  }
  if scalar <= 0x1DF9 {
    return 220
  }
  if scalar <= 0x1DFA {
    return 218
  }
  if scalar <= 0x1DFB {
    return 230
  }
  if scalar <= 0x1DFC {
    return 233
  }
  if scalar <= 0x1DFD {
    return 220
  }
  if scalar <= 0x1DFE {
    return 230
  }
  if scalar <= 0x1DFF {
    return 220
  }
  if scalar <= 0x20CF {
    return 0
  }
  if scalar <= 0x20D1 {
    return 230
  }
  if scalar <= 0x20D3 {
    return 1
  }
  if scalar <= 0x20D7 {
    return 230
  }
  if scalar <= 0x20DA {
    return 1
  }
  if scalar <= 0x20DC {
    return 230
  }
  if scalar <= 0x20E0 {
    return 0
  }
  if scalar <= 0x20E1 {
    return 230
  }
  if scalar <= 0x20E4 {
    return 0
  }
  if scalar <= 0x20E6 {
    return 1
  }
  if scalar <= 0x20E7 {
    return 230
  }
  if scalar <= 0x20E8 {
    return 220
  }
  if scalar <= 0x20E9 {
    return 230
  }
  if scalar <= 0x20EB {
    return 1
  }
  if scalar <= 0x20EF {
    return 220
  }
  if scalar <= 0x20F0 {
    return 230
  }
  if scalar <= 0x2CEE {
    return 0
  }
  if scalar <= 0x2CF1 {
    return 230
  }
  if scalar <= 0x2D7E {
    return 0
  }
  if scalar <= 0x2D7F {
    return 9
  }
  if scalar <= 0x2DDF {
    return 0
  }
  if scalar <= 0x2DFF {
    return 230
  }
  if scalar <= 0x3029 {
    return 0
  }
  if scalar <= 0x302A {
    return 218
  }
  if scalar <= 0x302B {
    return 228
  }
  if scalar <= 0x302C {
    return 232
  }
  if scalar <= 0x302D {
    return 222
  }
  if scalar <= 0x302F {
    return 224
  }
  if scalar <= 0x3098 {
    return 0
  }
  if scalar <= 0x309A {
    return 8
  }
  if scalar <= 0xA66E {
    return 0
  }
  if scalar <= 0xA66F {
    return 230
  }
  if scalar <= 0xA673 {
    return 0
  }
  if scalar <= 0xA67D {
    return 230
  }
  if scalar <= 0xA69D {
    return 0
  }
  if scalar <= 0xA69F {
    return 230
  }
  if scalar <= 0xA6EF {
    return 0
  }
  if scalar <= 0xA6F1 {
    return 230
  }
  if scalar <= 0xA805 {
    return 0
  }
  if scalar <= 0xA806 {
    return 9
  }
  if scalar <= 0xA82B {
    return 0
  }
  if scalar <= 0xA82C {
    return 9
  }
  if scalar <= 0xA8C3 {
    return 0
  }
  if scalar <= 0xA8C4 {
    return 9
  }
  if scalar <= 0xA8DF {
    return 0
  }
  if scalar <= 0xA8F1 {
    return 230
  }
  if scalar <= 0xA92A {
    return 0
  }
  if scalar <= 0xA92D {
    return 220
  }
  if scalar <= 0xA952 {
    return 0
  }
  if scalar <= 0xA953 {
    return 9
  }
  if scalar <= 0xA9B2 {
    return 0
  }
  if scalar <= 0xA9B3 {
    return 7
  }
  if scalar <= 0xA9BF {
    return 0
  }
  if scalar <= 0xA9C0 {
    return 9
  }
  if scalar <= 0xAAAF {
    return 0
  }
  if scalar <= 0xAAB0 {
    return 230
  }
  if scalar <= 0xAAB1 {
    return 0
  }
  if scalar <= 0xAAB3 {
    return 230
  }
  if scalar <= 0xAAB4 {
    return 220
  }
  if scalar <= 0xAAB6 {
    return 0
  }
  if scalar <= 0xAAB8 {
    return 230
  }
  if scalar <= 0xAABD {
    return 0
  }
  if scalar <= 0xAABF {
    return 230
  }
  if scalar <= 0xAAC0 {
    return 0
  }
  if scalar <= 0xAAC1 {
    return 230
  }
  if scalar <= 0xAAF5 {
    return 0
  }
  if scalar <= 0xAAF6 {
    return 9
  }
  if scalar <= 0xABEC {
    return 0
  }
  if scalar <= 0xABED {
    return 9
  }
  if scalar <= 0xFB1D {
    return 0
  }
  if scalar <= 0xFB1E {
    return 26
  }
  if scalar <= 0xFE1F {
    return 0
  }
  if scalar <= 0xFE26 {
    return 230
  }
  if scalar <= 0xFE2D {
    return 220
  }
  if scalar <= 0xFE2F {
    return 230
  }
  if scalar <= 0x101FC {
    return 0
  }
  if scalar <= 0x101FD {
    return 220
  }
  if scalar <= 0x102DF {
    return 0
  }
  if scalar <= 0x102E0 {
    return 220
  }
  if scalar <= 0x10375 {
    return 0
  }
  if scalar <= 0x1037A {
    return 230
  }
  if scalar <= 0x10A0C {
    return 0
  }
  if scalar <= 0x10A0D {
    return 220
  }
  if scalar <= 0x10A0E {
    return 0
  }
  if scalar <= 0x10A0F {
    return 230
  }
  if scalar <= 0x10A37 {
    return 0
  }
  if scalar <= 0x10A38 {
    return 230
  }
  if scalar <= 0x10A39 {
    return 1
  }
  if scalar <= 0x10A3A {
    return 220
  }
  if scalar <= 0x10A3E {
    return 0
  }
  if scalar <= 0x10A3F {
    return 9
  }
  if scalar <= 0x10AE4 {
    return 0
  }
  if scalar <= 0x10AE5 {
    return 230
  }
  if scalar <= 0x10AE6 {
    return 220
  }
  if scalar <= 0x10D23 {
    return 0
  }
  if scalar <= 0x10D27 {
    return 230
  }
  if scalar <= 0x10D68 {
    return 0
  }
  if scalar <= 0x10D6D {
    return 230
  }
  if scalar <= 0x10EAA {
    return 0
  }
  if scalar <= 0x10EAC {
    return 230
  }
  if scalar <= 0x10EF9 {
    return 0
  }
  if scalar <= 0x10EFB {
    return 220
  }
  if scalar <= 0x10EFC {
    return 0
  }
  if scalar <= 0x10EFF {
    return 220
  }
  if scalar <= 0x10F45 {
    return 0
  }
  if scalar <= 0x10F47 {
    return 220
  }
  if scalar <= 0x10F4A {
    return 230
  }
  if scalar <= 0x10F4B {
    return 220
  }
  if scalar <= 0x10F4C {
    return 230
  }
  if scalar <= 0x10F50 {
    return 220
  }
  if scalar <= 0x10F81 {
    return 0
  }
  if scalar <= 0x10F82 {
    return 230
  }
  if scalar <= 0x10F83 {
    return 220
  }
  if scalar <= 0x10F84 {
    return 230
  }
  if scalar <= 0x10F85 {
    return 220
  }
  if scalar <= 0x11045 {
    return 0
  }
  if scalar <= 0x11046 {
    return 9
  }
  if scalar <= 0x1106F {
    return 0
  }
  if scalar <= 0x11070 {
    return 9
  }
  if scalar <= 0x1107E {
    return 0
  }
  if scalar <= 0x1107F {
    return 9
  }
  if scalar <= 0x110B8 {
    return 0
  }
  if scalar <= 0x110B9 {
    return 9
  }
  if scalar <= 0x110BA {
    return 7
  }
  if scalar <= 0x110FF {
    return 0
  }
  if scalar <= 0x11102 {
    return 230
  }
  if scalar <= 0x11132 {
    return 0
  }
  if scalar <= 0x11134 {
    return 9
  }
  if scalar <= 0x11172 {
    return 0
  }
  if scalar <= 0x11173 {
    return 7
  }
  if scalar <= 0x111BF {
    return 0
  }
  if scalar <= 0x111C0 {
    return 9
  }
  if scalar <= 0x111C9 {
    return 0
  }
  if scalar <= 0x111CA {
    return 7
  }
  if scalar <= 0x11234 {
    return 0
  }
  if scalar <= 0x11235 {
    return 9
  }
  if scalar <= 0x11236 {
    return 7
  }
  if scalar <= 0x112E8 {
    return 0
  }
  if scalar <= 0x112E9 {
    return 7
  }
  if scalar <= 0x112EA {
    return 9
  }
  if scalar <= 0x1133A {
    return 0
  }
  if scalar <= 0x1133C {
    return 7
  }
  if scalar <= 0x1134C {
    return 0
  }
  if scalar <= 0x1134D {
    return 9
  }
  if scalar <= 0x11365 {
    return 0
  }
  if scalar <= 0x1136C {
    return 230
  }
  if scalar <= 0x1136F {
    return 0
  }
  if scalar <= 0x11374 {
    return 230
  }
  if scalar <= 0x113CD {
    return 0
  }
  if scalar <= 0x113D0 {
    return 9
  }
  if scalar <= 0x11441 {
    return 0
  }
  if scalar <= 0x11442 {
    return 9
  }
  if scalar <= 0x11445 {
    return 0
  }
  if scalar <= 0x11446 {
    return 7
  }
  if scalar <= 0x1145D {
    return 0
  }
  if scalar <= 0x1145E {
    return 230
  }
  if scalar <= 0x114C1 {
    return 0
  }
  if scalar <= 0x114C2 {
    return 9
  }
  if scalar <= 0x114C3 {
    return 7
  }
  if scalar <= 0x115BE {
    return 0
  }
  if scalar <= 0x115BF {
    return 9
  }
  if scalar <= 0x115C0 {
    return 7
  }
  if scalar <= 0x1163E {
    return 0
  }
  if scalar <= 0x1163F {
    return 9
  }
  if scalar <= 0x116B5 {
    return 0
  }
  if scalar <= 0x116B6 {
    return 9
  }
  if scalar <= 0x116B7 {
    return 7
  }
  if scalar <= 0x1172A {
    return 0
  }
  if scalar <= 0x1172B {
    return 9
  }
  if scalar <= 0x11838 {
    return 0
  }
  if scalar <= 0x11839 {
    return 9
  }
  if scalar <= 0x1183A {
    return 7
  }
  if scalar <= 0x1193C {
    return 0
  }
  if scalar <= 0x1193E {
    return 9
  }
  if scalar <= 0x11942 {
    return 0
  }
  if scalar <= 0x11943 {
    return 7
  }
  if scalar <= 0x119DF {
    return 0
  }
  if scalar <= 0x119E0 {
    return 9
  }
  if scalar <= 0x11A33 {
    return 0
  }
  if scalar <= 0x11A34 {
    return 9
  }
  if scalar <= 0x11A46 {
    return 0
  }
  if scalar <= 0x11A47 {
    return 9
  }
  if scalar <= 0x11A98 {
    return 0
  }
  if scalar <= 0x11A99 {
    return 9
  }
  if scalar <= 0x11C3E {
    return 0
  }
  if scalar <= 0x11C3F {
    return 9
  }
  if scalar <= 0x11D41 {
    return 0
  }
  if scalar <= 0x11D42 {
    return 7
  }
  if scalar <= 0x11D43 {
    return 0
  }
  if scalar <= 0x11D45 {
    return 9
  }
  if scalar <= 0x11D96 {
    return 0
  }
  if scalar <= 0x11D97 {
    return 9
  }
  if scalar <= 0x11F40 {
    return 0
  }
  if scalar <= 0x11F42 {
    return 9
  }
  if scalar <= 0x1612E {
    return 0
  }
  if scalar <= 0x1612F {
    return 9
  }
  if scalar <= 0x16AEF {
    return 0
  }
  if scalar <= 0x16AF4 {
    return 1
  }
  if scalar <= 0x16B2F {
    return 0
  }
  if scalar <= 0x16B36 {
    return 230
  }
  if scalar <= 0x16FEF {
    return 0
  }
  if scalar <= 0x16FF1 {
    return 6
  }
  if scalar <= 0x1BC9D {
    return 0
  }
  if scalar <= 0x1BC9E {
    return 1
  }
  if scalar <= 0x1D164 {
    return 0
  }
  if scalar <= 0x1D166 {
    return 216
  }
  if scalar <= 0x1D169 {
    return 1
  }
  if scalar <= 0x1D16C {
    return 0
  }
  if scalar <= 0x1D16D {
    return 226
  }
  if scalar <= 0x1D172 {
    return 216
  }
  if scalar <= 0x1D17A {
    return 0
  }
  if scalar <= 0x1D182 {
    return 220
  }
  if scalar <= 0x1D184 {
    return 0
  }
  if scalar <= 0x1D189 {
    return 230
  }
  if scalar <= 0x1D18B {
    return 220
  }
  if scalar <= 0x1D1A9 {
    return 0
  }
  if scalar <= 0x1D1AD {
    return 230
  }
  if scalar <= 0x1D241 {
    return 0
  }
  if scalar <= 0x1D244 {
    return 230
  }
  if scalar <= 0x1DFFF {
    return 0
  }
  if scalar <= 0x1E006 {
    return 230
  }
  if scalar <= 0x1E007 {
    return 0
  }
  if scalar <= 0x1E018 {
    return 230
  }
  if scalar <= 0x1E01A {
    return 0
  }
  if scalar <= 0x1E021 {
    return 230
  }
  if scalar <= 0x1E022 {
    return 0
  }
  if scalar <= 0x1E024 {
    return 230
  }
  if scalar <= 0x1E025 {
    return 0
  }
  if scalar <= 0x1E02A {
    return 230
  }
  if scalar <= 0x1E08E {
    return 0
  }
  if scalar <= 0x1E08F {
    return 230
  }
  if scalar <= 0x1E12F {
    return 0
  }
  if scalar <= 0x1E136 {
    return 230
  }
  if scalar <= 0x1E2AD {
    return 0
  }
  if scalar <= 0x1E2AE {
    return 230
  }
  if scalar <= 0x1E2EB {
    return 0
  }
  if scalar <= 0x1E2EF {
    return 230
  }
  if scalar <= 0x1E4EB {
    return 0
  }
  if scalar <= 0x1E4ED {
    return 232
  }
  if scalar <= 0x1E4EE {
    return 220
  }
  if scalar <= 0x1E4EF {
    return 230
  }
  if scalar <= 0x1E5ED {
    return 0
  }
  if scalar <= 0x1E5EE {
    return 230
  }
  if scalar <= 0x1E5EF {
    return 220
  }
  if scalar <= 0x1E6E2 {
    return 0
  }
  if scalar <= 0x1E6E3 {
    return 230
  }
  if scalar <= 0x1E6E5 {
    return 0
  }
  if scalar <= 0x1E6E6 {
    return 230
  }
  if scalar <= 0x1E6ED {
    return 0
  }
  if scalar <= 0x1E6EF {
    return 230
  }
  if scalar <= 0x1E6F4 {
    return 0
  }
  if scalar <= 0x1E6F5 {
    return 230
  }
  if scalar <= 0x1E8CF {
    return 0
  }
  if scalar <= 0x1E8D6 {
    return 220
  }
  if scalar <= 0x1E943 {
    return 0
  }
  if scalar <= 0x1E949 {
    return 230
  }
  if scalar <= 0x1E94A {
    return 7
  }
  return 0
}

extension Unicode.Scalar {
  var combiningClass: Unicode.CanonicalCombiningClass {
    return Unicode.CanonicalCombiningClass(rawValue: canonical_0020combining_0020class_0020of_0020_0028_0029_003AUnicode_0020scalar_0020numerical_0020value_003A8_2010bit_0020natural_0020number((self).value))
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

fileprivate func if_0020most_0020efficient_002C_0020hash_0020key_0020_0028_0029_0020with_0020_0028_0029_0020by_0020iteration_003AUnicode_0020scalars_003Ahasher_003A(_ key: String.UnicodeScalarView, _ hasher: inout Hasher) {
  for scalar in key {
    hasher.combine(scalar)
  }
}

extension String.UnicodeScalarView {
  func indexSkippingBoundsCheck(beforeBoundary boundary: String.UnicodeScalarView.Index) -> String.UnicodeScalarView.Index {
    return self.index(before: boundary)
  }
}

extension String.UnicodeScalarView {
  func entryIndex(beforeBoundary boundary: String.UnicodeScalarView.Index) -> String.UnicodeScalarView.Index? {
    if boundary > self.startIndex {
      return self.indexSkippingBoundsCheck(beforeBoundary: boundary)
    }
    return nil
  }
}

extension UnicodeText {
  static var empty: UnicodeText {
    return UnicodeText(skippingNormalizationOf: "".unicodeScalars)
  }
}

fileprivate func scalar_0020after_0020_0028_0029_0020in_0020_0028_0029_0020is_0020reordrant_003AUnicode_0020scalar_0020boundary_003AUnicodeText_003Aערך_0020אמת(_ cursor: String.UnicodeScalarView.Index, _ text: UnicodeText) -> Bool {
  if let index = text.entryIndex(afterBoundary: cursor) {
    return text[entryIndex: index].combiningClass != .notReordered
  }
  return false
}

fileprivate func scalar_0020before_0020_0028_0029_0020in_0020_0028_0029_0020belongs_0020after_0020_0028_0029_003AUnicode_0020scalar_0020boundary_003AUnicode_0020scalars_003AUnicodeCombiningClass_003Aערך_0020אמת(_ cursor: String.UnicodeScalarView.Index, _ scalars: String.UnicodeScalarView, _ clas_0073: Unicode.CanonicalCombiningClass) -> Bool {
  if let previous = scalars.entryIndex(beforeBoundary: cursor) {
    return scalars[previous].combiningClass > clas_0073
  }
  return false
}

fileprivate func scalar_0020before_0020_0028_0029_0020in_0020_0028_0029_0020is_0020reordrant_003AUnicode_0020scalar_0020boundary_003AUnicodeText_003Aערך_0020אמת(_ cursor: String.UnicodeScalarView.Index, _ text: UnicodeText) -> Bool {
  if let index = text.entryIndex(beforeBoundary: cursor) {
    return text[entryIndex: index].combiningClass != .notReordered
  }
  return false
}

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

fileprivate func before_0020end_0020of_0020segment_0020before_0020_0028_0029_0020in_0020_0028_0029_002C_0020skipping_0020bounds_0020check_003Alist_0020boundary_003AUnicodeSegments_003AUnicodeSegments_002EBoundary(_ segment_0020cursor: Int, _ list: UnicodeSegments) -> UnicodeSegments.Boundary {
  let segment_0020list: [Unicode_0020segment] = list.segments
  let beginning_0020of_0020previous_0020segment: Int = segment_0020list.index(before: segment_0020cursor)
  let segment: UnicodeText = segment_0020list[beginning_0020of_0020previous_0020segment].source
  return UnicodeSegments.Boundary(beginning_0020of_0020previous_0020segment, segment.boundary(beforeBoundary: segment.endIndex))
}

fileprivate func parse_0020line_0020in_0020_0028_0029_0020from_0020_0028_0029_0020to_0020_0028_0029_0020into_0020_0028_0029_003AGitStyleSayingSource_003A_0028_003Aoptional_0020_0028_0029_003AGit_2010style_0020parsing_0020cursor_003A_0029_003AGit_2010style_0020parsing_0020cursor_003A_0028_003Alist_0020of_0020_0028_0029_003AUnicode_0020segment_003A_0029_003A(_ source: GitStyleSayingSource, _ beginning: inout Git_2010style_0020parsing_0020cursor?, _ end: Git_2010style_0020parsing_0020cursor, _ segments: inout [Unicode_0020segment]) {
  if let start = beginning {
    var adjusted_0020offset: UInt64 = start.offset
    var segment: Slice<UnicodeText> = Slice(base: source.code, bounds: start.cursor ..< end.cursor)
    while segment.first == " " as Unicode.Scalar {
      segment.removeFirst()
      adjusted_0020offset += .one
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
  var beginning: Git_2010style_0020parsing_0020cursor? = Git_2010style_0020parsing_0020cursor(source_0020text.startIndex, .arithmeticZero) as Git_2010style_0020parsing_0020cursor?
  let end: Git_2010style_0020parsing_0020cursor = Git_2010style_0020parsing_0020cursor(source_0020text.endIndex, .one)
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
