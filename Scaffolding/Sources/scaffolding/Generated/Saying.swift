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
  if scalar < 0x0300 {
    return 0
  }
  if scalar < 0x0315 {
    return 230
  }
  if scalar < 0x0316 {
    return 232
  }
  if scalar < 0x031A {
    return 220
  }
  if scalar < 0x031B {
    return 232
  }
  if scalar < 0x031C {
    return 216
  }
  if scalar < 0x0321 {
    return 220
  }
  if scalar < 0x0323 {
    return 202
  }
  if scalar < 0x0327 {
    return 220
  }
  if scalar < 0x0329 {
    return 202
  }
  if scalar < 0x0334 {
    return 220
  }
  if scalar < 0x0339 {
    return 1
  }
  if scalar < 0x033D {
    return 220
  }
  if scalar < 0x0345 {
    return 230
  }
  if scalar < 0x0346 {
    return 240
  }
  if scalar < 0x0347 {
    return 230
  }
  if scalar < 0x034A {
    return 220
  }
  if scalar < 0x034D {
    return 230
  }
  if scalar < 0x034F {
    return 220
  }
  if scalar < 0x0350 {
    return 0
  }
  if scalar < 0x0353 {
    return 230
  }
  if scalar < 0x0357 {
    return 220
  }
  if scalar < 0x0358 {
    return 230
  }
  if scalar < 0x0359 {
    return 232
  }
  if scalar < 0x035B {
    return 220
  }
  if scalar < 0x035C {
    return 230
  }
  if scalar < 0x035D {
    return 233
  }
  if scalar < 0x035F {
    return 234
  }
  if scalar < 0x0360 {
    return 233
  }
  if scalar < 0x0362 {
    return 234
  }
  if scalar < 0x0363 {
    return 233
  }
  if scalar < 0x0370 {
    return 230
  }
  if scalar < 0x0483 {
    return 0
  }
  if scalar < 0x0488 {
    return 230
  }
  if scalar < 0x0591 {
    return 0
  }
  if scalar < 0x0592 {
    return 220
  }
  if scalar < 0x0596 {
    return 230
  }
  if scalar < 0x0597 {
    return 220
  }
  if scalar < 0x059A {
    return 230
  }
  if scalar < 0x059B {
    return 222
  }
  if scalar < 0x059C {
    return 220
  }
  if scalar < 0x05A2 {
    return 230
  }
  if scalar < 0x05A8 {
    return 220
  }
  if scalar < 0x05AA {
    return 230
  }
  if scalar < 0x05AB {
    return 220
  }
  if scalar < 0x05AD {
    return 230
  }
  if scalar < 0x05AE {
    return 222
  }
  if scalar < 0x05AF {
    return 228
  }
  if scalar < 0x05B0 {
    return 230
  }
  if scalar < 0x05B1 {
    return 10
  }
  if scalar < 0x05B2 {
    return 11
  }
  if scalar < 0x05B3 {
    return 12
  }
  if scalar < 0x05B4 {
    return 13
  }
  if scalar < 0x05B5 {
    return 14
  }
  if scalar < 0x05B6 {
    return 15
  }
  if scalar < 0x05B7 {
    return 16
  }
  if scalar < 0x05B8 {
    return 17
  }
  if scalar < 0x05B9 {
    return 18
  }
  if scalar < 0x05BB {
    return 19
  }
  if scalar < 0x05BC {
    return 20
  }
  if scalar < 0x05BD {
    return 21
  }
  if scalar < 0x05BE {
    return 22
  }
  if scalar < 0x05BF {
    return 0
  }
  if scalar < 0x05C0 {
    return 23
  }
  if scalar < 0x05C1 {
    return 0
  }
  if scalar < 0x05C2 {
    return 24
  }
  if scalar < 0x05C3 {
    return 25
  }
  if scalar < 0x05C4 {
    return 0
  }
  if scalar < 0x05C5 {
    return 230
  }
  if scalar < 0x05C6 {
    return 220
  }
  if scalar < 0x05C7 {
    return 0
  }
  if scalar < 0x05C8 {
    return 18
  }
  if scalar < 0x0610 {
    return 0
  }
  if scalar < 0x0618 {
    return 230
  }
  if scalar < 0x0619 {
    return 30
  }
  if scalar < 0x061A {
    return 31
  }
  if scalar < 0x061B {
    return 32
  }
  if scalar < 0x064B {
    return 0
  }
  if scalar < 0x064C {
    return 27
  }
  if scalar < 0x064D {
    return 28
  }
  if scalar < 0x064E {
    return 29
  }
  if scalar < 0x064F {
    return 30
  }
  if scalar < 0x0650 {
    return 31
  }
  if scalar < 0x0651 {
    return 32
  }
  if scalar < 0x0652 {
    return 33
  }
  if scalar < 0x0653 {
    return 34
  }
  if scalar < 0x0655 {
    return 230
  }
  if scalar < 0x0657 {
    return 220
  }
  if scalar < 0x065C {
    return 230
  }
  if scalar < 0x065D {
    return 220
  }
  if scalar < 0x065F {
    return 230
  }
  if scalar < 0x0660 {
    return 220
  }
  if scalar < 0x0670 {
    return 0
  }
  if scalar < 0x0671 {
    return 35
  }
  if scalar < 0x06D6 {
    return 0
  }
  if scalar < 0x06DD {
    return 230
  }
  if scalar < 0x06DF {
    return 0
  }
  if scalar < 0x06E3 {
    return 230
  }
  if scalar < 0x06E4 {
    return 220
  }
  if scalar < 0x06E5 {
    return 230
  }
  if scalar < 0x06E7 {
    return 0
  }
  if scalar < 0x06E9 {
    return 230
  }
  if scalar < 0x06EA {
    return 0
  }
  if scalar < 0x06EB {
    return 220
  }
  if scalar < 0x06ED {
    return 230
  }
  if scalar < 0x06EE {
    return 220
  }
  if scalar < 0x0711 {
    return 0
  }
  if scalar < 0x0712 {
    return 36
  }
  if scalar < 0x0730 {
    return 0
  }
  if scalar < 0x0731 {
    return 230
  }
  if scalar < 0x0732 {
    return 220
  }
  if scalar < 0x0734 {
    return 230
  }
  if scalar < 0x0735 {
    return 220
  }
  if scalar < 0x0737 {
    return 230
  }
  if scalar < 0x073A {
    return 220
  }
  if scalar < 0x073B {
    return 230
  }
  if scalar < 0x073D {
    return 220
  }
  if scalar < 0x073E {
    return 230
  }
  if scalar < 0x073F {
    return 220
  }
  if scalar < 0x0742 {
    return 230
  }
  if scalar < 0x0743 {
    return 220
  }
  if scalar < 0x0744 {
    return 230
  }
  if scalar < 0x0745 {
    return 220
  }
  if scalar < 0x0746 {
    return 230
  }
  if scalar < 0x0747 {
    return 220
  }
  if scalar < 0x0748 {
    return 230
  }
  if scalar < 0x0749 {
    return 220
  }
  if scalar < 0x074B {
    return 230
  }
  if scalar < 0x07EB {
    return 0
  }
  if scalar < 0x07F2 {
    return 230
  }
  if scalar < 0x07F3 {
    return 220
  }
  if scalar < 0x07F4 {
    return 230
  }
  if scalar < 0x07FD {
    return 0
  }
  if scalar < 0x07FE {
    return 220
  }
  if scalar < 0x0816 {
    return 0
  }
  if scalar < 0x081A {
    return 230
  }
  if scalar < 0x081B {
    return 0
  }
  if scalar < 0x0824 {
    return 230
  }
  if scalar < 0x0825 {
    return 0
  }
  if scalar < 0x0828 {
    return 230
  }
  if scalar < 0x0829 {
    return 0
  }
  if scalar < 0x082E {
    return 230
  }
  if scalar < 0x0859 {
    return 0
  }
  if scalar < 0x085C {
    return 220
  }
  if scalar < 0x0897 {
    return 0
  }
  if scalar < 0x0899 {
    return 230
  }
  if scalar < 0x089C {
    return 220
  }
  if scalar < 0x08A0 {
    return 230
  }
  if scalar < 0x08CA {
    return 0
  }
  if scalar < 0x08CF {
    return 230
  }
  if scalar < 0x08D4 {
    return 220
  }
  if scalar < 0x08E2 {
    return 230
  }
  if scalar < 0x08E3 {
    return 0
  }
  if scalar < 0x08E4 {
    return 220
  }
  if scalar < 0x08E6 {
    return 230
  }
  if scalar < 0x08E7 {
    return 220
  }
  if scalar < 0x08E9 {
    return 230
  }
  if scalar < 0x08EA {
    return 220
  }
  if scalar < 0x08ED {
    return 230
  }
  if scalar < 0x08F0 {
    return 220
  }
  if scalar < 0x08F1 {
    return 27
  }
  if scalar < 0x08F2 {
    return 28
  }
  if scalar < 0x08F3 {
    return 29
  }
  if scalar < 0x08F6 {
    return 230
  }
  if scalar < 0x08F7 {
    return 220
  }
  if scalar < 0x08F9 {
    return 230
  }
  if scalar < 0x08FB {
    return 220
  }
  if scalar < 0x0900 {
    return 230
  }
  if scalar < 0x093C {
    return 0
  }
  if scalar < 0x093D {
    return 7
  }
  if scalar < 0x094D {
    return 0
  }
  if scalar < 0x094E {
    return 9
  }
  if scalar < 0x0951 {
    return 0
  }
  if scalar < 0x0952 {
    return 230
  }
  if scalar < 0x0953 {
    return 220
  }
  if scalar < 0x0955 {
    return 230
  }
  if scalar < 0x09BC {
    return 0
  }
  if scalar < 0x09BD {
    return 7
  }
  if scalar < 0x09CD {
    return 0
  }
  if scalar < 0x09CE {
    return 9
  }
  if scalar < 0x09FE {
    return 0
  }
  if scalar < 0x09FF {
    return 230
  }
  if scalar < 0x0A3C {
    return 0
  }
  if scalar < 0x0A3D {
    return 7
  }
  if scalar < 0x0A4D {
    return 0
  }
  if scalar < 0x0A4E {
    return 9
  }
  if scalar < 0x0ABC {
    return 0
  }
  if scalar < 0x0ABD {
    return 7
  }
  if scalar < 0x0ACD {
    return 0
  }
  if scalar < 0x0ACE {
    return 9
  }
  if scalar < 0x0B3C {
    return 0
  }
  if scalar < 0x0B3D {
    return 7
  }
  if scalar < 0x0B4D {
    return 0
  }
  if scalar < 0x0B4E {
    return 9
  }
  if scalar < 0x0BCD {
    return 0
  }
  if scalar < 0x0BCE {
    return 9
  }
  if scalar < 0x0C3C {
    return 0
  }
  if scalar < 0x0C3D {
    return 7
  }
  if scalar < 0x0C4D {
    return 0
  }
  if scalar < 0x0C4E {
    return 9
  }
  if scalar < 0x0C55 {
    return 0
  }
  if scalar < 0x0C56 {
    return 84
  }
  if scalar < 0x0C57 {
    return 91
  }
  if scalar < 0x0CBC {
    return 0
  }
  if scalar < 0x0CBD {
    return 7
  }
  if scalar < 0x0CCD {
    return 0
  }
  if scalar < 0x0CCE {
    return 9
  }
  if scalar < 0x0D3B {
    return 0
  }
  if scalar < 0x0D3D {
    return 9
  }
  if scalar < 0x0D4D {
    return 0
  }
  if scalar < 0x0D4E {
    return 9
  }
  if scalar < 0x0DCA {
    return 0
  }
  if scalar < 0x0DCB {
    return 9
  }
  if scalar < 0x0E38 {
    return 0
  }
  if scalar < 0x0E3A {
    return 103
  }
  if scalar < 0x0E3B {
    return 9
  }
  if scalar < 0x0E48 {
    return 0
  }
  if scalar < 0x0E4C {
    return 107
  }
  if scalar < 0x0EB8 {
    return 0
  }
  if scalar < 0x0EBA {
    return 118
  }
  if scalar < 0x0EBB {
    return 9
  }
  if scalar < 0x0EC8 {
    return 0
  }
  if scalar < 0x0ECC {
    return 122
  }
  if scalar < 0x0F18 {
    return 0
  }
  if scalar < 0x0F1A {
    return 220
  }
  if scalar < 0x0F35 {
    return 0
  }
  if scalar < 0x0F36 {
    return 220
  }
  if scalar < 0x0F37 {
    return 0
  }
  if scalar < 0x0F38 {
    return 220
  }
  if scalar < 0x0F39 {
    return 0
  }
  if scalar < 0x0F3A {
    return 216
  }
  if scalar < 0x0F71 {
    return 0
  }
  if scalar < 0x0F72 {
    return 129
  }
  if scalar < 0x0F73 {
    return 130
  }
  if scalar < 0x0F74 {
    return 0
  }
  if scalar < 0x0F75 {
    return 132
  }
  if scalar < 0x0F7A {
    return 0
  }
  if scalar < 0x0F7E {
    return 130
  }
  if scalar < 0x0F80 {
    return 0
  }
  if scalar < 0x0F81 {
    return 130
  }
  if scalar < 0x0F82 {
    return 0
  }
  if scalar < 0x0F84 {
    return 230
  }
  if scalar < 0x0F85 {
    return 9
  }
  if scalar < 0x0F86 {
    return 0
  }
  if scalar < 0x0F88 {
    return 230
  }
  if scalar < 0x0FC6 {
    return 0
  }
  if scalar < 0x0FC7 {
    return 220
  }
  if scalar < 0x1037 {
    return 0
  }
  if scalar < 0x1038 {
    return 7
  }
  if scalar < 0x1039 {
    return 0
  }
  if scalar < 0x103B {
    return 9
  }
  if scalar < 0x108D {
    return 0
  }
  if scalar < 0x108E {
    return 220
  }
  if scalar < 0x135D {
    return 0
  }
  if scalar < 0x1360 {
    return 230
  }
  if scalar < 0x1714 {
    return 0
  }
  if scalar < 0x1716 {
    return 9
  }
  if scalar < 0x1734 {
    return 0
  }
  if scalar < 0x1735 {
    return 9
  }
  if scalar < 0x17D2 {
    return 0
  }
  if scalar < 0x17D3 {
    return 9
  }
  if scalar < 0x17DD {
    return 0
  }
  if scalar < 0x17DE {
    return 230
  }
  if scalar < 0x18A9 {
    return 0
  }
  if scalar < 0x18AA {
    return 228
  }
  if scalar < 0x1939 {
    return 0
  }
  if scalar < 0x193A {
    return 222
  }
  if scalar < 0x193B {
    return 230
  }
  if scalar < 0x193C {
    return 220
  }
  if scalar < 0x1A17 {
    return 0
  }
  if scalar < 0x1A18 {
    return 230
  }
  if scalar < 0x1A19 {
    return 220
  }
  if scalar < 0x1A60 {
    return 0
  }
  if scalar < 0x1A61 {
    return 9
  }
  if scalar < 0x1A75 {
    return 0
  }
  if scalar < 0x1A7D {
    return 230
  }
  if scalar < 0x1A7F {
    return 0
  }
  if scalar < 0x1A80 {
    return 220
  }
  if scalar < 0x1AB0 {
    return 0
  }
  if scalar < 0x1AB5 {
    return 230
  }
  if scalar < 0x1ABB {
    return 220
  }
  if scalar < 0x1ABD {
    return 230
  }
  if scalar < 0x1ABE {
    return 220
  }
  if scalar < 0x1ABF {
    return 0
  }
  if scalar < 0x1AC1 {
    return 220
  }
  if scalar < 0x1AC3 {
    return 230
  }
  if scalar < 0x1AC5 {
    return 220
  }
  if scalar < 0x1ACA {
    return 230
  }
  if scalar < 0x1ACB {
    return 220
  }
  if scalar < 0x1ADD {
    return 230
  }
  if scalar < 0x1ADE {
    return 220
  }
  if scalar < 0x1AE0 {
    return 0
  }
  if scalar < 0x1AE6 {
    return 230
  }
  if scalar < 0x1AE7 {
    return 220
  }
  if scalar < 0x1AEB {
    return 230
  }
  if scalar < 0x1AEC {
    return 234
  }
  if scalar < 0x1B34 {
    return 0
  }
  if scalar < 0x1B35 {
    return 7
  }
  if scalar < 0x1B44 {
    return 0
  }
  if scalar < 0x1B45 {
    return 9
  }
  if scalar < 0x1B6B {
    return 0
  }
  if scalar < 0x1B6C {
    return 230
  }
  if scalar < 0x1B6D {
    return 220
  }
  if scalar < 0x1B74 {
    return 230
  }
  if scalar < 0x1BAA {
    return 0
  }
  if scalar < 0x1BAC {
    return 9
  }
  if scalar < 0x1BE6 {
    return 0
  }
  if scalar < 0x1BE7 {
    return 7
  }
  if scalar < 0x1BF2 {
    return 0
  }
  if scalar < 0x1BF4 {
    return 9
  }
  if scalar < 0x1C37 {
    return 0
  }
  if scalar < 0x1C38 {
    return 7
  }
  if scalar < 0x1CD0 {
    return 0
  }
  if scalar < 0x1CD3 {
    return 230
  }
  if scalar < 0x1CD4 {
    return 0
  }
  if scalar < 0x1CD5 {
    return 1
  }
  if scalar < 0x1CDA {
    return 220
  }
  if scalar < 0x1CDC {
    return 230
  }
  if scalar < 0x1CE0 {
    return 220
  }
  if scalar < 0x1CE1 {
    return 230
  }
  if scalar < 0x1CE2 {
    return 0
  }
  if scalar < 0x1CE9 {
    return 1
  }
  if scalar < 0x1CED {
    return 0
  }
  if scalar < 0x1CEE {
    return 220
  }
  if scalar < 0x1CF4 {
    return 0
  }
  if scalar < 0x1CF5 {
    return 230
  }
  if scalar < 0x1CF8 {
    return 0
  }
  if scalar < 0x1CFA {
    return 230
  }
  if scalar < 0x1DC0 {
    return 0
  }
  if scalar < 0x1DC2 {
    return 230
  }
  if scalar < 0x1DC3 {
    return 220
  }
  if scalar < 0x1DCA {
    return 230
  }
  if scalar < 0x1DCB {
    return 220
  }
  if scalar < 0x1DCD {
    return 230
  }
  if scalar < 0x1DCE {
    return 234
  }
  if scalar < 0x1DCF {
    return 214
  }
  if scalar < 0x1DD0 {
    return 220
  }
  if scalar < 0x1DD1 {
    return 202
  }
  if scalar < 0x1DF6 {
    return 230
  }
  if scalar < 0x1DF7 {
    return 232
  }
  if scalar < 0x1DF9 {
    return 228
  }
  if scalar < 0x1DFA {
    return 220
  }
  if scalar < 0x1DFB {
    return 218
  }
  if scalar < 0x1DFC {
    return 230
  }
  if scalar < 0x1DFD {
    return 233
  }
  if scalar < 0x1DFE {
    return 220
  }
  if scalar < 0x1DFF {
    return 230
  }
  if scalar < 0x1E00 {
    return 220
  }
  if scalar < 0x20D0 {
    return 0
  }
  if scalar < 0x20D2 {
    return 230
  }
  if scalar < 0x20D4 {
    return 1
  }
  if scalar < 0x20D8 {
    return 230
  }
  if scalar < 0x20DB {
    return 1
  }
  if scalar < 0x20DD {
    return 230
  }
  if scalar < 0x20E1 {
    return 0
  }
  if scalar < 0x20E2 {
    return 230
  }
  if scalar < 0x20E5 {
    return 0
  }
  if scalar < 0x20E7 {
    return 1
  }
  if scalar < 0x20E8 {
    return 230
  }
  if scalar < 0x20E9 {
    return 220
  }
  if scalar < 0x20EA {
    return 230
  }
  if scalar < 0x20EC {
    return 1
  }
  if scalar < 0x20F0 {
    return 220
  }
  if scalar < 0x20F1 {
    return 230
  }
  if scalar < 0x2CEF {
    return 0
  }
  if scalar < 0x2CF2 {
    return 230
  }
  if scalar < 0x2D7F {
    return 0
  }
  if scalar < 0x2D80 {
    return 9
  }
  if scalar < 0x2DE0 {
    return 0
  }
  if scalar < 0x2E00 {
    return 230
  }
  if scalar < 0x302A {
    return 0
  }
  if scalar < 0x302B {
    return 218
  }
  if scalar < 0x302C {
    return 228
  }
  if scalar < 0x302D {
    return 232
  }
  if scalar < 0x302E {
    return 222
  }
  if scalar < 0x3030 {
    return 224
  }
  if scalar < 0x3099 {
    return 0
  }
  if scalar < 0x309B {
    return 8
  }
  if scalar < 0xA66F {
    return 0
  }
  if scalar < 0xA670 {
    return 230
  }
  if scalar < 0xA674 {
    return 0
  }
  if scalar < 0xA67E {
    return 230
  }
  if scalar < 0xA69E {
    return 0
  }
  if scalar < 0xA6A0 {
    return 230
  }
  if scalar < 0xA6F0 {
    return 0
  }
  if scalar < 0xA6F2 {
    return 230
  }
  if scalar < 0xA806 {
    return 0
  }
  if scalar < 0xA807 {
    return 9
  }
  if scalar < 0xA82C {
    return 0
  }
  if scalar < 0xA82D {
    return 9
  }
  if scalar < 0xA8C4 {
    return 0
  }
  if scalar < 0xA8C5 {
    return 9
  }
  if scalar < 0xA8E0 {
    return 0
  }
  if scalar < 0xA8F2 {
    return 230
  }
  if scalar < 0xA92B {
    return 0
  }
  if scalar < 0xA92E {
    return 220
  }
  if scalar < 0xA953 {
    return 0
  }
  if scalar < 0xA954 {
    return 9
  }
  if scalar < 0xA9B3 {
    return 0
  }
  if scalar < 0xA9B4 {
    return 7
  }
  if scalar < 0xA9C0 {
    return 0
  }
  if scalar < 0xA9C1 {
    return 9
  }
  if scalar < 0xAAB0 {
    return 0
  }
  if scalar < 0xAAB1 {
    return 230
  }
  if scalar < 0xAAB2 {
    return 0
  }
  if scalar < 0xAAB4 {
    return 230
  }
  if scalar < 0xAAB5 {
    return 220
  }
  if scalar < 0xAAB7 {
    return 0
  }
  if scalar < 0xAAB9 {
    return 230
  }
  if scalar < 0xAABE {
    return 0
  }
  if scalar < 0xAAC0 {
    return 230
  }
  if scalar < 0xAAC1 {
    return 0
  }
  if scalar < 0xAAC2 {
    return 230
  }
  if scalar < 0xAAF6 {
    return 0
  }
  if scalar < 0xAAF7 {
    return 9
  }
  if scalar < 0xABED {
    return 0
  }
  if scalar < 0xABEE {
    return 9
  }
  if scalar < 0xFB1E {
    return 0
  }
  if scalar < 0xFB1F {
    return 26
  }
  if scalar < 0xFE20 {
    return 0
  }
  if scalar < 0xFE27 {
    return 230
  }
  if scalar < 0xFE2E {
    return 220
  }
  if scalar < 0xFE30 {
    return 230
  }
  if scalar < 0x101FD {
    return 0
  }
  if scalar < 0x101FE {
    return 220
  }
  if scalar < 0x102E0 {
    return 0
  }
  if scalar < 0x102E1 {
    return 220
  }
  if scalar < 0x10376 {
    return 0
  }
  if scalar < 0x1037B {
    return 230
  }
  if scalar < 0x10A0D {
    return 0
  }
  if scalar < 0x10A0E {
    return 220
  }
  if scalar < 0x10A0F {
    return 0
  }
  if scalar < 0x10A10 {
    return 230
  }
  if scalar < 0x10A38 {
    return 0
  }
  if scalar < 0x10A39 {
    return 230
  }
  if scalar < 0x10A3A {
    return 1
  }
  if scalar < 0x10A3B {
    return 220
  }
  if scalar < 0x10A3F {
    return 0
  }
  if scalar < 0x10A40 {
    return 9
  }
  if scalar < 0x10AE5 {
    return 0
  }
  if scalar < 0x10AE6 {
    return 230
  }
  if scalar < 0x10AE7 {
    return 220
  }
  if scalar < 0x10D24 {
    return 0
  }
  if scalar < 0x10D28 {
    return 230
  }
  if scalar < 0x10D69 {
    return 0
  }
  if scalar < 0x10D6E {
    return 230
  }
  if scalar < 0x10EAB {
    return 0
  }
  if scalar < 0x10EAD {
    return 230
  }
  if scalar < 0x10EFA {
    return 0
  }
  if scalar < 0x10EFC {
    return 220
  }
  if scalar < 0x10EFD {
    return 0
  }
  if scalar < 0x10F00 {
    return 220
  }
  if scalar < 0x10F46 {
    return 0
  }
  if scalar < 0x10F48 {
    return 220
  }
  if scalar < 0x10F4B {
    return 230
  }
  if scalar < 0x10F4C {
    return 220
  }
  if scalar < 0x10F4D {
    return 230
  }
  if scalar < 0x10F51 {
    return 220
  }
  if scalar < 0x10F82 {
    return 0
  }
  if scalar < 0x10F83 {
    return 230
  }
  if scalar < 0x10F84 {
    return 220
  }
  if scalar < 0x10F85 {
    return 230
  }
  if scalar < 0x10F86 {
    return 220
  }
  if scalar < 0x11046 {
    return 0
  }
  if scalar < 0x11047 {
    return 9
  }
  if scalar < 0x11070 {
    return 0
  }
  if scalar < 0x11071 {
    return 9
  }
  if scalar < 0x1107F {
    return 0
  }
  if scalar < 0x11080 {
    return 9
  }
  if scalar < 0x110B9 {
    return 0
  }
  if scalar < 0x110BA {
    return 9
  }
  if scalar < 0x110BB {
    return 7
  }
  if scalar < 0x11100 {
    return 0
  }
  if scalar < 0x11103 {
    return 230
  }
  if scalar < 0x11133 {
    return 0
  }
  if scalar < 0x11135 {
    return 9
  }
  if scalar < 0x11173 {
    return 0
  }
  if scalar < 0x11174 {
    return 7
  }
  if scalar < 0x111C0 {
    return 0
  }
  if scalar < 0x111C1 {
    return 9
  }
  if scalar < 0x111CA {
    return 0
  }
  if scalar < 0x111CB {
    return 7
  }
  if scalar < 0x11235 {
    return 0
  }
  if scalar < 0x11236 {
    return 9
  }
  if scalar < 0x11237 {
    return 7
  }
  if scalar < 0x112E9 {
    return 0
  }
  if scalar < 0x112EA {
    return 7
  }
  if scalar < 0x112EB {
    return 9
  }
  if scalar < 0x1133B {
    return 0
  }
  if scalar < 0x1133D {
    return 7
  }
  if scalar < 0x1134D {
    return 0
  }
  if scalar < 0x1134E {
    return 9
  }
  if scalar < 0x11366 {
    return 0
  }
  if scalar < 0x1136D {
    return 230
  }
  if scalar < 0x11370 {
    return 0
  }
  if scalar < 0x11375 {
    return 230
  }
  if scalar < 0x113CE {
    return 0
  }
  if scalar < 0x113D1 {
    return 9
  }
  if scalar < 0x11442 {
    return 0
  }
  if scalar < 0x11443 {
    return 9
  }
  if scalar < 0x11446 {
    return 0
  }
  if scalar < 0x11447 {
    return 7
  }
  if scalar < 0x1145E {
    return 0
  }
  if scalar < 0x1145F {
    return 230
  }
  if scalar < 0x114C2 {
    return 0
  }
  if scalar < 0x114C3 {
    return 9
  }
  if scalar < 0x114C4 {
    return 7
  }
  if scalar < 0x115BF {
    return 0
  }
  if scalar < 0x115C0 {
    return 9
  }
  if scalar < 0x115C1 {
    return 7
  }
  if scalar < 0x1163F {
    return 0
  }
  if scalar < 0x11640 {
    return 9
  }
  if scalar < 0x116B6 {
    return 0
  }
  if scalar < 0x116B7 {
    return 9
  }
  if scalar < 0x116B8 {
    return 7
  }
  if scalar < 0x1172B {
    return 0
  }
  if scalar < 0x1172C {
    return 9
  }
  if scalar < 0x11839 {
    return 0
  }
  if scalar < 0x1183A {
    return 9
  }
  if scalar < 0x1183B {
    return 7
  }
  if scalar < 0x1193D {
    return 0
  }
  if scalar < 0x1193F {
    return 9
  }
  if scalar < 0x11943 {
    return 0
  }
  if scalar < 0x11944 {
    return 7
  }
  if scalar < 0x119E0 {
    return 0
  }
  if scalar < 0x119E1 {
    return 9
  }
  if scalar < 0x11A34 {
    return 0
  }
  if scalar < 0x11A35 {
    return 9
  }
  if scalar < 0x11A47 {
    return 0
  }
  if scalar < 0x11A48 {
    return 9
  }
  if scalar < 0x11A99 {
    return 0
  }
  if scalar < 0x11A9A {
    return 9
  }
  if scalar < 0x11C3F {
    return 0
  }
  if scalar < 0x11C40 {
    return 9
  }
  if scalar < 0x11D42 {
    return 0
  }
  if scalar < 0x11D43 {
    return 7
  }
  if scalar < 0x11D44 {
    return 0
  }
  if scalar < 0x11D46 {
    return 9
  }
  if scalar < 0x11D97 {
    return 0
  }
  if scalar < 0x11D98 {
    return 9
  }
  if scalar < 0x11F41 {
    return 0
  }
  if scalar < 0x11F43 {
    return 9
  }
  if scalar < 0x1612F {
    return 0
  }
  if scalar < 0x16130 {
    return 9
  }
  if scalar < 0x16AF0 {
    return 0
  }
  if scalar < 0x16AF5 {
    return 1
  }
  if scalar < 0x16B30 {
    return 0
  }
  if scalar < 0x16B37 {
    return 230
  }
  if scalar < 0x16FF0 {
    return 0
  }
  if scalar < 0x16FF2 {
    return 6
  }
  if scalar < 0x1BC9E {
    return 0
  }
  if scalar < 0x1BC9F {
    return 1
  }
  if scalar < 0x1D165 {
    return 0
  }
  if scalar < 0x1D167 {
    return 216
  }
  if scalar < 0x1D16A {
    return 1
  }
  if scalar < 0x1D16D {
    return 0
  }
  if scalar < 0x1D16E {
    return 226
  }
  if scalar < 0x1D173 {
    return 216
  }
  if scalar < 0x1D17B {
    return 0
  }
  if scalar < 0x1D183 {
    return 220
  }
  if scalar < 0x1D185 {
    return 0
  }
  if scalar < 0x1D18A {
    return 230
  }
  if scalar < 0x1D18C {
    return 220
  }
  if scalar < 0x1D1AA {
    return 0
  }
  if scalar < 0x1D1AE {
    return 230
  }
  if scalar < 0x1D242 {
    return 0
  }
  if scalar < 0x1D245 {
    return 230
  }
  if scalar < 0x1E000 {
    return 0
  }
  if scalar < 0x1E007 {
    return 230
  }
  if scalar < 0x1E008 {
    return 0
  }
  if scalar < 0x1E019 {
    return 230
  }
  if scalar < 0x1E01B {
    return 0
  }
  if scalar < 0x1E022 {
    return 230
  }
  if scalar < 0x1E023 {
    return 0
  }
  if scalar < 0x1E025 {
    return 230
  }
  if scalar < 0x1E026 {
    return 0
  }
  if scalar < 0x1E02B {
    return 230
  }
  if scalar < 0x1E08F {
    return 0
  }
  if scalar < 0x1E090 {
    return 230
  }
  if scalar < 0x1E130 {
    return 0
  }
  if scalar < 0x1E137 {
    return 230
  }
  if scalar < 0x1E2AE {
    return 0
  }
  if scalar < 0x1E2AF {
    return 230
  }
  if scalar < 0x1E2EC {
    return 0
  }
  if scalar < 0x1E2F0 {
    return 230
  }
  if scalar < 0x1E4EC {
    return 0
  }
  if scalar < 0x1E4EE {
    return 232
  }
  if scalar < 0x1E4EF {
    return 220
  }
  if scalar < 0x1E4F0 {
    return 230
  }
  if scalar < 0x1E5EE {
    return 0
  }
  if scalar < 0x1E5EF {
    return 230
  }
  if scalar < 0x1E5F0 {
    return 220
  }
  if scalar < 0x1E6E3 {
    return 0
  }
  if scalar < 0x1E6E4 {
    return 230
  }
  if scalar < 0x1E6E6 {
    return 0
  }
  if scalar < 0x1E6E7 {
    return 230
  }
  if scalar < 0x1E6EE {
    return 0
  }
  if scalar < 0x1E6F0 {
    return 230
  }
  if scalar < 0x1E6F5 {
    return 0
  }
  if scalar < 0x1E6F6 {
    return 230
  }
  if scalar < 0x1E8D0 {
    return 0
  }
  if scalar < 0x1E8D7 {
    return 220
  }
  if scalar < 0x1E944 {
    return 0
  }
  if scalar < 0x1E94A {
    return 230
  }
  if scalar < 0x1E94B {
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
