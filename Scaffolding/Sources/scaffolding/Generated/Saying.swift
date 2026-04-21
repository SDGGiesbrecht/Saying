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

extension String.UnicodeScalarView {
  func scalarsAreIndividuallyDecomposedAccordingToCompatibilityDecomposition() -> Bool {
    for scalar in self {
      if !scalar.isDecomposedAccordingtoCompatibilityDecomposition {
        return false
      }
    }
    return true
  }
}

fileprivate func _0028_0029_0020individually_0020decomposed_0020according_0020to_0020compatibility_0020decomposition_002C_0020skipping_0020necessity_0020check_003AUnicode_0020scalars_003AUnicode_0020scalars(_ scalars: String.UnicodeScalarView) -> String.UnicodeScalarView {
  var decomposed: String.UnicodeScalarView = "".unicodeScalars
  for scalar in scalars {
    decomposed += scalar.compatibilityDecomposition()
  }
  return decomposed
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

extension Unicode.Scalar {
  func compatibilityDecomposition() -> String.UnicodeScalarView {
    return full_0020compatibility_0020decomposition_0020of_0020_0028_0029_003AUnicode_0020scalar_003AUnicode_0020scalars(self)
  }
}

extension String.UnicodeScalarView {
  func compatibilityDecomposition() -> String.UnicodeScalarView {
    return self.individuallyDecomposedAccordingToCompatibilityDecomposition().reorderedCanonically()
  }
}

extension String.UnicodeScalarView {
  public func hash(into hasher: inout Hasher) {
    if_0020most_0020efficient_002C_0020hash_0020key_0020_0028_0029_0020with_0020_0028_0029_0020by_0020iteration_003AUnicode_0020scalars_003Ahasher_003A(self, &hasher)
  }
}

extension String.UnicodeScalarView {
  func individuallyDecomposedAccordingToCompatibilityDecomposition() -> String.UnicodeScalarView {
    if self.scalarsAreIndividuallyDecomposedAccordingToCompatibilityDecomposition() {
      return self
    }
    return _0028_0029_0020individually_0020decomposed_0020according_0020to_0020compatibility_0020decomposition_002C_0020skipping_0020necessity_0020check_003AUnicode_0020scalars_003AUnicode_0020scalars(self)
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

extension String.UnicodeScalarView {
  func reorderedCanonically() -> String.UnicodeScalarView {
    if self.isOrderedCanonically() {
      return self
    }
    return _0028_0029_0020reordered_0020canonically_002C_0020skipping_0020necessity_0020check_003AUnicode_0020scalars_003AUnicode_0020scalars(self)
  }
}

fileprivate func _0028_0029의_0020자모_003AUnicode_0020scalar_0020numerical_0020value_003AUnicode_0020scalars(_ 글자_0020마디: UInt32) -> String.UnicodeScalarView {
  let 글자_0020마디의_0020색인: UInt32 = 글자_0020마디 &- 첫_0020글자_0020마디_003AUnicode_0020scalar_0020numerical_0020value()
  var 자모: String.UnicodeScalarView = "".unicodeScalars
  자모.append(Unicode.Scalar(skippingValidityCheck: 첫_0020초성_003AUnicode_0020scalar_0020numerical_0020value() &+ 글자_0020마디의_0020색인 / 최종_0020쌍의_0020수_003AUnicode_0020scalar_0020numerical_0020value()))
  자모.append(Unicode.Scalar(skippingValidityCheck: 첫_0020중성_003AUnicode_0020scalar_0020numerical_0020value() &+ 글자_0020마디의_0020색인 % 최종_0020쌍의_0020수_003AUnicode_0020scalar_0020numerical_0020value() / 종성의_0020개수_0020및_0020없음_003AUnicode_0020scalar_0020numerical_0020value()))
  let 종성의_0020색인: UInt32 = 글자_0020마디의_0020색인 % 종성의_0020개수_0020및_0020없음_003AUnicode_0020scalar_0020numerical_0020value()
  if 종성의_0020색인 > 0x0 {
    자모.append(Unicode.Scalar(skippingValidityCheck: 첫_0020종성_0020직전_003AUnicode_0020scalar_0020numerical_0020value() &+ 종성의_0020색인))
  }
  return 자모
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

extension Unicode.Scalar {
  init(skippingValidityCheck value: UInt32) {
    self = {
      if let scalar = Unicode.Scalar(value) {
        return scalar
      }
      fatalError()
    }()
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

fileprivate func compatibility_0020decomposition_0020quick_0020check_0020of_0020_0028_0029_003AUnicode_0020scalar_0020numerical_0020value_003Aערך_0020אמת(_ scalar: UInt32) -> Bool {
  if scalar <= 0x009F {
    return true
  }
  if scalar <= 0x00A0 {
    return false
  }
  if scalar <= 0x00A7 {
    return true
  }
  if scalar <= 0x00A8 {
    return false
  }
  if scalar <= 0x00A9 {
    return true
  }
  if scalar <= 0x00AA {
    return false
  }
  if scalar <= 0x00AE {
    return true
  }
  if scalar <= 0x00AF {
    return false
  }
  if scalar <= 0x00B1 {
    return true
  }
  if scalar <= 0x00B5 {
    return false
  }
  if scalar <= 0x00B7 {
    return true
  }
  if scalar <= 0x00BA {
    return false
  }
  if scalar <= 0x00BB {
    return true
  }
  if scalar <= 0x00BE {
    return false
  }
  if scalar <= 0x00BF {
    return true
  }
  if scalar <= 0x00C5 {
    return false
  }
  if scalar <= 0x00C6 {
    return true
  }
  if scalar <= 0x00CF {
    return false
  }
  if scalar <= 0x00D0 {
    return true
  }
  if scalar <= 0x00D6 {
    return false
  }
  if scalar <= 0x00D8 {
    return true
  }
  if scalar <= 0x00DD {
    return false
  }
  if scalar <= 0x00DF {
    return true
  }
  if scalar <= 0x00E5 {
    return false
  }
  if scalar <= 0x00E6 {
    return true
  }
  if scalar <= 0x00EF {
    return false
  }
  if scalar <= 0x00F0 {
    return true
  }
  if scalar <= 0x00F6 {
    return false
  }
  if scalar <= 0x00F8 {
    return true
  }
  if scalar <= 0x00FD {
    return false
  }
  if scalar <= 0x00FE {
    return true
  }
  if scalar <= 0x010F {
    return false
  }
  if scalar <= 0x0111 {
    return true
  }
  if scalar <= 0x0125 {
    return false
  }
  if scalar <= 0x0127 {
    return true
  }
  if scalar <= 0x0130 {
    return false
  }
  if scalar <= 0x0131 {
    return true
  }
  if scalar <= 0x0137 {
    return false
  }
  if scalar <= 0x0138 {
    return true
  }
  if scalar <= 0x0140 {
    return false
  }
  if scalar <= 0x0142 {
    return true
  }
  if scalar <= 0x0149 {
    return false
  }
  if scalar <= 0x014B {
    return true
  }
  if scalar <= 0x0151 {
    return false
  }
  if scalar <= 0x0153 {
    return true
  }
  if scalar <= 0x0165 {
    return false
  }
  if scalar <= 0x0167 {
    return true
  }
  if scalar <= 0x017F {
    return false
  }
  if scalar <= 0x019F {
    return true
  }
  if scalar <= 0x01A1 {
    return false
  }
  if scalar <= 0x01AE {
    return true
  }
  if scalar <= 0x01B0 {
    return false
  }
  if scalar <= 0x01C3 {
    return true
  }
  if scalar <= 0x01DC {
    return false
  }
  if scalar <= 0x01DD {
    return true
  }
  if scalar <= 0x01E3 {
    return false
  }
  if scalar <= 0x01E5 {
    return true
  }
  if scalar <= 0x01F5 {
    return false
  }
  if scalar <= 0x01F7 {
    return true
  }
  if scalar <= 0x021B {
    return false
  }
  if scalar <= 0x021D {
    return true
  }
  if scalar <= 0x021F {
    return false
  }
  if scalar <= 0x0225 {
    return true
  }
  if scalar <= 0x0233 {
    return false
  }
  if scalar <= 0x02AF {
    return true
  }
  if scalar <= 0x02B8 {
    return false
  }
  if scalar <= 0x02D7 {
    return true
  }
  if scalar <= 0x02DD {
    return false
  }
  if scalar <= 0x02DF {
    return true
  }
  if scalar <= 0x02E4 {
    return false
  }
  if scalar <= 0x033F {
    return true
  }
  if scalar <= 0x0341 {
    return false
  }
  if scalar <= 0x0342 {
    return true
  }
  if scalar <= 0x0344 {
    return false
  }
  if scalar <= 0x0373 {
    return true
  }
  if scalar <= 0x0374 {
    return false
  }
  if scalar <= 0x0379 {
    return true
  }
  if scalar <= 0x037A {
    return false
  }
  if scalar <= 0x037D {
    return true
  }
  if scalar <= 0x037E {
    return false
  }
  if scalar <= 0x0383 {
    return true
  }
  if scalar <= 0x038A {
    return false
  }
  if scalar <= 0x038B {
    return true
  }
  if scalar <= 0x038C {
    return false
  }
  if scalar <= 0x038D {
    return true
  }
  if scalar <= 0x0390 {
    return false
  }
  if scalar <= 0x03A9 {
    return true
  }
  if scalar <= 0x03B0 {
    return false
  }
  if scalar <= 0x03C9 {
    return true
  }
  if scalar <= 0x03CE {
    return false
  }
  if scalar <= 0x03CF {
    return true
  }
  if scalar <= 0x03D6 {
    return false
  }
  if scalar <= 0x03EF {
    return true
  }
  if scalar <= 0x03F2 {
    return false
  }
  if scalar <= 0x03F3 {
    return true
  }
  if scalar <= 0x03F5 {
    return false
  }
  if scalar <= 0x03F8 {
    return true
  }
  if scalar <= 0x03F9 {
    return false
  }
  if scalar <= 0x03FF {
    return true
  }
  if scalar <= 0x0401 {
    return false
  }
  if scalar <= 0x0402 {
    return true
  }
  if scalar <= 0x0403 {
    return false
  }
  if scalar <= 0x0406 {
    return true
  }
  if scalar <= 0x0407 {
    return false
  }
  if scalar <= 0x040B {
    return true
  }
  if scalar <= 0x040E {
    return false
  }
  if scalar <= 0x0418 {
    return true
  }
  if scalar <= 0x0419 {
    return false
  }
  if scalar <= 0x0438 {
    return true
  }
  if scalar <= 0x0439 {
    return false
  }
  if scalar <= 0x044F {
    return true
  }
  if scalar <= 0x0451 {
    return false
  }
  if scalar <= 0x0452 {
    return true
  }
  if scalar <= 0x0453 {
    return false
  }
  if scalar <= 0x0456 {
    return true
  }
  if scalar <= 0x0457 {
    return false
  }
  if scalar <= 0x045B {
    return true
  }
  if scalar <= 0x045E {
    return false
  }
  if scalar <= 0x0475 {
    return true
  }
  if scalar <= 0x0477 {
    return false
  }
  if scalar <= 0x04C0 {
    return true
  }
  if scalar <= 0x04C2 {
    return false
  }
  if scalar <= 0x04CF {
    return true
  }
  if scalar <= 0x04D3 {
    return false
  }
  if scalar <= 0x04D5 {
    return true
  }
  if scalar <= 0x04D7 {
    return false
  }
  if scalar <= 0x04D9 {
    return true
  }
  if scalar <= 0x04DF {
    return false
  }
  if scalar <= 0x04E1 {
    return true
  }
  if scalar <= 0x04E7 {
    return false
  }
  if scalar <= 0x04E9 {
    return true
  }
  if scalar <= 0x04F5 {
    return false
  }
  if scalar <= 0x04F7 {
    return true
  }
  if scalar <= 0x04F9 {
    return false
  }
  if scalar <= 0x0586 {
    return true
  }
  if scalar <= 0x0587 {
    return false
  }
  if scalar <= 0x0621 {
    return true
  }
  if scalar <= 0x0626 {
    return false
  }
  if scalar <= 0x0674 {
    return true
  }
  if scalar <= 0x0678 {
    return false
  }
  if scalar <= 0x06BF {
    return true
  }
  if scalar <= 0x06C0 {
    return false
  }
  if scalar <= 0x06C1 {
    return true
  }
  if scalar <= 0x06C2 {
    return false
  }
  if scalar <= 0x06D2 {
    return true
  }
  if scalar <= 0x06D3 {
    return false
  }
  if scalar <= 0x0928 {
    return true
  }
  if scalar <= 0x0929 {
    return false
  }
  if scalar <= 0x0930 {
    return true
  }
  if scalar <= 0x0931 {
    return false
  }
  if scalar <= 0x0933 {
    return true
  }
  if scalar <= 0x0934 {
    return false
  }
  if scalar <= 0x0957 {
    return true
  }
  if scalar <= 0x095F {
    return false
  }
  if scalar <= 0x09CA {
    return true
  }
  if scalar <= 0x09CC {
    return false
  }
  if scalar <= 0x09DB {
    return true
  }
  if scalar <= 0x09DD {
    return false
  }
  if scalar <= 0x09DE {
    return true
  }
  if scalar <= 0x09DF {
    return false
  }
  if scalar <= 0x0A32 {
    return true
  }
  if scalar <= 0x0A33 {
    return false
  }
  if scalar <= 0x0A35 {
    return true
  }
  if scalar <= 0x0A36 {
    return false
  }
  if scalar <= 0x0A58 {
    return true
  }
  if scalar <= 0x0A5B {
    return false
  }
  if scalar <= 0x0A5D {
    return true
  }
  if scalar <= 0x0A5E {
    return false
  }
  if scalar <= 0x0B47 {
    return true
  }
  if scalar <= 0x0B48 {
    return false
  }
  if scalar <= 0x0B4A {
    return true
  }
  if scalar <= 0x0B4C {
    return false
  }
  if scalar <= 0x0B5B {
    return true
  }
  if scalar <= 0x0B5D {
    return false
  }
  if scalar <= 0x0B93 {
    return true
  }
  if scalar <= 0x0B94 {
    return false
  }
  if scalar <= 0x0BC9 {
    return true
  }
  if scalar <= 0x0BCC {
    return false
  }
  if scalar <= 0x0C47 {
    return true
  }
  if scalar <= 0x0C48 {
    return false
  }
  if scalar <= 0x0CBF {
    return true
  }
  if scalar <= 0x0CC0 {
    return false
  }
  if scalar <= 0x0CC6 {
    return true
  }
  if scalar <= 0x0CC8 {
    return false
  }
  if scalar <= 0x0CC9 {
    return true
  }
  if scalar <= 0x0CCB {
    return false
  }
  if scalar <= 0x0D49 {
    return true
  }
  if scalar <= 0x0D4C {
    return false
  }
  if scalar <= 0x0DD9 {
    return true
  }
  if scalar <= 0x0DDA {
    return false
  }
  if scalar <= 0x0DDB {
    return true
  }
  if scalar <= 0x0DDE {
    return false
  }
  if scalar <= 0x0E32 {
    return true
  }
  if scalar <= 0x0E33 {
    return false
  }
  if scalar <= 0x0EB2 {
    return true
  }
  if scalar <= 0x0EB3 {
    return false
  }
  if scalar <= 0x0EDB {
    return true
  }
  if scalar <= 0x0EDD {
    return false
  }
  if scalar <= 0x0F0B {
    return true
  }
  if scalar <= 0x0F0C {
    return false
  }
  if scalar <= 0x0F42 {
    return true
  }
  if scalar <= 0x0F43 {
    return false
  }
  if scalar <= 0x0F4C {
    return true
  }
  if scalar <= 0x0F4D {
    return false
  }
  if scalar <= 0x0F51 {
    return true
  }
  if scalar <= 0x0F52 {
    return false
  }
  if scalar <= 0x0F56 {
    return true
  }
  if scalar <= 0x0F57 {
    return false
  }
  if scalar <= 0x0F5B {
    return true
  }
  if scalar <= 0x0F5C {
    return false
  }
  if scalar <= 0x0F68 {
    return true
  }
  if scalar <= 0x0F69 {
    return false
  }
  if scalar <= 0x0F72 {
    return true
  }
  if scalar <= 0x0F73 {
    return false
  }
  if scalar <= 0x0F74 {
    return true
  }
  if scalar <= 0x0F79 {
    return false
  }
  if scalar <= 0x0F80 {
    return true
  }
  if scalar <= 0x0F81 {
    return false
  }
  if scalar <= 0x0F92 {
    return true
  }
  if scalar <= 0x0F93 {
    return false
  }
  if scalar <= 0x0F9C {
    return true
  }
  if scalar <= 0x0F9D {
    return false
  }
  if scalar <= 0x0FA1 {
    return true
  }
  if scalar <= 0x0FA2 {
    return false
  }
  if scalar <= 0x0FA6 {
    return true
  }
  if scalar <= 0x0FA7 {
    return false
  }
  if scalar <= 0x0FAB {
    return true
  }
  if scalar <= 0x0FAC {
    return false
  }
  if scalar <= 0x0FB8 {
    return true
  }
  if scalar <= 0x0FB9 {
    return false
  }
  if scalar <= 0x1025 {
    return true
  }
  if scalar <= 0x1026 {
    return false
  }
  if scalar <= 0x10FB {
    return true
  }
  if scalar <= 0x10FC {
    return false
  }
  if scalar <= 0x1B05 {
    return true
  }
  if scalar <= 0x1B06 {
    return false
  }
  if scalar <= 0x1B07 {
    return true
  }
  if scalar <= 0x1B08 {
    return false
  }
  if scalar <= 0x1B09 {
    return true
  }
  if scalar <= 0x1B0A {
    return false
  }
  if scalar <= 0x1B0B {
    return true
  }
  if scalar <= 0x1B0C {
    return false
  }
  if scalar <= 0x1B0D {
    return true
  }
  if scalar <= 0x1B0E {
    return false
  }
  if scalar <= 0x1B11 {
    return true
  }
  if scalar <= 0x1B12 {
    return false
  }
  if scalar <= 0x1B3A {
    return true
  }
  if scalar <= 0x1B3B {
    return false
  }
  if scalar <= 0x1B3C {
    return true
  }
  if scalar <= 0x1B3D {
    return false
  }
  if scalar <= 0x1B3F {
    return true
  }
  if scalar <= 0x1B41 {
    return false
  }
  if scalar <= 0x1B42 {
    return true
  }
  if scalar <= 0x1B43 {
    return false
  }
  if scalar <= 0x1D2B {
    return true
  }
  if scalar <= 0x1D2E {
    return false
  }
  if scalar <= 0x1D2F {
    return true
  }
  if scalar <= 0x1D3A {
    return false
  }
  if scalar <= 0x1D3B {
    return true
  }
  if scalar <= 0x1D4D {
    return false
  }
  if scalar <= 0x1D4E {
    return true
  }
  if scalar <= 0x1D6A {
    return false
  }
  if scalar <= 0x1D77 {
    return true
  }
  if scalar <= 0x1D78 {
    return false
  }
  if scalar <= 0x1D9A {
    return true
  }
  if scalar <= 0x1DBF {
    return false
  }
  if scalar <= 0x1DFF {
    return true
  }
  if scalar <= 0x1E9B {
    return false
  }
  if scalar <= 0x1E9F {
    return true
  }
  if scalar <= 0x1EF9 {
    return false
  }
  if scalar <= 0x1EFF {
    return true
  }
  if scalar <= 0x1F15 {
    return false
  }
  if scalar <= 0x1F17 {
    return true
  }
  if scalar <= 0x1F1D {
    return false
  }
  if scalar <= 0x1F1F {
    return true
  }
  if scalar <= 0x1F45 {
    return false
  }
  if scalar <= 0x1F47 {
    return true
  }
  if scalar <= 0x1F4D {
    return false
  }
  if scalar <= 0x1F4F {
    return true
  }
  if scalar <= 0x1F57 {
    return false
  }
  if scalar <= 0x1F58 {
    return true
  }
  if scalar <= 0x1F59 {
    return false
  }
  if scalar <= 0x1F5A {
    return true
  }
  if scalar <= 0x1F5B {
    return false
  }
  if scalar <= 0x1F5C {
    return true
  }
  if scalar <= 0x1F5D {
    return false
  }
  if scalar <= 0x1F5E {
    return true
  }
  if scalar <= 0x1F7D {
    return false
  }
  if scalar <= 0x1F7F {
    return true
  }
  if scalar <= 0x1FB4 {
    return false
  }
  if scalar <= 0x1FB5 {
    return true
  }
  if scalar <= 0x1FC4 {
    return false
  }
  if scalar <= 0x1FC5 {
    return true
  }
  if scalar <= 0x1FD3 {
    return false
  }
  if scalar <= 0x1FD5 {
    return true
  }
  if scalar <= 0x1FDB {
    return false
  }
  if scalar <= 0x1FDC {
    return true
  }
  if scalar <= 0x1FEF {
    return false
  }
  if scalar <= 0x1FF1 {
    return true
  }
  if scalar <= 0x1FF4 {
    return false
  }
  if scalar <= 0x1FF5 {
    return true
  }
  if scalar <= 0x1FFE {
    return false
  }
  if scalar <= 0x1FFF {
    return true
  }
  if scalar <= 0x200A {
    return false
  }
  if scalar <= 0x2010 {
    return true
  }
  if scalar <= 0x2011 {
    return false
  }
  if scalar <= 0x2016 {
    return true
  }
  if scalar <= 0x2017 {
    return false
  }
  if scalar <= 0x2023 {
    return true
  }
  if scalar <= 0x2026 {
    return false
  }
  if scalar <= 0x202E {
    return true
  }
  if scalar <= 0x202F {
    return false
  }
  if scalar <= 0x2032 {
    return true
  }
  if scalar <= 0x2034 {
    return false
  }
  if scalar <= 0x2035 {
    return true
  }
  if scalar <= 0x2037 {
    return false
  }
  if scalar <= 0x203B {
    return true
  }
  if scalar <= 0x203C {
    return false
  }
  if scalar <= 0x203D {
    return true
  }
  if scalar <= 0x203E {
    return false
  }
  if scalar <= 0x2046 {
    return true
  }
  if scalar <= 0x2049 {
    return false
  }
  if scalar <= 0x2056 {
    return true
  }
  if scalar <= 0x2057 {
    return false
  }
  if scalar <= 0x205E {
    return true
  }
  if scalar <= 0x205F {
    return false
  }
  if scalar <= 0x206F {
    return true
  }
  if scalar <= 0x2071 {
    return false
  }
  if scalar <= 0x2073 {
    return true
  }
  if scalar <= 0x208E {
    return false
  }
  if scalar <= 0x208F {
    return true
  }
  if scalar <= 0x209C {
    return false
  }
  if scalar <= 0x20A7 {
    return true
  }
  if scalar <= 0x20A8 {
    return false
  }
  if scalar <= 0x20FF {
    return true
  }
  if scalar <= 0x2103 {
    return false
  }
  if scalar <= 0x2104 {
    return true
  }
  if scalar <= 0x2107 {
    return false
  }
  if scalar <= 0x2108 {
    return true
  }
  if scalar <= 0x2113 {
    return false
  }
  if scalar <= 0x2114 {
    return true
  }
  if scalar <= 0x2116 {
    return false
  }
  if scalar <= 0x2118 {
    return true
  }
  if scalar <= 0x211D {
    return false
  }
  if scalar <= 0x211F {
    return true
  }
  if scalar <= 0x2122 {
    return false
  }
  if scalar <= 0x2123 {
    return true
  }
  if scalar <= 0x2124 {
    return false
  }
  if scalar <= 0x2125 {
    return true
  }
  if scalar <= 0x2126 {
    return false
  }
  if scalar <= 0x2127 {
    return true
  }
  if scalar <= 0x2128 {
    return false
  }
  if scalar <= 0x2129 {
    return true
  }
  if scalar <= 0x212D {
    return false
  }
  if scalar <= 0x212E {
    return true
  }
  if scalar <= 0x2131 {
    return false
  }
  if scalar <= 0x2132 {
    return true
  }
  if scalar <= 0x2139 {
    return false
  }
  if scalar <= 0x213A {
    return true
  }
  if scalar <= 0x2140 {
    return false
  }
  if scalar <= 0x2144 {
    return true
  }
  if scalar <= 0x2149 {
    return false
  }
  if scalar <= 0x214F {
    return true
  }
  if scalar <= 0x217F {
    return false
  }
  if scalar <= 0x2188 {
    return true
  }
  if scalar <= 0x2189 {
    return false
  }
  if scalar <= 0x2199 {
    return true
  }
  if scalar <= 0x219B {
    return false
  }
  if scalar <= 0x21AD {
    return true
  }
  if scalar <= 0x21AE {
    return false
  }
  if scalar <= 0x21CC {
    return true
  }
  if scalar <= 0x21CF {
    return false
  }
  if scalar <= 0x2203 {
    return true
  }
  if scalar <= 0x2204 {
    return false
  }
  if scalar <= 0x2208 {
    return true
  }
  if scalar <= 0x2209 {
    return false
  }
  if scalar <= 0x220B {
    return true
  }
  if scalar <= 0x220C {
    return false
  }
  if scalar <= 0x2223 {
    return true
  }
  if scalar <= 0x2224 {
    return false
  }
  if scalar <= 0x2225 {
    return true
  }
  if scalar <= 0x2226 {
    return false
  }
  if scalar <= 0x222B {
    return true
  }
  if scalar <= 0x222D {
    return false
  }
  if scalar <= 0x222E {
    return true
  }
  if scalar <= 0x2230 {
    return false
  }
  if scalar <= 0x2240 {
    return true
  }
  if scalar <= 0x2241 {
    return false
  }
  if scalar <= 0x2243 {
    return true
  }
  if scalar <= 0x2244 {
    return false
  }
  if scalar <= 0x2246 {
    return true
  }
  if scalar <= 0x2247 {
    return false
  }
  if scalar <= 0x2248 {
    return true
  }
  if scalar <= 0x2249 {
    return false
  }
  if scalar <= 0x225F {
    return true
  }
  if scalar <= 0x2260 {
    return false
  }
  if scalar <= 0x2261 {
    return true
  }
  if scalar <= 0x2262 {
    return false
  }
  if scalar <= 0x226C {
    return true
  }
  if scalar <= 0x2271 {
    return false
  }
  if scalar <= 0x2273 {
    return true
  }
  if scalar <= 0x2275 {
    return false
  }
  if scalar <= 0x2277 {
    return true
  }
  if scalar <= 0x2279 {
    return false
  }
  if scalar <= 0x227F {
    return true
  }
  if scalar <= 0x2281 {
    return false
  }
  if scalar <= 0x2283 {
    return true
  }
  if scalar <= 0x2285 {
    return false
  }
  if scalar <= 0x2287 {
    return true
  }
  if scalar <= 0x2289 {
    return false
  }
  if scalar <= 0x22AB {
    return true
  }
  if scalar <= 0x22AF {
    return false
  }
  if scalar <= 0x22DF {
    return true
  }
  if scalar <= 0x22E3 {
    return false
  }
  if scalar <= 0x22E9 {
    return true
  }
  if scalar <= 0x22ED {
    return false
  }
  if scalar <= 0x2328 {
    return true
  }
  if scalar <= 0x232A {
    return false
  }
  if scalar <= 0x245F {
    return true
  }
  if scalar <= 0x24EA {
    return false
  }
  if scalar <= 0x2A0B {
    return true
  }
  if scalar <= 0x2A0C {
    return false
  }
  if scalar <= 0x2A73 {
    return true
  }
  if scalar <= 0x2A76 {
    return false
  }
  if scalar <= 0x2ADB {
    return true
  }
  if scalar <= 0x2ADC {
    return false
  }
  if scalar <= 0x2C7B {
    return true
  }
  if scalar <= 0x2C7D {
    return false
  }
  if scalar <= 0x2D6E {
    return true
  }
  if scalar <= 0x2D6F {
    return false
  }
  if scalar <= 0x2E9E {
    return true
  }
  if scalar <= 0x2E9F {
    return false
  }
  if scalar <= 0x2EF2 {
    return true
  }
  if scalar <= 0x2EF3 {
    return false
  }
  if scalar <= 0x2EFF {
    return true
  }
  if scalar <= 0x2FD5 {
    return false
  }
  if scalar <= 0x2FFF {
    return true
  }
  if scalar <= 0x3000 {
    return false
  }
  if scalar <= 0x3035 {
    return true
  }
  if scalar <= 0x3036 {
    return false
  }
  if scalar <= 0x3037 {
    return true
  }
  if scalar <= 0x303A {
    return false
  }
  if scalar <= 0x304B {
    return true
  }
  if scalar <= 0x304C {
    return false
  }
  if scalar <= 0x304D {
    return true
  }
  if scalar <= 0x304E {
    return false
  }
  if scalar <= 0x304F {
    return true
  }
  if scalar <= 0x3050 {
    return false
  }
  if scalar <= 0x3051 {
    return true
  }
  if scalar <= 0x3052 {
    return false
  }
  if scalar <= 0x3053 {
    return true
  }
  if scalar <= 0x3054 {
    return false
  }
  if scalar <= 0x3055 {
    return true
  }
  if scalar <= 0x3056 {
    return false
  }
  if scalar <= 0x3057 {
    return true
  }
  if scalar <= 0x3058 {
    return false
  }
  if scalar <= 0x3059 {
    return true
  }
  if scalar <= 0x305A {
    return false
  }
  if scalar <= 0x305B {
    return true
  }
  if scalar <= 0x305C {
    return false
  }
  if scalar <= 0x305D {
    return true
  }
  if scalar <= 0x305E {
    return false
  }
  if scalar <= 0x305F {
    return true
  }
  if scalar <= 0x3060 {
    return false
  }
  if scalar <= 0x3061 {
    return true
  }
  if scalar <= 0x3062 {
    return false
  }
  if scalar <= 0x3064 {
    return true
  }
  if scalar <= 0x3065 {
    return false
  }
  if scalar <= 0x3066 {
    return true
  }
  if scalar <= 0x3067 {
    return false
  }
  if scalar <= 0x3068 {
    return true
  }
  if scalar <= 0x3069 {
    return false
  }
  if scalar <= 0x306F {
    return true
  }
  if scalar <= 0x3071 {
    return false
  }
  if scalar <= 0x3072 {
    return true
  }
  if scalar <= 0x3074 {
    return false
  }
  if scalar <= 0x3075 {
    return true
  }
  if scalar <= 0x3077 {
    return false
  }
  if scalar <= 0x3078 {
    return true
  }
  if scalar <= 0x307A {
    return false
  }
  if scalar <= 0x307B {
    return true
  }
  if scalar <= 0x307D {
    return false
  }
  if scalar <= 0x3093 {
    return true
  }
  if scalar <= 0x3094 {
    return false
  }
  if scalar <= 0x309A {
    return true
  }
  if scalar <= 0x309C {
    return false
  }
  if scalar <= 0x309D {
    return true
  }
  if scalar <= 0x309F {
    return false
  }
  if scalar <= 0x30AB {
    return true
  }
  if scalar <= 0x30AC {
    return false
  }
  if scalar <= 0x30AD {
    return true
  }
  if scalar <= 0x30AE {
    return false
  }
  if scalar <= 0x30AF {
    return true
  }
  if scalar <= 0x30B0 {
    return false
  }
  if scalar <= 0x30B1 {
    return true
  }
  if scalar <= 0x30B2 {
    return false
  }
  if scalar <= 0x30B3 {
    return true
  }
  if scalar <= 0x30B4 {
    return false
  }
  if scalar <= 0x30B5 {
    return true
  }
  if scalar <= 0x30B6 {
    return false
  }
  if scalar <= 0x30B7 {
    return true
  }
  if scalar <= 0x30B8 {
    return false
  }
  if scalar <= 0x30B9 {
    return true
  }
  if scalar <= 0x30BA {
    return false
  }
  if scalar <= 0x30BB {
    return true
  }
  if scalar <= 0x30BC {
    return false
  }
  if scalar <= 0x30BD {
    return true
  }
  if scalar <= 0x30BE {
    return false
  }
  if scalar <= 0x30BF {
    return true
  }
  if scalar <= 0x30C0 {
    return false
  }
  if scalar <= 0x30C1 {
    return true
  }
  if scalar <= 0x30C2 {
    return false
  }
  if scalar <= 0x30C4 {
    return true
  }
  if scalar <= 0x30C5 {
    return false
  }
  if scalar <= 0x30C6 {
    return true
  }
  if scalar <= 0x30C7 {
    return false
  }
  if scalar <= 0x30C8 {
    return true
  }
  if scalar <= 0x30C9 {
    return false
  }
  if scalar <= 0x30CF {
    return true
  }
  if scalar <= 0x30D1 {
    return false
  }
  if scalar <= 0x30D2 {
    return true
  }
  if scalar <= 0x30D4 {
    return false
  }
  if scalar <= 0x30D5 {
    return true
  }
  if scalar <= 0x30D7 {
    return false
  }
  if scalar <= 0x30D8 {
    return true
  }
  if scalar <= 0x30DA {
    return false
  }
  if scalar <= 0x30DB {
    return true
  }
  if scalar <= 0x30DD {
    return false
  }
  if scalar <= 0x30F3 {
    return true
  }
  if scalar <= 0x30F4 {
    return false
  }
  if scalar <= 0x30F6 {
    return true
  }
  if scalar <= 0x30FA {
    return false
  }
  if scalar <= 0x30FD {
    return true
  }
  if scalar <= 0x30FF {
    return false
  }
  if scalar <= 0x3130 {
    return true
  }
  if scalar <= 0x318E {
    return false
  }
  if scalar <= 0x3191 {
    return true
  }
  if scalar <= 0x319F {
    return false
  }
  if scalar <= 0x31FF {
    return true
  }
  if scalar <= 0x321E {
    return false
  }
  if scalar <= 0x321F {
    return true
  }
  if scalar <= 0x3247 {
    return false
  }
  if scalar <= 0x324F {
    return true
  }
  if scalar <= 0x327E {
    return false
  }
  if scalar <= 0x327F {
    return true
  }
  if scalar <= 0x33FF {
    return false
  }
  if scalar <= 0xA69B {
    return true
  }
  if scalar <= 0xA69D {
    return false
  }
  if scalar <= 0xA76F {
    return true
  }
  if scalar <= 0xA770 {
    return false
  }
  if scalar <= 0xA7F0 {
    return true
  }
  if scalar <= 0xA7F4 {
    return false
  }
  if scalar <= 0xA7F7 {
    return true
  }
  if scalar <= 0xA7F9 {
    return false
  }
  if scalar <= 0xAB5B {
    return true
  }
  if scalar <= 0xAB5F {
    return false
  }
  if scalar <= 0xAB68 {
    return true
  }
  if scalar <= 0xAB69 {
    return false
  }
  if scalar <= 0xABFF {
    return true
  }
  if scalar <= 0xD7A3 {
    return false
  }
  if scalar <= 0xF8FF {
    return true
  }
  if scalar <= 0xFA0D {
    return false
  }
  if scalar <= 0xFA0F {
    return true
  }
  if scalar <= 0xFA10 {
    return false
  }
  if scalar <= 0xFA11 {
    return true
  }
  if scalar <= 0xFA12 {
    return false
  }
  if scalar <= 0xFA14 {
    return true
  }
  if scalar <= 0xFA1E {
    return false
  }
  if scalar <= 0xFA1F {
    return true
  }
  if scalar <= 0xFA20 {
    return false
  }
  if scalar <= 0xFA21 {
    return true
  }
  if scalar <= 0xFA22 {
    return false
  }
  if scalar <= 0xFA24 {
    return true
  }
  if scalar <= 0xFA26 {
    return false
  }
  if scalar <= 0xFA29 {
    return true
  }
  if scalar <= 0xFA6D {
    return false
  }
  if scalar <= 0xFA6F {
    return true
  }
  if scalar <= 0xFAD9 {
    return false
  }
  if scalar <= 0xFAFF {
    return true
  }
  if scalar <= 0xFB06 {
    return false
  }
  if scalar <= 0xFB12 {
    return true
  }
  if scalar <= 0xFB17 {
    return false
  }
  if scalar <= 0xFB1C {
    return true
  }
  if scalar <= 0xFB1D {
    return false
  }
  if scalar <= 0xFB1E {
    return true
  }
  if scalar <= 0xFB36 {
    return false
  }
  if scalar <= 0xFB37 {
    return true
  }
  if scalar <= 0xFB3C {
    return false
  }
  if scalar <= 0xFB3D {
    return true
  }
  if scalar <= 0xFB3E {
    return false
  }
  if scalar <= 0xFB3F {
    return true
  }
  if scalar <= 0xFB41 {
    return false
  }
  if scalar <= 0xFB42 {
    return true
  }
  if scalar <= 0xFB44 {
    return false
  }
  if scalar <= 0xFB45 {
    return true
  }
  if scalar <= 0xFBB1 {
    return false
  }
  if scalar <= 0xFBD2 {
    return true
  }
  if scalar <= 0xFD3D {
    return false
  }
  if scalar <= 0xFD4F {
    return true
  }
  if scalar <= 0xFD8F {
    return false
  }
  if scalar <= 0xFD91 {
    return true
  }
  if scalar <= 0xFDC7 {
    return false
  }
  if scalar <= 0xFDEF {
    return true
  }
  if scalar <= 0xFDFC {
    return false
  }
  if scalar <= 0xFE0F {
    return true
  }
  if scalar <= 0xFE19 {
    return false
  }
  if scalar <= 0xFE2F {
    return true
  }
  if scalar <= 0xFE44 {
    return false
  }
  if scalar <= 0xFE46 {
    return true
  }
  if scalar <= 0xFE52 {
    return false
  }
  if scalar <= 0xFE53 {
    return true
  }
  if scalar <= 0xFE66 {
    return false
  }
  if scalar <= 0xFE67 {
    return true
  }
  if scalar <= 0xFE6B {
    return false
  }
  if scalar <= 0xFE6F {
    return true
  }
  if scalar <= 0xFE72 {
    return false
  }
  if scalar <= 0xFE73 {
    return true
  }
  if scalar <= 0xFE74 {
    return false
  }
  if scalar <= 0xFE75 {
    return true
  }
  if scalar <= 0xFEFC {
    return false
  }
  if scalar <= 0xFF00 {
    return true
  }
  if scalar <= 0xFFBE {
    return false
  }
  if scalar <= 0xFFC1 {
    return true
  }
  if scalar <= 0xFFC7 {
    return false
  }
  if scalar <= 0xFFC9 {
    return true
  }
  if scalar <= 0xFFCF {
    return false
  }
  if scalar <= 0xFFD1 {
    return true
  }
  if scalar <= 0xFFD7 {
    return false
  }
  if scalar <= 0xFFD9 {
    return true
  }
  if scalar <= 0xFFDC {
    return false
  }
  if scalar <= 0xFFDF {
    return true
  }
  if scalar <= 0xFFE6 {
    return false
  }
  if scalar <= 0xFFE7 {
    return true
  }
  if scalar <= 0xFFEE {
    return false
  }
  if scalar <= 0x105C8 {
    return true
  }
  if scalar <= 0x105C9 {
    return false
  }
  if scalar <= 0x105E3 {
    return true
  }
  if scalar <= 0x105E4 {
    return false
  }
  if scalar <= 0x10780 {
    return true
  }
  if scalar <= 0x10785 {
    return false
  }
  if scalar <= 0x10786 {
    return true
  }
  if scalar <= 0x107B0 {
    return false
  }
  if scalar <= 0x107B1 {
    return true
  }
  if scalar <= 0x107BA {
    return false
  }
  if scalar <= 0x11099 {
    return true
  }
  if scalar <= 0x1109A {
    return false
  }
  if scalar <= 0x1109B {
    return true
  }
  if scalar <= 0x1109C {
    return false
  }
  if scalar <= 0x110AA {
    return true
  }
  if scalar <= 0x110AB {
    return false
  }
  if scalar <= 0x1112D {
    return true
  }
  if scalar <= 0x1112F {
    return false
  }
  if scalar <= 0x1134A {
    return true
  }
  if scalar <= 0x1134C {
    return false
  }
  if scalar <= 0x11382 {
    return true
  }
  if scalar <= 0x11383 {
    return false
  }
  if scalar <= 0x11384 {
    return true
  }
  if scalar <= 0x11385 {
    return false
  }
  if scalar <= 0x1138D {
    return true
  }
  if scalar <= 0x1138E {
    return false
  }
  if scalar <= 0x11390 {
    return true
  }
  if scalar <= 0x11391 {
    return false
  }
  if scalar <= 0x113C4 {
    return true
  }
  if scalar <= 0x113C5 {
    return false
  }
  if scalar <= 0x113C6 {
    return true
  }
  if scalar <= 0x113C8 {
    return false
  }
  if scalar <= 0x114BA {
    return true
  }
  if scalar <= 0x114BC {
    return false
  }
  if scalar <= 0x114BD {
    return true
  }
  if scalar <= 0x114BE {
    return false
  }
  if scalar <= 0x115B9 {
    return true
  }
  if scalar <= 0x115BB {
    return false
  }
  if scalar <= 0x11937 {
    return true
  }
  if scalar <= 0x11938 {
    return false
  }
  if scalar <= 0x16120 {
    return true
  }
  if scalar <= 0x16128 {
    return false
  }
  if scalar <= 0x16D67 {
    return true
  }
  if scalar <= 0x16D6A {
    return false
  }
  if scalar <= 0x1CCD5 {
    return true
  }
  if scalar <= 0x1CCF9 {
    return false
  }
  if scalar <= 0x1D15D {
    return true
  }
  if scalar <= 0x1D164 {
    return false
  }
  if scalar <= 0x1D1BA {
    return true
  }
  if scalar <= 0x1D1C0 {
    return false
  }
  if scalar <= 0x1D3FF {
    return true
  }
  if scalar <= 0x1D454 {
    return false
  }
  if scalar <= 0x1D455 {
    return true
  }
  if scalar <= 0x1D49C {
    return false
  }
  if scalar <= 0x1D49D {
    return true
  }
  if scalar <= 0x1D49F {
    return false
  }
  if scalar <= 0x1D4A1 {
    return true
  }
  if scalar <= 0x1D4A2 {
    return false
  }
  if scalar <= 0x1D4A4 {
    return true
  }
  if scalar <= 0x1D4A6 {
    return false
  }
  if scalar <= 0x1D4A8 {
    return true
  }
  if scalar <= 0x1D4AC {
    return false
  }
  if scalar <= 0x1D4AD {
    return true
  }
  if scalar <= 0x1D4B9 {
    return false
  }
  if scalar <= 0x1D4BA {
    return true
  }
  if scalar <= 0x1D4BB {
    return false
  }
  if scalar <= 0x1D4BC {
    return true
  }
  if scalar <= 0x1D4C3 {
    return false
  }
  if scalar <= 0x1D4C4 {
    return true
  }
  if scalar <= 0x1D505 {
    return false
  }
  if scalar <= 0x1D506 {
    return true
  }
  if scalar <= 0x1D50A {
    return false
  }
  if scalar <= 0x1D50C {
    return true
  }
  if scalar <= 0x1D514 {
    return false
  }
  if scalar <= 0x1D515 {
    return true
  }
  if scalar <= 0x1D51C {
    return false
  }
  if scalar <= 0x1D51D {
    return true
  }
  if scalar <= 0x1D539 {
    return false
  }
  if scalar <= 0x1D53A {
    return true
  }
  if scalar <= 0x1D53E {
    return false
  }
  if scalar <= 0x1D53F {
    return true
  }
  if scalar <= 0x1D544 {
    return false
  }
  if scalar <= 0x1D545 {
    return true
  }
  if scalar <= 0x1D546 {
    return false
  }
  if scalar <= 0x1D549 {
    return true
  }
  if scalar <= 0x1D550 {
    return false
  }
  if scalar <= 0x1D551 {
    return true
  }
  if scalar <= 0x1D6A5 {
    return false
  }
  if scalar <= 0x1D6A7 {
    return true
  }
  if scalar <= 0x1D7CB {
    return false
  }
  if scalar <= 0x1D7CD {
    return true
  }
  if scalar <= 0x1D7FF {
    return false
  }
  if scalar <= 0x1E02F {
    return true
  }
  if scalar <= 0x1E06D {
    return false
  }
  if scalar <= 0x1EDFF {
    return true
  }
  if scalar <= 0x1EE03 {
    return false
  }
  if scalar <= 0x1EE04 {
    return true
  }
  if scalar <= 0x1EE1F {
    return false
  }
  if scalar <= 0x1EE20 {
    return true
  }
  if scalar <= 0x1EE22 {
    return false
  }
  if scalar <= 0x1EE23 {
    return true
  }
  if scalar <= 0x1EE24 {
    return false
  }
  if scalar <= 0x1EE26 {
    return true
  }
  if scalar <= 0x1EE27 {
    return false
  }
  if scalar <= 0x1EE28 {
    return true
  }
  if scalar <= 0x1EE32 {
    return false
  }
  if scalar <= 0x1EE33 {
    return true
  }
  if scalar <= 0x1EE37 {
    return false
  }
  if scalar <= 0x1EE38 {
    return true
  }
  if scalar <= 0x1EE39 {
    return false
  }
  if scalar <= 0x1EE3A {
    return true
  }
  if scalar <= 0x1EE3B {
    return false
  }
  if scalar <= 0x1EE41 {
    return true
  }
  if scalar <= 0x1EE42 {
    return false
  }
  if scalar <= 0x1EE46 {
    return true
  }
  if scalar <= 0x1EE47 {
    return false
  }
  if scalar <= 0x1EE48 {
    return true
  }
  if scalar <= 0x1EE49 {
    return false
  }
  if scalar <= 0x1EE4A {
    return true
  }
  if scalar <= 0x1EE4B {
    return false
  }
  if scalar <= 0x1EE4C {
    return true
  }
  if scalar <= 0x1EE4F {
    return false
  }
  if scalar <= 0x1EE50 {
    return true
  }
  if scalar <= 0x1EE52 {
    return false
  }
  if scalar <= 0x1EE53 {
    return true
  }
  if scalar <= 0x1EE54 {
    return false
  }
  if scalar <= 0x1EE56 {
    return true
  }
  if scalar <= 0x1EE57 {
    return false
  }
  if scalar <= 0x1EE58 {
    return true
  }
  if scalar <= 0x1EE59 {
    return false
  }
  if scalar <= 0x1EE5A {
    return true
  }
  if scalar <= 0x1EE5B {
    return false
  }
  if scalar <= 0x1EE5C {
    return true
  }
  if scalar <= 0x1EE5D {
    return false
  }
  if scalar <= 0x1EE5E {
    return true
  }
  if scalar <= 0x1EE5F {
    return false
  }
  if scalar <= 0x1EE60 {
    return true
  }
  if scalar <= 0x1EE62 {
    return false
  }
  if scalar <= 0x1EE63 {
    return true
  }
  if scalar <= 0x1EE64 {
    return false
  }
  if scalar <= 0x1EE66 {
    return true
  }
  if scalar <= 0x1EE6A {
    return false
  }
  if scalar <= 0x1EE6B {
    return true
  }
  if scalar <= 0x1EE72 {
    return false
  }
  if scalar <= 0x1EE73 {
    return true
  }
  if scalar <= 0x1EE77 {
    return false
  }
  if scalar <= 0x1EE78 {
    return true
  }
  if scalar <= 0x1EE7C {
    return false
  }
  if scalar <= 0x1EE7D {
    return true
  }
  if scalar <= 0x1EE7E {
    return false
  }
  if scalar <= 0x1EE7F {
    return true
  }
  if scalar <= 0x1EE89 {
    return false
  }
  if scalar <= 0x1EE8A {
    return true
  }
  if scalar <= 0x1EE9B {
    return false
  }
  if scalar <= 0x1EEA0 {
    return true
  }
  if scalar <= 0x1EEA3 {
    return false
  }
  if scalar <= 0x1EEA4 {
    return true
  }
  if scalar <= 0x1EEA9 {
    return false
  }
  if scalar <= 0x1EEAA {
    return true
  }
  if scalar <= 0x1EEBB {
    return false
  }
  if scalar <= 0x1F0FF {
    return true
  }
  if scalar <= 0x1F10A {
    return false
  }
  if scalar <= 0x1F10F {
    return true
  }
  if scalar <= 0x1F12E {
    return false
  }
  if scalar <= 0x1F12F {
    return true
  }
  if scalar <= 0x1F14F {
    return false
  }
  if scalar <= 0x1F169 {
    return true
  }
  if scalar <= 0x1F16C {
    return false
  }
  if scalar <= 0x1F18F {
    return true
  }
  if scalar <= 0x1F190 {
    return false
  }
  if scalar <= 0x1F1FF {
    return true
  }
  if scalar <= 0x1F202 {
    return false
  }
  if scalar <= 0x1F20F {
    return true
  }
  if scalar <= 0x1F23B {
    return false
  }
  if scalar <= 0x1F23F {
    return true
  }
  if scalar <= 0x1F248 {
    return false
  }
  if scalar <= 0x1F24F {
    return true
  }
  if scalar <= 0x1F251 {
    return false
  }
  if scalar <= 0x1FBEF {
    return true
  }
  if scalar <= 0x1FBF9 {
    return false
  }
  if scalar <= 0x2F7FF {
    return true
  }
  if scalar <= 0x2FA1D {
    return false
  }
  return true
}

fileprivate func full_0020compatibility_0020decomposition_0020of_0020_0028_0029_003AUnicode_0020scalar_003AUnicode_0020scalars(_ scalar: Unicode.Scalar) -> String.UnicodeScalarView {
  let value: UInt32 = (scalar).value
  if value <= 0x009F {
    return String(scalar).unicodeScalars
  }
  if value <= 0x00A0 {
    return " ".unicodeScalars
  }
  if value <= 0x00A7 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x00A8 {
    return " \u{0308}".unicodeScalars
  }
  if value <= 0x00A9 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x00AA {
    return "a".unicodeScalars
  }
  if value <= 0x00AE {
    return String(scalar).unicodeScalars
  }
  if value <= 0x00AF {
    return " \u{0304}".unicodeScalars
  }
  if value <= 0x00B1 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x00B2 {
    return "2".unicodeScalars
  }
  if value <= 0x00B3 {
    return "3".unicodeScalars
  }
  if value <= 0x00B4 {
    return " \u{0301}".unicodeScalars
  }
  if value <= 0x00B5 {
    return "μ".unicodeScalars
  }
  if value <= 0x00B7 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x00B8 {
    return " \u{0327}".unicodeScalars
  }
  if value <= 0x00B9 {
    return "1".unicodeScalars
  }
  if value <= 0x00BA {
    return "o".unicodeScalars
  }
  if value <= 0x00BB {
    return String(scalar).unicodeScalars
  }
  if value <= 0x00BC {
    return "1⁄4".unicodeScalars
  }
  if value <= 0x00BD {
    return "1⁄2".unicodeScalars
  }
  if value <= 0x00BE {
    return "3⁄4".unicodeScalars
  }
  if value <= 0x00BF {
    return String(scalar).unicodeScalars
  }
  if value <= 0x00C0 {
    return "A\u{0300}".unicodeScalars
  }
  if value <= 0x00C1 {
    return "A\u{0301}".unicodeScalars
  }
  if value <= 0x00C2 {
    return "A\u{0302}".unicodeScalars
  }
  if value <= 0x00C3 {
    return "A\u{0303}".unicodeScalars
  }
  if value <= 0x00C4 {
    return "A\u{0308}".unicodeScalars
  }
  if value <= 0x00C5 {
    return "A\u{030A}".unicodeScalars
  }
  if value <= 0x00C6 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x00C7 {
    return "C\u{0327}".unicodeScalars
  }
  if value <= 0x00C8 {
    return "E\u{0300}".unicodeScalars
  }
  if value <= 0x00C9 {
    return "E\u{0301}".unicodeScalars
  }
  if value <= 0x00CA {
    return "E\u{0302}".unicodeScalars
  }
  if value <= 0x00CB {
    return "E\u{0308}".unicodeScalars
  }
  if value <= 0x00CC {
    return "I\u{0300}".unicodeScalars
  }
  if value <= 0x00CD {
    return "I\u{0301}".unicodeScalars
  }
  if value <= 0x00CE {
    return "I\u{0302}".unicodeScalars
  }
  if value <= 0x00CF {
    return "I\u{0308}".unicodeScalars
  }
  if value <= 0x00D0 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x00D1 {
    return "N\u{0303}".unicodeScalars
  }
  if value <= 0x00D2 {
    return "O\u{0300}".unicodeScalars
  }
  if value <= 0x00D3 {
    return "O\u{0301}".unicodeScalars
  }
  if value <= 0x00D4 {
    return "O\u{0302}".unicodeScalars
  }
  if value <= 0x00D5 {
    return "O\u{0303}".unicodeScalars
  }
  if value <= 0x00D6 {
    return "O\u{0308}".unicodeScalars
  }
  if value <= 0x00D8 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x00D9 {
    return "U\u{0300}".unicodeScalars
  }
  if value <= 0x00DA {
    return "U\u{0301}".unicodeScalars
  }
  if value <= 0x00DB {
    return "U\u{0302}".unicodeScalars
  }
  if value <= 0x00DC {
    return "U\u{0308}".unicodeScalars
  }
  if value <= 0x00DD {
    return "Y\u{0301}".unicodeScalars
  }
  if value <= 0x00DF {
    return String(scalar).unicodeScalars
  }
  if value <= 0x00E0 {
    return "a\u{0300}".unicodeScalars
  }
  if value <= 0x00E1 {
    return "a\u{0301}".unicodeScalars
  }
  if value <= 0x00E2 {
    return "a\u{0302}".unicodeScalars
  }
  if value <= 0x00E3 {
    return "a\u{0303}".unicodeScalars
  }
  if value <= 0x00E4 {
    return "a\u{0308}".unicodeScalars
  }
  if value <= 0x00E5 {
    return "a\u{030A}".unicodeScalars
  }
  if value <= 0x00E6 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x00E7 {
    return "c\u{0327}".unicodeScalars
  }
  if value <= 0x00E8 {
    return "e\u{0300}".unicodeScalars
  }
  if value <= 0x00E9 {
    return "e\u{0301}".unicodeScalars
  }
  if value <= 0x00EA {
    return "e\u{0302}".unicodeScalars
  }
  if value <= 0x00EB {
    return "e\u{0308}".unicodeScalars
  }
  if value <= 0x00EC {
    return "i\u{0300}".unicodeScalars
  }
  if value <= 0x00ED {
    return "i\u{0301}".unicodeScalars
  }
  if value <= 0x00EE {
    return "i\u{0302}".unicodeScalars
  }
  if value <= 0x00EF {
    return "i\u{0308}".unicodeScalars
  }
  if value <= 0x00F0 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x00F1 {
    return "n\u{0303}".unicodeScalars
  }
  if value <= 0x00F2 {
    return "o\u{0300}".unicodeScalars
  }
  if value <= 0x00F3 {
    return "o\u{0301}".unicodeScalars
  }
  if value <= 0x00F4 {
    return "o\u{0302}".unicodeScalars
  }
  if value <= 0x00F5 {
    return "o\u{0303}".unicodeScalars
  }
  if value <= 0x00F6 {
    return "o\u{0308}".unicodeScalars
  }
  if value <= 0x00F8 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x00F9 {
    return "u\u{0300}".unicodeScalars
  }
  if value <= 0x00FA {
    return "u\u{0301}".unicodeScalars
  }
  if value <= 0x00FB {
    return "u\u{0302}".unicodeScalars
  }
  if value <= 0x00FC {
    return "u\u{0308}".unicodeScalars
  }
  if value <= 0x00FD {
    return "y\u{0301}".unicodeScalars
  }
  if value <= 0x00FE {
    return String(scalar).unicodeScalars
  }
  if value <= 0x00FF {
    return "y\u{0308}".unicodeScalars
  }
  if value <= 0x0100 {
    return "A\u{0304}".unicodeScalars
  }
  if value <= 0x0101 {
    return "a\u{0304}".unicodeScalars
  }
  if value <= 0x0102 {
    return "A\u{0306}".unicodeScalars
  }
  if value <= 0x0103 {
    return "a\u{0306}".unicodeScalars
  }
  if value <= 0x0104 {
    return "A\u{0328}".unicodeScalars
  }
  if value <= 0x0105 {
    return "a\u{0328}".unicodeScalars
  }
  if value <= 0x0106 {
    return "C\u{0301}".unicodeScalars
  }
  if value <= 0x0107 {
    return "c\u{0301}".unicodeScalars
  }
  if value <= 0x0108 {
    return "C\u{0302}".unicodeScalars
  }
  if value <= 0x0109 {
    return "c\u{0302}".unicodeScalars
  }
  if value <= 0x010A {
    return "C\u{0307}".unicodeScalars
  }
  if value <= 0x010B {
    return "c\u{0307}".unicodeScalars
  }
  if value <= 0x010C {
    return "C\u{030C}".unicodeScalars
  }
  if value <= 0x010D {
    return "c\u{030C}".unicodeScalars
  }
  if value <= 0x010E {
    return "D\u{030C}".unicodeScalars
  }
  if value <= 0x010F {
    return "d\u{030C}".unicodeScalars
  }
  if value <= 0x0111 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x0112 {
    return "E\u{0304}".unicodeScalars
  }
  if value <= 0x0113 {
    return "e\u{0304}".unicodeScalars
  }
  if value <= 0x0114 {
    return "E\u{0306}".unicodeScalars
  }
  if value <= 0x0115 {
    return "e\u{0306}".unicodeScalars
  }
  if value <= 0x0116 {
    return "E\u{0307}".unicodeScalars
  }
  if value <= 0x0117 {
    return "e\u{0307}".unicodeScalars
  }
  if value <= 0x0118 {
    return "E\u{0328}".unicodeScalars
  }
  if value <= 0x0119 {
    return "e\u{0328}".unicodeScalars
  }
  if value <= 0x011A {
    return "E\u{030C}".unicodeScalars
  }
  if value <= 0x011B {
    return "e\u{030C}".unicodeScalars
  }
  if value <= 0x011C {
    return "G\u{0302}".unicodeScalars
  }
  if value <= 0x011D {
    return "g\u{0302}".unicodeScalars
  }
  if value <= 0x011E {
    return "G\u{0306}".unicodeScalars
  }
  if value <= 0x011F {
    return "g\u{0306}".unicodeScalars
  }
  if value <= 0x0120 {
    return "G\u{0307}".unicodeScalars
  }
  if value <= 0x0121 {
    return "g\u{0307}".unicodeScalars
  }
  if value <= 0x0122 {
    return "G\u{0327}".unicodeScalars
  }
  if value <= 0x0123 {
    return "g\u{0327}".unicodeScalars
  }
  if value <= 0x0124 {
    return "H\u{0302}".unicodeScalars
  }
  if value <= 0x0125 {
    return "h\u{0302}".unicodeScalars
  }
  if value <= 0x0127 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x0128 {
    return "I\u{0303}".unicodeScalars
  }
  if value <= 0x0129 {
    return "i\u{0303}".unicodeScalars
  }
  if value <= 0x012A {
    return "I\u{0304}".unicodeScalars
  }
  if value <= 0x012B {
    return "i\u{0304}".unicodeScalars
  }
  if value <= 0x012C {
    return "I\u{0306}".unicodeScalars
  }
  if value <= 0x012D {
    return "i\u{0306}".unicodeScalars
  }
  if value <= 0x012E {
    return "I\u{0328}".unicodeScalars
  }
  if value <= 0x012F {
    return "i\u{0328}".unicodeScalars
  }
  if value <= 0x0130 {
    return "I\u{0307}".unicodeScalars
  }
  if value <= 0x0131 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x0132 {
    return "IJ".unicodeScalars
  }
  if value <= 0x0133 {
    return "ij".unicodeScalars
  }
  if value <= 0x0134 {
    return "J\u{0302}".unicodeScalars
  }
  if value <= 0x0135 {
    return "j\u{0302}".unicodeScalars
  }
  if value <= 0x0136 {
    return "K\u{0327}".unicodeScalars
  }
  if value <= 0x0137 {
    return "k\u{0327}".unicodeScalars
  }
  if value <= 0x0138 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x0139 {
    return "L\u{0301}".unicodeScalars
  }
  if value <= 0x013A {
    return "l\u{0301}".unicodeScalars
  }
  if value <= 0x013B {
    return "L\u{0327}".unicodeScalars
  }
  if value <= 0x013C {
    return "l\u{0327}".unicodeScalars
  }
  if value <= 0x013D {
    return "L\u{030C}".unicodeScalars
  }
  if value <= 0x013E {
    return "l\u{030C}".unicodeScalars
  }
  if value <= 0x013F {
    return "L·".unicodeScalars
  }
  if value <= 0x0140 {
    return "l·".unicodeScalars
  }
  if value <= 0x0142 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x0143 {
    return "N\u{0301}".unicodeScalars
  }
  if value <= 0x0144 {
    return "n\u{0301}".unicodeScalars
  }
  if value <= 0x0145 {
    return "N\u{0327}".unicodeScalars
  }
  if value <= 0x0146 {
    return "n\u{0327}".unicodeScalars
  }
  if value <= 0x0147 {
    return "N\u{030C}".unicodeScalars
  }
  if value <= 0x0148 {
    return "n\u{030C}".unicodeScalars
  }
  if value <= 0x0149 {
    return "ʼn".unicodeScalars
  }
  if value <= 0x014B {
    return String(scalar).unicodeScalars
  }
  if value <= 0x014C {
    return "O\u{0304}".unicodeScalars
  }
  if value <= 0x014D {
    return "o\u{0304}".unicodeScalars
  }
  if value <= 0x014E {
    return "O\u{0306}".unicodeScalars
  }
  if value <= 0x014F {
    return "o\u{0306}".unicodeScalars
  }
  if value <= 0x0150 {
    return "O\u{030B}".unicodeScalars
  }
  if value <= 0x0151 {
    return "o\u{030B}".unicodeScalars
  }
  if value <= 0x0153 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x0154 {
    return "R\u{0301}".unicodeScalars
  }
  if value <= 0x0155 {
    return "r\u{0301}".unicodeScalars
  }
  if value <= 0x0156 {
    return "R\u{0327}".unicodeScalars
  }
  if value <= 0x0157 {
    return "r\u{0327}".unicodeScalars
  }
  if value <= 0x0158 {
    return "R\u{030C}".unicodeScalars
  }
  if value <= 0x0159 {
    return "r\u{030C}".unicodeScalars
  }
  if value <= 0x015A {
    return "S\u{0301}".unicodeScalars
  }
  if value <= 0x015B {
    return "s\u{0301}".unicodeScalars
  }
  if value <= 0x015C {
    return "S\u{0302}".unicodeScalars
  }
  if value <= 0x015D {
    return "s\u{0302}".unicodeScalars
  }
  if value <= 0x015E {
    return "S\u{0327}".unicodeScalars
  }
  if value <= 0x015F {
    return "s\u{0327}".unicodeScalars
  }
  if value <= 0x0160 {
    return "S\u{030C}".unicodeScalars
  }
  if value <= 0x0161 {
    return "s\u{030C}".unicodeScalars
  }
  if value <= 0x0162 {
    return "T\u{0327}".unicodeScalars
  }
  if value <= 0x0163 {
    return "t\u{0327}".unicodeScalars
  }
  if value <= 0x0164 {
    return "T\u{030C}".unicodeScalars
  }
  if value <= 0x0165 {
    return "t\u{030C}".unicodeScalars
  }
  if value <= 0x0167 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x0168 {
    return "U\u{0303}".unicodeScalars
  }
  if value <= 0x0169 {
    return "u\u{0303}".unicodeScalars
  }
  if value <= 0x016A {
    return "U\u{0304}".unicodeScalars
  }
  if value <= 0x016B {
    return "u\u{0304}".unicodeScalars
  }
  if value <= 0x016C {
    return "U\u{0306}".unicodeScalars
  }
  if value <= 0x016D {
    return "u\u{0306}".unicodeScalars
  }
  if value <= 0x016E {
    return "U\u{030A}".unicodeScalars
  }
  if value <= 0x016F {
    return "u\u{030A}".unicodeScalars
  }
  if value <= 0x0170 {
    return "U\u{030B}".unicodeScalars
  }
  if value <= 0x0171 {
    return "u\u{030B}".unicodeScalars
  }
  if value <= 0x0172 {
    return "U\u{0328}".unicodeScalars
  }
  if value <= 0x0173 {
    return "u\u{0328}".unicodeScalars
  }
  if value <= 0x0174 {
    return "W\u{0302}".unicodeScalars
  }
  if value <= 0x0175 {
    return "w\u{0302}".unicodeScalars
  }
  if value <= 0x0176 {
    return "Y\u{0302}".unicodeScalars
  }
  if value <= 0x0177 {
    return "y\u{0302}".unicodeScalars
  }
  if value <= 0x0178 {
    return "Y\u{0308}".unicodeScalars
  }
  if value <= 0x0179 {
    return "Z\u{0301}".unicodeScalars
  }
  if value <= 0x017A {
    return "z\u{0301}".unicodeScalars
  }
  if value <= 0x017B {
    return "Z\u{0307}".unicodeScalars
  }
  if value <= 0x017C {
    return "z\u{0307}".unicodeScalars
  }
  if value <= 0x017D {
    return "Z\u{030C}".unicodeScalars
  }
  if value <= 0x017E {
    return "z\u{030C}".unicodeScalars
  }
  if value <= 0x017F {
    return "s".unicodeScalars
  }
  if value <= 0x019F {
    return String(scalar).unicodeScalars
  }
  if value <= 0x01A0 {
    return "O\u{031B}".unicodeScalars
  }
  if value <= 0x01A1 {
    return "o\u{031B}".unicodeScalars
  }
  if value <= 0x01AE {
    return String(scalar).unicodeScalars
  }
  if value <= 0x01AF {
    return "U\u{031B}".unicodeScalars
  }
  if value <= 0x01B0 {
    return "u\u{031B}".unicodeScalars
  }
  if value <= 0x01C3 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x01C4 {
    return "DZ\u{030C}".unicodeScalars
  }
  if value <= 0x01C5 {
    return "Dz\u{030C}".unicodeScalars
  }
  if value <= 0x01C6 {
    return "dz\u{030C}".unicodeScalars
  }
  if value <= 0x01C7 {
    return "LJ".unicodeScalars
  }
  if value <= 0x01C8 {
    return "Lj".unicodeScalars
  }
  if value <= 0x01C9 {
    return "lj".unicodeScalars
  }
  if value <= 0x01CA {
    return "NJ".unicodeScalars
  }
  if value <= 0x01CB {
    return "Nj".unicodeScalars
  }
  if value <= 0x01CC {
    return "nj".unicodeScalars
  }
  if value <= 0x01CD {
    return "A\u{030C}".unicodeScalars
  }
  if value <= 0x01CE {
    return "a\u{030C}".unicodeScalars
  }
  if value <= 0x01CF {
    return "I\u{030C}".unicodeScalars
  }
  if value <= 0x01D0 {
    return "i\u{030C}".unicodeScalars
  }
  if value <= 0x01D1 {
    return "O\u{030C}".unicodeScalars
  }
  if value <= 0x01D2 {
    return "o\u{030C}".unicodeScalars
  }
  if value <= 0x01D3 {
    return "U\u{030C}".unicodeScalars
  }
  if value <= 0x01D4 {
    return "u\u{030C}".unicodeScalars
  }
  if value <= 0x01D5 {
    return "U\u{0308}\u{0304}".unicodeScalars
  }
  if value <= 0x01D6 {
    return "u\u{0308}\u{0304}".unicodeScalars
  }
  if value <= 0x01D7 {
    return "U\u{0308}\u{0301}".unicodeScalars
  }
  if value <= 0x01D8 {
    return "u\u{0308}\u{0301}".unicodeScalars
  }
  if value <= 0x01D9 {
    return "U\u{0308}\u{030C}".unicodeScalars
  }
  if value <= 0x01DA {
    return "u\u{0308}\u{030C}".unicodeScalars
  }
  if value <= 0x01DB {
    return "U\u{0308}\u{0300}".unicodeScalars
  }
  if value <= 0x01DC {
    return "u\u{0308}\u{0300}".unicodeScalars
  }
  if value <= 0x01DD {
    return String(scalar).unicodeScalars
  }
  if value <= 0x01DE {
    return "A\u{0308}\u{0304}".unicodeScalars
  }
  if value <= 0x01DF {
    return "a\u{0308}\u{0304}".unicodeScalars
  }
  if value <= 0x01E0 {
    return "A\u{0307}\u{0304}".unicodeScalars
  }
  if value <= 0x01E1 {
    return "a\u{0307}\u{0304}".unicodeScalars
  }
  if value <= 0x01E2 {
    return "Æ\u{0304}".unicodeScalars
  }
  if value <= 0x01E3 {
    return "æ\u{0304}".unicodeScalars
  }
  if value <= 0x01E5 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x01E6 {
    return "G\u{030C}".unicodeScalars
  }
  if value <= 0x01E7 {
    return "g\u{030C}".unicodeScalars
  }
  if value <= 0x01E8 {
    return "K\u{030C}".unicodeScalars
  }
  if value <= 0x01E9 {
    return "k\u{030C}".unicodeScalars
  }
  if value <= 0x01EA {
    return "O\u{0328}".unicodeScalars
  }
  if value <= 0x01EB {
    return "o\u{0328}".unicodeScalars
  }
  if value <= 0x01EC {
    return "O\u{0328}\u{0304}".unicodeScalars
  }
  if value <= 0x01ED {
    return "o\u{0328}\u{0304}".unicodeScalars
  }
  if value <= 0x01EE {
    return "Ʒ\u{030C}".unicodeScalars
  }
  if value <= 0x01EF {
    return "ʒ\u{030C}".unicodeScalars
  }
  if value <= 0x01F0 {
    return "j\u{030C}".unicodeScalars
  }
  if value <= 0x01F1 {
    return "DZ".unicodeScalars
  }
  if value <= 0x01F2 {
    return "Dz".unicodeScalars
  }
  if value <= 0x01F3 {
    return "dz".unicodeScalars
  }
  if value <= 0x01F4 {
    return "G\u{0301}".unicodeScalars
  }
  if value <= 0x01F5 {
    return "g\u{0301}".unicodeScalars
  }
  if value <= 0x01F7 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x01F8 {
    return "N\u{0300}".unicodeScalars
  }
  if value <= 0x01F9 {
    return "n\u{0300}".unicodeScalars
  }
  if value <= 0x01FA {
    return "A\u{030A}\u{0301}".unicodeScalars
  }
  if value <= 0x01FB {
    return "a\u{030A}\u{0301}".unicodeScalars
  }
  if value <= 0x01FC {
    return "Æ\u{0301}".unicodeScalars
  }
  if value <= 0x01FD {
    return "æ\u{0301}".unicodeScalars
  }
  if value <= 0x01FE {
    return "Ø\u{0301}".unicodeScalars
  }
  if value <= 0x01FF {
    return "ø\u{0301}".unicodeScalars
  }
  if value <= 0x0200 {
    return "A\u{030F}".unicodeScalars
  }
  if value <= 0x0201 {
    return "a\u{030F}".unicodeScalars
  }
  if value <= 0x0202 {
    return "A\u{0311}".unicodeScalars
  }
  if value <= 0x0203 {
    return "a\u{0311}".unicodeScalars
  }
  if value <= 0x0204 {
    return "E\u{030F}".unicodeScalars
  }
  if value <= 0x0205 {
    return "e\u{030F}".unicodeScalars
  }
  if value <= 0x0206 {
    return "E\u{0311}".unicodeScalars
  }
  if value <= 0x0207 {
    return "e\u{0311}".unicodeScalars
  }
  if value <= 0x0208 {
    return "I\u{030F}".unicodeScalars
  }
  if value <= 0x0209 {
    return "i\u{030F}".unicodeScalars
  }
  if value <= 0x020A {
    return "I\u{0311}".unicodeScalars
  }
  if value <= 0x020B {
    return "i\u{0311}".unicodeScalars
  }
  if value <= 0x020C {
    return "O\u{030F}".unicodeScalars
  }
  if value <= 0x020D {
    return "o\u{030F}".unicodeScalars
  }
  if value <= 0x020E {
    return "O\u{0311}".unicodeScalars
  }
  if value <= 0x020F {
    return "o\u{0311}".unicodeScalars
  }
  if value <= 0x0210 {
    return "R\u{030F}".unicodeScalars
  }
  if value <= 0x0211 {
    return "r\u{030F}".unicodeScalars
  }
  if value <= 0x0212 {
    return "R\u{0311}".unicodeScalars
  }
  if value <= 0x0213 {
    return "r\u{0311}".unicodeScalars
  }
  if value <= 0x0214 {
    return "U\u{030F}".unicodeScalars
  }
  if value <= 0x0215 {
    return "u\u{030F}".unicodeScalars
  }
  if value <= 0x0216 {
    return "U\u{0311}".unicodeScalars
  }
  if value <= 0x0217 {
    return "u\u{0311}".unicodeScalars
  }
  if value <= 0x0218 {
    return "S\u{0326}".unicodeScalars
  }
  if value <= 0x0219 {
    return "s\u{0326}".unicodeScalars
  }
  if value <= 0x021A {
    return "T\u{0326}".unicodeScalars
  }
  if value <= 0x021B {
    return "t\u{0326}".unicodeScalars
  }
  if value <= 0x021D {
    return String(scalar).unicodeScalars
  }
  if value <= 0x021E {
    return "H\u{030C}".unicodeScalars
  }
  if value <= 0x021F {
    return "h\u{030C}".unicodeScalars
  }
  if value <= 0x0225 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x0226 {
    return "A\u{0307}".unicodeScalars
  }
  if value <= 0x0227 {
    return "a\u{0307}".unicodeScalars
  }
  if value <= 0x0228 {
    return "E\u{0327}".unicodeScalars
  }
  if value <= 0x0229 {
    return "e\u{0327}".unicodeScalars
  }
  if value <= 0x022A {
    return "O\u{0308}\u{0304}".unicodeScalars
  }
  if value <= 0x022B {
    return "o\u{0308}\u{0304}".unicodeScalars
  }
  if value <= 0x022C {
    return "O\u{0303}\u{0304}".unicodeScalars
  }
  if value <= 0x022D {
    return "o\u{0303}\u{0304}".unicodeScalars
  }
  if value <= 0x022E {
    return "O\u{0307}".unicodeScalars
  }
  if value <= 0x022F {
    return "o\u{0307}".unicodeScalars
  }
  if value <= 0x0230 {
    return "O\u{0307}\u{0304}".unicodeScalars
  }
  if value <= 0x0231 {
    return "o\u{0307}\u{0304}".unicodeScalars
  }
  if value <= 0x0232 {
    return "Y\u{0304}".unicodeScalars
  }
  if value <= 0x0233 {
    return "y\u{0304}".unicodeScalars
  }
  if value <= 0x02AF {
    return String(scalar).unicodeScalars
  }
  if value <= 0x02B0 {
    return "h".unicodeScalars
  }
  if value <= 0x02B1 {
    return "ɦ".unicodeScalars
  }
  if value <= 0x02B2 {
    return "j".unicodeScalars
  }
  if value <= 0x02B3 {
    return "r".unicodeScalars
  }
  if value <= 0x02B4 {
    return "ɹ".unicodeScalars
  }
  if value <= 0x02B5 {
    return "ɻ".unicodeScalars
  }
  if value <= 0x02B6 {
    return "ʁ".unicodeScalars
  }
  if value <= 0x02B7 {
    return "w".unicodeScalars
  }
  if value <= 0x02B8 {
    return "y".unicodeScalars
  }
  if value <= 0x02D7 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x02D8 {
    return " \u{0306}".unicodeScalars
  }
  if value <= 0x02D9 {
    return " \u{0307}".unicodeScalars
  }
  if value <= 0x02DA {
    return " \u{030A}".unicodeScalars
  }
  if value <= 0x02DB {
    return " \u{0328}".unicodeScalars
  }
  if value <= 0x02DC {
    return " \u{0303}".unicodeScalars
  }
  if value <= 0x02DD {
    return " \u{030B}".unicodeScalars
  }
  if value <= 0x02DF {
    return String(scalar).unicodeScalars
  }
  if value <= 0x02E0 {
    return "ɣ".unicodeScalars
  }
  if value <= 0x02E1 {
    return "l".unicodeScalars
  }
  if value <= 0x02E2 {
    return "s".unicodeScalars
  }
  if value <= 0x02E3 {
    return "x".unicodeScalars
  }
  if value <= 0x02E4 {
    return "ʕ".unicodeScalars
  }
  if value <= 0x033F {
    return String(scalar).unicodeScalars
  }
  if value <= 0x0340 {
    return "\u{0300}".unicodeScalars
  }
  if value <= 0x0341 {
    return "\u{0301}".unicodeScalars
  }
  if value <= 0x0342 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x0343 {
    return "\u{0313}".unicodeScalars
  }
  if value <= 0x0344 {
    return "\u{0308}\u{0301}".unicodeScalars
  }
  if value <= 0x0373 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x0374 {
    return "ʹ".unicodeScalars
  }
  if value <= 0x0379 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x037A {
    return " \u{0345}".unicodeScalars
  }
  if value <= 0x037D {
    return String(scalar).unicodeScalars
  }
  if value <= 0x037E {
    return ";".unicodeScalars
  }
  if value <= 0x0383 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x0384 {
    return " \u{0301}".unicodeScalars
  }
  if value <= 0x0385 {
    return " \u{0308}\u{0301}".unicodeScalars
  }
  if value <= 0x0386 {
    return "Α\u{0301}".unicodeScalars
  }
  if value <= 0x0387 {
    return "·".unicodeScalars
  }
  if value <= 0x0388 {
    return "Ε\u{0301}".unicodeScalars
  }
  if value <= 0x0389 {
    return "Η\u{0301}".unicodeScalars
  }
  if value <= 0x038A {
    return "Ι\u{0301}".unicodeScalars
  }
  if value <= 0x038B {
    return String(scalar).unicodeScalars
  }
  if value <= 0x038C {
    return "Ο\u{0301}".unicodeScalars
  }
  if value <= 0x038D {
    return String(scalar).unicodeScalars
  }
  if value <= 0x038E {
    return "Υ\u{0301}".unicodeScalars
  }
  if value <= 0x038F {
    return "Ω\u{0301}".unicodeScalars
  }
  if value <= 0x0390 {
    return "ι\u{0308}\u{0301}".unicodeScalars
  }
  if value <= 0x03A9 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x03AA {
    return "Ι\u{0308}".unicodeScalars
  }
  if value <= 0x03AB {
    return "Υ\u{0308}".unicodeScalars
  }
  if value <= 0x03AC {
    return "α\u{0301}".unicodeScalars
  }
  if value <= 0x03AD {
    return "ε\u{0301}".unicodeScalars
  }
  if value <= 0x03AE {
    return "η\u{0301}".unicodeScalars
  }
  if value <= 0x03AF {
    return "ι\u{0301}".unicodeScalars
  }
  if value <= 0x03B0 {
    return "υ\u{0308}\u{0301}".unicodeScalars
  }
  if value <= 0x03C9 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x03CA {
    return "ι\u{0308}".unicodeScalars
  }
  if value <= 0x03CB {
    return "υ\u{0308}".unicodeScalars
  }
  if value <= 0x03CC {
    return "ο\u{0301}".unicodeScalars
  }
  if value <= 0x03CD {
    return "υ\u{0301}".unicodeScalars
  }
  if value <= 0x03CE {
    return "ω\u{0301}".unicodeScalars
  }
  if value <= 0x03CF {
    return String(scalar).unicodeScalars
  }
  if value <= 0x03D0 {
    return "β".unicodeScalars
  }
  if value <= 0x03D1 {
    return "θ".unicodeScalars
  }
  if value <= 0x03D2 {
    return "Υ".unicodeScalars
  }
  if value <= 0x03D3 {
    return "Υ\u{0301}".unicodeScalars
  }
  if value <= 0x03D4 {
    return "Υ\u{0308}".unicodeScalars
  }
  if value <= 0x03D5 {
    return "φ".unicodeScalars
  }
  if value <= 0x03D6 {
    return "π".unicodeScalars
  }
  if value <= 0x03EF {
    return String(scalar).unicodeScalars
  }
  if value <= 0x03F0 {
    return "κ".unicodeScalars
  }
  if value <= 0x03F1 {
    return "ρ".unicodeScalars
  }
  if value <= 0x03F2 {
    return "ς".unicodeScalars
  }
  if value <= 0x03F3 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x03F4 {
    return "Θ".unicodeScalars
  }
  if value <= 0x03F5 {
    return "ε".unicodeScalars
  }
  if value <= 0x03F8 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x03F9 {
    return "Σ".unicodeScalars
  }
  if value <= 0x03FF {
    return String(scalar).unicodeScalars
  }
  if value <= 0x0400 {
    return "Е\u{0300}".unicodeScalars
  }
  if value <= 0x0401 {
    return "Е\u{0308}".unicodeScalars
  }
  if value <= 0x0402 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x0403 {
    return "Г\u{0301}".unicodeScalars
  }
  if value <= 0x0406 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x0407 {
    return "І\u{0308}".unicodeScalars
  }
  if value <= 0x040B {
    return String(scalar).unicodeScalars
  }
  if value <= 0x040C {
    return "К\u{0301}".unicodeScalars
  }
  if value <= 0x040D {
    return "И\u{0300}".unicodeScalars
  }
  if value <= 0x040E {
    return "У\u{0306}".unicodeScalars
  }
  if value <= 0x0418 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x0419 {
    return "И\u{0306}".unicodeScalars
  }
  if value <= 0x0438 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x0439 {
    return "и\u{0306}".unicodeScalars
  }
  if value <= 0x044F {
    return String(scalar).unicodeScalars
  }
  if value <= 0x0450 {
    return "е\u{0300}".unicodeScalars
  }
  if value <= 0x0451 {
    return "е\u{0308}".unicodeScalars
  }
  if value <= 0x0452 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x0453 {
    return "г\u{0301}".unicodeScalars
  }
  if value <= 0x0456 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x0457 {
    return "і\u{0308}".unicodeScalars
  }
  if value <= 0x045B {
    return String(scalar).unicodeScalars
  }
  if value <= 0x045C {
    return "к\u{0301}".unicodeScalars
  }
  if value <= 0x045D {
    return "и\u{0300}".unicodeScalars
  }
  if value <= 0x045E {
    return "у\u{0306}".unicodeScalars
  }
  if value <= 0x0475 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x0476 {
    return "Ѵ\u{030F}".unicodeScalars
  }
  if value <= 0x0477 {
    return "ѵ\u{030F}".unicodeScalars
  }
  if value <= 0x04C0 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x04C1 {
    return "Ж\u{0306}".unicodeScalars
  }
  if value <= 0x04C2 {
    return "ж\u{0306}".unicodeScalars
  }
  if value <= 0x04CF {
    return String(scalar).unicodeScalars
  }
  if value <= 0x04D0 {
    return "А\u{0306}".unicodeScalars
  }
  if value <= 0x04D1 {
    return "а\u{0306}".unicodeScalars
  }
  if value <= 0x04D2 {
    return "А\u{0308}".unicodeScalars
  }
  if value <= 0x04D3 {
    return "а\u{0308}".unicodeScalars
  }
  if value <= 0x04D5 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x04D6 {
    return "Е\u{0306}".unicodeScalars
  }
  if value <= 0x04D7 {
    return "е\u{0306}".unicodeScalars
  }
  if value <= 0x04D9 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x04DA {
    return "Ә\u{0308}".unicodeScalars
  }
  if value <= 0x04DB {
    return "ә\u{0308}".unicodeScalars
  }
  if value <= 0x04DC {
    return "Ж\u{0308}".unicodeScalars
  }
  if value <= 0x04DD {
    return "ж\u{0308}".unicodeScalars
  }
  if value <= 0x04DE {
    return "З\u{0308}".unicodeScalars
  }
  if value <= 0x04DF {
    return "з\u{0308}".unicodeScalars
  }
  if value <= 0x04E1 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x04E2 {
    return "И\u{0304}".unicodeScalars
  }
  if value <= 0x04E3 {
    return "и\u{0304}".unicodeScalars
  }
  if value <= 0x04E4 {
    return "И\u{0308}".unicodeScalars
  }
  if value <= 0x04E5 {
    return "и\u{0308}".unicodeScalars
  }
  if value <= 0x04E6 {
    return "О\u{0308}".unicodeScalars
  }
  if value <= 0x04E7 {
    return "о\u{0308}".unicodeScalars
  }
  if value <= 0x04E9 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x04EA {
    return "Ө\u{0308}".unicodeScalars
  }
  if value <= 0x04EB {
    return "ө\u{0308}".unicodeScalars
  }
  if value <= 0x04EC {
    return "Э\u{0308}".unicodeScalars
  }
  if value <= 0x04ED {
    return "э\u{0308}".unicodeScalars
  }
  if value <= 0x04EE {
    return "У\u{0304}".unicodeScalars
  }
  if value <= 0x04EF {
    return "у\u{0304}".unicodeScalars
  }
  if value <= 0x04F0 {
    return "У\u{0308}".unicodeScalars
  }
  if value <= 0x04F1 {
    return "у\u{0308}".unicodeScalars
  }
  if value <= 0x04F2 {
    return "У\u{030B}".unicodeScalars
  }
  if value <= 0x04F3 {
    return "у\u{030B}".unicodeScalars
  }
  if value <= 0x04F4 {
    return "Ч\u{0308}".unicodeScalars
  }
  if value <= 0x04F5 {
    return "ч\u{0308}".unicodeScalars
  }
  if value <= 0x04F7 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x04F8 {
    return "Ы\u{0308}".unicodeScalars
  }
  if value <= 0x04F9 {
    return "ы\u{0308}".unicodeScalars
  }
  if value <= 0x0586 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x0587 {
    return "եւ".unicodeScalars
  }
  if value <= 0x0621 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x0622 {
    return "ا\u{0653}".unicodeScalars
  }
  if value <= 0x0623 {
    return "ا\u{0654}".unicodeScalars
  }
  if value <= 0x0624 {
    return "و\u{0654}".unicodeScalars
  }
  if value <= 0x0625 {
    return "ا\u{0655}".unicodeScalars
  }
  if value <= 0x0626 {
    return "ي\u{0654}".unicodeScalars
  }
  if value <= 0x0674 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x0675 {
    return "اٴ".unicodeScalars
  }
  if value <= 0x0676 {
    return "وٴ".unicodeScalars
  }
  if value <= 0x0677 {
    return "ۇٴ".unicodeScalars
  }
  if value <= 0x0678 {
    return "يٴ".unicodeScalars
  }
  if value <= 0x06BF {
    return String(scalar).unicodeScalars
  }
  if value <= 0x06C0 {
    return "ە\u{0654}".unicodeScalars
  }
  if value <= 0x06C1 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x06C2 {
    return "ہ\u{0654}".unicodeScalars
  }
  if value <= 0x06D2 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x06D3 {
    return "ے\u{0654}".unicodeScalars
  }
  if value <= 0x0928 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x0929 {
    return "न\u{093C}".unicodeScalars
  }
  if value <= 0x0930 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x0931 {
    return "र\u{093C}".unicodeScalars
  }
  if value <= 0x0933 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x0934 {
    return "ळ\u{093C}".unicodeScalars
  }
  if value <= 0x0957 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x0958 {
    return "क\u{093C}".unicodeScalars
  }
  if value <= 0x0959 {
    return "ख\u{093C}".unicodeScalars
  }
  if value <= 0x095A {
    return "ग\u{093C}".unicodeScalars
  }
  if value <= 0x095B {
    return "ज\u{093C}".unicodeScalars
  }
  if value <= 0x095C {
    return "ड\u{093C}".unicodeScalars
  }
  if value <= 0x095D {
    return "ढ\u{093C}".unicodeScalars
  }
  if value <= 0x095E {
    return "फ\u{093C}".unicodeScalars
  }
  if value <= 0x095F {
    return "य\u{093C}".unicodeScalars
  }
  if value <= 0x09CA {
    return String(scalar).unicodeScalars
  }
  if value <= 0x09CB {
    return "ো".unicodeScalars
  }
  if value <= 0x09CC {
    return "ৌ".unicodeScalars
  }
  if value <= 0x09DB {
    return String(scalar).unicodeScalars
  }
  if value <= 0x09DC {
    return "ড\u{09BC}".unicodeScalars
  }
  if value <= 0x09DD {
    return "ঢ\u{09BC}".unicodeScalars
  }
  if value <= 0x09DE {
    return String(scalar).unicodeScalars
  }
  if value <= 0x09DF {
    return "য\u{09BC}".unicodeScalars
  }
  if value <= 0x0A32 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x0A33 {
    return "ਲ\u{0A3C}".unicodeScalars
  }
  if value <= 0x0A35 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x0A36 {
    return "ਸ\u{0A3C}".unicodeScalars
  }
  if value <= 0x0A58 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x0A59 {
    return "ਖ\u{0A3C}".unicodeScalars
  }
  if value <= 0x0A5A {
    return "ਗ\u{0A3C}".unicodeScalars
  }
  if value <= 0x0A5B {
    return "ਜ\u{0A3C}".unicodeScalars
  }
  if value <= 0x0A5D {
    return String(scalar).unicodeScalars
  }
  if value <= 0x0A5E {
    return "ਫ\u{0A3C}".unicodeScalars
  }
  if value <= 0x0B47 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x0B48 {
    return "ୈ".unicodeScalars
  }
  if value <= 0x0B4A {
    return String(scalar).unicodeScalars
  }
  if value <= 0x0B4B {
    return "ୋ".unicodeScalars
  }
  if value <= 0x0B4C {
    return "ୌ".unicodeScalars
  }
  if value <= 0x0B5B {
    return String(scalar).unicodeScalars
  }
  if value <= 0x0B5C {
    return "ଡ\u{0B3C}".unicodeScalars
  }
  if value <= 0x0B5D {
    return "ଢ\u{0B3C}".unicodeScalars
  }
  if value <= 0x0B93 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x0B94 {
    return "ஔ".unicodeScalars
  }
  if value <= 0x0BC9 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x0BCA {
    return "ொ".unicodeScalars
  }
  if value <= 0x0BCB {
    return "ோ".unicodeScalars
  }
  if value <= 0x0BCC {
    return "ௌ".unicodeScalars
  }
  if value <= 0x0C47 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x0C48 {
    return "ె\u{0C56}".unicodeScalars
  }
  if value <= 0x0CBF {
    return String(scalar).unicodeScalars
  }
  if value <= 0x0CC0 {
    return "ೀ".unicodeScalars
  }
  if value <= 0x0CC6 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x0CC7 {
    return "ೇ".unicodeScalars
  }
  if value <= 0x0CC8 {
    return "ೈ".unicodeScalars
  }
  if value <= 0x0CC9 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x0CCA {
    return "ೊ".unicodeScalars
  }
  if value <= 0x0CCB {
    return "ೋ".unicodeScalars
  }
  if value <= 0x0D49 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x0D4A {
    return "ൊ".unicodeScalars
  }
  if value <= 0x0D4B {
    return "ോ".unicodeScalars
  }
  if value <= 0x0D4C {
    return "ൌ".unicodeScalars
  }
  if value <= 0x0DD9 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x0DDA {
    return "ෙ\u{0DCA}".unicodeScalars
  }
  if value <= 0x0DDB {
    return String(scalar).unicodeScalars
  }
  if value <= 0x0DDC {
    return "ො".unicodeScalars
  }
  if value <= 0x0DDD {
    return "ො\u{0DCA}".unicodeScalars
  }
  if value <= 0x0DDE {
    return "ෞ".unicodeScalars
  }
  if value <= 0x0E32 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x0E33 {
    return "ํา".unicodeScalars
  }
  if value <= 0x0EB2 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x0EB3 {
    return "ໍາ".unicodeScalars
  }
  if value <= 0x0EDB {
    return String(scalar).unicodeScalars
  }
  if value <= 0x0EDC {
    return "ຫນ".unicodeScalars
  }
  if value <= 0x0EDD {
    return "ຫມ".unicodeScalars
  }
  if value <= 0x0F0B {
    return String(scalar).unicodeScalars
  }
  if value <= 0x0F0C {
    return "་".unicodeScalars
  }
  if value <= 0x0F42 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x0F43 {
    return "གྷ".unicodeScalars
  }
  if value <= 0x0F4C {
    return String(scalar).unicodeScalars
  }
  if value <= 0x0F4D {
    return "ཌྷ".unicodeScalars
  }
  if value <= 0x0F51 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x0F52 {
    return "དྷ".unicodeScalars
  }
  if value <= 0x0F56 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x0F57 {
    return "བྷ".unicodeScalars
  }
  if value <= 0x0F5B {
    return String(scalar).unicodeScalars
  }
  if value <= 0x0F5C {
    return "ཛྷ".unicodeScalars
  }
  if value <= 0x0F68 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x0F69 {
    return "ཀྵ".unicodeScalars
  }
  if value <= 0x0F72 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x0F73 {
    return "\u{0F71}\u{0F72}".unicodeScalars
  }
  if value <= 0x0F74 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x0F75 {
    return "\u{0F71}\u{0F74}".unicodeScalars
  }
  if value <= 0x0F76 {
    return "ྲ\u{0F80}".unicodeScalars
  }
  if value <= 0x0F77 {
    return "ྲ\u{0F71}\u{0F80}".unicodeScalars
  }
  if value <= 0x0F78 {
    return "ླ\u{0F80}".unicodeScalars
  }
  if value <= 0x0F79 {
    return "ླ\u{0F71}\u{0F80}".unicodeScalars
  }
  if value <= 0x0F80 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x0F81 {
    return "\u{0F71}\u{0F80}".unicodeScalars
  }
  if value <= 0x0F92 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x0F93 {
    return "ྒྷ".unicodeScalars
  }
  if value <= 0x0F9C {
    return String(scalar).unicodeScalars
  }
  if value <= 0x0F9D {
    return "ྜྷ".unicodeScalars
  }
  if value <= 0x0FA1 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x0FA2 {
    return "ྡྷ".unicodeScalars
  }
  if value <= 0x0FA6 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x0FA7 {
    return "ྦྷ".unicodeScalars
  }
  if value <= 0x0FAB {
    return String(scalar).unicodeScalars
  }
  if value <= 0x0FAC {
    return "ྫྷ".unicodeScalars
  }
  if value <= 0x0FB8 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x0FB9 {
    return "ྐྵ".unicodeScalars
  }
  if value <= 0x1025 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1026 {
    return "ဦ".unicodeScalars
  }
  if value <= 0x10FB {
    return String(scalar).unicodeScalars
  }
  if value <= 0x10FC {
    return "ნ".unicodeScalars
  }
  if value <= 0x1B05 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1B06 {
    return "ᬆ".unicodeScalars
  }
  if value <= 0x1B07 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1B08 {
    return "ᬈ".unicodeScalars
  }
  if value <= 0x1B09 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1B0A {
    return "ᬊ".unicodeScalars
  }
  if value <= 0x1B0B {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1B0C {
    return "ᬌ".unicodeScalars
  }
  if value <= 0x1B0D {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1B0E {
    return "ᬎ".unicodeScalars
  }
  if value <= 0x1B11 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1B12 {
    return "ᬒ".unicodeScalars
  }
  if value <= 0x1B3A {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1B3B {
    return "ᬻ".unicodeScalars
  }
  if value <= 0x1B3C {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1B3D {
    return "ᬽ".unicodeScalars
  }
  if value <= 0x1B3F {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1B40 {
    return "ᭀ".unicodeScalars
  }
  if value <= 0x1B41 {
    return "ᭁ".unicodeScalars
  }
  if value <= 0x1B42 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1B43 {
    return "ᭃ".unicodeScalars
  }
  if value <= 0x1D2B {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1D2C {
    return "A".unicodeScalars
  }
  if value <= 0x1D2D {
    return "Æ".unicodeScalars
  }
  if value <= 0x1D2E {
    return "B".unicodeScalars
  }
  if value <= 0x1D2F {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1D30 {
    return "D".unicodeScalars
  }
  if value <= 0x1D31 {
    return "E".unicodeScalars
  }
  if value <= 0x1D32 {
    return "Ǝ".unicodeScalars
  }
  if value <= 0x1D33 {
    return "G".unicodeScalars
  }
  if value <= 0x1D34 {
    return "H".unicodeScalars
  }
  if value <= 0x1D35 {
    return "I".unicodeScalars
  }
  if value <= 0x1D36 {
    return "J".unicodeScalars
  }
  if value <= 0x1D37 {
    return "K".unicodeScalars
  }
  if value <= 0x1D38 {
    return "L".unicodeScalars
  }
  if value <= 0x1D39 {
    return "M".unicodeScalars
  }
  if value <= 0x1D3A {
    return "N".unicodeScalars
  }
  if value <= 0x1D3B {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1D3C {
    return "O".unicodeScalars
  }
  if value <= 0x1D3D {
    return "Ȣ".unicodeScalars
  }
  if value <= 0x1D3E {
    return "P".unicodeScalars
  }
  if value <= 0x1D3F {
    return "R".unicodeScalars
  }
  if value <= 0x1D40 {
    return "T".unicodeScalars
  }
  if value <= 0x1D41 {
    return "U".unicodeScalars
  }
  if value <= 0x1D42 {
    return "W".unicodeScalars
  }
  if value <= 0x1D43 {
    return "a".unicodeScalars
  }
  if value <= 0x1D44 {
    return "ɐ".unicodeScalars
  }
  if value <= 0x1D45 {
    return "ɑ".unicodeScalars
  }
  if value <= 0x1D46 {
    return "ᴂ".unicodeScalars
  }
  if value <= 0x1D47 {
    return "b".unicodeScalars
  }
  if value <= 0x1D48 {
    return "d".unicodeScalars
  }
  if value <= 0x1D49 {
    return "e".unicodeScalars
  }
  if value <= 0x1D4A {
    return "ə".unicodeScalars
  }
  if value <= 0x1D4B {
    return "ɛ".unicodeScalars
  }
  if value <= 0x1D4C {
    return "ɜ".unicodeScalars
  }
  if value <= 0x1D4D {
    return "g".unicodeScalars
  }
  if value <= 0x1D4E {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1D4F {
    return "k".unicodeScalars
  }
  if value <= 0x1D50 {
    return "m".unicodeScalars
  }
  if value <= 0x1D51 {
    return "ŋ".unicodeScalars
  }
  if value <= 0x1D52 {
    return "o".unicodeScalars
  }
  if value <= 0x1D53 {
    return "ɔ".unicodeScalars
  }
  if value <= 0x1D54 {
    return "ᴖ".unicodeScalars
  }
  if value <= 0x1D55 {
    return "ᴗ".unicodeScalars
  }
  if value <= 0x1D56 {
    return "p".unicodeScalars
  }
  if value <= 0x1D57 {
    return "t".unicodeScalars
  }
  if value <= 0x1D58 {
    return "u".unicodeScalars
  }
  if value <= 0x1D59 {
    return "ᴝ".unicodeScalars
  }
  if value <= 0x1D5A {
    return "ɯ".unicodeScalars
  }
  if value <= 0x1D5B {
    return "v".unicodeScalars
  }
  if value <= 0x1D5C {
    return "ᴥ".unicodeScalars
  }
  if value <= 0x1D5D {
    return "β".unicodeScalars
  }
  if value <= 0x1D5E {
    return "γ".unicodeScalars
  }
  if value <= 0x1D5F {
    return "δ".unicodeScalars
  }
  if value <= 0x1D60 {
    return "φ".unicodeScalars
  }
  if value <= 0x1D61 {
    return "χ".unicodeScalars
  }
  if value <= 0x1D62 {
    return "i".unicodeScalars
  }
  if value <= 0x1D63 {
    return "r".unicodeScalars
  }
  if value <= 0x1D64 {
    return "u".unicodeScalars
  }
  if value <= 0x1D65 {
    return "v".unicodeScalars
  }
  if value <= 0x1D66 {
    return "β".unicodeScalars
  }
  if value <= 0x1D67 {
    return "γ".unicodeScalars
  }
  if value <= 0x1D68 {
    return "ρ".unicodeScalars
  }
  if value <= 0x1D69 {
    return "φ".unicodeScalars
  }
  if value <= 0x1D6A {
    return "χ".unicodeScalars
  }
  if value <= 0x1D77 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1D78 {
    return "н".unicodeScalars
  }
  if value <= 0x1D9A {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1D9B {
    return "ɒ".unicodeScalars
  }
  if value <= 0x1D9C {
    return "c".unicodeScalars
  }
  if value <= 0x1D9D {
    return "ɕ".unicodeScalars
  }
  if value <= 0x1D9E {
    return "ð".unicodeScalars
  }
  if value <= 0x1D9F {
    return "ɜ".unicodeScalars
  }
  if value <= 0x1DA0 {
    return "f".unicodeScalars
  }
  if value <= 0x1DA1 {
    return "ɟ".unicodeScalars
  }
  if value <= 0x1DA2 {
    return "ɡ".unicodeScalars
  }
  if value <= 0x1DA3 {
    return "ɥ".unicodeScalars
  }
  if value <= 0x1DA4 {
    return "ɨ".unicodeScalars
  }
  if value <= 0x1DA5 {
    return "ɩ".unicodeScalars
  }
  if value <= 0x1DA6 {
    return "ɪ".unicodeScalars
  }
  if value <= 0x1DA7 {
    return "ᵻ".unicodeScalars
  }
  if value <= 0x1DA8 {
    return "ʝ".unicodeScalars
  }
  if value <= 0x1DA9 {
    return "ɭ".unicodeScalars
  }
  if value <= 0x1DAA {
    return "ᶅ".unicodeScalars
  }
  if value <= 0x1DAB {
    return "ʟ".unicodeScalars
  }
  if value <= 0x1DAC {
    return "ɱ".unicodeScalars
  }
  if value <= 0x1DAD {
    return "ɰ".unicodeScalars
  }
  if value <= 0x1DAE {
    return "ɲ".unicodeScalars
  }
  if value <= 0x1DAF {
    return "ɳ".unicodeScalars
  }
  if value <= 0x1DB0 {
    return "ɴ".unicodeScalars
  }
  if value <= 0x1DB1 {
    return "ɵ".unicodeScalars
  }
  if value <= 0x1DB2 {
    return "ɸ".unicodeScalars
  }
  if value <= 0x1DB3 {
    return "ʂ".unicodeScalars
  }
  if value <= 0x1DB4 {
    return "ʃ".unicodeScalars
  }
  if value <= 0x1DB5 {
    return "ƫ".unicodeScalars
  }
  if value <= 0x1DB6 {
    return "ʉ".unicodeScalars
  }
  if value <= 0x1DB7 {
    return "ʊ".unicodeScalars
  }
  if value <= 0x1DB8 {
    return "ᴜ".unicodeScalars
  }
  if value <= 0x1DB9 {
    return "ʋ".unicodeScalars
  }
  if value <= 0x1DBA {
    return "ʌ".unicodeScalars
  }
  if value <= 0x1DBB {
    return "z".unicodeScalars
  }
  if value <= 0x1DBC {
    return "ʐ".unicodeScalars
  }
  if value <= 0x1DBD {
    return "ʑ".unicodeScalars
  }
  if value <= 0x1DBE {
    return "ʒ".unicodeScalars
  }
  if value <= 0x1DBF {
    return "θ".unicodeScalars
  }
  if value <= 0x1DFF {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1E00 {
    return "A\u{0325}".unicodeScalars
  }
  if value <= 0x1E01 {
    return "a\u{0325}".unicodeScalars
  }
  if value <= 0x1E02 {
    return "B\u{0307}".unicodeScalars
  }
  if value <= 0x1E03 {
    return "b\u{0307}".unicodeScalars
  }
  if value <= 0x1E04 {
    return "B\u{0323}".unicodeScalars
  }
  if value <= 0x1E05 {
    return "b\u{0323}".unicodeScalars
  }
  if value <= 0x1E06 {
    return "B\u{0331}".unicodeScalars
  }
  if value <= 0x1E07 {
    return "b\u{0331}".unicodeScalars
  }
  if value <= 0x1E08 {
    return "C\u{0327}\u{0301}".unicodeScalars
  }
  if value <= 0x1E09 {
    return "c\u{0327}\u{0301}".unicodeScalars
  }
  if value <= 0x1E0A {
    return "D\u{0307}".unicodeScalars
  }
  if value <= 0x1E0B {
    return "d\u{0307}".unicodeScalars
  }
  if value <= 0x1E0C {
    return "D\u{0323}".unicodeScalars
  }
  if value <= 0x1E0D {
    return "d\u{0323}".unicodeScalars
  }
  if value <= 0x1E0E {
    return "D\u{0331}".unicodeScalars
  }
  if value <= 0x1E0F {
    return "d\u{0331}".unicodeScalars
  }
  if value <= 0x1E10 {
    return "D\u{0327}".unicodeScalars
  }
  if value <= 0x1E11 {
    return "d\u{0327}".unicodeScalars
  }
  if value <= 0x1E12 {
    return "D\u{032D}".unicodeScalars
  }
  if value <= 0x1E13 {
    return "d\u{032D}".unicodeScalars
  }
  if value <= 0x1E14 {
    return "E\u{0304}\u{0300}".unicodeScalars
  }
  if value <= 0x1E15 {
    return "e\u{0304}\u{0300}".unicodeScalars
  }
  if value <= 0x1E16 {
    return "E\u{0304}\u{0301}".unicodeScalars
  }
  if value <= 0x1E17 {
    return "e\u{0304}\u{0301}".unicodeScalars
  }
  if value <= 0x1E18 {
    return "E\u{032D}".unicodeScalars
  }
  if value <= 0x1E19 {
    return "e\u{032D}".unicodeScalars
  }
  if value <= 0x1E1A {
    return "E\u{0330}".unicodeScalars
  }
  if value <= 0x1E1B {
    return "e\u{0330}".unicodeScalars
  }
  if value <= 0x1E1C {
    return "E\u{0327}\u{0306}".unicodeScalars
  }
  if value <= 0x1E1D {
    return "e\u{0327}\u{0306}".unicodeScalars
  }
  if value <= 0x1E1E {
    return "F\u{0307}".unicodeScalars
  }
  if value <= 0x1E1F {
    return "f\u{0307}".unicodeScalars
  }
  if value <= 0x1E20 {
    return "G\u{0304}".unicodeScalars
  }
  if value <= 0x1E21 {
    return "g\u{0304}".unicodeScalars
  }
  if value <= 0x1E22 {
    return "H\u{0307}".unicodeScalars
  }
  if value <= 0x1E23 {
    return "h\u{0307}".unicodeScalars
  }
  if value <= 0x1E24 {
    return "H\u{0323}".unicodeScalars
  }
  if value <= 0x1E25 {
    return "h\u{0323}".unicodeScalars
  }
  if value <= 0x1E26 {
    return "H\u{0308}".unicodeScalars
  }
  if value <= 0x1E27 {
    return "h\u{0308}".unicodeScalars
  }
  if value <= 0x1E28 {
    return "H\u{0327}".unicodeScalars
  }
  if value <= 0x1E29 {
    return "h\u{0327}".unicodeScalars
  }
  if value <= 0x1E2A {
    return "H\u{032E}".unicodeScalars
  }
  if value <= 0x1E2B {
    return "h\u{032E}".unicodeScalars
  }
  if value <= 0x1E2C {
    return "I\u{0330}".unicodeScalars
  }
  if value <= 0x1E2D {
    return "i\u{0330}".unicodeScalars
  }
  if value <= 0x1E2E {
    return "I\u{0308}\u{0301}".unicodeScalars
  }
  if value <= 0x1E2F {
    return "i\u{0308}\u{0301}".unicodeScalars
  }
  if value <= 0x1E30 {
    return "K\u{0301}".unicodeScalars
  }
  if value <= 0x1E31 {
    return "k\u{0301}".unicodeScalars
  }
  if value <= 0x1E32 {
    return "K\u{0323}".unicodeScalars
  }
  if value <= 0x1E33 {
    return "k\u{0323}".unicodeScalars
  }
  if value <= 0x1E34 {
    return "K\u{0331}".unicodeScalars
  }
  if value <= 0x1E35 {
    return "k\u{0331}".unicodeScalars
  }
  if value <= 0x1E36 {
    return "L\u{0323}".unicodeScalars
  }
  if value <= 0x1E37 {
    return "l\u{0323}".unicodeScalars
  }
  if value <= 0x1E38 {
    return "L\u{0323}\u{0304}".unicodeScalars
  }
  if value <= 0x1E39 {
    return "l\u{0323}\u{0304}".unicodeScalars
  }
  if value <= 0x1E3A {
    return "L\u{0331}".unicodeScalars
  }
  if value <= 0x1E3B {
    return "l\u{0331}".unicodeScalars
  }
  if value <= 0x1E3C {
    return "L\u{032D}".unicodeScalars
  }
  if value <= 0x1E3D {
    return "l\u{032D}".unicodeScalars
  }
  if value <= 0x1E3E {
    return "M\u{0301}".unicodeScalars
  }
  if value <= 0x1E3F {
    return "m\u{0301}".unicodeScalars
  }
  if value <= 0x1E40 {
    return "M\u{0307}".unicodeScalars
  }
  if value <= 0x1E41 {
    return "m\u{0307}".unicodeScalars
  }
  if value <= 0x1E42 {
    return "M\u{0323}".unicodeScalars
  }
  if value <= 0x1E43 {
    return "m\u{0323}".unicodeScalars
  }
  if value <= 0x1E44 {
    return "N\u{0307}".unicodeScalars
  }
  if value <= 0x1E45 {
    return "n\u{0307}".unicodeScalars
  }
  if value <= 0x1E46 {
    return "N\u{0323}".unicodeScalars
  }
  if value <= 0x1E47 {
    return "n\u{0323}".unicodeScalars
  }
  if value <= 0x1E48 {
    return "N\u{0331}".unicodeScalars
  }
  if value <= 0x1E49 {
    return "n\u{0331}".unicodeScalars
  }
  if value <= 0x1E4A {
    return "N\u{032D}".unicodeScalars
  }
  if value <= 0x1E4B {
    return "n\u{032D}".unicodeScalars
  }
  if value <= 0x1E4C {
    return "O\u{0303}\u{0301}".unicodeScalars
  }
  if value <= 0x1E4D {
    return "o\u{0303}\u{0301}".unicodeScalars
  }
  if value <= 0x1E4E {
    return "O\u{0303}\u{0308}".unicodeScalars
  }
  if value <= 0x1E4F {
    return "o\u{0303}\u{0308}".unicodeScalars
  }
  if value <= 0x1E50 {
    return "O\u{0304}\u{0300}".unicodeScalars
  }
  if value <= 0x1E51 {
    return "o\u{0304}\u{0300}".unicodeScalars
  }
  if value <= 0x1E52 {
    return "O\u{0304}\u{0301}".unicodeScalars
  }
  if value <= 0x1E53 {
    return "o\u{0304}\u{0301}".unicodeScalars
  }
  if value <= 0x1E54 {
    return "P\u{0301}".unicodeScalars
  }
  if value <= 0x1E55 {
    return "p\u{0301}".unicodeScalars
  }
  if value <= 0x1E56 {
    return "P\u{0307}".unicodeScalars
  }
  if value <= 0x1E57 {
    return "p\u{0307}".unicodeScalars
  }
  if value <= 0x1E58 {
    return "R\u{0307}".unicodeScalars
  }
  if value <= 0x1E59 {
    return "r\u{0307}".unicodeScalars
  }
  if value <= 0x1E5A {
    return "R\u{0323}".unicodeScalars
  }
  if value <= 0x1E5B {
    return "r\u{0323}".unicodeScalars
  }
  if value <= 0x1E5C {
    return "R\u{0323}\u{0304}".unicodeScalars
  }
  if value <= 0x1E5D {
    return "r\u{0323}\u{0304}".unicodeScalars
  }
  if value <= 0x1E5E {
    return "R\u{0331}".unicodeScalars
  }
  if value <= 0x1E5F {
    return "r\u{0331}".unicodeScalars
  }
  if value <= 0x1E60 {
    return "S\u{0307}".unicodeScalars
  }
  if value <= 0x1E61 {
    return "s\u{0307}".unicodeScalars
  }
  if value <= 0x1E62 {
    return "S\u{0323}".unicodeScalars
  }
  if value <= 0x1E63 {
    return "s\u{0323}".unicodeScalars
  }
  if value <= 0x1E64 {
    return "S\u{0301}\u{0307}".unicodeScalars
  }
  if value <= 0x1E65 {
    return "s\u{0301}\u{0307}".unicodeScalars
  }
  if value <= 0x1E66 {
    return "S\u{030C}\u{0307}".unicodeScalars
  }
  if value <= 0x1E67 {
    return "s\u{030C}\u{0307}".unicodeScalars
  }
  if value <= 0x1E68 {
    return "S\u{0323}\u{0307}".unicodeScalars
  }
  if value <= 0x1E69 {
    return "s\u{0323}\u{0307}".unicodeScalars
  }
  if value <= 0x1E6A {
    return "T\u{0307}".unicodeScalars
  }
  if value <= 0x1E6B {
    return "t\u{0307}".unicodeScalars
  }
  if value <= 0x1E6C {
    return "T\u{0323}".unicodeScalars
  }
  if value <= 0x1E6D {
    return "t\u{0323}".unicodeScalars
  }
  if value <= 0x1E6E {
    return "T\u{0331}".unicodeScalars
  }
  if value <= 0x1E6F {
    return "t\u{0331}".unicodeScalars
  }
  if value <= 0x1E70 {
    return "T\u{032D}".unicodeScalars
  }
  if value <= 0x1E71 {
    return "t\u{032D}".unicodeScalars
  }
  if value <= 0x1E72 {
    return "U\u{0324}".unicodeScalars
  }
  if value <= 0x1E73 {
    return "u\u{0324}".unicodeScalars
  }
  if value <= 0x1E74 {
    return "U\u{0330}".unicodeScalars
  }
  if value <= 0x1E75 {
    return "u\u{0330}".unicodeScalars
  }
  if value <= 0x1E76 {
    return "U\u{032D}".unicodeScalars
  }
  if value <= 0x1E77 {
    return "u\u{032D}".unicodeScalars
  }
  if value <= 0x1E78 {
    return "U\u{0303}\u{0301}".unicodeScalars
  }
  if value <= 0x1E79 {
    return "u\u{0303}\u{0301}".unicodeScalars
  }
  if value <= 0x1E7A {
    return "U\u{0304}\u{0308}".unicodeScalars
  }
  if value <= 0x1E7B {
    return "u\u{0304}\u{0308}".unicodeScalars
  }
  if value <= 0x1E7C {
    return "V\u{0303}".unicodeScalars
  }
  if value <= 0x1E7D {
    return "v\u{0303}".unicodeScalars
  }
  if value <= 0x1E7E {
    return "V\u{0323}".unicodeScalars
  }
  if value <= 0x1E7F {
    return "v\u{0323}".unicodeScalars
  }
  if value <= 0x1E80 {
    return "W\u{0300}".unicodeScalars
  }
  if value <= 0x1E81 {
    return "w\u{0300}".unicodeScalars
  }
  if value <= 0x1E82 {
    return "W\u{0301}".unicodeScalars
  }
  if value <= 0x1E83 {
    return "w\u{0301}".unicodeScalars
  }
  if value <= 0x1E84 {
    return "W\u{0308}".unicodeScalars
  }
  if value <= 0x1E85 {
    return "w\u{0308}".unicodeScalars
  }
  if value <= 0x1E86 {
    return "W\u{0307}".unicodeScalars
  }
  if value <= 0x1E87 {
    return "w\u{0307}".unicodeScalars
  }
  if value <= 0x1E88 {
    return "W\u{0323}".unicodeScalars
  }
  if value <= 0x1E89 {
    return "w\u{0323}".unicodeScalars
  }
  if value <= 0x1E8A {
    return "X\u{0307}".unicodeScalars
  }
  if value <= 0x1E8B {
    return "x\u{0307}".unicodeScalars
  }
  if value <= 0x1E8C {
    return "X\u{0308}".unicodeScalars
  }
  if value <= 0x1E8D {
    return "x\u{0308}".unicodeScalars
  }
  if value <= 0x1E8E {
    return "Y\u{0307}".unicodeScalars
  }
  if value <= 0x1E8F {
    return "y\u{0307}".unicodeScalars
  }
  if value <= 0x1E90 {
    return "Z\u{0302}".unicodeScalars
  }
  if value <= 0x1E91 {
    return "z\u{0302}".unicodeScalars
  }
  if value <= 0x1E92 {
    return "Z\u{0323}".unicodeScalars
  }
  if value <= 0x1E93 {
    return "z\u{0323}".unicodeScalars
  }
  if value <= 0x1E94 {
    return "Z\u{0331}".unicodeScalars
  }
  if value <= 0x1E95 {
    return "z\u{0331}".unicodeScalars
  }
  if value <= 0x1E96 {
    return "h\u{0331}".unicodeScalars
  }
  if value <= 0x1E97 {
    return "t\u{0308}".unicodeScalars
  }
  if value <= 0x1E98 {
    return "w\u{030A}".unicodeScalars
  }
  if value <= 0x1E99 {
    return "y\u{030A}".unicodeScalars
  }
  if value <= 0x1E9A {
    return "aʾ".unicodeScalars
  }
  if value <= 0x1E9B {
    return "s\u{0307}".unicodeScalars
  }
  if value <= 0x1E9F {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1EA0 {
    return "A\u{0323}".unicodeScalars
  }
  if value <= 0x1EA1 {
    return "a\u{0323}".unicodeScalars
  }
  if value <= 0x1EA2 {
    return "A\u{0309}".unicodeScalars
  }
  if value <= 0x1EA3 {
    return "a\u{0309}".unicodeScalars
  }
  if value <= 0x1EA4 {
    return "A\u{0302}\u{0301}".unicodeScalars
  }
  if value <= 0x1EA5 {
    return "a\u{0302}\u{0301}".unicodeScalars
  }
  if value <= 0x1EA6 {
    return "A\u{0302}\u{0300}".unicodeScalars
  }
  if value <= 0x1EA7 {
    return "a\u{0302}\u{0300}".unicodeScalars
  }
  if value <= 0x1EA8 {
    return "A\u{0302}\u{0309}".unicodeScalars
  }
  if value <= 0x1EA9 {
    return "a\u{0302}\u{0309}".unicodeScalars
  }
  if value <= 0x1EAA {
    return "A\u{0302}\u{0303}".unicodeScalars
  }
  if value <= 0x1EAB {
    return "a\u{0302}\u{0303}".unicodeScalars
  }
  if value <= 0x1EAC {
    return "A\u{0323}\u{0302}".unicodeScalars
  }
  if value <= 0x1EAD {
    return "a\u{0323}\u{0302}".unicodeScalars
  }
  if value <= 0x1EAE {
    return "A\u{0306}\u{0301}".unicodeScalars
  }
  if value <= 0x1EAF {
    return "a\u{0306}\u{0301}".unicodeScalars
  }
  if value <= 0x1EB0 {
    return "A\u{0306}\u{0300}".unicodeScalars
  }
  if value <= 0x1EB1 {
    return "a\u{0306}\u{0300}".unicodeScalars
  }
  if value <= 0x1EB2 {
    return "A\u{0306}\u{0309}".unicodeScalars
  }
  if value <= 0x1EB3 {
    return "a\u{0306}\u{0309}".unicodeScalars
  }
  if value <= 0x1EB4 {
    return "A\u{0306}\u{0303}".unicodeScalars
  }
  if value <= 0x1EB5 {
    return "a\u{0306}\u{0303}".unicodeScalars
  }
  if value <= 0x1EB6 {
    return "A\u{0323}\u{0306}".unicodeScalars
  }
  if value <= 0x1EB7 {
    return "a\u{0323}\u{0306}".unicodeScalars
  }
  if value <= 0x1EB8 {
    return "E\u{0323}".unicodeScalars
  }
  if value <= 0x1EB9 {
    return "e\u{0323}".unicodeScalars
  }
  if value <= 0x1EBA {
    return "E\u{0309}".unicodeScalars
  }
  if value <= 0x1EBB {
    return "e\u{0309}".unicodeScalars
  }
  if value <= 0x1EBC {
    return "E\u{0303}".unicodeScalars
  }
  if value <= 0x1EBD {
    return "e\u{0303}".unicodeScalars
  }
  if value <= 0x1EBE {
    return "E\u{0302}\u{0301}".unicodeScalars
  }
  if value <= 0x1EBF {
    return "e\u{0302}\u{0301}".unicodeScalars
  }
  if value <= 0x1EC0 {
    return "E\u{0302}\u{0300}".unicodeScalars
  }
  if value <= 0x1EC1 {
    return "e\u{0302}\u{0300}".unicodeScalars
  }
  if value <= 0x1EC2 {
    return "E\u{0302}\u{0309}".unicodeScalars
  }
  if value <= 0x1EC3 {
    return "e\u{0302}\u{0309}".unicodeScalars
  }
  if value <= 0x1EC4 {
    return "E\u{0302}\u{0303}".unicodeScalars
  }
  if value <= 0x1EC5 {
    return "e\u{0302}\u{0303}".unicodeScalars
  }
  if value <= 0x1EC6 {
    return "E\u{0323}\u{0302}".unicodeScalars
  }
  if value <= 0x1EC7 {
    return "e\u{0323}\u{0302}".unicodeScalars
  }
  if value <= 0x1EC8 {
    return "I\u{0309}".unicodeScalars
  }
  if value <= 0x1EC9 {
    return "i\u{0309}".unicodeScalars
  }
  if value <= 0x1ECA {
    return "I\u{0323}".unicodeScalars
  }
  if value <= 0x1ECB {
    return "i\u{0323}".unicodeScalars
  }
  if value <= 0x1ECC {
    return "O\u{0323}".unicodeScalars
  }
  if value <= 0x1ECD {
    return "o\u{0323}".unicodeScalars
  }
  if value <= 0x1ECE {
    return "O\u{0309}".unicodeScalars
  }
  if value <= 0x1ECF {
    return "o\u{0309}".unicodeScalars
  }
  if value <= 0x1ED0 {
    return "O\u{0302}\u{0301}".unicodeScalars
  }
  if value <= 0x1ED1 {
    return "o\u{0302}\u{0301}".unicodeScalars
  }
  if value <= 0x1ED2 {
    return "O\u{0302}\u{0300}".unicodeScalars
  }
  if value <= 0x1ED3 {
    return "o\u{0302}\u{0300}".unicodeScalars
  }
  if value <= 0x1ED4 {
    return "O\u{0302}\u{0309}".unicodeScalars
  }
  if value <= 0x1ED5 {
    return "o\u{0302}\u{0309}".unicodeScalars
  }
  if value <= 0x1ED6 {
    return "O\u{0302}\u{0303}".unicodeScalars
  }
  if value <= 0x1ED7 {
    return "o\u{0302}\u{0303}".unicodeScalars
  }
  if value <= 0x1ED8 {
    return "O\u{0323}\u{0302}".unicodeScalars
  }
  if value <= 0x1ED9 {
    return "o\u{0323}\u{0302}".unicodeScalars
  }
  if value <= 0x1EDA {
    return "O\u{031B}\u{0301}".unicodeScalars
  }
  if value <= 0x1EDB {
    return "o\u{031B}\u{0301}".unicodeScalars
  }
  if value <= 0x1EDC {
    return "O\u{031B}\u{0300}".unicodeScalars
  }
  if value <= 0x1EDD {
    return "o\u{031B}\u{0300}".unicodeScalars
  }
  if value <= 0x1EDE {
    return "O\u{031B}\u{0309}".unicodeScalars
  }
  if value <= 0x1EDF {
    return "o\u{031B}\u{0309}".unicodeScalars
  }
  if value <= 0x1EE0 {
    return "O\u{031B}\u{0303}".unicodeScalars
  }
  if value <= 0x1EE1 {
    return "o\u{031B}\u{0303}".unicodeScalars
  }
  if value <= 0x1EE2 {
    return "O\u{031B}\u{0323}".unicodeScalars
  }
  if value <= 0x1EE3 {
    return "o\u{031B}\u{0323}".unicodeScalars
  }
  if value <= 0x1EE4 {
    return "U\u{0323}".unicodeScalars
  }
  if value <= 0x1EE5 {
    return "u\u{0323}".unicodeScalars
  }
  if value <= 0x1EE6 {
    return "U\u{0309}".unicodeScalars
  }
  if value <= 0x1EE7 {
    return "u\u{0309}".unicodeScalars
  }
  if value <= 0x1EE8 {
    return "U\u{031B}\u{0301}".unicodeScalars
  }
  if value <= 0x1EE9 {
    return "u\u{031B}\u{0301}".unicodeScalars
  }
  if value <= 0x1EEA {
    return "U\u{031B}\u{0300}".unicodeScalars
  }
  if value <= 0x1EEB {
    return "u\u{031B}\u{0300}".unicodeScalars
  }
  if value <= 0x1EEC {
    return "U\u{031B}\u{0309}".unicodeScalars
  }
  if value <= 0x1EED {
    return "u\u{031B}\u{0309}".unicodeScalars
  }
  if value <= 0x1EEE {
    return "U\u{031B}\u{0303}".unicodeScalars
  }
  if value <= 0x1EEF {
    return "u\u{031B}\u{0303}".unicodeScalars
  }
  if value <= 0x1EF0 {
    return "U\u{031B}\u{0323}".unicodeScalars
  }
  if value <= 0x1EF1 {
    return "u\u{031B}\u{0323}".unicodeScalars
  }
  if value <= 0x1EF2 {
    return "Y\u{0300}".unicodeScalars
  }
  if value <= 0x1EF3 {
    return "y\u{0300}".unicodeScalars
  }
  if value <= 0x1EF4 {
    return "Y\u{0323}".unicodeScalars
  }
  if value <= 0x1EF5 {
    return "y\u{0323}".unicodeScalars
  }
  if value <= 0x1EF6 {
    return "Y\u{0309}".unicodeScalars
  }
  if value <= 0x1EF7 {
    return "y\u{0309}".unicodeScalars
  }
  if value <= 0x1EF8 {
    return "Y\u{0303}".unicodeScalars
  }
  if value <= 0x1EF9 {
    return "y\u{0303}".unicodeScalars
  }
  if value <= 0x1EFF {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1F00 {
    return "α\u{0313}".unicodeScalars
  }
  if value <= 0x1F01 {
    return "α\u{0314}".unicodeScalars
  }
  if value <= 0x1F02 {
    return "α\u{0313}\u{0300}".unicodeScalars
  }
  if value <= 0x1F03 {
    return "α\u{0314}\u{0300}".unicodeScalars
  }
  if value <= 0x1F04 {
    return "α\u{0313}\u{0301}".unicodeScalars
  }
  if value <= 0x1F05 {
    return "α\u{0314}\u{0301}".unicodeScalars
  }
  if value <= 0x1F06 {
    return "α\u{0313}\u{0342}".unicodeScalars
  }
  if value <= 0x1F07 {
    return "α\u{0314}\u{0342}".unicodeScalars
  }
  if value <= 0x1F08 {
    return "Α\u{0313}".unicodeScalars
  }
  if value <= 0x1F09 {
    return "Α\u{0314}".unicodeScalars
  }
  if value <= 0x1F0A {
    return "Α\u{0313}\u{0300}".unicodeScalars
  }
  if value <= 0x1F0B {
    return "Α\u{0314}\u{0300}".unicodeScalars
  }
  if value <= 0x1F0C {
    return "Α\u{0313}\u{0301}".unicodeScalars
  }
  if value <= 0x1F0D {
    return "Α\u{0314}\u{0301}".unicodeScalars
  }
  if value <= 0x1F0E {
    return "Α\u{0313}\u{0342}".unicodeScalars
  }
  if value <= 0x1F0F {
    return "Α\u{0314}\u{0342}".unicodeScalars
  }
  if value <= 0x1F10 {
    return "ε\u{0313}".unicodeScalars
  }
  if value <= 0x1F11 {
    return "ε\u{0314}".unicodeScalars
  }
  if value <= 0x1F12 {
    return "ε\u{0313}\u{0300}".unicodeScalars
  }
  if value <= 0x1F13 {
    return "ε\u{0314}\u{0300}".unicodeScalars
  }
  if value <= 0x1F14 {
    return "ε\u{0313}\u{0301}".unicodeScalars
  }
  if value <= 0x1F15 {
    return "ε\u{0314}\u{0301}".unicodeScalars
  }
  if value <= 0x1F17 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1F18 {
    return "Ε\u{0313}".unicodeScalars
  }
  if value <= 0x1F19 {
    return "Ε\u{0314}".unicodeScalars
  }
  if value <= 0x1F1A {
    return "Ε\u{0313}\u{0300}".unicodeScalars
  }
  if value <= 0x1F1B {
    return "Ε\u{0314}\u{0300}".unicodeScalars
  }
  if value <= 0x1F1C {
    return "Ε\u{0313}\u{0301}".unicodeScalars
  }
  if value <= 0x1F1D {
    return "Ε\u{0314}\u{0301}".unicodeScalars
  }
  if value <= 0x1F1F {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1F20 {
    return "η\u{0313}".unicodeScalars
  }
  if value <= 0x1F21 {
    return "η\u{0314}".unicodeScalars
  }
  if value <= 0x1F22 {
    return "η\u{0313}\u{0300}".unicodeScalars
  }
  if value <= 0x1F23 {
    return "η\u{0314}\u{0300}".unicodeScalars
  }
  if value <= 0x1F24 {
    return "η\u{0313}\u{0301}".unicodeScalars
  }
  if value <= 0x1F25 {
    return "η\u{0314}\u{0301}".unicodeScalars
  }
  if value <= 0x1F26 {
    return "η\u{0313}\u{0342}".unicodeScalars
  }
  if value <= 0x1F27 {
    return "η\u{0314}\u{0342}".unicodeScalars
  }
  if value <= 0x1F28 {
    return "Η\u{0313}".unicodeScalars
  }
  if value <= 0x1F29 {
    return "Η\u{0314}".unicodeScalars
  }
  if value <= 0x1F2A {
    return "Η\u{0313}\u{0300}".unicodeScalars
  }
  if value <= 0x1F2B {
    return "Η\u{0314}\u{0300}".unicodeScalars
  }
  if value <= 0x1F2C {
    return "Η\u{0313}\u{0301}".unicodeScalars
  }
  if value <= 0x1F2D {
    return "Η\u{0314}\u{0301}".unicodeScalars
  }
  if value <= 0x1F2E {
    return "Η\u{0313}\u{0342}".unicodeScalars
  }
  if value <= 0x1F2F {
    return "Η\u{0314}\u{0342}".unicodeScalars
  }
  if value <= 0x1F30 {
    return "ι\u{0313}".unicodeScalars
  }
  if value <= 0x1F31 {
    return "ι\u{0314}".unicodeScalars
  }
  if value <= 0x1F32 {
    return "ι\u{0313}\u{0300}".unicodeScalars
  }
  if value <= 0x1F33 {
    return "ι\u{0314}\u{0300}".unicodeScalars
  }
  if value <= 0x1F34 {
    return "ι\u{0313}\u{0301}".unicodeScalars
  }
  if value <= 0x1F35 {
    return "ι\u{0314}\u{0301}".unicodeScalars
  }
  if value <= 0x1F36 {
    return "ι\u{0313}\u{0342}".unicodeScalars
  }
  if value <= 0x1F37 {
    return "ι\u{0314}\u{0342}".unicodeScalars
  }
  if value <= 0x1F38 {
    return "Ι\u{0313}".unicodeScalars
  }
  if value <= 0x1F39 {
    return "Ι\u{0314}".unicodeScalars
  }
  if value <= 0x1F3A {
    return "Ι\u{0313}\u{0300}".unicodeScalars
  }
  if value <= 0x1F3B {
    return "Ι\u{0314}\u{0300}".unicodeScalars
  }
  if value <= 0x1F3C {
    return "Ι\u{0313}\u{0301}".unicodeScalars
  }
  if value <= 0x1F3D {
    return "Ι\u{0314}\u{0301}".unicodeScalars
  }
  if value <= 0x1F3E {
    return "Ι\u{0313}\u{0342}".unicodeScalars
  }
  if value <= 0x1F3F {
    return "Ι\u{0314}\u{0342}".unicodeScalars
  }
  if value <= 0x1F40 {
    return "ο\u{0313}".unicodeScalars
  }
  if value <= 0x1F41 {
    return "ο\u{0314}".unicodeScalars
  }
  if value <= 0x1F42 {
    return "ο\u{0313}\u{0300}".unicodeScalars
  }
  if value <= 0x1F43 {
    return "ο\u{0314}\u{0300}".unicodeScalars
  }
  if value <= 0x1F44 {
    return "ο\u{0313}\u{0301}".unicodeScalars
  }
  if value <= 0x1F45 {
    return "ο\u{0314}\u{0301}".unicodeScalars
  }
  if value <= 0x1F47 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1F48 {
    return "Ο\u{0313}".unicodeScalars
  }
  if value <= 0x1F49 {
    return "Ο\u{0314}".unicodeScalars
  }
  if value <= 0x1F4A {
    return "Ο\u{0313}\u{0300}".unicodeScalars
  }
  if value <= 0x1F4B {
    return "Ο\u{0314}\u{0300}".unicodeScalars
  }
  if value <= 0x1F4C {
    return "Ο\u{0313}\u{0301}".unicodeScalars
  }
  if value <= 0x1F4D {
    return "Ο\u{0314}\u{0301}".unicodeScalars
  }
  if value <= 0x1F4F {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1F50 {
    return "υ\u{0313}".unicodeScalars
  }
  if value <= 0x1F51 {
    return "υ\u{0314}".unicodeScalars
  }
  if value <= 0x1F52 {
    return "υ\u{0313}\u{0300}".unicodeScalars
  }
  if value <= 0x1F53 {
    return "υ\u{0314}\u{0300}".unicodeScalars
  }
  if value <= 0x1F54 {
    return "υ\u{0313}\u{0301}".unicodeScalars
  }
  if value <= 0x1F55 {
    return "υ\u{0314}\u{0301}".unicodeScalars
  }
  if value <= 0x1F56 {
    return "υ\u{0313}\u{0342}".unicodeScalars
  }
  if value <= 0x1F57 {
    return "υ\u{0314}\u{0342}".unicodeScalars
  }
  if value <= 0x1F58 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1F59 {
    return "Υ\u{0314}".unicodeScalars
  }
  if value <= 0x1F5A {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1F5B {
    return "Υ\u{0314}\u{0300}".unicodeScalars
  }
  if value <= 0x1F5C {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1F5D {
    return "Υ\u{0314}\u{0301}".unicodeScalars
  }
  if value <= 0x1F5E {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1F5F {
    return "Υ\u{0314}\u{0342}".unicodeScalars
  }
  if value <= 0x1F60 {
    return "ω\u{0313}".unicodeScalars
  }
  if value <= 0x1F61 {
    return "ω\u{0314}".unicodeScalars
  }
  if value <= 0x1F62 {
    return "ω\u{0313}\u{0300}".unicodeScalars
  }
  if value <= 0x1F63 {
    return "ω\u{0314}\u{0300}".unicodeScalars
  }
  if value <= 0x1F64 {
    return "ω\u{0313}\u{0301}".unicodeScalars
  }
  if value <= 0x1F65 {
    return "ω\u{0314}\u{0301}".unicodeScalars
  }
  if value <= 0x1F66 {
    return "ω\u{0313}\u{0342}".unicodeScalars
  }
  if value <= 0x1F67 {
    return "ω\u{0314}\u{0342}".unicodeScalars
  }
  if value <= 0x1F68 {
    return "Ω\u{0313}".unicodeScalars
  }
  if value <= 0x1F69 {
    return "Ω\u{0314}".unicodeScalars
  }
  if value <= 0x1F6A {
    return "Ω\u{0313}\u{0300}".unicodeScalars
  }
  if value <= 0x1F6B {
    return "Ω\u{0314}\u{0300}".unicodeScalars
  }
  if value <= 0x1F6C {
    return "Ω\u{0313}\u{0301}".unicodeScalars
  }
  if value <= 0x1F6D {
    return "Ω\u{0314}\u{0301}".unicodeScalars
  }
  if value <= 0x1F6E {
    return "Ω\u{0313}\u{0342}".unicodeScalars
  }
  if value <= 0x1F6F {
    return "Ω\u{0314}\u{0342}".unicodeScalars
  }
  if value <= 0x1F70 {
    return "α\u{0300}".unicodeScalars
  }
  if value <= 0x1F71 {
    return "α\u{0301}".unicodeScalars
  }
  if value <= 0x1F72 {
    return "ε\u{0300}".unicodeScalars
  }
  if value <= 0x1F73 {
    return "ε\u{0301}".unicodeScalars
  }
  if value <= 0x1F74 {
    return "η\u{0300}".unicodeScalars
  }
  if value <= 0x1F75 {
    return "η\u{0301}".unicodeScalars
  }
  if value <= 0x1F76 {
    return "ι\u{0300}".unicodeScalars
  }
  if value <= 0x1F77 {
    return "ι\u{0301}".unicodeScalars
  }
  if value <= 0x1F78 {
    return "ο\u{0300}".unicodeScalars
  }
  if value <= 0x1F79 {
    return "ο\u{0301}".unicodeScalars
  }
  if value <= 0x1F7A {
    return "υ\u{0300}".unicodeScalars
  }
  if value <= 0x1F7B {
    return "υ\u{0301}".unicodeScalars
  }
  if value <= 0x1F7C {
    return "ω\u{0300}".unicodeScalars
  }
  if value <= 0x1F7D {
    return "ω\u{0301}".unicodeScalars
  }
  if value <= 0x1F7F {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1F80 {
    return "α\u{0313}\u{0345}".unicodeScalars
  }
  if value <= 0x1F81 {
    return "α\u{0314}\u{0345}".unicodeScalars
  }
  if value <= 0x1F82 {
    return "α\u{0313}\u{0300}\u{0345}".unicodeScalars
  }
  if value <= 0x1F83 {
    return "α\u{0314}\u{0300}\u{0345}".unicodeScalars
  }
  if value <= 0x1F84 {
    return "α\u{0313}\u{0301}\u{0345}".unicodeScalars
  }
  if value <= 0x1F85 {
    return "α\u{0314}\u{0301}\u{0345}".unicodeScalars
  }
  if value <= 0x1F86 {
    return "α\u{0313}\u{0342}\u{0345}".unicodeScalars
  }
  if value <= 0x1F87 {
    return "α\u{0314}\u{0342}\u{0345}".unicodeScalars
  }
  if value <= 0x1F88 {
    return "Α\u{0313}\u{0345}".unicodeScalars
  }
  if value <= 0x1F89 {
    return "Α\u{0314}\u{0345}".unicodeScalars
  }
  if value <= 0x1F8A {
    return "Α\u{0313}\u{0300}\u{0345}".unicodeScalars
  }
  if value <= 0x1F8B {
    return "Α\u{0314}\u{0300}\u{0345}".unicodeScalars
  }
  if value <= 0x1F8C {
    return "Α\u{0313}\u{0301}\u{0345}".unicodeScalars
  }
  if value <= 0x1F8D {
    return "Α\u{0314}\u{0301}\u{0345}".unicodeScalars
  }
  if value <= 0x1F8E {
    return "Α\u{0313}\u{0342}\u{0345}".unicodeScalars
  }
  if value <= 0x1F8F {
    return "Α\u{0314}\u{0342}\u{0345}".unicodeScalars
  }
  if value <= 0x1F90 {
    return "η\u{0313}\u{0345}".unicodeScalars
  }
  if value <= 0x1F91 {
    return "η\u{0314}\u{0345}".unicodeScalars
  }
  if value <= 0x1F92 {
    return "η\u{0313}\u{0300}\u{0345}".unicodeScalars
  }
  if value <= 0x1F93 {
    return "η\u{0314}\u{0300}\u{0345}".unicodeScalars
  }
  if value <= 0x1F94 {
    return "η\u{0313}\u{0301}\u{0345}".unicodeScalars
  }
  if value <= 0x1F95 {
    return "η\u{0314}\u{0301}\u{0345}".unicodeScalars
  }
  if value <= 0x1F96 {
    return "η\u{0313}\u{0342}\u{0345}".unicodeScalars
  }
  if value <= 0x1F97 {
    return "η\u{0314}\u{0342}\u{0345}".unicodeScalars
  }
  if value <= 0x1F98 {
    return "Η\u{0313}\u{0345}".unicodeScalars
  }
  if value <= 0x1F99 {
    return "Η\u{0314}\u{0345}".unicodeScalars
  }
  if value <= 0x1F9A {
    return "Η\u{0313}\u{0300}\u{0345}".unicodeScalars
  }
  if value <= 0x1F9B {
    return "Η\u{0314}\u{0300}\u{0345}".unicodeScalars
  }
  if value <= 0x1F9C {
    return "Η\u{0313}\u{0301}\u{0345}".unicodeScalars
  }
  if value <= 0x1F9D {
    return "Η\u{0314}\u{0301}\u{0345}".unicodeScalars
  }
  if value <= 0x1F9E {
    return "Η\u{0313}\u{0342}\u{0345}".unicodeScalars
  }
  if value <= 0x1F9F {
    return "Η\u{0314}\u{0342}\u{0345}".unicodeScalars
  }
  if value <= 0x1FA0 {
    return "ω\u{0313}\u{0345}".unicodeScalars
  }
  if value <= 0x1FA1 {
    return "ω\u{0314}\u{0345}".unicodeScalars
  }
  if value <= 0x1FA2 {
    return "ω\u{0313}\u{0300}\u{0345}".unicodeScalars
  }
  if value <= 0x1FA3 {
    return "ω\u{0314}\u{0300}\u{0345}".unicodeScalars
  }
  if value <= 0x1FA4 {
    return "ω\u{0313}\u{0301}\u{0345}".unicodeScalars
  }
  if value <= 0x1FA5 {
    return "ω\u{0314}\u{0301}\u{0345}".unicodeScalars
  }
  if value <= 0x1FA6 {
    return "ω\u{0313}\u{0342}\u{0345}".unicodeScalars
  }
  if value <= 0x1FA7 {
    return "ω\u{0314}\u{0342}\u{0345}".unicodeScalars
  }
  if value <= 0x1FA8 {
    return "Ω\u{0313}\u{0345}".unicodeScalars
  }
  if value <= 0x1FA9 {
    return "Ω\u{0314}\u{0345}".unicodeScalars
  }
  if value <= 0x1FAA {
    return "Ω\u{0313}\u{0300}\u{0345}".unicodeScalars
  }
  if value <= 0x1FAB {
    return "Ω\u{0314}\u{0300}\u{0345}".unicodeScalars
  }
  if value <= 0x1FAC {
    return "Ω\u{0313}\u{0301}\u{0345}".unicodeScalars
  }
  if value <= 0x1FAD {
    return "Ω\u{0314}\u{0301}\u{0345}".unicodeScalars
  }
  if value <= 0x1FAE {
    return "Ω\u{0313}\u{0342}\u{0345}".unicodeScalars
  }
  if value <= 0x1FAF {
    return "Ω\u{0314}\u{0342}\u{0345}".unicodeScalars
  }
  if value <= 0x1FB0 {
    return "α\u{0306}".unicodeScalars
  }
  if value <= 0x1FB1 {
    return "α\u{0304}".unicodeScalars
  }
  if value <= 0x1FB2 {
    return "α\u{0300}\u{0345}".unicodeScalars
  }
  if value <= 0x1FB3 {
    return "α\u{0345}".unicodeScalars
  }
  if value <= 0x1FB4 {
    return "α\u{0301}\u{0345}".unicodeScalars
  }
  if value <= 0x1FB5 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1FB6 {
    return "α\u{0342}".unicodeScalars
  }
  if value <= 0x1FB7 {
    return "α\u{0342}\u{0345}".unicodeScalars
  }
  if value <= 0x1FB8 {
    return "Α\u{0306}".unicodeScalars
  }
  if value <= 0x1FB9 {
    return "Α\u{0304}".unicodeScalars
  }
  if value <= 0x1FBA {
    return "Α\u{0300}".unicodeScalars
  }
  if value <= 0x1FBB {
    return "Α\u{0301}".unicodeScalars
  }
  if value <= 0x1FBC {
    return "Α\u{0345}".unicodeScalars
  }
  if value <= 0x1FBD {
    return " \u{0313}".unicodeScalars
  }
  if value <= 0x1FBE {
    return "ι".unicodeScalars
  }
  if value <= 0x1FBF {
    return " \u{0313}".unicodeScalars
  }
  if value <= 0x1FC0 {
    return " \u{0342}".unicodeScalars
  }
  if value <= 0x1FC1 {
    return " \u{0308}\u{0342}".unicodeScalars
  }
  if value <= 0x1FC2 {
    return "η\u{0300}\u{0345}".unicodeScalars
  }
  if value <= 0x1FC3 {
    return "η\u{0345}".unicodeScalars
  }
  if value <= 0x1FC4 {
    return "η\u{0301}\u{0345}".unicodeScalars
  }
  if value <= 0x1FC5 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1FC6 {
    return "η\u{0342}".unicodeScalars
  }
  if value <= 0x1FC7 {
    return "η\u{0342}\u{0345}".unicodeScalars
  }
  if value <= 0x1FC8 {
    return "Ε\u{0300}".unicodeScalars
  }
  if value <= 0x1FC9 {
    return "Ε\u{0301}".unicodeScalars
  }
  if value <= 0x1FCA {
    return "Η\u{0300}".unicodeScalars
  }
  if value <= 0x1FCB {
    return "Η\u{0301}".unicodeScalars
  }
  if value <= 0x1FCC {
    return "Η\u{0345}".unicodeScalars
  }
  if value <= 0x1FCD {
    return " \u{0313}\u{0300}".unicodeScalars
  }
  if value <= 0x1FCE {
    return " \u{0313}\u{0301}".unicodeScalars
  }
  if value <= 0x1FCF {
    return " \u{0313}\u{0342}".unicodeScalars
  }
  if value <= 0x1FD0 {
    return "ι\u{0306}".unicodeScalars
  }
  if value <= 0x1FD1 {
    return "ι\u{0304}".unicodeScalars
  }
  if value <= 0x1FD2 {
    return "ι\u{0308}\u{0300}".unicodeScalars
  }
  if value <= 0x1FD3 {
    return "ι\u{0308}\u{0301}".unicodeScalars
  }
  if value <= 0x1FD5 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1FD6 {
    return "ι\u{0342}".unicodeScalars
  }
  if value <= 0x1FD7 {
    return "ι\u{0308}\u{0342}".unicodeScalars
  }
  if value <= 0x1FD8 {
    return "Ι\u{0306}".unicodeScalars
  }
  if value <= 0x1FD9 {
    return "Ι\u{0304}".unicodeScalars
  }
  if value <= 0x1FDA {
    return "Ι\u{0300}".unicodeScalars
  }
  if value <= 0x1FDB {
    return "Ι\u{0301}".unicodeScalars
  }
  if value <= 0x1FDC {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1FDD {
    return " \u{0314}\u{0300}".unicodeScalars
  }
  if value <= 0x1FDE {
    return " \u{0314}\u{0301}".unicodeScalars
  }
  if value <= 0x1FDF {
    return " \u{0314}\u{0342}".unicodeScalars
  }
  if value <= 0x1FE0 {
    return "υ\u{0306}".unicodeScalars
  }
  if value <= 0x1FE1 {
    return "υ\u{0304}".unicodeScalars
  }
  if value <= 0x1FE2 {
    return "υ\u{0308}\u{0300}".unicodeScalars
  }
  if value <= 0x1FE3 {
    return "υ\u{0308}\u{0301}".unicodeScalars
  }
  if value <= 0x1FE4 {
    return "ρ\u{0313}".unicodeScalars
  }
  if value <= 0x1FE5 {
    return "ρ\u{0314}".unicodeScalars
  }
  if value <= 0x1FE6 {
    return "υ\u{0342}".unicodeScalars
  }
  if value <= 0x1FE7 {
    return "υ\u{0308}\u{0342}".unicodeScalars
  }
  if value <= 0x1FE8 {
    return "Υ\u{0306}".unicodeScalars
  }
  if value <= 0x1FE9 {
    return "Υ\u{0304}".unicodeScalars
  }
  if value <= 0x1FEA {
    return "Υ\u{0300}".unicodeScalars
  }
  if value <= 0x1FEB {
    return "Υ\u{0301}".unicodeScalars
  }
  if value <= 0x1FEC {
    return "Ρ\u{0314}".unicodeScalars
  }
  if value <= 0x1FED {
    return " \u{0308}\u{0300}".unicodeScalars
  }
  if value <= 0x1FEE {
    return " \u{0308}\u{0301}".unicodeScalars
  }
  if value <= 0x1FEF {
    return "`".unicodeScalars
  }
  if value <= 0x1FF1 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1FF2 {
    return "ω\u{0300}\u{0345}".unicodeScalars
  }
  if value <= 0x1FF3 {
    return "ω\u{0345}".unicodeScalars
  }
  if value <= 0x1FF4 {
    return "ω\u{0301}\u{0345}".unicodeScalars
  }
  if value <= 0x1FF5 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1FF6 {
    return "ω\u{0342}".unicodeScalars
  }
  if value <= 0x1FF7 {
    return "ω\u{0342}\u{0345}".unicodeScalars
  }
  if value <= 0x1FF8 {
    return "Ο\u{0300}".unicodeScalars
  }
  if value <= 0x1FF9 {
    return "Ο\u{0301}".unicodeScalars
  }
  if value <= 0x1FFA {
    return "Ω\u{0300}".unicodeScalars
  }
  if value <= 0x1FFB {
    return "Ω\u{0301}".unicodeScalars
  }
  if value <= 0x1FFC {
    return "Ω\u{0345}".unicodeScalars
  }
  if value <= 0x1FFD {
    return " \u{0301}".unicodeScalars
  }
  if value <= 0x1FFE {
    return " \u{0314}".unicodeScalars
  }
  if value <= 0x1FFF {
    return String(scalar).unicodeScalars
  }
  if value <= 0x200A {
    return " ".unicodeScalars
  }
  if value <= 0x2010 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x2011 {
    return "‐".unicodeScalars
  }
  if value <= 0x2016 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x2017 {
    return " \u{0333}".unicodeScalars
  }
  if value <= 0x2023 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x2024 {
    return ".".unicodeScalars
  }
  if value <= 0x2025 {
    return "..".unicodeScalars
  }
  if value <= 0x2026 {
    return "...".unicodeScalars
  }
  if value <= 0x202E {
    return String(scalar).unicodeScalars
  }
  if value <= 0x202F {
    return " ".unicodeScalars
  }
  if value <= 0x2032 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x2033 {
    return "′′".unicodeScalars
  }
  if value <= 0x2034 {
    return "′′′".unicodeScalars
  }
  if value <= 0x2035 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x2036 {
    return "‵‵".unicodeScalars
  }
  if value <= 0x2037 {
    return "‵‵‵".unicodeScalars
  }
  if value <= 0x203B {
    return String(scalar).unicodeScalars
  }
  if value <= 0x203C {
    return "!!".unicodeScalars
  }
  if value <= 0x203D {
    return String(scalar).unicodeScalars
  }
  if value <= 0x203E {
    return " \u{0305}".unicodeScalars
  }
  if value <= 0x2046 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x2047 {
    return "??".unicodeScalars
  }
  if value <= 0x2048 {
    return "?!".unicodeScalars
  }
  if value <= 0x2049 {
    return "!?".unicodeScalars
  }
  if value <= 0x2056 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x2057 {
    return "′′′′".unicodeScalars
  }
  if value <= 0x205E {
    return String(scalar).unicodeScalars
  }
  if value <= 0x205F {
    return " ".unicodeScalars
  }
  if value <= 0x206F {
    return String(scalar).unicodeScalars
  }
  if value <= 0x2070 {
    return "0".unicodeScalars
  }
  if value <= 0x2071 {
    return "i".unicodeScalars
  }
  if value <= 0x2073 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x2074 {
    return "4".unicodeScalars
  }
  if value <= 0x2075 {
    return "5".unicodeScalars
  }
  if value <= 0x2076 {
    return "6".unicodeScalars
  }
  if value <= 0x2077 {
    return "7".unicodeScalars
  }
  if value <= 0x2078 {
    return "8".unicodeScalars
  }
  if value <= 0x2079 {
    return "9".unicodeScalars
  }
  if value <= 0x207A {
    return "+".unicodeScalars
  }
  if value <= 0x207B {
    return "−".unicodeScalars
  }
  if value <= 0x207C {
    return "=".unicodeScalars
  }
  if value <= 0x207D {
    return "(".unicodeScalars
  }
  if value <= 0x207E {
    return ")".unicodeScalars
  }
  if value <= 0x207F {
    return "n".unicodeScalars
  }
  if value <= 0x2080 {
    return "0".unicodeScalars
  }
  if value <= 0x2081 {
    return "1".unicodeScalars
  }
  if value <= 0x2082 {
    return "2".unicodeScalars
  }
  if value <= 0x2083 {
    return "3".unicodeScalars
  }
  if value <= 0x2084 {
    return "4".unicodeScalars
  }
  if value <= 0x2085 {
    return "5".unicodeScalars
  }
  if value <= 0x2086 {
    return "6".unicodeScalars
  }
  if value <= 0x2087 {
    return "7".unicodeScalars
  }
  if value <= 0x2088 {
    return "8".unicodeScalars
  }
  if value <= 0x2089 {
    return "9".unicodeScalars
  }
  if value <= 0x208A {
    return "+".unicodeScalars
  }
  if value <= 0x208B {
    return "−".unicodeScalars
  }
  if value <= 0x208C {
    return "=".unicodeScalars
  }
  if value <= 0x208D {
    return "(".unicodeScalars
  }
  if value <= 0x208E {
    return ")".unicodeScalars
  }
  if value <= 0x208F {
    return String(scalar).unicodeScalars
  }
  if value <= 0x2090 {
    return "a".unicodeScalars
  }
  if value <= 0x2091 {
    return "e".unicodeScalars
  }
  if value <= 0x2092 {
    return "o".unicodeScalars
  }
  if value <= 0x2093 {
    return "x".unicodeScalars
  }
  if value <= 0x2094 {
    return "ə".unicodeScalars
  }
  if value <= 0x2095 {
    return "h".unicodeScalars
  }
  if value <= 0x2096 {
    return "k".unicodeScalars
  }
  if value <= 0x2097 {
    return "l".unicodeScalars
  }
  if value <= 0x2098 {
    return "m".unicodeScalars
  }
  if value <= 0x2099 {
    return "n".unicodeScalars
  }
  if value <= 0x209A {
    return "p".unicodeScalars
  }
  if value <= 0x209B {
    return "s".unicodeScalars
  }
  if value <= 0x209C {
    return "t".unicodeScalars
  }
  if value <= 0x20A7 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x20A8 {
    return "Rs".unicodeScalars
  }
  if value <= 0x20FF {
    return String(scalar).unicodeScalars
  }
  if value <= 0x2100 {
    return "a/c".unicodeScalars
  }
  if value <= 0x2101 {
    return "a/s".unicodeScalars
  }
  if value <= 0x2102 {
    return "C".unicodeScalars
  }
  if value <= 0x2103 {
    return "°C".unicodeScalars
  }
  if value <= 0x2104 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x2105 {
    return "c/o".unicodeScalars
  }
  if value <= 0x2106 {
    return "c/u".unicodeScalars
  }
  if value <= 0x2107 {
    return "Ɛ".unicodeScalars
  }
  if value <= 0x2108 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x2109 {
    return "°F".unicodeScalars
  }
  if value <= 0x210A {
    return "g".unicodeScalars
  }
  if value <= 0x210D {
    return "H".unicodeScalars
  }
  if value <= 0x210E {
    return "h".unicodeScalars
  }
  if value <= 0x210F {
    return "ħ".unicodeScalars
  }
  if value <= 0x2111 {
    return "I".unicodeScalars
  }
  if value <= 0x2112 {
    return "L".unicodeScalars
  }
  if value <= 0x2113 {
    return "l".unicodeScalars
  }
  if value <= 0x2114 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x2115 {
    return "N".unicodeScalars
  }
  if value <= 0x2116 {
    return "No".unicodeScalars
  }
  if value <= 0x2118 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x2119 {
    return "P".unicodeScalars
  }
  if value <= 0x211A {
    return "Q".unicodeScalars
  }
  if value <= 0x211D {
    return "R".unicodeScalars
  }
  if value <= 0x211F {
    return String(scalar).unicodeScalars
  }
  if value <= 0x2120 {
    return "SM".unicodeScalars
  }
  if value <= 0x2121 {
    return "TEL".unicodeScalars
  }
  if value <= 0x2122 {
    return "TM".unicodeScalars
  }
  if value <= 0x2123 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x2124 {
    return "Z".unicodeScalars
  }
  if value <= 0x2125 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x2126 {
    return "Ω".unicodeScalars
  }
  if value <= 0x2127 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x2128 {
    return "Z".unicodeScalars
  }
  if value <= 0x2129 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x212A {
    return "K".unicodeScalars
  }
  if value <= 0x212B {
    return "A\u{030A}".unicodeScalars
  }
  if value <= 0x212C {
    return "B".unicodeScalars
  }
  if value <= 0x212D {
    return "C".unicodeScalars
  }
  if value <= 0x212E {
    return String(scalar).unicodeScalars
  }
  if value <= 0x212F {
    return "e".unicodeScalars
  }
  if value <= 0x2130 {
    return "E".unicodeScalars
  }
  if value <= 0x2131 {
    return "F".unicodeScalars
  }
  if value <= 0x2132 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x2133 {
    return "M".unicodeScalars
  }
  if value <= 0x2134 {
    return "o".unicodeScalars
  }
  if value <= 0x2135 {
    return "א".unicodeScalars
  }
  if value <= 0x2136 {
    return "ב".unicodeScalars
  }
  if value <= 0x2137 {
    return "ג".unicodeScalars
  }
  if value <= 0x2138 {
    return "ד".unicodeScalars
  }
  if value <= 0x2139 {
    return "i".unicodeScalars
  }
  if value <= 0x213A {
    return String(scalar).unicodeScalars
  }
  if value <= 0x213B {
    return "FAX".unicodeScalars
  }
  if value <= 0x213C {
    return "π".unicodeScalars
  }
  if value <= 0x213D {
    return "γ".unicodeScalars
  }
  if value <= 0x213E {
    return "Γ".unicodeScalars
  }
  if value <= 0x213F {
    return "Π".unicodeScalars
  }
  if value <= 0x2140 {
    return "∑".unicodeScalars
  }
  if value <= 0x2144 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x2145 {
    return "D".unicodeScalars
  }
  if value <= 0x2146 {
    return "d".unicodeScalars
  }
  if value <= 0x2147 {
    return "e".unicodeScalars
  }
  if value <= 0x2148 {
    return "i".unicodeScalars
  }
  if value <= 0x2149 {
    return "j".unicodeScalars
  }
  if value <= 0x214F {
    return String(scalar).unicodeScalars
  }
  if value <= 0x2150 {
    return "1⁄7".unicodeScalars
  }
  if value <= 0x2151 {
    return "1⁄9".unicodeScalars
  }
  if value <= 0x2152 {
    return "1⁄10".unicodeScalars
  }
  if value <= 0x2153 {
    return "1⁄3".unicodeScalars
  }
  if value <= 0x2154 {
    return "2⁄3".unicodeScalars
  }
  if value <= 0x2155 {
    return "1⁄5".unicodeScalars
  }
  if value <= 0x2156 {
    return "2⁄5".unicodeScalars
  }
  if value <= 0x2157 {
    return "3⁄5".unicodeScalars
  }
  if value <= 0x2158 {
    return "4⁄5".unicodeScalars
  }
  if value <= 0x2159 {
    return "1⁄6".unicodeScalars
  }
  if value <= 0x215A {
    return "5⁄6".unicodeScalars
  }
  if value <= 0x215B {
    return "1⁄8".unicodeScalars
  }
  if value <= 0x215C {
    return "3⁄8".unicodeScalars
  }
  if value <= 0x215D {
    return "5⁄8".unicodeScalars
  }
  if value <= 0x215E {
    return "7⁄8".unicodeScalars
  }
  if value <= 0x215F {
    return "1⁄".unicodeScalars
  }
  if value <= 0x2160 {
    return "I".unicodeScalars
  }
  if value <= 0x2161 {
    return "II".unicodeScalars
  }
  if value <= 0x2162 {
    return "III".unicodeScalars
  }
  if value <= 0x2163 {
    return "IV".unicodeScalars
  }
  if value <= 0x2164 {
    return "V".unicodeScalars
  }
  if value <= 0x2165 {
    return "VI".unicodeScalars
  }
  if value <= 0x2166 {
    return "VII".unicodeScalars
  }
  if value <= 0x2167 {
    return "VIII".unicodeScalars
  }
  if value <= 0x2168 {
    return "IX".unicodeScalars
  }
  if value <= 0x2169 {
    return "X".unicodeScalars
  }
  if value <= 0x216A {
    return "XI".unicodeScalars
  }
  if value <= 0x216B {
    return "XII".unicodeScalars
  }
  if value <= 0x216C {
    return "L".unicodeScalars
  }
  if value <= 0x216D {
    return "C".unicodeScalars
  }
  if value <= 0x216E {
    return "D".unicodeScalars
  }
  if value <= 0x216F {
    return "M".unicodeScalars
  }
  if value <= 0x2170 {
    return "i".unicodeScalars
  }
  if value <= 0x2171 {
    return "ii".unicodeScalars
  }
  if value <= 0x2172 {
    return "iii".unicodeScalars
  }
  if value <= 0x2173 {
    return "iv".unicodeScalars
  }
  if value <= 0x2174 {
    return "v".unicodeScalars
  }
  if value <= 0x2175 {
    return "vi".unicodeScalars
  }
  if value <= 0x2176 {
    return "vii".unicodeScalars
  }
  if value <= 0x2177 {
    return "viii".unicodeScalars
  }
  if value <= 0x2178 {
    return "ix".unicodeScalars
  }
  if value <= 0x2179 {
    return "x".unicodeScalars
  }
  if value <= 0x217A {
    return "xi".unicodeScalars
  }
  if value <= 0x217B {
    return "xii".unicodeScalars
  }
  if value <= 0x217C {
    return "l".unicodeScalars
  }
  if value <= 0x217D {
    return "c".unicodeScalars
  }
  if value <= 0x217E {
    return "d".unicodeScalars
  }
  if value <= 0x217F {
    return "m".unicodeScalars
  }
  if value <= 0x2188 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x2189 {
    return "0⁄3".unicodeScalars
  }
  if value <= 0x2199 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x219A {
    return "←\u{0338}".unicodeScalars
  }
  if value <= 0x219B {
    return "→\u{0338}".unicodeScalars
  }
  if value <= 0x21AD {
    return String(scalar).unicodeScalars
  }
  if value <= 0x21AE {
    return "↔\u{0338}".unicodeScalars
  }
  if value <= 0x21CC {
    return String(scalar).unicodeScalars
  }
  if value <= 0x21CD {
    return "⇐\u{0338}".unicodeScalars
  }
  if value <= 0x21CE {
    return "⇔\u{0338}".unicodeScalars
  }
  if value <= 0x21CF {
    return "⇒\u{0338}".unicodeScalars
  }
  if value <= 0x2203 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x2204 {
    return "∃\u{0338}".unicodeScalars
  }
  if value <= 0x2208 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x2209 {
    return "∈\u{0338}".unicodeScalars
  }
  if value <= 0x220B {
    return String(scalar).unicodeScalars
  }
  if value <= 0x220C {
    return "∋\u{0338}".unicodeScalars
  }
  if value <= 0x2223 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x2224 {
    return "∣\u{0338}".unicodeScalars
  }
  if value <= 0x2225 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x2226 {
    return "∥\u{0338}".unicodeScalars
  }
  if value <= 0x222B {
    return String(scalar).unicodeScalars
  }
  if value <= 0x222C {
    return "∫∫".unicodeScalars
  }
  if value <= 0x222D {
    return "∫∫∫".unicodeScalars
  }
  if value <= 0x222E {
    return String(scalar).unicodeScalars
  }
  if value <= 0x222F {
    return "∮∮".unicodeScalars
  }
  if value <= 0x2230 {
    return "∮∮∮".unicodeScalars
  }
  if value <= 0x2240 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x2241 {
    return "∼\u{0338}".unicodeScalars
  }
  if value <= 0x2243 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x2244 {
    return "≃\u{0338}".unicodeScalars
  }
  if value <= 0x2246 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x2247 {
    return "≅\u{0338}".unicodeScalars
  }
  if value <= 0x2248 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x2249 {
    return "≈\u{0338}".unicodeScalars
  }
  if value <= 0x225F {
    return String(scalar).unicodeScalars
  }
  if value <= 0x2260 {
    return "=\u{0338}".unicodeScalars
  }
  if value <= 0x2261 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x2262 {
    return "≡\u{0338}".unicodeScalars
  }
  if value <= 0x226C {
    return String(scalar).unicodeScalars
  }
  if value <= 0x226D {
    return "≍\u{0338}".unicodeScalars
  }
  if value <= 0x226E {
    return "<\u{0338}".unicodeScalars
  }
  if value <= 0x226F {
    return ">\u{0338}".unicodeScalars
  }
  if value <= 0x2270 {
    return "≤\u{0338}".unicodeScalars
  }
  if value <= 0x2271 {
    return "≥\u{0338}".unicodeScalars
  }
  if value <= 0x2273 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x2274 {
    return "≲\u{0338}".unicodeScalars
  }
  if value <= 0x2275 {
    return "≳\u{0338}".unicodeScalars
  }
  if value <= 0x2277 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x2278 {
    return "≶\u{0338}".unicodeScalars
  }
  if value <= 0x2279 {
    return "≷\u{0338}".unicodeScalars
  }
  if value <= 0x227F {
    return String(scalar).unicodeScalars
  }
  if value <= 0x2280 {
    return "≺\u{0338}".unicodeScalars
  }
  if value <= 0x2281 {
    return "≻\u{0338}".unicodeScalars
  }
  if value <= 0x2283 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x2284 {
    return "⊂\u{0338}".unicodeScalars
  }
  if value <= 0x2285 {
    return "⊃\u{0338}".unicodeScalars
  }
  if value <= 0x2287 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x2288 {
    return "⊆\u{0338}".unicodeScalars
  }
  if value <= 0x2289 {
    return "⊇\u{0338}".unicodeScalars
  }
  if value <= 0x22AB {
    return String(scalar).unicodeScalars
  }
  if value <= 0x22AC {
    return "⊢\u{0338}".unicodeScalars
  }
  if value <= 0x22AD {
    return "⊨\u{0338}".unicodeScalars
  }
  if value <= 0x22AE {
    return "⊩\u{0338}".unicodeScalars
  }
  if value <= 0x22AF {
    return "⊫\u{0338}".unicodeScalars
  }
  if value <= 0x22DF {
    return String(scalar).unicodeScalars
  }
  if value <= 0x22E0 {
    return "≼\u{0338}".unicodeScalars
  }
  if value <= 0x22E1 {
    return "≽\u{0338}".unicodeScalars
  }
  if value <= 0x22E2 {
    return "⊑\u{0338}".unicodeScalars
  }
  if value <= 0x22E3 {
    return "⊒\u{0338}".unicodeScalars
  }
  if value <= 0x22E9 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x22EA {
    return "⊲\u{0338}".unicodeScalars
  }
  if value <= 0x22EB {
    return "⊳\u{0338}".unicodeScalars
  }
  if value <= 0x22EC {
    return "⊴\u{0338}".unicodeScalars
  }
  if value <= 0x22ED {
    return "⊵\u{0338}".unicodeScalars
  }
  if value <= 0x2328 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x2329 {
    return "〈".unicodeScalars
  }
  if value <= 0x232A {
    return "〉".unicodeScalars
  }
  if value <= 0x245F {
    return String(scalar).unicodeScalars
  }
  if value <= 0x2460 {
    return "1".unicodeScalars
  }
  if value <= 0x2461 {
    return "2".unicodeScalars
  }
  if value <= 0x2462 {
    return "3".unicodeScalars
  }
  if value <= 0x2463 {
    return "4".unicodeScalars
  }
  if value <= 0x2464 {
    return "5".unicodeScalars
  }
  if value <= 0x2465 {
    return "6".unicodeScalars
  }
  if value <= 0x2466 {
    return "7".unicodeScalars
  }
  if value <= 0x2467 {
    return "8".unicodeScalars
  }
  if value <= 0x2468 {
    return "9".unicodeScalars
  }
  if value <= 0x2469 {
    return "10".unicodeScalars
  }
  if value <= 0x246A {
    return "11".unicodeScalars
  }
  if value <= 0x246B {
    return "12".unicodeScalars
  }
  if value <= 0x246C {
    return "13".unicodeScalars
  }
  if value <= 0x246D {
    return "14".unicodeScalars
  }
  if value <= 0x246E {
    return "15".unicodeScalars
  }
  if value <= 0x246F {
    return "16".unicodeScalars
  }
  if value <= 0x2470 {
    return "17".unicodeScalars
  }
  if value <= 0x2471 {
    return "18".unicodeScalars
  }
  if value <= 0x2472 {
    return "19".unicodeScalars
  }
  if value <= 0x2473 {
    return "20".unicodeScalars
  }
  if value <= 0x2474 {
    return "(1)".unicodeScalars
  }
  if value <= 0x2475 {
    return "(2)".unicodeScalars
  }
  if value <= 0x2476 {
    return "(3)".unicodeScalars
  }
  if value <= 0x2477 {
    return "(4)".unicodeScalars
  }
  if value <= 0x2478 {
    return "(5)".unicodeScalars
  }
  if value <= 0x2479 {
    return "(6)".unicodeScalars
  }
  if value <= 0x247A {
    return "(7)".unicodeScalars
  }
  if value <= 0x247B {
    return "(8)".unicodeScalars
  }
  if value <= 0x247C {
    return "(9)".unicodeScalars
  }
  if value <= 0x247D {
    return "(10)".unicodeScalars
  }
  if value <= 0x247E {
    return "(11)".unicodeScalars
  }
  if value <= 0x247F {
    return "(12)".unicodeScalars
  }
  if value <= 0x2480 {
    return "(13)".unicodeScalars
  }
  if value <= 0x2481 {
    return "(14)".unicodeScalars
  }
  if value <= 0x2482 {
    return "(15)".unicodeScalars
  }
  if value <= 0x2483 {
    return "(16)".unicodeScalars
  }
  if value <= 0x2484 {
    return "(17)".unicodeScalars
  }
  if value <= 0x2485 {
    return "(18)".unicodeScalars
  }
  if value <= 0x2486 {
    return "(19)".unicodeScalars
  }
  if value <= 0x2487 {
    return "(20)".unicodeScalars
  }
  if value <= 0x2488 {
    return "1.".unicodeScalars
  }
  if value <= 0x2489 {
    return "2.".unicodeScalars
  }
  if value <= 0x248A {
    return "3.".unicodeScalars
  }
  if value <= 0x248B {
    return "4.".unicodeScalars
  }
  if value <= 0x248C {
    return "5.".unicodeScalars
  }
  if value <= 0x248D {
    return "6.".unicodeScalars
  }
  if value <= 0x248E {
    return "7.".unicodeScalars
  }
  if value <= 0x248F {
    return "8.".unicodeScalars
  }
  if value <= 0x2490 {
    return "9.".unicodeScalars
  }
  if value <= 0x2491 {
    return "10.".unicodeScalars
  }
  if value <= 0x2492 {
    return "11.".unicodeScalars
  }
  if value <= 0x2493 {
    return "12.".unicodeScalars
  }
  if value <= 0x2494 {
    return "13.".unicodeScalars
  }
  if value <= 0x2495 {
    return "14.".unicodeScalars
  }
  if value <= 0x2496 {
    return "15.".unicodeScalars
  }
  if value <= 0x2497 {
    return "16.".unicodeScalars
  }
  if value <= 0x2498 {
    return "17.".unicodeScalars
  }
  if value <= 0x2499 {
    return "18.".unicodeScalars
  }
  if value <= 0x249A {
    return "19.".unicodeScalars
  }
  if value <= 0x249B {
    return "20.".unicodeScalars
  }
  if value <= 0x249C {
    return "(a)".unicodeScalars
  }
  if value <= 0x249D {
    return "(b)".unicodeScalars
  }
  if value <= 0x249E {
    return "(c)".unicodeScalars
  }
  if value <= 0x249F {
    return "(d)".unicodeScalars
  }
  if value <= 0x24A0 {
    return "(e)".unicodeScalars
  }
  if value <= 0x24A1 {
    return "(f)".unicodeScalars
  }
  if value <= 0x24A2 {
    return "(g)".unicodeScalars
  }
  if value <= 0x24A3 {
    return "(h)".unicodeScalars
  }
  if value <= 0x24A4 {
    return "(i)".unicodeScalars
  }
  if value <= 0x24A5 {
    return "(j)".unicodeScalars
  }
  if value <= 0x24A6 {
    return "(k)".unicodeScalars
  }
  if value <= 0x24A7 {
    return "(l)".unicodeScalars
  }
  if value <= 0x24A8 {
    return "(m)".unicodeScalars
  }
  if value <= 0x24A9 {
    return "(n)".unicodeScalars
  }
  if value <= 0x24AA {
    return "(o)".unicodeScalars
  }
  if value <= 0x24AB {
    return "(p)".unicodeScalars
  }
  if value <= 0x24AC {
    return "(q)".unicodeScalars
  }
  if value <= 0x24AD {
    return "(r)".unicodeScalars
  }
  if value <= 0x24AE {
    return "(s)".unicodeScalars
  }
  if value <= 0x24AF {
    return "(t)".unicodeScalars
  }
  if value <= 0x24B0 {
    return "(u)".unicodeScalars
  }
  if value <= 0x24B1 {
    return "(v)".unicodeScalars
  }
  if value <= 0x24B2 {
    return "(w)".unicodeScalars
  }
  if value <= 0x24B3 {
    return "(x)".unicodeScalars
  }
  if value <= 0x24B4 {
    return "(y)".unicodeScalars
  }
  if value <= 0x24B5 {
    return "(z)".unicodeScalars
  }
  if value <= 0x24B6 {
    return "A".unicodeScalars
  }
  if value <= 0x24B7 {
    return "B".unicodeScalars
  }
  if value <= 0x24B8 {
    return "C".unicodeScalars
  }
  if value <= 0x24B9 {
    return "D".unicodeScalars
  }
  if value <= 0x24BA {
    return "E".unicodeScalars
  }
  if value <= 0x24BB {
    return "F".unicodeScalars
  }
  if value <= 0x24BC {
    return "G".unicodeScalars
  }
  if value <= 0x24BD {
    return "H".unicodeScalars
  }
  if value <= 0x24BE {
    return "I".unicodeScalars
  }
  if value <= 0x24BF {
    return "J".unicodeScalars
  }
  if value <= 0x24C0 {
    return "K".unicodeScalars
  }
  if value <= 0x24C1 {
    return "L".unicodeScalars
  }
  if value <= 0x24C2 {
    return "M".unicodeScalars
  }
  if value <= 0x24C3 {
    return "N".unicodeScalars
  }
  if value <= 0x24C4 {
    return "O".unicodeScalars
  }
  if value <= 0x24C5 {
    return "P".unicodeScalars
  }
  if value <= 0x24C6 {
    return "Q".unicodeScalars
  }
  if value <= 0x24C7 {
    return "R".unicodeScalars
  }
  if value <= 0x24C8 {
    return "S".unicodeScalars
  }
  if value <= 0x24C9 {
    return "T".unicodeScalars
  }
  if value <= 0x24CA {
    return "U".unicodeScalars
  }
  if value <= 0x24CB {
    return "V".unicodeScalars
  }
  if value <= 0x24CC {
    return "W".unicodeScalars
  }
  if value <= 0x24CD {
    return "X".unicodeScalars
  }
  if value <= 0x24CE {
    return "Y".unicodeScalars
  }
  if value <= 0x24CF {
    return "Z".unicodeScalars
  }
  if value <= 0x24D0 {
    return "a".unicodeScalars
  }
  if value <= 0x24D1 {
    return "b".unicodeScalars
  }
  if value <= 0x24D2 {
    return "c".unicodeScalars
  }
  if value <= 0x24D3 {
    return "d".unicodeScalars
  }
  if value <= 0x24D4 {
    return "e".unicodeScalars
  }
  if value <= 0x24D5 {
    return "f".unicodeScalars
  }
  if value <= 0x24D6 {
    return "g".unicodeScalars
  }
  if value <= 0x24D7 {
    return "h".unicodeScalars
  }
  if value <= 0x24D8 {
    return "i".unicodeScalars
  }
  if value <= 0x24D9 {
    return "j".unicodeScalars
  }
  if value <= 0x24DA {
    return "k".unicodeScalars
  }
  if value <= 0x24DB {
    return "l".unicodeScalars
  }
  if value <= 0x24DC {
    return "m".unicodeScalars
  }
  if value <= 0x24DD {
    return "n".unicodeScalars
  }
  if value <= 0x24DE {
    return "o".unicodeScalars
  }
  if value <= 0x24DF {
    return "p".unicodeScalars
  }
  if value <= 0x24E0 {
    return "q".unicodeScalars
  }
  if value <= 0x24E1 {
    return "r".unicodeScalars
  }
  if value <= 0x24E2 {
    return "s".unicodeScalars
  }
  if value <= 0x24E3 {
    return "t".unicodeScalars
  }
  if value <= 0x24E4 {
    return "u".unicodeScalars
  }
  if value <= 0x24E5 {
    return "v".unicodeScalars
  }
  if value <= 0x24E6 {
    return "w".unicodeScalars
  }
  if value <= 0x24E7 {
    return "x".unicodeScalars
  }
  if value <= 0x24E8 {
    return "y".unicodeScalars
  }
  if value <= 0x24E9 {
    return "z".unicodeScalars
  }
  if value <= 0x24EA {
    return "0".unicodeScalars
  }
  if value <= 0x2A0B {
    return String(scalar).unicodeScalars
  }
  if value <= 0x2A0C {
    return "∫∫∫∫".unicodeScalars
  }
  if value <= 0x2A73 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x2A74 {
    return "::=".unicodeScalars
  }
  if value <= 0x2A75 {
    return "==".unicodeScalars
  }
  if value <= 0x2A76 {
    return "===".unicodeScalars
  }
  if value <= 0x2ADB {
    return String(scalar).unicodeScalars
  }
  if value <= 0x2ADC {
    return "⫝\u{0338}".unicodeScalars
  }
  if value <= 0x2C7B {
    return String(scalar).unicodeScalars
  }
  if value <= 0x2C7C {
    return "j".unicodeScalars
  }
  if value <= 0x2C7D {
    return "V".unicodeScalars
  }
  if value <= 0x2D6E {
    return String(scalar).unicodeScalars
  }
  if value <= 0x2D6F {
    return "ⵡ".unicodeScalars
  }
  if value <= 0x2E9E {
    return String(scalar).unicodeScalars
  }
  if value <= 0x2E9F {
    return "母".unicodeScalars
  }
  if value <= 0x2EF2 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x2EF3 {
    return "龟".unicodeScalars
  }
  if value <= 0x2EFF {
    return String(scalar).unicodeScalars
  }
  if value <= 0x2F00 {
    return "一".unicodeScalars
  }
  if value <= 0x2F01 {
    return "丨".unicodeScalars
  }
  if value <= 0x2F02 {
    return "丶".unicodeScalars
  }
  if value <= 0x2F03 {
    return "丿".unicodeScalars
  }
  if value <= 0x2F04 {
    return "乙".unicodeScalars
  }
  if value <= 0x2F05 {
    return "亅".unicodeScalars
  }
  if value <= 0x2F06 {
    return "二".unicodeScalars
  }
  if value <= 0x2F07 {
    return "亠".unicodeScalars
  }
  if value <= 0x2F08 {
    return "人".unicodeScalars
  }
  if value <= 0x2F09 {
    return "儿".unicodeScalars
  }
  if value <= 0x2F0A {
    return "入".unicodeScalars
  }
  if value <= 0x2F0B {
    return "八".unicodeScalars
  }
  if value <= 0x2F0C {
    return "冂".unicodeScalars
  }
  if value <= 0x2F0D {
    return "冖".unicodeScalars
  }
  if value <= 0x2F0E {
    return "冫".unicodeScalars
  }
  if value <= 0x2F0F {
    return "几".unicodeScalars
  }
  if value <= 0x2F10 {
    return "凵".unicodeScalars
  }
  if value <= 0x2F11 {
    return "刀".unicodeScalars
  }
  if value <= 0x2F12 {
    return "力".unicodeScalars
  }
  if value <= 0x2F13 {
    return "勹".unicodeScalars
  }
  if value <= 0x2F14 {
    return "匕".unicodeScalars
  }
  if value <= 0x2F15 {
    return "匚".unicodeScalars
  }
  if value <= 0x2F16 {
    return "匸".unicodeScalars
  }
  if value <= 0x2F17 {
    return "十".unicodeScalars
  }
  if value <= 0x2F18 {
    return "卜".unicodeScalars
  }
  if value <= 0x2F19 {
    return "卩".unicodeScalars
  }
  if value <= 0x2F1A {
    return "厂".unicodeScalars
  }
  if value <= 0x2F1B {
    return "厶".unicodeScalars
  }
  if value <= 0x2F1C {
    return "又".unicodeScalars
  }
  if value <= 0x2F1D {
    return "口".unicodeScalars
  }
  if value <= 0x2F1E {
    return "囗".unicodeScalars
  }
  if value <= 0x2F1F {
    return "土".unicodeScalars
  }
  if value <= 0x2F20 {
    return "士".unicodeScalars
  }
  if value <= 0x2F21 {
    return "夂".unicodeScalars
  }
  if value <= 0x2F22 {
    return "夊".unicodeScalars
  }
  if value <= 0x2F23 {
    return "夕".unicodeScalars
  }
  if value <= 0x2F24 {
    return "大".unicodeScalars
  }
  if value <= 0x2F25 {
    return "女".unicodeScalars
  }
  if value <= 0x2F26 {
    return "子".unicodeScalars
  }
  if value <= 0x2F27 {
    return "宀".unicodeScalars
  }
  if value <= 0x2F28 {
    return "寸".unicodeScalars
  }
  if value <= 0x2F29 {
    return "小".unicodeScalars
  }
  if value <= 0x2F2A {
    return "尢".unicodeScalars
  }
  if value <= 0x2F2B {
    return "尸".unicodeScalars
  }
  if value <= 0x2F2C {
    return "屮".unicodeScalars
  }
  if value <= 0x2F2D {
    return "山".unicodeScalars
  }
  if value <= 0x2F2E {
    return "巛".unicodeScalars
  }
  if value <= 0x2F2F {
    return "工".unicodeScalars
  }
  if value <= 0x2F30 {
    return "己".unicodeScalars
  }
  if value <= 0x2F31 {
    return "巾".unicodeScalars
  }
  if value <= 0x2F32 {
    return "干".unicodeScalars
  }
  if value <= 0x2F33 {
    return "幺".unicodeScalars
  }
  if value <= 0x2F34 {
    return "广".unicodeScalars
  }
  if value <= 0x2F35 {
    return "廴".unicodeScalars
  }
  if value <= 0x2F36 {
    return "廾".unicodeScalars
  }
  if value <= 0x2F37 {
    return "弋".unicodeScalars
  }
  if value <= 0x2F38 {
    return "弓".unicodeScalars
  }
  if value <= 0x2F39 {
    return "彐".unicodeScalars
  }
  if value <= 0x2F3A {
    return "彡".unicodeScalars
  }
  if value <= 0x2F3B {
    return "彳".unicodeScalars
  }
  if value <= 0x2F3C {
    return "心".unicodeScalars
  }
  if value <= 0x2F3D {
    return "戈".unicodeScalars
  }
  if value <= 0x2F3E {
    return "戶".unicodeScalars
  }
  if value <= 0x2F3F {
    return "手".unicodeScalars
  }
  if value <= 0x2F40 {
    return "支".unicodeScalars
  }
  if value <= 0x2F41 {
    return "攴".unicodeScalars
  }
  if value <= 0x2F42 {
    return "文".unicodeScalars
  }
  if value <= 0x2F43 {
    return "斗".unicodeScalars
  }
  if value <= 0x2F44 {
    return "斤".unicodeScalars
  }
  if value <= 0x2F45 {
    return "方".unicodeScalars
  }
  if value <= 0x2F46 {
    return "无".unicodeScalars
  }
  if value <= 0x2F47 {
    return "日".unicodeScalars
  }
  if value <= 0x2F48 {
    return "曰".unicodeScalars
  }
  if value <= 0x2F49 {
    return "月".unicodeScalars
  }
  if value <= 0x2F4A {
    return "木".unicodeScalars
  }
  if value <= 0x2F4B {
    return "欠".unicodeScalars
  }
  if value <= 0x2F4C {
    return "止".unicodeScalars
  }
  if value <= 0x2F4D {
    return "歹".unicodeScalars
  }
  if value <= 0x2F4E {
    return "殳".unicodeScalars
  }
  if value <= 0x2F4F {
    return "毋".unicodeScalars
  }
  if value <= 0x2F50 {
    return "比".unicodeScalars
  }
  if value <= 0x2F51 {
    return "毛".unicodeScalars
  }
  if value <= 0x2F52 {
    return "氏".unicodeScalars
  }
  if value <= 0x2F53 {
    return "气".unicodeScalars
  }
  if value <= 0x2F54 {
    return "水".unicodeScalars
  }
  if value <= 0x2F55 {
    return "火".unicodeScalars
  }
  if value <= 0x2F56 {
    return "爪".unicodeScalars
  }
  if value <= 0x2F57 {
    return "父".unicodeScalars
  }
  if value <= 0x2F58 {
    return "爻".unicodeScalars
  }
  if value <= 0x2F59 {
    return "爿".unicodeScalars
  }
  if value <= 0x2F5A {
    return "片".unicodeScalars
  }
  if value <= 0x2F5B {
    return "牙".unicodeScalars
  }
  if value <= 0x2F5C {
    return "牛".unicodeScalars
  }
  if value <= 0x2F5D {
    return "犬".unicodeScalars
  }
  if value <= 0x2F5E {
    return "玄".unicodeScalars
  }
  if value <= 0x2F5F {
    return "玉".unicodeScalars
  }
  if value <= 0x2F60 {
    return "瓜".unicodeScalars
  }
  if value <= 0x2F61 {
    return "瓦".unicodeScalars
  }
  if value <= 0x2F62 {
    return "甘".unicodeScalars
  }
  if value <= 0x2F63 {
    return "生".unicodeScalars
  }
  if value <= 0x2F64 {
    return "用".unicodeScalars
  }
  if value <= 0x2F65 {
    return "田".unicodeScalars
  }
  if value <= 0x2F66 {
    return "疋".unicodeScalars
  }
  if value <= 0x2F67 {
    return "疒".unicodeScalars
  }
  if value <= 0x2F68 {
    return "癶".unicodeScalars
  }
  if value <= 0x2F69 {
    return "白".unicodeScalars
  }
  if value <= 0x2F6A {
    return "皮".unicodeScalars
  }
  if value <= 0x2F6B {
    return "皿".unicodeScalars
  }
  if value <= 0x2F6C {
    return "目".unicodeScalars
  }
  if value <= 0x2F6D {
    return "矛".unicodeScalars
  }
  if value <= 0x2F6E {
    return "矢".unicodeScalars
  }
  if value <= 0x2F6F {
    return "石".unicodeScalars
  }
  if value <= 0x2F70 {
    return "示".unicodeScalars
  }
  if value <= 0x2F71 {
    return "禸".unicodeScalars
  }
  if value <= 0x2F72 {
    return "禾".unicodeScalars
  }
  if value <= 0x2F73 {
    return "穴".unicodeScalars
  }
  if value <= 0x2F74 {
    return "立".unicodeScalars
  }
  if value <= 0x2F75 {
    return "竹".unicodeScalars
  }
  if value <= 0x2F76 {
    return "米".unicodeScalars
  }
  if value <= 0x2F77 {
    return "糸".unicodeScalars
  }
  if value <= 0x2F78 {
    return "缶".unicodeScalars
  }
  if value <= 0x2F79 {
    return "网".unicodeScalars
  }
  if value <= 0x2F7A {
    return "羊".unicodeScalars
  }
  if value <= 0x2F7B {
    return "羽".unicodeScalars
  }
  if value <= 0x2F7C {
    return "老".unicodeScalars
  }
  if value <= 0x2F7D {
    return "而".unicodeScalars
  }
  if value <= 0x2F7E {
    return "耒".unicodeScalars
  }
  if value <= 0x2F7F {
    return "耳".unicodeScalars
  }
  if value <= 0x2F80 {
    return "聿".unicodeScalars
  }
  if value <= 0x2F81 {
    return "肉".unicodeScalars
  }
  if value <= 0x2F82 {
    return "臣".unicodeScalars
  }
  if value <= 0x2F83 {
    return "自".unicodeScalars
  }
  if value <= 0x2F84 {
    return "至".unicodeScalars
  }
  if value <= 0x2F85 {
    return "臼".unicodeScalars
  }
  if value <= 0x2F86 {
    return "舌".unicodeScalars
  }
  if value <= 0x2F87 {
    return "舛".unicodeScalars
  }
  if value <= 0x2F88 {
    return "舟".unicodeScalars
  }
  if value <= 0x2F89 {
    return "艮".unicodeScalars
  }
  if value <= 0x2F8A {
    return "色".unicodeScalars
  }
  if value <= 0x2F8B {
    return "艸".unicodeScalars
  }
  if value <= 0x2F8C {
    return "虍".unicodeScalars
  }
  if value <= 0x2F8D {
    return "虫".unicodeScalars
  }
  if value <= 0x2F8E {
    return "血".unicodeScalars
  }
  if value <= 0x2F8F {
    return "行".unicodeScalars
  }
  if value <= 0x2F90 {
    return "衣".unicodeScalars
  }
  if value <= 0x2F91 {
    return "襾".unicodeScalars
  }
  if value <= 0x2F92 {
    return "見".unicodeScalars
  }
  if value <= 0x2F93 {
    return "角".unicodeScalars
  }
  if value <= 0x2F94 {
    return "言".unicodeScalars
  }
  if value <= 0x2F95 {
    return "谷".unicodeScalars
  }
  if value <= 0x2F96 {
    return "豆".unicodeScalars
  }
  if value <= 0x2F97 {
    return "豕".unicodeScalars
  }
  if value <= 0x2F98 {
    return "豸".unicodeScalars
  }
  if value <= 0x2F99 {
    return "貝".unicodeScalars
  }
  if value <= 0x2F9A {
    return "赤".unicodeScalars
  }
  if value <= 0x2F9B {
    return "走".unicodeScalars
  }
  if value <= 0x2F9C {
    return "足".unicodeScalars
  }
  if value <= 0x2F9D {
    return "身".unicodeScalars
  }
  if value <= 0x2F9E {
    return "車".unicodeScalars
  }
  if value <= 0x2F9F {
    return "辛".unicodeScalars
  }
  if value <= 0x2FA0 {
    return "辰".unicodeScalars
  }
  if value <= 0x2FA1 {
    return "辵".unicodeScalars
  }
  if value <= 0x2FA2 {
    return "邑".unicodeScalars
  }
  if value <= 0x2FA3 {
    return "酉".unicodeScalars
  }
  if value <= 0x2FA4 {
    return "釆".unicodeScalars
  }
  if value <= 0x2FA5 {
    return "里".unicodeScalars
  }
  if value <= 0x2FA6 {
    return "金".unicodeScalars
  }
  if value <= 0x2FA7 {
    return "長".unicodeScalars
  }
  if value <= 0x2FA8 {
    return "門".unicodeScalars
  }
  if value <= 0x2FA9 {
    return "阜".unicodeScalars
  }
  if value <= 0x2FAA {
    return "隶".unicodeScalars
  }
  if value <= 0x2FAB {
    return "隹".unicodeScalars
  }
  if value <= 0x2FAC {
    return "雨".unicodeScalars
  }
  if value <= 0x2FAD {
    return "靑".unicodeScalars
  }
  if value <= 0x2FAE {
    return "非".unicodeScalars
  }
  if value <= 0x2FAF {
    return "面".unicodeScalars
  }
  if value <= 0x2FB0 {
    return "革".unicodeScalars
  }
  if value <= 0x2FB1 {
    return "韋".unicodeScalars
  }
  if value <= 0x2FB2 {
    return "韭".unicodeScalars
  }
  if value <= 0x2FB3 {
    return "音".unicodeScalars
  }
  if value <= 0x2FB4 {
    return "頁".unicodeScalars
  }
  if value <= 0x2FB5 {
    return "風".unicodeScalars
  }
  if value <= 0x2FB6 {
    return "飛".unicodeScalars
  }
  if value <= 0x2FB7 {
    return "食".unicodeScalars
  }
  if value <= 0x2FB8 {
    return "首".unicodeScalars
  }
  if value <= 0x2FB9 {
    return "香".unicodeScalars
  }
  if value <= 0x2FBA {
    return "馬".unicodeScalars
  }
  if value <= 0x2FBB {
    return "骨".unicodeScalars
  }
  if value <= 0x2FBC {
    return "高".unicodeScalars
  }
  if value <= 0x2FBD {
    return "髟".unicodeScalars
  }
  if value <= 0x2FBE {
    return "鬥".unicodeScalars
  }
  if value <= 0x2FBF {
    return "鬯".unicodeScalars
  }
  if value <= 0x2FC0 {
    return "鬲".unicodeScalars
  }
  if value <= 0x2FC1 {
    return "鬼".unicodeScalars
  }
  if value <= 0x2FC2 {
    return "魚".unicodeScalars
  }
  if value <= 0x2FC3 {
    return "鳥".unicodeScalars
  }
  if value <= 0x2FC4 {
    return "鹵".unicodeScalars
  }
  if value <= 0x2FC5 {
    return "鹿".unicodeScalars
  }
  if value <= 0x2FC6 {
    return "麥".unicodeScalars
  }
  if value <= 0x2FC7 {
    return "麻".unicodeScalars
  }
  if value <= 0x2FC8 {
    return "黃".unicodeScalars
  }
  if value <= 0x2FC9 {
    return "黍".unicodeScalars
  }
  if value <= 0x2FCA {
    return "黑".unicodeScalars
  }
  if value <= 0x2FCB {
    return "黹".unicodeScalars
  }
  if value <= 0x2FCC {
    return "黽".unicodeScalars
  }
  if value <= 0x2FCD {
    return "鼎".unicodeScalars
  }
  if value <= 0x2FCE {
    return "鼓".unicodeScalars
  }
  if value <= 0x2FCF {
    return "鼠".unicodeScalars
  }
  if value <= 0x2FD0 {
    return "鼻".unicodeScalars
  }
  if value <= 0x2FD1 {
    return "齊".unicodeScalars
  }
  if value <= 0x2FD2 {
    return "齒".unicodeScalars
  }
  if value <= 0x2FD3 {
    return "龍".unicodeScalars
  }
  if value <= 0x2FD4 {
    return "龜".unicodeScalars
  }
  if value <= 0x2FD5 {
    return "龠".unicodeScalars
  }
  if value <= 0x2FFF {
    return String(scalar).unicodeScalars
  }
  if value <= 0x3000 {
    return " ".unicodeScalars
  }
  if value <= 0x3035 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x3036 {
    return "〒".unicodeScalars
  }
  if value <= 0x3037 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x3038 {
    return "十".unicodeScalars
  }
  if value <= 0x3039 {
    return "卄".unicodeScalars
  }
  if value <= 0x303A {
    return "卅".unicodeScalars
  }
  if value <= 0x304B {
    return String(scalar).unicodeScalars
  }
  if value <= 0x304C {
    return "か\u{3099}".unicodeScalars
  }
  if value <= 0x304D {
    return String(scalar).unicodeScalars
  }
  if value <= 0x304E {
    return "き\u{3099}".unicodeScalars
  }
  if value <= 0x304F {
    return String(scalar).unicodeScalars
  }
  if value <= 0x3050 {
    return "く\u{3099}".unicodeScalars
  }
  if value <= 0x3051 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x3052 {
    return "け\u{3099}".unicodeScalars
  }
  if value <= 0x3053 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x3054 {
    return "こ\u{3099}".unicodeScalars
  }
  if value <= 0x3055 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x3056 {
    return "さ\u{3099}".unicodeScalars
  }
  if value <= 0x3057 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x3058 {
    return "し\u{3099}".unicodeScalars
  }
  if value <= 0x3059 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x305A {
    return "す\u{3099}".unicodeScalars
  }
  if value <= 0x305B {
    return String(scalar).unicodeScalars
  }
  if value <= 0x305C {
    return "せ\u{3099}".unicodeScalars
  }
  if value <= 0x305D {
    return String(scalar).unicodeScalars
  }
  if value <= 0x305E {
    return "そ\u{3099}".unicodeScalars
  }
  if value <= 0x305F {
    return String(scalar).unicodeScalars
  }
  if value <= 0x3060 {
    return "た\u{3099}".unicodeScalars
  }
  if value <= 0x3061 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x3062 {
    return "ち\u{3099}".unicodeScalars
  }
  if value <= 0x3064 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x3065 {
    return "つ\u{3099}".unicodeScalars
  }
  if value <= 0x3066 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x3067 {
    return "て\u{3099}".unicodeScalars
  }
  if value <= 0x3068 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x3069 {
    return "と\u{3099}".unicodeScalars
  }
  if value <= 0x306F {
    return String(scalar).unicodeScalars
  }
  if value <= 0x3070 {
    return "は\u{3099}".unicodeScalars
  }
  if value <= 0x3071 {
    return "は\u{309A}".unicodeScalars
  }
  if value <= 0x3072 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x3073 {
    return "ひ\u{3099}".unicodeScalars
  }
  if value <= 0x3074 {
    return "ひ\u{309A}".unicodeScalars
  }
  if value <= 0x3075 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x3076 {
    return "ふ\u{3099}".unicodeScalars
  }
  if value <= 0x3077 {
    return "ふ\u{309A}".unicodeScalars
  }
  if value <= 0x3078 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x3079 {
    return "へ\u{3099}".unicodeScalars
  }
  if value <= 0x307A {
    return "へ\u{309A}".unicodeScalars
  }
  if value <= 0x307B {
    return String(scalar).unicodeScalars
  }
  if value <= 0x307C {
    return "ほ\u{3099}".unicodeScalars
  }
  if value <= 0x307D {
    return "ほ\u{309A}".unicodeScalars
  }
  if value <= 0x3093 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x3094 {
    return "う\u{3099}".unicodeScalars
  }
  if value <= 0x309A {
    return String(scalar).unicodeScalars
  }
  if value <= 0x309B {
    return " \u{3099}".unicodeScalars
  }
  if value <= 0x309C {
    return " \u{309A}".unicodeScalars
  }
  if value <= 0x309D {
    return String(scalar).unicodeScalars
  }
  if value <= 0x309E {
    return "ゝ\u{3099}".unicodeScalars
  }
  if value <= 0x309F {
    return "より".unicodeScalars
  }
  if value <= 0x30AB {
    return String(scalar).unicodeScalars
  }
  if value <= 0x30AC {
    return "カ\u{3099}".unicodeScalars
  }
  if value <= 0x30AD {
    return String(scalar).unicodeScalars
  }
  if value <= 0x30AE {
    return "キ\u{3099}".unicodeScalars
  }
  if value <= 0x30AF {
    return String(scalar).unicodeScalars
  }
  if value <= 0x30B0 {
    return "ク\u{3099}".unicodeScalars
  }
  if value <= 0x30B1 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x30B2 {
    return "ケ\u{3099}".unicodeScalars
  }
  if value <= 0x30B3 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x30B4 {
    return "コ\u{3099}".unicodeScalars
  }
  if value <= 0x30B5 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x30B6 {
    return "サ\u{3099}".unicodeScalars
  }
  if value <= 0x30B7 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x30B8 {
    return "シ\u{3099}".unicodeScalars
  }
  if value <= 0x30B9 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x30BA {
    return "ス\u{3099}".unicodeScalars
  }
  if value <= 0x30BB {
    return String(scalar).unicodeScalars
  }
  if value <= 0x30BC {
    return "セ\u{3099}".unicodeScalars
  }
  if value <= 0x30BD {
    return String(scalar).unicodeScalars
  }
  if value <= 0x30BE {
    return "ソ\u{3099}".unicodeScalars
  }
  if value <= 0x30BF {
    return String(scalar).unicodeScalars
  }
  if value <= 0x30C0 {
    return "タ\u{3099}".unicodeScalars
  }
  if value <= 0x30C1 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x30C2 {
    return "チ\u{3099}".unicodeScalars
  }
  if value <= 0x30C4 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x30C5 {
    return "ツ\u{3099}".unicodeScalars
  }
  if value <= 0x30C6 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x30C7 {
    return "テ\u{3099}".unicodeScalars
  }
  if value <= 0x30C8 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x30C9 {
    return "ト\u{3099}".unicodeScalars
  }
  if value <= 0x30CF {
    return String(scalar).unicodeScalars
  }
  if value <= 0x30D0 {
    return "ハ\u{3099}".unicodeScalars
  }
  if value <= 0x30D1 {
    return "ハ\u{309A}".unicodeScalars
  }
  if value <= 0x30D2 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x30D3 {
    return "ヒ\u{3099}".unicodeScalars
  }
  if value <= 0x30D4 {
    return "ヒ\u{309A}".unicodeScalars
  }
  if value <= 0x30D5 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x30D6 {
    return "フ\u{3099}".unicodeScalars
  }
  if value <= 0x30D7 {
    return "フ\u{309A}".unicodeScalars
  }
  if value <= 0x30D8 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x30D9 {
    return "ヘ\u{3099}".unicodeScalars
  }
  if value <= 0x30DA {
    return "ヘ\u{309A}".unicodeScalars
  }
  if value <= 0x30DB {
    return String(scalar).unicodeScalars
  }
  if value <= 0x30DC {
    return "ホ\u{3099}".unicodeScalars
  }
  if value <= 0x30DD {
    return "ホ\u{309A}".unicodeScalars
  }
  if value <= 0x30F3 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x30F4 {
    return "ウ\u{3099}".unicodeScalars
  }
  if value <= 0x30F6 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x30F7 {
    return "ワ\u{3099}".unicodeScalars
  }
  if value <= 0x30F8 {
    return "ヰ\u{3099}".unicodeScalars
  }
  if value <= 0x30F9 {
    return "ヱ\u{3099}".unicodeScalars
  }
  if value <= 0x30FA {
    return "ヲ\u{3099}".unicodeScalars
  }
  if value <= 0x30FD {
    return String(scalar).unicodeScalars
  }
  if value <= 0x30FE {
    return "ヽ\u{3099}".unicodeScalars
  }
  if value <= 0x30FF {
    return "コト".unicodeScalars
  }
  if value <= 0x3130 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x3131 {
    return "ᄀ".unicodeScalars
  }
  if value <= 0x3132 {
    return "ᄁ".unicodeScalars
  }
  if value <= 0x3133 {
    return "ᆪ".unicodeScalars
  }
  if value <= 0x3134 {
    return "ᄂ".unicodeScalars
  }
  if value <= 0x3135 {
    return "ᆬ".unicodeScalars
  }
  if value <= 0x3136 {
    return "ᆭ".unicodeScalars
  }
  if value <= 0x3137 {
    return "ᄃ".unicodeScalars
  }
  if value <= 0x3138 {
    return "ᄄ".unicodeScalars
  }
  if value <= 0x3139 {
    return "ᄅ".unicodeScalars
  }
  if value <= 0x313A {
    return "ᆰ".unicodeScalars
  }
  if value <= 0x313B {
    return "ᆱ".unicodeScalars
  }
  if value <= 0x313C {
    return "ᆲ".unicodeScalars
  }
  if value <= 0x313D {
    return "ᆳ".unicodeScalars
  }
  if value <= 0x313E {
    return "ᆴ".unicodeScalars
  }
  if value <= 0x313F {
    return "ᆵ".unicodeScalars
  }
  if value <= 0x3140 {
    return "ᄚ".unicodeScalars
  }
  if value <= 0x3141 {
    return "ᄆ".unicodeScalars
  }
  if value <= 0x3142 {
    return "ᄇ".unicodeScalars
  }
  if value <= 0x3143 {
    return "ᄈ".unicodeScalars
  }
  if value <= 0x3144 {
    return "ᄡ".unicodeScalars
  }
  if value <= 0x3145 {
    return "ᄉ".unicodeScalars
  }
  if value <= 0x3146 {
    return "ᄊ".unicodeScalars
  }
  if value <= 0x3147 {
    return "ᄋ".unicodeScalars
  }
  if value <= 0x3148 {
    return "ᄌ".unicodeScalars
  }
  if value <= 0x3149 {
    return "ᄍ".unicodeScalars
  }
  if value <= 0x314A {
    return "ᄎ".unicodeScalars
  }
  if value <= 0x314B {
    return "ᄏ".unicodeScalars
  }
  if value <= 0x314C {
    return "ᄐ".unicodeScalars
  }
  if value <= 0x314D {
    return "ᄑ".unicodeScalars
  }
  if value <= 0x314E {
    return "ᄒ".unicodeScalars
  }
  if value <= 0x314F {
    return "ᅡ".unicodeScalars
  }
  if value <= 0x3150 {
    return "ᅢ".unicodeScalars
  }
  if value <= 0x3151 {
    return "ᅣ".unicodeScalars
  }
  if value <= 0x3152 {
    return "ᅤ".unicodeScalars
  }
  if value <= 0x3153 {
    return "ᅥ".unicodeScalars
  }
  if value <= 0x3154 {
    return "ᅦ".unicodeScalars
  }
  if value <= 0x3155 {
    return "ᅧ".unicodeScalars
  }
  if value <= 0x3156 {
    return "ᅨ".unicodeScalars
  }
  if value <= 0x3157 {
    return "ᅩ".unicodeScalars
  }
  if value <= 0x3158 {
    return "ᅪ".unicodeScalars
  }
  if value <= 0x3159 {
    return "ᅫ".unicodeScalars
  }
  if value <= 0x315A {
    return "ᅬ".unicodeScalars
  }
  if value <= 0x315B {
    return "ᅭ".unicodeScalars
  }
  if value <= 0x315C {
    return "ᅮ".unicodeScalars
  }
  if value <= 0x315D {
    return "ᅯ".unicodeScalars
  }
  if value <= 0x315E {
    return "ᅰ".unicodeScalars
  }
  if value <= 0x315F {
    return "ᅱ".unicodeScalars
  }
  if value <= 0x3160 {
    return "ᅲ".unicodeScalars
  }
  if value <= 0x3161 {
    return "ᅳ".unicodeScalars
  }
  if value <= 0x3162 {
    return "ᅴ".unicodeScalars
  }
  if value <= 0x3163 {
    return "ᅵ".unicodeScalars
  }
  if value <= 0x3164 {
    return "ᅠ".unicodeScalars
  }
  if value <= 0x3165 {
    return "ᄔ".unicodeScalars
  }
  if value <= 0x3166 {
    return "ᄕ".unicodeScalars
  }
  if value <= 0x3167 {
    return "ᇇ".unicodeScalars
  }
  if value <= 0x3168 {
    return "ᇈ".unicodeScalars
  }
  if value <= 0x3169 {
    return "ᇌ".unicodeScalars
  }
  if value <= 0x316A {
    return "ᇎ".unicodeScalars
  }
  if value <= 0x316B {
    return "ᇓ".unicodeScalars
  }
  if value <= 0x316C {
    return "ᇗ".unicodeScalars
  }
  if value <= 0x316D {
    return "ᇙ".unicodeScalars
  }
  if value <= 0x316E {
    return "ᄜ".unicodeScalars
  }
  if value <= 0x316F {
    return "ᇝ".unicodeScalars
  }
  if value <= 0x3170 {
    return "ᇟ".unicodeScalars
  }
  if value <= 0x3171 {
    return "ᄝ".unicodeScalars
  }
  if value <= 0x3172 {
    return "ᄞ".unicodeScalars
  }
  if value <= 0x3173 {
    return "ᄠ".unicodeScalars
  }
  if value <= 0x3174 {
    return "ᄢ".unicodeScalars
  }
  if value <= 0x3175 {
    return "ᄣ".unicodeScalars
  }
  if value <= 0x3176 {
    return "ᄧ".unicodeScalars
  }
  if value <= 0x3177 {
    return "ᄩ".unicodeScalars
  }
  if value <= 0x3178 {
    return "ᄫ".unicodeScalars
  }
  if value <= 0x3179 {
    return "ᄬ".unicodeScalars
  }
  if value <= 0x317A {
    return "ᄭ".unicodeScalars
  }
  if value <= 0x317B {
    return "ᄮ".unicodeScalars
  }
  if value <= 0x317C {
    return "ᄯ".unicodeScalars
  }
  if value <= 0x317D {
    return "ᄲ".unicodeScalars
  }
  if value <= 0x317E {
    return "ᄶ".unicodeScalars
  }
  if value <= 0x317F {
    return "ᅀ".unicodeScalars
  }
  if value <= 0x3180 {
    return "ᅇ".unicodeScalars
  }
  if value <= 0x3181 {
    return "ᅌ".unicodeScalars
  }
  if value <= 0x3182 {
    return "ᇱ".unicodeScalars
  }
  if value <= 0x3183 {
    return "ᇲ".unicodeScalars
  }
  if value <= 0x3184 {
    return "ᅗ".unicodeScalars
  }
  if value <= 0x3185 {
    return "ᅘ".unicodeScalars
  }
  if value <= 0x3186 {
    return "ᅙ".unicodeScalars
  }
  if value <= 0x3187 {
    return "ᆄ".unicodeScalars
  }
  if value <= 0x3188 {
    return "ᆅ".unicodeScalars
  }
  if value <= 0x3189 {
    return "ᆈ".unicodeScalars
  }
  if value <= 0x318A {
    return "ᆑ".unicodeScalars
  }
  if value <= 0x318B {
    return "ᆒ".unicodeScalars
  }
  if value <= 0x318C {
    return "ᆔ".unicodeScalars
  }
  if value <= 0x318D {
    return "ᆞ".unicodeScalars
  }
  if value <= 0x318E {
    return "ᆡ".unicodeScalars
  }
  if value <= 0x3191 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x3192 {
    return "一".unicodeScalars
  }
  if value <= 0x3193 {
    return "二".unicodeScalars
  }
  if value <= 0x3194 {
    return "三".unicodeScalars
  }
  if value <= 0x3195 {
    return "四".unicodeScalars
  }
  if value <= 0x3196 {
    return "上".unicodeScalars
  }
  if value <= 0x3197 {
    return "中".unicodeScalars
  }
  if value <= 0x3198 {
    return "下".unicodeScalars
  }
  if value <= 0x3199 {
    return "甲".unicodeScalars
  }
  if value <= 0x319A {
    return "乙".unicodeScalars
  }
  if value <= 0x319B {
    return "丙".unicodeScalars
  }
  if value <= 0x319C {
    return "丁".unicodeScalars
  }
  if value <= 0x319D {
    return "天".unicodeScalars
  }
  if value <= 0x319E {
    return "地".unicodeScalars
  }
  if value <= 0x319F {
    return "人".unicodeScalars
  }
  if value <= 0x31FF {
    return String(scalar).unicodeScalars
  }
  if value <= 0x3200 {
    return "(ᄀ)".unicodeScalars
  }
  if value <= 0x3201 {
    return "(ᄂ)".unicodeScalars
  }
  if value <= 0x3202 {
    return "(ᄃ)".unicodeScalars
  }
  if value <= 0x3203 {
    return "(ᄅ)".unicodeScalars
  }
  if value <= 0x3204 {
    return "(ᄆ)".unicodeScalars
  }
  if value <= 0x3205 {
    return "(ᄇ)".unicodeScalars
  }
  if value <= 0x3206 {
    return "(ᄉ)".unicodeScalars
  }
  if value <= 0x3207 {
    return "(ᄋ)".unicodeScalars
  }
  if value <= 0x3208 {
    return "(ᄌ)".unicodeScalars
  }
  if value <= 0x3209 {
    return "(ᄎ)".unicodeScalars
  }
  if value <= 0x320A {
    return "(ᄏ)".unicodeScalars
  }
  if value <= 0x320B {
    return "(ᄐ)".unicodeScalars
  }
  if value <= 0x320C {
    return "(ᄑ)".unicodeScalars
  }
  if value <= 0x320D {
    return "(ᄒ)".unicodeScalars
  }
  if value <= 0x320E {
    return "(가)".unicodeScalars
  }
  if value <= 0x320F {
    return "(나)".unicodeScalars
  }
  if value <= 0x3210 {
    return "(다)".unicodeScalars
  }
  if value <= 0x3211 {
    return "(라)".unicodeScalars
  }
  if value <= 0x3212 {
    return "(마)".unicodeScalars
  }
  if value <= 0x3213 {
    return "(바)".unicodeScalars
  }
  if value <= 0x3214 {
    return "(사)".unicodeScalars
  }
  if value <= 0x3215 {
    return "(아)".unicodeScalars
  }
  if value <= 0x3216 {
    return "(자)".unicodeScalars
  }
  if value <= 0x3217 {
    return "(차)".unicodeScalars
  }
  if value <= 0x3218 {
    return "(카)".unicodeScalars
  }
  if value <= 0x3219 {
    return "(타)".unicodeScalars
  }
  if value <= 0x321A {
    return "(파)".unicodeScalars
  }
  if value <= 0x321B {
    return "(하)".unicodeScalars
  }
  if value <= 0x321C {
    return "(주)".unicodeScalars
  }
  if value <= 0x321D {
    return "(오전)".unicodeScalars
  }
  if value <= 0x321E {
    return "(오후)".unicodeScalars
  }
  if value <= 0x321F {
    return String(scalar).unicodeScalars
  }
  if value <= 0x3220 {
    return "(一)".unicodeScalars
  }
  if value <= 0x3221 {
    return "(二)".unicodeScalars
  }
  if value <= 0x3222 {
    return "(三)".unicodeScalars
  }
  if value <= 0x3223 {
    return "(四)".unicodeScalars
  }
  if value <= 0x3224 {
    return "(五)".unicodeScalars
  }
  if value <= 0x3225 {
    return "(六)".unicodeScalars
  }
  if value <= 0x3226 {
    return "(七)".unicodeScalars
  }
  if value <= 0x3227 {
    return "(八)".unicodeScalars
  }
  if value <= 0x3228 {
    return "(九)".unicodeScalars
  }
  if value <= 0x3229 {
    return "(十)".unicodeScalars
  }
  if value <= 0x322A {
    return "(月)".unicodeScalars
  }
  if value <= 0x322B {
    return "(火)".unicodeScalars
  }
  if value <= 0x322C {
    return "(水)".unicodeScalars
  }
  if value <= 0x322D {
    return "(木)".unicodeScalars
  }
  if value <= 0x322E {
    return "(金)".unicodeScalars
  }
  if value <= 0x322F {
    return "(土)".unicodeScalars
  }
  if value <= 0x3230 {
    return "(日)".unicodeScalars
  }
  if value <= 0x3231 {
    return "(株)".unicodeScalars
  }
  if value <= 0x3232 {
    return "(有)".unicodeScalars
  }
  if value <= 0x3233 {
    return "(社)".unicodeScalars
  }
  if value <= 0x3234 {
    return "(名)".unicodeScalars
  }
  if value <= 0x3235 {
    return "(特)".unicodeScalars
  }
  if value <= 0x3236 {
    return "(財)".unicodeScalars
  }
  if value <= 0x3237 {
    return "(祝)".unicodeScalars
  }
  if value <= 0x3238 {
    return "(労)".unicodeScalars
  }
  if value <= 0x3239 {
    return "(代)".unicodeScalars
  }
  if value <= 0x323A {
    return "(呼)".unicodeScalars
  }
  if value <= 0x323B {
    return "(学)".unicodeScalars
  }
  if value <= 0x323C {
    return "(監)".unicodeScalars
  }
  if value <= 0x323D {
    return "(企)".unicodeScalars
  }
  if value <= 0x323E {
    return "(資)".unicodeScalars
  }
  if value <= 0x323F {
    return "(協)".unicodeScalars
  }
  if value <= 0x3240 {
    return "(祭)".unicodeScalars
  }
  if value <= 0x3241 {
    return "(休)".unicodeScalars
  }
  if value <= 0x3242 {
    return "(自)".unicodeScalars
  }
  if value <= 0x3243 {
    return "(至)".unicodeScalars
  }
  if value <= 0x3244 {
    return "問".unicodeScalars
  }
  if value <= 0x3245 {
    return "幼".unicodeScalars
  }
  if value <= 0x3246 {
    return "文".unicodeScalars
  }
  if value <= 0x3247 {
    return "箏".unicodeScalars
  }
  if value <= 0x324F {
    return String(scalar).unicodeScalars
  }
  if value <= 0x3250 {
    return "PTE".unicodeScalars
  }
  if value <= 0x3251 {
    return "21".unicodeScalars
  }
  if value <= 0x3252 {
    return "22".unicodeScalars
  }
  if value <= 0x3253 {
    return "23".unicodeScalars
  }
  if value <= 0x3254 {
    return "24".unicodeScalars
  }
  if value <= 0x3255 {
    return "25".unicodeScalars
  }
  if value <= 0x3256 {
    return "26".unicodeScalars
  }
  if value <= 0x3257 {
    return "27".unicodeScalars
  }
  if value <= 0x3258 {
    return "28".unicodeScalars
  }
  if value <= 0x3259 {
    return "29".unicodeScalars
  }
  if value <= 0x325A {
    return "30".unicodeScalars
  }
  if value <= 0x325B {
    return "31".unicodeScalars
  }
  if value <= 0x325C {
    return "32".unicodeScalars
  }
  if value <= 0x325D {
    return "33".unicodeScalars
  }
  if value <= 0x325E {
    return "34".unicodeScalars
  }
  if value <= 0x325F {
    return "35".unicodeScalars
  }
  if value <= 0x3260 {
    return "ᄀ".unicodeScalars
  }
  if value <= 0x3261 {
    return "ᄂ".unicodeScalars
  }
  if value <= 0x3262 {
    return "ᄃ".unicodeScalars
  }
  if value <= 0x3263 {
    return "ᄅ".unicodeScalars
  }
  if value <= 0x3264 {
    return "ᄆ".unicodeScalars
  }
  if value <= 0x3265 {
    return "ᄇ".unicodeScalars
  }
  if value <= 0x3266 {
    return "ᄉ".unicodeScalars
  }
  if value <= 0x3267 {
    return "ᄋ".unicodeScalars
  }
  if value <= 0x3268 {
    return "ᄌ".unicodeScalars
  }
  if value <= 0x3269 {
    return "ᄎ".unicodeScalars
  }
  if value <= 0x326A {
    return "ᄏ".unicodeScalars
  }
  if value <= 0x326B {
    return "ᄐ".unicodeScalars
  }
  if value <= 0x326C {
    return "ᄑ".unicodeScalars
  }
  if value <= 0x326D {
    return "ᄒ".unicodeScalars
  }
  if value <= 0x326E {
    return "가".unicodeScalars
  }
  if value <= 0x326F {
    return "나".unicodeScalars
  }
  if value <= 0x3270 {
    return "다".unicodeScalars
  }
  if value <= 0x3271 {
    return "라".unicodeScalars
  }
  if value <= 0x3272 {
    return "마".unicodeScalars
  }
  if value <= 0x3273 {
    return "바".unicodeScalars
  }
  if value <= 0x3274 {
    return "사".unicodeScalars
  }
  if value <= 0x3275 {
    return "아".unicodeScalars
  }
  if value <= 0x3276 {
    return "자".unicodeScalars
  }
  if value <= 0x3277 {
    return "차".unicodeScalars
  }
  if value <= 0x3278 {
    return "카".unicodeScalars
  }
  if value <= 0x3279 {
    return "타".unicodeScalars
  }
  if value <= 0x327A {
    return "파".unicodeScalars
  }
  if value <= 0x327B {
    return "하".unicodeScalars
  }
  if value <= 0x327C {
    return "참고".unicodeScalars
  }
  if value <= 0x327D {
    return "주의".unicodeScalars
  }
  if value <= 0x327E {
    return "우".unicodeScalars
  }
  if value <= 0x327F {
    return String(scalar).unicodeScalars
  }
  if value <= 0x3280 {
    return "一".unicodeScalars
  }
  if value <= 0x3281 {
    return "二".unicodeScalars
  }
  if value <= 0x3282 {
    return "三".unicodeScalars
  }
  if value <= 0x3283 {
    return "四".unicodeScalars
  }
  if value <= 0x3284 {
    return "五".unicodeScalars
  }
  if value <= 0x3285 {
    return "六".unicodeScalars
  }
  if value <= 0x3286 {
    return "七".unicodeScalars
  }
  if value <= 0x3287 {
    return "八".unicodeScalars
  }
  if value <= 0x3288 {
    return "九".unicodeScalars
  }
  if value <= 0x3289 {
    return "十".unicodeScalars
  }
  if value <= 0x328A {
    return "月".unicodeScalars
  }
  if value <= 0x328B {
    return "火".unicodeScalars
  }
  if value <= 0x328C {
    return "水".unicodeScalars
  }
  if value <= 0x328D {
    return "木".unicodeScalars
  }
  if value <= 0x328E {
    return "金".unicodeScalars
  }
  if value <= 0x328F {
    return "土".unicodeScalars
  }
  if value <= 0x3290 {
    return "日".unicodeScalars
  }
  if value <= 0x3291 {
    return "株".unicodeScalars
  }
  if value <= 0x3292 {
    return "有".unicodeScalars
  }
  if value <= 0x3293 {
    return "社".unicodeScalars
  }
  if value <= 0x3294 {
    return "名".unicodeScalars
  }
  if value <= 0x3295 {
    return "特".unicodeScalars
  }
  if value <= 0x3296 {
    return "財".unicodeScalars
  }
  if value <= 0x3297 {
    return "祝".unicodeScalars
  }
  if value <= 0x3298 {
    return "労".unicodeScalars
  }
  if value <= 0x3299 {
    return "秘".unicodeScalars
  }
  if value <= 0x329A {
    return "男".unicodeScalars
  }
  if value <= 0x329B {
    return "女".unicodeScalars
  }
  if value <= 0x329C {
    return "適".unicodeScalars
  }
  if value <= 0x329D {
    return "優".unicodeScalars
  }
  if value <= 0x329E {
    return "印".unicodeScalars
  }
  if value <= 0x329F {
    return "注".unicodeScalars
  }
  if value <= 0x32A0 {
    return "項".unicodeScalars
  }
  if value <= 0x32A1 {
    return "休".unicodeScalars
  }
  if value <= 0x32A2 {
    return "写".unicodeScalars
  }
  if value <= 0x32A3 {
    return "正".unicodeScalars
  }
  if value <= 0x32A4 {
    return "上".unicodeScalars
  }
  if value <= 0x32A5 {
    return "中".unicodeScalars
  }
  if value <= 0x32A6 {
    return "下".unicodeScalars
  }
  if value <= 0x32A7 {
    return "左".unicodeScalars
  }
  if value <= 0x32A8 {
    return "右".unicodeScalars
  }
  if value <= 0x32A9 {
    return "医".unicodeScalars
  }
  if value <= 0x32AA {
    return "宗".unicodeScalars
  }
  if value <= 0x32AB {
    return "学".unicodeScalars
  }
  if value <= 0x32AC {
    return "監".unicodeScalars
  }
  if value <= 0x32AD {
    return "企".unicodeScalars
  }
  if value <= 0x32AE {
    return "資".unicodeScalars
  }
  if value <= 0x32AF {
    return "協".unicodeScalars
  }
  if value <= 0x32B0 {
    return "夜".unicodeScalars
  }
  if value <= 0x32B1 {
    return "36".unicodeScalars
  }
  if value <= 0x32B2 {
    return "37".unicodeScalars
  }
  if value <= 0x32B3 {
    return "38".unicodeScalars
  }
  if value <= 0x32B4 {
    return "39".unicodeScalars
  }
  if value <= 0x32B5 {
    return "40".unicodeScalars
  }
  if value <= 0x32B6 {
    return "41".unicodeScalars
  }
  if value <= 0x32B7 {
    return "42".unicodeScalars
  }
  if value <= 0x32B8 {
    return "43".unicodeScalars
  }
  if value <= 0x32B9 {
    return "44".unicodeScalars
  }
  if value <= 0x32BA {
    return "45".unicodeScalars
  }
  if value <= 0x32BB {
    return "46".unicodeScalars
  }
  if value <= 0x32BC {
    return "47".unicodeScalars
  }
  if value <= 0x32BD {
    return "48".unicodeScalars
  }
  if value <= 0x32BE {
    return "49".unicodeScalars
  }
  if value <= 0x32BF {
    return "50".unicodeScalars
  }
  if value <= 0x32C0 {
    return "1月".unicodeScalars
  }
  if value <= 0x32C1 {
    return "2月".unicodeScalars
  }
  if value <= 0x32C2 {
    return "3月".unicodeScalars
  }
  if value <= 0x32C3 {
    return "4月".unicodeScalars
  }
  if value <= 0x32C4 {
    return "5月".unicodeScalars
  }
  if value <= 0x32C5 {
    return "6月".unicodeScalars
  }
  if value <= 0x32C6 {
    return "7月".unicodeScalars
  }
  if value <= 0x32C7 {
    return "8月".unicodeScalars
  }
  if value <= 0x32C8 {
    return "9月".unicodeScalars
  }
  if value <= 0x32C9 {
    return "10月".unicodeScalars
  }
  if value <= 0x32CA {
    return "11月".unicodeScalars
  }
  if value <= 0x32CB {
    return "12月".unicodeScalars
  }
  if value <= 0x32CC {
    return "Hg".unicodeScalars
  }
  if value <= 0x32CD {
    return "erg".unicodeScalars
  }
  if value <= 0x32CE {
    return "eV".unicodeScalars
  }
  if value <= 0x32CF {
    return "LTD".unicodeScalars
  }
  if value <= 0x32D0 {
    return "ア".unicodeScalars
  }
  if value <= 0x32D1 {
    return "イ".unicodeScalars
  }
  if value <= 0x32D2 {
    return "ウ".unicodeScalars
  }
  if value <= 0x32D3 {
    return "エ".unicodeScalars
  }
  if value <= 0x32D4 {
    return "オ".unicodeScalars
  }
  if value <= 0x32D5 {
    return "カ".unicodeScalars
  }
  if value <= 0x32D6 {
    return "キ".unicodeScalars
  }
  if value <= 0x32D7 {
    return "ク".unicodeScalars
  }
  if value <= 0x32D8 {
    return "ケ".unicodeScalars
  }
  if value <= 0x32D9 {
    return "コ".unicodeScalars
  }
  if value <= 0x32DA {
    return "サ".unicodeScalars
  }
  if value <= 0x32DB {
    return "シ".unicodeScalars
  }
  if value <= 0x32DC {
    return "ス".unicodeScalars
  }
  if value <= 0x32DD {
    return "セ".unicodeScalars
  }
  if value <= 0x32DE {
    return "ソ".unicodeScalars
  }
  if value <= 0x32DF {
    return "タ".unicodeScalars
  }
  if value <= 0x32E0 {
    return "チ".unicodeScalars
  }
  if value <= 0x32E1 {
    return "ツ".unicodeScalars
  }
  if value <= 0x32E2 {
    return "テ".unicodeScalars
  }
  if value <= 0x32E3 {
    return "ト".unicodeScalars
  }
  if value <= 0x32E4 {
    return "ナ".unicodeScalars
  }
  if value <= 0x32E5 {
    return "ニ".unicodeScalars
  }
  if value <= 0x32E6 {
    return "ヌ".unicodeScalars
  }
  if value <= 0x32E7 {
    return "ネ".unicodeScalars
  }
  if value <= 0x32E8 {
    return "ノ".unicodeScalars
  }
  if value <= 0x32E9 {
    return "ハ".unicodeScalars
  }
  if value <= 0x32EA {
    return "ヒ".unicodeScalars
  }
  if value <= 0x32EB {
    return "フ".unicodeScalars
  }
  if value <= 0x32EC {
    return "ヘ".unicodeScalars
  }
  if value <= 0x32ED {
    return "ホ".unicodeScalars
  }
  if value <= 0x32EE {
    return "マ".unicodeScalars
  }
  if value <= 0x32EF {
    return "ミ".unicodeScalars
  }
  if value <= 0x32F0 {
    return "ム".unicodeScalars
  }
  if value <= 0x32F1 {
    return "メ".unicodeScalars
  }
  if value <= 0x32F2 {
    return "モ".unicodeScalars
  }
  if value <= 0x32F3 {
    return "ヤ".unicodeScalars
  }
  if value <= 0x32F4 {
    return "ユ".unicodeScalars
  }
  if value <= 0x32F5 {
    return "ヨ".unicodeScalars
  }
  if value <= 0x32F6 {
    return "ラ".unicodeScalars
  }
  if value <= 0x32F7 {
    return "リ".unicodeScalars
  }
  if value <= 0x32F8 {
    return "ル".unicodeScalars
  }
  if value <= 0x32F9 {
    return "レ".unicodeScalars
  }
  if value <= 0x32FA {
    return "ロ".unicodeScalars
  }
  if value <= 0x32FB {
    return "ワ".unicodeScalars
  }
  if value <= 0x32FC {
    return "ヰ".unicodeScalars
  }
  if value <= 0x32FD {
    return "ヱ".unicodeScalars
  }
  if value <= 0x32FE {
    return "ヲ".unicodeScalars
  }
  if value <= 0x32FF {
    return "令和".unicodeScalars
  }
  if value <= 0x3300 {
    return "アハ\u{309A}ート".unicodeScalars
  }
  if value <= 0x3301 {
    return "アルファ".unicodeScalars
  }
  if value <= 0x3302 {
    return "アンヘ\u{309A}ア".unicodeScalars
  }
  if value <= 0x3303 {
    return "アール".unicodeScalars
  }
  if value <= 0x3304 {
    return "イニンク\u{3099}".unicodeScalars
  }
  if value <= 0x3305 {
    return "インチ".unicodeScalars
  }
  if value <= 0x3306 {
    return "ウォン".unicodeScalars
  }
  if value <= 0x3307 {
    return "エスクート\u{3099}".unicodeScalars
  }
  if value <= 0x3308 {
    return "エーカー".unicodeScalars
  }
  if value <= 0x3309 {
    return "オンス".unicodeScalars
  }
  if value <= 0x330A {
    return "オーム".unicodeScalars
  }
  if value <= 0x330B {
    return "カイリ".unicodeScalars
  }
  if value <= 0x330C {
    return "カラット".unicodeScalars
  }
  if value <= 0x330D {
    return "カロリー".unicodeScalars
  }
  if value <= 0x330E {
    return "カ\u{3099}ロン".unicodeScalars
  }
  if value <= 0x330F {
    return "カ\u{3099}ンマ".unicodeScalars
  }
  if value <= 0x3310 {
    return "キ\u{3099}カ\u{3099}".unicodeScalars
  }
  if value <= 0x3311 {
    return "キ\u{3099}ニー".unicodeScalars
  }
  if value <= 0x3312 {
    return "キュリー".unicodeScalars
  }
  if value <= 0x3313 {
    return "キ\u{3099}ルタ\u{3099}ー".unicodeScalars
  }
  if value <= 0x3314 {
    return "キロ".unicodeScalars
  }
  if value <= 0x3315 {
    return "キロク\u{3099}ラム".unicodeScalars
  }
  if value <= 0x3316 {
    return "キロメートル".unicodeScalars
  }
  if value <= 0x3317 {
    return "キロワット".unicodeScalars
  }
  if value <= 0x3318 {
    return "ク\u{3099}ラム".unicodeScalars
  }
  if value <= 0x3319 {
    return "ク\u{3099}ラムトン".unicodeScalars
  }
  if value <= 0x331A {
    return "クルセ\u{3099}イロ".unicodeScalars
  }
  if value <= 0x331B {
    return "クローネ".unicodeScalars
  }
  if value <= 0x331C {
    return "ケース".unicodeScalars
  }
  if value <= 0x331D {
    return "コルナ".unicodeScalars
  }
  if value <= 0x331E {
    return "コーホ\u{309A}".unicodeScalars
  }
  if value <= 0x331F {
    return "サイクル".unicodeScalars
  }
  if value <= 0x3320 {
    return "サンチーム".unicodeScalars
  }
  if value <= 0x3321 {
    return "シリンク\u{3099}".unicodeScalars
  }
  if value <= 0x3322 {
    return "センチ".unicodeScalars
  }
  if value <= 0x3323 {
    return "セント".unicodeScalars
  }
  if value <= 0x3324 {
    return "タ\u{3099}ース".unicodeScalars
  }
  if value <= 0x3325 {
    return "テ\u{3099}シ".unicodeScalars
  }
  if value <= 0x3326 {
    return "ト\u{3099}ル".unicodeScalars
  }
  if value <= 0x3327 {
    return "トン".unicodeScalars
  }
  if value <= 0x3328 {
    return "ナノ".unicodeScalars
  }
  if value <= 0x3329 {
    return "ノット".unicodeScalars
  }
  if value <= 0x332A {
    return "ハイツ".unicodeScalars
  }
  if value <= 0x332B {
    return "ハ\u{309A}ーセント".unicodeScalars
  }
  if value <= 0x332C {
    return "ハ\u{309A}ーツ".unicodeScalars
  }
  if value <= 0x332D {
    return "ハ\u{3099}ーレル".unicodeScalars
  }
  if value <= 0x332E {
    return "ヒ\u{309A}アストル".unicodeScalars
  }
  if value <= 0x332F {
    return "ヒ\u{309A}クル".unicodeScalars
  }
  if value <= 0x3330 {
    return "ヒ\u{309A}コ".unicodeScalars
  }
  if value <= 0x3331 {
    return "ヒ\u{3099}ル".unicodeScalars
  }
  if value <= 0x3332 {
    return "ファラット\u{3099}".unicodeScalars
  }
  if value <= 0x3333 {
    return "フィート".unicodeScalars
  }
  if value <= 0x3334 {
    return "フ\u{3099}ッシェル".unicodeScalars
  }
  if value <= 0x3335 {
    return "フラン".unicodeScalars
  }
  if value <= 0x3336 {
    return "ヘクタール".unicodeScalars
  }
  if value <= 0x3337 {
    return "ヘ\u{309A}ソ".unicodeScalars
  }
  if value <= 0x3338 {
    return "ヘ\u{309A}ニヒ".unicodeScalars
  }
  if value <= 0x3339 {
    return "ヘルツ".unicodeScalars
  }
  if value <= 0x333A {
    return "ヘ\u{309A}ンス".unicodeScalars
  }
  if value <= 0x333B {
    return "ヘ\u{309A}ーシ\u{3099}".unicodeScalars
  }
  if value <= 0x333C {
    return "ヘ\u{3099}ータ".unicodeScalars
  }
  if value <= 0x333D {
    return "ホ\u{309A}イント".unicodeScalars
  }
  if value <= 0x333E {
    return "ホ\u{3099}ルト".unicodeScalars
  }
  if value <= 0x333F {
    return "ホン".unicodeScalars
  }
  if value <= 0x3340 {
    return "ホ\u{309A}ント\u{3099}".unicodeScalars
  }
  if value <= 0x3341 {
    return "ホール".unicodeScalars
  }
  if value <= 0x3342 {
    return "ホーン".unicodeScalars
  }
  if value <= 0x3343 {
    return "マイクロ".unicodeScalars
  }
  if value <= 0x3344 {
    return "マイル".unicodeScalars
  }
  if value <= 0x3345 {
    return "マッハ".unicodeScalars
  }
  if value <= 0x3346 {
    return "マルク".unicodeScalars
  }
  if value <= 0x3347 {
    return "マンション".unicodeScalars
  }
  if value <= 0x3348 {
    return "ミクロン".unicodeScalars
  }
  if value <= 0x3349 {
    return "ミリ".unicodeScalars
  }
  if value <= 0x334A {
    return "ミリハ\u{3099}ール".unicodeScalars
  }
  if value <= 0x334B {
    return "メカ\u{3099}".unicodeScalars
  }
  if value <= 0x334C {
    return "メカ\u{3099}トン".unicodeScalars
  }
  if value <= 0x334D {
    return "メートル".unicodeScalars
  }
  if value <= 0x334E {
    return "ヤート\u{3099}".unicodeScalars
  }
  if value <= 0x334F {
    return "ヤール".unicodeScalars
  }
  if value <= 0x3350 {
    return "ユアン".unicodeScalars
  }
  if value <= 0x3351 {
    return "リットル".unicodeScalars
  }
  if value <= 0x3352 {
    return "リラ".unicodeScalars
  }
  if value <= 0x3353 {
    return "ルヒ\u{309A}ー".unicodeScalars
  }
  if value <= 0x3354 {
    return "ルーフ\u{3099}ル".unicodeScalars
  }
  if value <= 0x3355 {
    return "レム".unicodeScalars
  }
  if value <= 0x3356 {
    return "レントケ\u{3099}ン".unicodeScalars
  }
  if value <= 0x3357 {
    return "ワット".unicodeScalars
  }
  if value <= 0x3358 {
    return "0点".unicodeScalars
  }
  if value <= 0x3359 {
    return "1点".unicodeScalars
  }
  if value <= 0x335A {
    return "2点".unicodeScalars
  }
  if value <= 0x335B {
    return "3点".unicodeScalars
  }
  if value <= 0x335C {
    return "4点".unicodeScalars
  }
  if value <= 0x335D {
    return "5点".unicodeScalars
  }
  if value <= 0x335E {
    return "6点".unicodeScalars
  }
  if value <= 0x335F {
    return "7点".unicodeScalars
  }
  if value <= 0x3360 {
    return "8点".unicodeScalars
  }
  if value <= 0x3361 {
    return "9点".unicodeScalars
  }
  if value <= 0x3362 {
    return "10点".unicodeScalars
  }
  if value <= 0x3363 {
    return "11点".unicodeScalars
  }
  if value <= 0x3364 {
    return "12点".unicodeScalars
  }
  if value <= 0x3365 {
    return "13点".unicodeScalars
  }
  if value <= 0x3366 {
    return "14点".unicodeScalars
  }
  if value <= 0x3367 {
    return "15点".unicodeScalars
  }
  if value <= 0x3368 {
    return "16点".unicodeScalars
  }
  if value <= 0x3369 {
    return "17点".unicodeScalars
  }
  if value <= 0x336A {
    return "18点".unicodeScalars
  }
  if value <= 0x336B {
    return "19点".unicodeScalars
  }
  if value <= 0x336C {
    return "20点".unicodeScalars
  }
  if value <= 0x336D {
    return "21点".unicodeScalars
  }
  if value <= 0x336E {
    return "22点".unicodeScalars
  }
  if value <= 0x336F {
    return "23点".unicodeScalars
  }
  if value <= 0x3370 {
    return "24点".unicodeScalars
  }
  if value <= 0x3371 {
    return "hPa".unicodeScalars
  }
  if value <= 0x3372 {
    return "da".unicodeScalars
  }
  if value <= 0x3373 {
    return "AU".unicodeScalars
  }
  if value <= 0x3374 {
    return "bar".unicodeScalars
  }
  if value <= 0x3375 {
    return "oV".unicodeScalars
  }
  if value <= 0x3376 {
    return "pc".unicodeScalars
  }
  if value <= 0x3377 {
    return "dm".unicodeScalars
  }
  if value <= 0x3378 {
    return "dm2".unicodeScalars
  }
  if value <= 0x3379 {
    return "dm3".unicodeScalars
  }
  if value <= 0x337A {
    return "IU".unicodeScalars
  }
  if value <= 0x337B {
    return "平成".unicodeScalars
  }
  if value <= 0x337C {
    return "昭和".unicodeScalars
  }
  if value <= 0x337D {
    return "大正".unicodeScalars
  }
  if value <= 0x337E {
    return "明治".unicodeScalars
  }
  if value <= 0x337F {
    return "株式会社".unicodeScalars
  }
  if value <= 0x3380 {
    return "pA".unicodeScalars
  }
  if value <= 0x3381 {
    return "nA".unicodeScalars
  }
  if value <= 0x3382 {
    return "μA".unicodeScalars
  }
  if value <= 0x3383 {
    return "mA".unicodeScalars
  }
  if value <= 0x3384 {
    return "kA".unicodeScalars
  }
  if value <= 0x3385 {
    return "KB".unicodeScalars
  }
  if value <= 0x3386 {
    return "MB".unicodeScalars
  }
  if value <= 0x3387 {
    return "GB".unicodeScalars
  }
  if value <= 0x3388 {
    return "cal".unicodeScalars
  }
  if value <= 0x3389 {
    return "kcal".unicodeScalars
  }
  if value <= 0x338A {
    return "pF".unicodeScalars
  }
  if value <= 0x338B {
    return "nF".unicodeScalars
  }
  if value <= 0x338C {
    return "μF".unicodeScalars
  }
  if value <= 0x338D {
    return "μg".unicodeScalars
  }
  if value <= 0x338E {
    return "mg".unicodeScalars
  }
  if value <= 0x338F {
    return "kg".unicodeScalars
  }
  if value <= 0x3390 {
    return "Hz".unicodeScalars
  }
  if value <= 0x3391 {
    return "kHz".unicodeScalars
  }
  if value <= 0x3392 {
    return "MHz".unicodeScalars
  }
  if value <= 0x3393 {
    return "GHz".unicodeScalars
  }
  if value <= 0x3394 {
    return "THz".unicodeScalars
  }
  if value <= 0x3395 {
    return "μl".unicodeScalars
  }
  if value <= 0x3396 {
    return "ml".unicodeScalars
  }
  if value <= 0x3397 {
    return "dl".unicodeScalars
  }
  if value <= 0x3398 {
    return "kl".unicodeScalars
  }
  if value <= 0x3399 {
    return "fm".unicodeScalars
  }
  if value <= 0x339A {
    return "nm".unicodeScalars
  }
  if value <= 0x339B {
    return "μm".unicodeScalars
  }
  if value <= 0x339C {
    return "mm".unicodeScalars
  }
  if value <= 0x339D {
    return "cm".unicodeScalars
  }
  if value <= 0x339E {
    return "km".unicodeScalars
  }
  if value <= 0x339F {
    return "mm2".unicodeScalars
  }
  if value <= 0x33A0 {
    return "cm2".unicodeScalars
  }
  if value <= 0x33A1 {
    return "m2".unicodeScalars
  }
  if value <= 0x33A2 {
    return "km2".unicodeScalars
  }
  if value <= 0x33A3 {
    return "mm3".unicodeScalars
  }
  if value <= 0x33A4 {
    return "cm3".unicodeScalars
  }
  if value <= 0x33A5 {
    return "m3".unicodeScalars
  }
  if value <= 0x33A6 {
    return "km3".unicodeScalars
  }
  if value <= 0x33A7 {
    return "m∕s".unicodeScalars
  }
  if value <= 0x33A8 {
    return "m∕s2".unicodeScalars
  }
  if value <= 0x33A9 {
    return "Pa".unicodeScalars
  }
  if value <= 0x33AA {
    return "kPa".unicodeScalars
  }
  if value <= 0x33AB {
    return "MPa".unicodeScalars
  }
  if value <= 0x33AC {
    return "GPa".unicodeScalars
  }
  if value <= 0x33AD {
    return "rad".unicodeScalars
  }
  if value <= 0x33AE {
    return "rad∕s".unicodeScalars
  }
  if value <= 0x33AF {
    return "rad∕s2".unicodeScalars
  }
  if value <= 0x33B0 {
    return "ps".unicodeScalars
  }
  if value <= 0x33B1 {
    return "ns".unicodeScalars
  }
  if value <= 0x33B2 {
    return "μs".unicodeScalars
  }
  if value <= 0x33B3 {
    return "ms".unicodeScalars
  }
  if value <= 0x33B4 {
    return "pV".unicodeScalars
  }
  if value <= 0x33B5 {
    return "nV".unicodeScalars
  }
  if value <= 0x33B6 {
    return "μV".unicodeScalars
  }
  if value <= 0x33B7 {
    return "mV".unicodeScalars
  }
  if value <= 0x33B8 {
    return "kV".unicodeScalars
  }
  if value <= 0x33B9 {
    return "MV".unicodeScalars
  }
  if value <= 0x33BA {
    return "pW".unicodeScalars
  }
  if value <= 0x33BB {
    return "nW".unicodeScalars
  }
  if value <= 0x33BC {
    return "μW".unicodeScalars
  }
  if value <= 0x33BD {
    return "mW".unicodeScalars
  }
  if value <= 0x33BE {
    return "kW".unicodeScalars
  }
  if value <= 0x33BF {
    return "MW".unicodeScalars
  }
  if value <= 0x33C0 {
    return "kΩ".unicodeScalars
  }
  if value <= 0x33C1 {
    return "MΩ".unicodeScalars
  }
  if value <= 0x33C2 {
    return "a.m.".unicodeScalars
  }
  if value <= 0x33C3 {
    return "Bq".unicodeScalars
  }
  if value <= 0x33C4 {
    return "cc".unicodeScalars
  }
  if value <= 0x33C5 {
    return "cd".unicodeScalars
  }
  if value <= 0x33C6 {
    return "C∕kg".unicodeScalars
  }
  if value <= 0x33C7 {
    return "Co.".unicodeScalars
  }
  if value <= 0x33C8 {
    return "dB".unicodeScalars
  }
  if value <= 0x33C9 {
    return "Gy".unicodeScalars
  }
  if value <= 0x33CA {
    return "ha".unicodeScalars
  }
  if value <= 0x33CB {
    return "HP".unicodeScalars
  }
  if value <= 0x33CC {
    return "in".unicodeScalars
  }
  if value <= 0x33CD {
    return "KK".unicodeScalars
  }
  if value <= 0x33CE {
    return "KM".unicodeScalars
  }
  if value <= 0x33CF {
    return "kt".unicodeScalars
  }
  if value <= 0x33D0 {
    return "lm".unicodeScalars
  }
  if value <= 0x33D1 {
    return "ln".unicodeScalars
  }
  if value <= 0x33D2 {
    return "log".unicodeScalars
  }
  if value <= 0x33D3 {
    return "lx".unicodeScalars
  }
  if value <= 0x33D4 {
    return "mb".unicodeScalars
  }
  if value <= 0x33D5 {
    return "mil".unicodeScalars
  }
  if value <= 0x33D6 {
    return "mol".unicodeScalars
  }
  if value <= 0x33D7 {
    return "PH".unicodeScalars
  }
  if value <= 0x33D8 {
    return "p.m.".unicodeScalars
  }
  if value <= 0x33D9 {
    return "PPM".unicodeScalars
  }
  if value <= 0x33DA {
    return "PR".unicodeScalars
  }
  if value <= 0x33DB {
    return "sr".unicodeScalars
  }
  if value <= 0x33DC {
    return "Sv".unicodeScalars
  }
  if value <= 0x33DD {
    return "Wb".unicodeScalars
  }
  if value <= 0x33DE {
    return "V∕m".unicodeScalars
  }
  if value <= 0x33DF {
    return "A∕m".unicodeScalars
  }
  if value <= 0x33E0 {
    return "1日".unicodeScalars
  }
  if value <= 0x33E1 {
    return "2日".unicodeScalars
  }
  if value <= 0x33E2 {
    return "3日".unicodeScalars
  }
  if value <= 0x33E3 {
    return "4日".unicodeScalars
  }
  if value <= 0x33E4 {
    return "5日".unicodeScalars
  }
  if value <= 0x33E5 {
    return "6日".unicodeScalars
  }
  if value <= 0x33E6 {
    return "7日".unicodeScalars
  }
  if value <= 0x33E7 {
    return "8日".unicodeScalars
  }
  if value <= 0x33E8 {
    return "9日".unicodeScalars
  }
  if value <= 0x33E9 {
    return "10日".unicodeScalars
  }
  if value <= 0x33EA {
    return "11日".unicodeScalars
  }
  if value <= 0x33EB {
    return "12日".unicodeScalars
  }
  if value <= 0x33EC {
    return "13日".unicodeScalars
  }
  if value <= 0x33ED {
    return "14日".unicodeScalars
  }
  if value <= 0x33EE {
    return "15日".unicodeScalars
  }
  if value <= 0x33EF {
    return "16日".unicodeScalars
  }
  if value <= 0x33F0 {
    return "17日".unicodeScalars
  }
  if value <= 0x33F1 {
    return "18日".unicodeScalars
  }
  if value <= 0x33F2 {
    return "19日".unicodeScalars
  }
  if value <= 0x33F3 {
    return "20日".unicodeScalars
  }
  if value <= 0x33F4 {
    return "21日".unicodeScalars
  }
  if value <= 0x33F5 {
    return "22日".unicodeScalars
  }
  if value <= 0x33F6 {
    return "23日".unicodeScalars
  }
  if value <= 0x33F7 {
    return "24日".unicodeScalars
  }
  if value <= 0x33F8 {
    return "25日".unicodeScalars
  }
  if value <= 0x33F9 {
    return "26日".unicodeScalars
  }
  if value <= 0x33FA {
    return "27日".unicodeScalars
  }
  if value <= 0x33FB {
    return "28日".unicodeScalars
  }
  if value <= 0x33FC {
    return "29日".unicodeScalars
  }
  if value <= 0x33FD {
    return "30日".unicodeScalars
  }
  if value <= 0x33FE {
    return "31日".unicodeScalars
  }
  if value <= 0x33FF {
    return "gal".unicodeScalars
  }
  if value <= 0xA69B {
    return String(scalar).unicodeScalars
  }
  if value <= 0xA69C {
    return "ъ".unicodeScalars
  }
  if value <= 0xA69D {
    return "ь".unicodeScalars
  }
  if value <= 0xA76F {
    return String(scalar).unicodeScalars
  }
  if value <= 0xA770 {
    return "ꝯ".unicodeScalars
  }
  if value <= 0xA7F0 {
    return String(scalar).unicodeScalars
  }
  if value <= 0xA7F1 {
    return "S".unicodeScalars
  }
  if value <= 0xA7F2 {
    return "C".unicodeScalars
  }
  if value <= 0xA7F3 {
    return "F".unicodeScalars
  }
  if value <= 0xA7F4 {
    return "Q".unicodeScalars
  }
  if value <= 0xA7F7 {
    return String(scalar).unicodeScalars
  }
  if value <= 0xA7F8 {
    return "Ħ".unicodeScalars
  }
  if value <= 0xA7F9 {
    return "œ".unicodeScalars
  }
  if value <= 0xAB5B {
    return String(scalar).unicodeScalars
  }
  if value <= 0xAB5C {
    return "ꜧ".unicodeScalars
  }
  if value <= 0xAB5D {
    return "ꬷ".unicodeScalars
  }
  if value <= 0xAB5E {
    return "ɫ".unicodeScalars
  }
  if value <= 0xAB5F {
    return "ꭒ".unicodeScalars
  }
  if value <= 0xAB68 {
    return String(scalar).unicodeScalars
  }
  if value <= 0xAB69 {
    return "ʍ".unicodeScalars
  }
  if value <= 0xABFF {
    return String(scalar).unicodeScalars
  }
  if value <= 0xD7A3 {
    return _0028_0029의_0020자모_003AUnicode_0020scalar_0020numerical_0020value_003AUnicode_0020scalars(value)
  }
  if value <= 0xF8FF {
    return String(scalar).unicodeScalars
  }
  if value <= 0xF900 {
    return "豈".unicodeScalars
  }
  if value <= 0xF901 {
    return "更".unicodeScalars
  }
  if value <= 0xF902 {
    return "車".unicodeScalars
  }
  if value <= 0xF903 {
    return "賈".unicodeScalars
  }
  if value <= 0xF904 {
    return "滑".unicodeScalars
  }
  if value <= 0xF905 {
    return "串".unicodeScalars
  }
  if value <= 0xF906 {
    return "句".unicodeScalars
  }
  if value <= 0xF908 {
    return "龜".unicodeScalars
  }
  if value <= 0xF909 {
    return "契".unicodeScalars
  }
  if value <= 0xF90A {
    return "金".unicodeScalars
  }
  if value <= 0xF90B {
    return "喇".unicodeScalars
  }
  if value <= 0xF90C {
    return "奈".unicodeScalars
  }
  if value <= 0xF90D {
    return "懶".unicodeScalars
  }
  if value <= 0xF90E {
    return "癩".unicodeScalars
  }
  if value <= 0xF90F {
    return "羅".unicodeScalars
  }
  if value <= 0xF910 {
    return "蘿".unicodeScalars
  }
  if value <= 0xF911 {
    return "螺".unicodeScalars
  }
  if value <= 0xF912 {
    return "裸".unicodeScalars
  }
  if value <= 0xF913 {
    return "邏".unicodeScalars
  }
  if value <= 0xF914 {
    return "樂".unicodeScalars
  }
  if value <= 0xF915 {
    return "洛".unicodeScalars
  }
  if value <= 0xF916 {
    return "烙".unicodeScalars
  }
  if value <= 0xF917 {
    return "珞".unicodeScalars
  }
  if value <= 0xF918 {
    return "落".unicodeScalars
  }
  if value <= 0xF919 {
    return "酪".unicodeScalars
  }
  if value <= 0xF91A {
    return "駱".unicodeScalars
  }
  if value <= 0xF91B {
    return "亂".unicodeScalars
  }
  if value <= 0xF91C {
    return "卵".unicodeScalars
  }
  if value <= 0xF91D {
    return "欄".unicodeScalars
  }
  if value <= 0xF91E {
    return "爛".unicodeScalars
  }
  if value <= 0xF91F {
    return "蘭".unicodeScalars
  }
  if value <= 0xF920 {
    return "鸞".unicodeScalars
  }
  if value <= 0xF921 {
    return "嵐".unicodeScalars
  }
  if value <= 0xF922 {
    return "濫".unicodeScalars
  }
  if value <= 0xF923 {
    return "藍".unicodeScalars
  }
  if value <= 0xF924 {
    return "襤".unicodeScalars
  }
  if value <= 0xF925 {
    return "拉".unicodeScalars
  }
  if value <= 0xF926 {
    return "臘".unicodeScalars
  }
  if value <= 0xF927 {
    return "蠟".unicodeScalars
  }
  if value <= 0xF928 {
    return "廊".unicodeScalars
  }
  if value <= 0xF929 {
    return "朗".unicodeScalars
  }
  if value <= 0xF92A {
    return "浪".unicodeScalars
  }
  if value <= 0xF92B {
    return "狼".unicodeScalars
  }
  if value <= 0xF92C {
    return "郎".unicodeScalars
  }
  if value <= 0xF92D {
    return "來".unicodeScalars
  }
  if value <= 0xF92E {
    return "冷".unicodeScalars
  }
  if value <= 0xF92F {
    return "勞".unicodeScalars
  }
  if value <= 0xF930 {
    return "擄".unicodeScalars
  }
  if value <= 0xF931 {
    return "櫓".unicodeScalars
  }
  if value <= 0xF932 {
    return "爐".unicodeScalars
  }
  if value <= 0xF933 {
    return "盧".unicodeScalars
  }
  if value <= 0xF934 {
    return "老".unicodeScalars
  }
  if value <= 0xF935 {
    return "蘆".unicodeScalars
  }
  if value <= 0xF936 {
    return "虜".unicodeScalars
  }
  if value <= 0xF937 {
    return "路".unicodeScalars
  }
  if value <= 0xF938 {
    return "露".unicodeScalars
  }
  if value <= 0xF939 {
    return "魯".unicodeScalars
  }
  if value <= 0xF93A {
    return "鷺".unicodeScalars
  }
  if value <= 0xF93B {
    return "碌".unicodeScalars
  }
  if value <= 0xF93C {
    return "祿".unicodeScalars
  }
  if value <= 0xF93D {
    return "綠".unicodeScalars
  }
  if value <= 0xF93E {
    return "菉".unicodeScalars
  }
  if value <= 0xF93F {
    return "錄".unicodeScalars
  }
  if value <= 0xF940 {
    return "鹿".unicodeScalars
  }
  if value <= 0xF941 {
    return "論".unicodeScalars
  }
  if value <= 0xF942 {
    return "壟".unicodeScalars
  }
  if value <= 0xF943 {
    return "弄".unicodeScalars
  }
  if value <= 0xF944 {
    return "籠".unicodeScalars
  }
  if value <= 0xF945 {
    return "聾".unicodeScalars
  }
  if value <= 0xF946 {
    return "牢".unicodeScalars
  }
  if value <= 0xF947 {
    return "磊".unicodeScalars
  }
  if value <= 0xF948 {
    return "賂".unicodeScalars
  }
  if value <= 0xF949 {
    return "雷".unicodeScalars
  }
  if value <= 0xF94A {
    return "壘".unicodeScalars
  }
  if value <= 0xF94B {
    return "屢".unicodeScalars
  }
  if value <= 0xF94C {
    return "樓".unicodeScalars
  }
  if value <= 0xF94D {
    return "淚".unicodeScalars
  }
  if value <= 0xF94E {
    return "漏".unicodeScalars
  }
  if value <= 0xF94F {
    return "累".unicodeScalars
  }
  if value <= 0xF950 {
    return "縷".unicodeScalars
  }
  if value <= 0xF951 {
    return "陋".unicodeScalars
  }
  if value <= 0xF952 {
    return "勒".unicodeScalars
  }
  if value <= 0xF953 {
    return "肋".unicodeScalars
  }
  if value <= 0xF954 {
    return "凜".unicodeScalars
  }
  if value <= 0xF955 {
    return "凌".unicodeScalars
  }
  if value <= 0xF956 {
    return "稜".unicodeScalars
  }
  if value <= 0xF957 {
    return "綾".unicodeScalars
  }
  if value <= 0xF958 {
    return "菱".unicodeScalars
  }
  if value <= 0xF959 {
    return "陵".unicodeScalars
  }
  if value <= 0xF95A {
    return "讀".unicodeScalars
  }
  if value <= 0xF95B {
    return "拏".unicodeScalars
  }
  if value <= 0xF95C {
    return "樂".unicodeScalars
  }
  if value <= 0xF95D {
    return "諾".unicodeScalars
  }
  if value <= 0xF95E {
    return "丹".unicodeScalars
  }
  if value <= 0xF95F {
    return "寧".unicodeScalars
  }
  if value <= 0xF960 {
    return "怒".unicodeScalars
  }
  if value <= 0xF961 {
    return "率".unicodeScalars
  }
  if value <= 0xF962 {
    return "異".unicodeScalars
  }
  if value <= 0xF963 {
    return "北".unicodeScalars
  }
  if value <= 0xF964 {
    return "磻".unicodeScalars
  }
  if value <= 0xF965 {
    return "便".unicodeScalars
  }
  if value <= 0xF966 {
    return "復".unicodeScalars
  }
  if value <= 0xF967 {
    return "不".unicodeScalars
  }
  if value <= 0xF968 {
    return "泌".unicodeScalars
  }
  if value <= 0xF969 {
    return "數".unicodeScalars
  }
  if value <= 0xF96A {
    return "索".unicodeScalars
  }
  if value <= 0xF96B {
    return "參".unicodeScalars
  }
  if value <= 0xF96C {
    return "塞".unicodeScalars
  }
  if value <= 0xF96D {
    return "省".unicodeScalars
  }
  if value <= 0xF96E {
    return "葉".unicodeScalars
  }
  if value <= 0xF96F {
    return "說".unicodeScalars
  }
  if value <= 0xF970 {
    return "殺".unicodeScalars
  }
  if value <= 0xF971 {
    return "辰".unicodeScalars
  }
  if value <= 0xF972 {
    return "沈".unicodeScalars
  }
  if value <= 0xF973 {
    return "拾".unicodeScalars
  }
  if value <= 0xF974 {
    return "若".unicodeScalars
  }
  if value <= 0xF975 {
    return "掠".unicodeScalars
  }
  if value <= 0xF976 {
    return "略".unicodeScalars
  }
  if value <= 0xF977 {
    return "亮".unicodeScalars
  }
  if value <= 0xF978 {
    return "兩".unicodeScalars
  }
  if value <= 0xF979 {
    return "凉".unicodeScalars
  }
  if value <= 0xF97A {
    return "梁".unicodeScalars
  }
  if value <= 0xF97B {
    return "糧".unicodeScalars
  }
  if value <= 0xF97C {
    return "良".unicodeScalars
  }
  if value <= 0xF97D {
    return "諒".unicodeScalars
  }
  if value <= 0xF97E {
    return "量".unicodeScalars
  }
  if value <= 0xF97F {
    return "勵".unicodeScalars
  }
  if value <= 0xF980 {
    return "呂".unicodeScalars
  }
  if value <= 0xF981 {
    return "女".unicodeScalars
  }
  if value <= 0xF982 {
    return "廬".unicodeScalars
  }
  if value <= 0xF983 {
    return "旅".unicodeScalars
  }
  if value <= 0xF984 {
    return "濾".unicodeScalars
  }
  if value <= 0xF985 {
    return "礪".unicodeScalars
  }
  if value <= 0xF986 {
    return "閭".unicodeScalars
  }
  if value <= 0xF987 {
    return "驪".unicodeScalars
  }
  if value <= 0xF988 {
    return "麗".unicodeScalars
  }
  if value <= 0xF989 {
    return "黎".unicodeScalars
  }
  if value <= 0xF98A {
    return "力".unicodeScalars
  }
  if value <= 0xF98B {
    return "曆".unicodeScalars
  }
  if value <= 0xF98C {
    return "歷".unicodeScalars
  }
  if value <= 0xF98D {
    return "轢".unicodeScalars
  }
  if value <= 0xF98E {
    return "年".unicodeScalars
  }
  if value <= 0xF98F {
    return "憐".unicodeScalars
  }
  if value <= 0xF990 {
    return "戀".unicodeScalars
  }
  if value <= 0xF991 {
    return "撚".unicodeScalars
  }
  if value <= 0xF992 {
    return "漣".unicodeScalars
  }
  if value <= 0xF993 {
    return "煉".unicodeScalars
  }
  if value <= 0xF994 {
    return "璉".unicodeScalars
  }
  if value <= 0xF995 {
    return "秊".unicodeScalars
  }
  if value <= 0xF996 {
    return "練".unicodeScalars
  }
  if value <= 0xF997 {
    return "聯".unicodeScalars
  }
  if value <= 0xF998 {
    return "輦".unicodeScalars
  }
  if value <= 0xF999 {
    return "蓮".unicodeScalars
  }
  if value <= 0xF99A {
    return "連".unicodeScalars
  }
  if value <= 0xF99B {
    return "鍊".unicodeScalars
  }
  if value <= 0xF99C {
    return "列".unicodeScalars
  }
  if value <= 0xF99D {
    return "劣".unicodeScalars
  }
  if value <= 0xF99E {
    return "咽".unicodeScalars
  }
  if value <= 0xF99F {
    return "烈".unicodeScalars
  }
  if value <= 0xF9A0 {
    return "裂".unicodeScalars
  }
  if value <= 0xF9A1 {
    return "說".unicodeScalars
  }
  if value <= 0xF9A2 {
    return "廉".unicodeScalars
  }
  if value <= 0xF9A3 {
    return "念".unicodeScalars
  }
  if value <= 0xF9A4 {
    return "捻".unicodeScalars
  }
  if value <= 0xF9A5 {
    return "殮".unicodeScalars
  }
  if value <= 0xF9A6 {
    return "簾".unicodeScalars
  }
  if value <= 0xF9A7 {
    return "獵".unicodeScalars
  }
  if value <= 0xF9A8 {
    return "令".unicodeScalars
  }
  if value <= 0xF9A9 {
    return "囹".unicodeScalars
  }
  if value <= 0xF9AA {
    return "寧".unicodeScalars
  }
  if value <= 0xF9AB {
    return "嶺".unicodeScalars
  }
  if value <= 0xF9AC {
    return "怜".unicodeScalars
  }
  if value <= 0xF9AD {
    return "玲".unicodeScalars
  }
  if value <= 0xF9AE {
    return "瑩".unicodeScalars
  }
  if value <= 0xF9AF {
    return "羚".unicodeScalars
  }
  if value <= 0xF9B0 {
    return "聆".unicodeScalars
  }
  if value <= 0xF9B1 {
    return "鈴".unicodeScalars
  }
  if value <= 0xF9B2 {
    return "零".unicodeScalars
  }
  if value <= 0xF9B3 {
    return "靈".unicodeScalars
  }
  if value <= 0xF9B4 {
    return "領".unicodeScalars
  }
  if value <= 0xF9B5 {
    return "例".unicodeScalars
  }
  if value <= 0xF9B6 {
    return "禮".unicodeScalars
  }
  if value <= 0xF9B7 {
    return "醴".unicodeScalars
  }
  if value <= 0xF9B8 {
    return "隸".unicodeScalars
  }
  if value <= 0xF9B9 {
    return "惡".unicodeScalars
  }
  if value <= 0xF9BA {
    return "了".unicodeScalars
  }
  if value <= 0xF9BB {
    return "僚".unicodeScalars
  }
  if value <= 0xF9BC {
    return "寮".unicodeScalars
  }
  if value <= 0xF9BD {
    return "尿".unicodeScalars
  }
  if value <= 0xF9BE {
    return "料".unicodeScalars
  }
  if value <= 0xF9BF {
    return "樂".unicodeScalars
  }
  if value <= 0xF9C0 {
    return "燎".unicodeScalars
  }
  if value <= 0xF9C1 {
    return "療".unicodeScalars
  }
  if value <= 0xF9C2 {
    return "蓼".unicodeScalars
  }
  if value <= 0xF9C3 {
    return "遼".unicodeScalars
  }
  if value <= 0xF9C4 {
    return "龍".unicodeScalars
  }
  if value <= 0xF9C5 {
    return "暈".unicodeScalars
  }
  if value <= 0xF9C6 {
    return "阮".unicodeScalars
  }
  if value <= 0xF9C7 {
    return "劉".unicodeScalars
  }
  if value <= 0xF9C8 {
    return "杻".unicodeScalars
  }
  if value <= 0xF9C9 {
    return "柳".unicodeScalars
  }
  if value <= 0xF9CA {
    return "流".unicodeScalars
  }
  if value <= 0xF9CB {
    return "溜".unicodeScalars
  }
  if value <= 0xF9CC {
    return "琉".unicodeScalars
  }
  if value <= 0xF9CD {
    return "留".unicodeScalars
  }
  if value <= 0xF9CE {
    return "硫".unicodeScalars
  }
  if value <= 0xF9CF {
    return "紐".unicodeScalars
  }
  if value <= 0xF9D0 {
    return "類".unicodeScalars
  }
  if value <= 0xF9D1 {
    return "六".unicodeScalars
  }
  if value <= 0xF9D2 {
    return "戮".unicodeScalars
  }
  if value <= 0xF9D3 {
    return "陸".unicodeScalars
  }
  if value <= 0xF9D4 {
    return "倫".unicodeScalars
  }
  if value <= 0xF9D5 {
    return "崙".unicodeScalars
  }
  if value <= 0xF9D6 {
    return "淪".unicodeScalars
  }
  if value <= 0xF9D7 {
    return "輪".unicodeScalars
  }
  if value <= 0xF9D8 {
    return "律".unicodeScalars
  }
  if value <= 0xF9D9 {
    return "慄".unicodeScalars
  }
  if value <= 0xF9DA {
    return "栗".unicodeScalars
  }
  if value <= 0xF9DB {
    return "率".unicodeScalars
  }
  if value <= 0xF9DC {
    return "隆".unicodeScalars
  }
  if value <= 0xF9DD {
    return "利".unicodeScalars
  }
  if value <= 0xF9DE {
    return "吏".unicodeScalars
  }
  if value <= 0xF9DF {
    return "履".unicodeScalars
  }
  if value <= 0xF9E0 {
    return "易".unicodeScalars
  }
  if value <= 0xF9E1 {
    return "李".unicodeScalars
  }
  if value <= 0xF9E2 {
    return "梨".unicodeScalars
  }
  if value <= 0xF9E3 {
    return "泥".unicodeScalars
  }
  if value <= 0xF9E4 {
    return "理".unicodeScalars
  }
  if value <= 0xF9E5 {
    return "痢".unicodeScalars
  }
  if value <= 0xF9E6 {
    return "罹".unicodeScalars
  }
  if value <= 0xF9E7 {
    return "裏".unicodeScalars
  }
  if value <= 0xF9E8 {
    return "裡".unicodeScalars
  }
  if value <= 0xF9E9 {
    return "里".unicodeScalars
  }
  if value <= 0xF9EA {
    return "離".unicodeScalars
  }
  if value <= 0xF9EB {
    return "匿".unicodeScalars
  }
  if value <= 0xF9EC {
    return "溺".unicodeScalars
  }
  if value <= 0xF9ED {
    return "吝".unicodeScalars
  }
  if value <= 0xF9EE {
    return "燐".unicodeScalars
  }
  if value <= 0xF9EF {
    return "璘".unicodeScalars
  }
  if value <= 0xF9F0 {
    return "藺".unicodeScalars
  }
  if value <= 0xF9F1 {
    return "隣".unicodeScalars
  }
  if value <= 0xF9F2 {
    return "鱗".unicodeScalars
  }
  if value <= 0xF9F3 {
    return "麟".unicodeScalars
  }
  if value <= 0xF9F4 {
    return "林".unicodeScalars
  }
  if value <= 0xF9F5 {
    return "淋".unicodeScalars
  }
  if value <= 0xF9F6 {
    return "臨".unicodeScalars
  }
  if value <= 0xF9F7 {
    return "立".unicodeScalars
  }
  if value <= 0xF9F8 {
    return "笠".unicodeScalars
  }
  if value <= 0xF9F9 {
    return "粒".unicodeScalars
  }
  if value <= 0xF9FA {
    return "狀".unicodeScalars
  }
  if value <= 0xF9FB {
    return "炙".unicodeScalars
  }
  if value <= 0xF9FC {
    return "識".unicodeScalars
  }
  if value <= 0xF9FD {
    return "什".unicodeScalars
  }
  if value <= 0xF9FE {
    return "茶".unicodeScalars
  }
  if value <= 0xF9FF {
    return "刺".unicodeScalars
  }
  if value <= 0xFA00 {
    return "切".unicodeScalars
  }
  if value <= 0xFA01 {
    return "度".unicodeScalars
  }
  if value <= 0xFA02 {
    return "拓".unicodeScalars
  }
  if value <= 0xFA03 {
    return "糖".unicodeScalars
  }
  if value <= 0xFA04 {
    return "宅".unicodeScalars
  }
  if value <= 0xFA05 {
    return "洞".unicodeScalars
  }
  if value <= 0xFA06 {
    return "暴".unicodeScalars
  }
  if value <= 0xFA07 {
    return "輻".unicodeScalars
  }
  if value <= 0xFA08 {
    return "行".unicodeScalars
  }
  if value <= 0xFA09 {
    return "降".unicodeScalars
  }
  if value <= 0xFA0A {
    return "見".unicodeScalars
  }
  if value <= 0xFA0B {
    return "廓".unicodeScalars
  }
  if value <= 0xFA0C {
    return "兀".unicodeScalars
  }
  if value <= 0xFA0D {
    return "嗀".unicodeScalars
  }
  if value <= 0xFA0F {
    return String(scalar).unicodeScalars
  }
  if value <= 0xFA10 {
    return "塚".unicodeScalars
  }
  if value <= 0xFA11 {
    return String(scalar).unicodeScalars
  }
  if value <= 0xFA12 {
    return "晴".unicodeScalars
  }
  if value <= 0xFA14 {
    return String(scalar).unicodeScalars
  }
  if value <= 0xFA15 {
    return "凞".unicodeScalars
  }
  if value <= 0xFA16 {
    return "猪".unicodeScalars
  }
  if value <= 0xFA17 {
    return "益".unicodeScalars
  }
  if value <= 0xFA18 {
    return "礼".unicodeScalars
  }
  if value <= 0xFA19 {
    return "神".unicodeScalars
  }
  if value <= 0xFA1A {
    return "祥".unicodeScalars
  }
  if value <= 0xFA1B {
    return "福".unicodeScalars
  }
  if value <= 0xFA1C {
    return "靖".unicodeScalars
  }
  if value <= 0xFA1D {
    return "精".unicodeScalars
  }
  if value <= 0xFA1E {
    return "羽".unicodeScalars
  }
  if value <= 0xFA1F {
    return String(scalar).unicodeScalars
  }
  if value <= 0xFA20 {
    return "蘒".unicodeScalars
  }
  if value <= 0xFA21 {
    return String(scalar).unicodeScalars
  }
  if value <= 0xFA22 {
    return "諸".unicodeScalars
  }
  if value <= 0xFA24 {
    return String(scalar).unicodeScalars
  }
  if value <= 0xFA25 {
    return "逸".unicodeScalars
  }
  if value <= 0xFA26 {
    return "都".unicodeScalars
  }
  if value <= 0xFA29 {
    return String(scalar).unicodeScalars
  }
  if value <= 0xFA2A {
    return "飯".unicodeScalars
  }
  if value <= 0xFA2B {
    return "飼".unicodeScalars
  }
  if value <= 0xFA2C {
    return "館".unicodeScalars
  }
  if value <= 0xFA2D {
    return "鶴".unicodeScalars
  }
  if value <= 0xFA2E {
    return "郞".unicodeScalars
  }
  if value <= 0xFA2F {
    return "隷".unicodeScalars
  }
  if value <= 0xFA30 {
    return "侮".unicodeScalars
  }
  if value <= 0xFA31 {
    return "僧".unicodeScalars
  }
  if value <= 0xFA32 {
    return "免".unicodeScalars
  }
  if value <= 0xFA33 {
    return "勉".unicodeScalars
  }
  if value <= 0xFA34 {
    return "勤".unicodeScalars
  }
  if value <= 0xFA35 {
    return "卑".unicodeScalars
  }
  if value <= 0xFA36 {
    return "喝".unicodeScalars
  }
  if value <= 0xFA37 {
    return "嘆".unicodeScalars
  }
  if value <= 0xFA38 {
    return "器".unicodeScalars
  }
  if value <= 0xFA39 {
    return "塀".unicodeScalars
  }
  if value <= 0xFA3A {
    return "墨".unicodeScalars
  }
  if value <= 0xFA3B {
    return "層".unicodeScalars
  }
  if value <= 0xFA3C {
    return "屮".unicodeScalars
  }
  if value <= 0xFA3D {
    return "悔".unicodeScalars
  }
  if value <= 0xFA3E {
    return "慨".unicodeScalars
  }
  if value <= 0xFA3F {
    return "憎".unicodeScalars
  }
  if value <= 0xFA40 {
    return "懲".unicodeScalars
  }
  if value <= 0xFA41 {
    return "敏".unicodeScalars
  }
  if value <= 0xFA42 {
    return "既".unicodeScalars
  }
  if value <= 0xFA43 {
    return "暑".unicodeScalars
  }
  if value <= 0xFA44 {
    return "梅".unicodeScalars
  }
  if value <= 0xFA45 {
    return "海".unicodeScalars
  }
  if value <= 0xFA46 {
    return "渚".unicodeScalars
  }
  if value <= 0xFA47 {
    return "漢".unicodeScalars
  }
  if value <= 0xFA48 {
    return "煮".unicodeScalars
  }
  if value <= 0xFA49 {
    return "爫".unicodeScalars
  }
  if value <= 0xFA4A {
    return "琢".unicodeScalars
  }
  if value <= 0xFA4B {
    return "碑".unicodeScalars
  }
  if value <= 0xFA4C {
    return "社".unicodeScalars
  }
  if value <= 0xFA4D {
    return "祉".unicodeScalars
  }
  if value <= 0xFA4E {
    return "祈".unicodeScalars
  }
  if value <= 0xFA4F {
    return "祐".unicodeScalars
  }
  if value <= 0xFA50 {
    return "祖".unicodeScalars
  }
  if value <= 0xFA51 {
    return "祝".unicodeScalars
  }
  if value <= 0xFA52 {
    return "禍".unicodeScalars
  }
  if value <= 0xFA53 {
    return "禎".unicodeScalars
  }
  if value <= 0xFA54 {
    return "穀".unicodeScalars
  }
  if value <= 0xFA55 {
    return "突".unicodeScalars
  }
  if value <= 0xFA56 {
    return "節".unicodeScalars
  }
  if value <= 0xFA57 {
    return "練".unicodeScalars
  }
  if value <= 0xFA58 {
    return "縉".unicodeScalars
  }
  if value <= 0xFA59 {
    return "繁".unicodeScalars
  }
  if value <= 0xFA5A {
    return "署".unicodeScalars
  }
  if value <= 0xFA5B {
    return "者".unicodeScalars
  }
  if value <= 0xFA5C {
    return "臭".unicodeScalars
  }
  if value <= 0xFA5E {
    return "艹".unicodeScalars
  }
  if value <= 0xFA5F {
    return "著".unicodeScalars
  }
  if value <= 0xFA60 {
    return "褐".unicodeScalars
  }
  if value <= 0xFA61 {
    return "視".unicodeScalars
  }
  if value <= 0xFA62 {
    return "謁".unicodeScalars
  }
  if value <= 0xFA63 {
    return "謹".unicodeScalars
  }
  if value <= 0xFA64 {
    return "賓".unicodeScalars
  }
  if value <= 0xFA65 {
    return "贈".unicodeScalars
  }
  if value <= 0xFA66 {
    return "辶".unicodeScalars
  }
  if value <= 0xFA67 {
    return "逸".unicodeScalars
  }
  if value <= 0xFA68 {
    return "難".unicodeScalars
  }
  if value <= 0xFA69 {
    return "響".unicodeScalars
  }
  if value <= 0xFA6A {
    return "頻".unicodeScalars
  }
  if value <= 0xFA6B {
    return "恵".unicodeScalars
  }
  if value <= 0xFA6C {
    return "𤋮".unicodeScalars
  }
  if value <= 0xFA6D {
    return "舘".unicodeScalars
  }
  if value <= 0xFA6F {
    return String(scalar).unicodeScalars
  }
  if value <= 0xFA70 {
    return "並".unicodeScalars
  }
  if value <= 0xFA71 {
    return "况".unicodeScalars
  }
  if value <= 0xFA72 {
    return "全".unicodeScalars
  }
  if value <= 0xFA73 {
    return "侀".unicodeScalars
  }
  if value <= 0xFA74 {
    return "充".unicodeScalars
  }
  if value <= 0xFA75 {
    return "冀".unicodeScalars
  }
  if value <= 0xFA76 {
    return "勇".unicodeScalars
  }
  if value <= 0xFA77 {
    return "勺".unicodeScalars
  }
  if value <= 0xFA78 {
    return "喝".unicodeScalars
  }
  if value <= 0xFA79 {
    return "啕".unicodeScalars
  }
  if value <= 0xFA7A {
    return "喙".unicodeScalars
  }
  if value <= 0xFA7B {
    return "嗢".unicodeScalars
  }
  if value <= 0xFA7C {
    return "塚".unicodeScalars
  }
  if value <= 0xFA7D {
    return "墳".unicodeScalars
  }
  if value <= 0xFA7E {
    return "奄".unicodeScalars
  }
  if value <= 0xFA7F {
    return "奔".unicodeScalars
  }
  if value <= 0xFA80 {
    return "婢".unicodeScalars
  }
  if value <= 0xFA81 {
    return "嬨".unicodeScalars
  }
  if value <= 0xFA82 {
    return "廒".unicodeScalars
  }
  if value <= 0xFA83 {
    return "廙".unicodeScalars
  }
  if value <= 0xFA84 {
    return "彩".unicodeScalars
  }
  if value <= 0xFA85 {
    return "徭".unicodeScalars
  }
  if value <= 0xFA86 {
    return "惘".unicodeScalars
  }
  if value <= 0xFA87 {
    return "慎".unicodeScalars
  }
  if value <= 0xFA88 {
    return "愈".unicodeScalars
  }
  if value <= 0xFA89 {
    return "憎".unicodeScalars
  }
  if value <= 0xFA8A {
    return "慠".unicodeScalars
  }
  if value <= 0xFA8B {
    return "懲".unicodeScalars
  }
  if value <= 0xFA8C {
    return "戴".unicodeScalars
  }
  if value <= 0xFA8D {
    return "揄".unicodeScalars
  }
  if value <= 0xFA8E {
    return "搜".unicodeScalars
  }
  if value <= 0xFA8F {
    return "摒".unicodeScalars
  }
  if value <= 0xFA90 {
    return "敖".unicodeScalars
  }
  if value <= 0xFA91 {
    return "晴".unicodeScalars
  }
  if value <= 0xFA92 {
    return "朗".unicodeScalars
  }
  if value <= 0xFA93 {
    return "望".unicodeScalars
  }
  if value <= 0xFA94 {
    return "杖".unicodeScalars
  }
  if value <= 0xFA95 {
    return "歹".unicodeScalars
  }
  if value <= 0xFA96 {
    return "殺".unicodeScalars
  }
  if value <= 0xFA97 {
    return "流".unicodeScalars
  }
  if value <= 0xFA98 {
    return "滛".unicodeScalars
  }
  if value <= 0xFA99 {
    return "滋".unicodeScalars
  }
  if value <= 0xFA9A {
    return "漢".unicodeScalars
  }
  if value <= 0xFA9B {
    return "瀞".unicodeScalars
  }
  if value <= 0xFA9C {
    return "煮".unicodeScalars
  }
  if value <= 0xFA9D {
    return "瞧".unicodeScalars
  }
  if value <= 0xFA9E {
    return "爵".unicodeScalars
  }
  if value <= 0xFA9F {
    return "犯".unicodeScalars
  }
  if value <= 0xFAA0 {
    return "猪".unicodeScalars
  }
  if value <= 0xFAA1 {
    return "瑱".unicodeScalars
  }
  if value <= 0xFAA2 {
    return "甆".unicodeScalars
  }
  if value <= 0xFAA3 {
    return "画".unicodeScalars
  }
  if value <= 0xFAA4 {
    return "瘝".unicodeScalars
  }
  if value <= 0xFAA5 {
    return "瘟".unicodeScalars
  }
  if value <= 0xFAA6 {
    return "益".unicodeScalars
  }
  if value <= 0xFAA7 {
    return "盛".unicodeScalars
  }
  if value <= 0xFAA8 {
    return "直".unicodeScalars
  }
  if value <= 0xFAA9 {
    return "睊".unicodeScalars
  }
  if value <= 0xFAAA {
    return "着".unicodeScalars
  }
  if value <= 0xFAAB {
    return "磌".unicodeScalars
  }
  if value <= 0xFAAC {
    return "窱".unicodeScalars
  }
  if value <= 0xFAAD {
    return "節".unicodeScalars
  }
  if value <= 0xFAAE {
    return "类".unicodeScalars
  }
  if value <= 0xFAAF {
    return "絛".unicodeScalars
  }
  if value <= 0xFAB0 {
    return "練".unicodeScalars
  }
  if value <= 0xFAB1 {
    return "缾".unicodeScalars
  }
  if value <= 0xFAB2 {
    return "者".unicodeScalars
  }
  if value <= 0xFAB3 {
    return "荒".unicodeScalars
  }
  if value <= 0xFAB4 {
    return "華".unicodeScalars
  }
  if value <= 0xFAB5 {
    return "蝹".unicodeScalars
  }
  if value <= 0xFAB6 {
    return "襁".unicodeScalars
  }
  if value <= 0xFAB7 {
    return "覆".unicodeScalars
  }
  if value <= 0xFAB8 {
    return "視".unicodeScalars
  }
  if value <= 0xFAB9 {
    return "調".unicodeScalars
  }
  if value <= 0xFABA {
    return "諸".unicodeScalars
  }
  if value <= 0xFABB {
    return "請".unicodeScalars
  }
  if value <= 0xFABC {
    return "謁".unicodeScalars
  }
  if value <= 0xFABD {
    return "諾".unicodeScalars
  }
  if value <= 0xFABE {
    return "諭".unicodeScalars
  }
  if value <= 0xFABF {
    return "謹".unicodeScalars
  }
  if value <= 0xFAC0 {
    return "變".unicodeScalars
  }
  if value <= 0xFAC1 {
    return "贈".unicodeScalars
  }
  if value <= 0xFAC2 {
    return "輸".unicodeScalars
  }
  if value <= 0xFAC3 {
    return "遲".unicodeScalars
  }
  if value <= 0xFAC4 {
    return "醙".unicodeScalars
  }
  if value <= 0xFAC5 {
    return "鉶".unicodeScalars
  }
  if value <= 0xFAC6 {
    return "陼".unicodeScalars
  }
  if value <= 0xFAC7 {
    return "難".unicodeScalars
  }
  if value <= 0xFAC8 {
    return "靖".unicodeScalars
  }
  if value <= 0xFAC9 {
    return "韛".unicodeScalars
  }
  if value <= 0xFACA {
    return "響".unicodeScalars
  }
  if value <= 0xFACB {
    return "頋".unicodeScalars
  }
  if value <= 0xFACC {
    return "頻".unicodeScalars
  }
  if value <= 0xFACD {
    return "鬒".unicodeScalars
  }
  if value <= 0xFACE {
    return "龜".unicodeScalars
  }
  if value <= 0xFACF {
    return "𢡊".unicodeScalars
  }
  if value <= 0xFAD0 {
    return "𢡄".unicodeScalars
  }
  if value <= 0xFAD1 {
    return "𣏕".unicodeScalars
  }
  if value <= 0xFAD2 {
    return "㮝".unicodeScalars
  }
  if value <= 0xFAD3 {
    return "䀘".unicodeScalars
  }
  if value <= 0xFAD4 {
    return "䀹".unicodeScalars
  }
  if value <= 0xFAD5 {
    return "𥉉".unicodeScalars
  }
  if value <= 0xFAD6 {
    return "𥳐".unicodeScalars
  }
  if value <= 0xFAD7 {
    return "𧻓".unicodeScalars
  }
  if value <= 0xFAD8 {
    return "齃".unicodeScalars
  }
  if value <= 0xFAD9 {
    return "龎".unicodeScalars
  }
  if value <= 0xFAFF {
    return String(scalar).unicodeScalars
  }
  if value <= 0xFB00 {
    return "ff".unicodeScalars
  }
  if value <= 0xFB01 {
    return "fi".unicodeScalars
  }
  if value <= 0xFB02 {
    return "fl".unicodeScalars
  }
  if value <= 0xFB03 {
    return "ffi".unicodeScalars
  }
  if value <= 0xFB04 {
    return "ffl".unicodeScalars
  }
  if value <= 0xFB06 {
    return "st".unicodeScalars
  }
  if value <= 0xFB12 {
    return String(scalar).unicodeScalars
  }
  if value <= 0xFB13 {
    return "մն".unicodeScalars
  }
  if value <= 0xFB14 {
    return "մե".unicodeScalars
  }
  if value <= 0xFB15 {
    return "մի".unicodeScalars
  }
  if value <= 0xFB16 {
    return "վն".unicodeScalars
  }
  if value <= 0xFB17 {
    return "մխ".unicodeScalars
  }
  if value <= 0xFB1C {
    return String(scalar).unicodeScalars
  }
  if value <= 0xFB1D {
    return "י\u{05B4}".unicodeScalars
  }
  if value <= 0xFB1E {
    return String(scalar).unicodeScalars
  }
  if value <= 0xFB1F {
    return "ײ\u{05B7}".unicodeScalars
  }
  if value <= 0xFB20 {
    return "ע".unicodeScalars
  }
  if value <= 0xFB21 {
    return "א".unicodeScalars
  }
  if value <= 0xFB22 {
    return "ד".unicodeScalars
  }
  if value <= 0xFB23 {
    return "ה".unicodeScalars
  }
  if value <= 0xFB24 {
    return "כ".unicodeScalars
  }
  if value <= 0xFB25 {
    return "ל".unicodeScalars
  }
  if value <= 0xFB26 {
    return "ם".unicodeScalars
  }
  if value <= 0xFB27 {
    return "ר".unicodeScalars
  }
  if value <= 0xFB28 {
    return "ת".unicodeScalars
  }
  if value <= 0xFB29 {
    return "+".unicodeScalars
  }
  if value <= 0xFB2A {
    return "ש\u{05C1}".unicodeScalars
  }
  if value <= 0xFB2B {
    return "ש\u{05C2}".unicodeScalars
  }
  if value <= 0xFB2C {
    return "ש\u{05BC}\u{05C1}".unicodeScalars
  }
  if value <= 0xFB2D {
    return "ש\u{05BC}\u{05C2}".unicodeScalars
  }
  if value <= 0xFB2E {
    return "א\u{05B7}".unicodeScalars
  }
  if value <= 0xFB2F {
    return "א\u{05B8}".unicodeScalars
  }
  if value <= 0xFB30 {
    return "א\u{05BC}".unicodeScalars
  }
  if value <= 0xFB31 {
    return "ב\u{05BC}".unicodeScalars
  }
  if value <= 0xFB32 {
    return "ג\u{05BC}".unicodeScalars
  }
  if value <= 0xFB33 {
    return "ד\u{05BC}".unicodeScalars
  }
  if value <= 0xFB34 {
    return "ה\u{05BC}".unicodeScalars
  }
  if value <= 0xFB35 {
    return "ו\u{05BC}".unicodeScalars
  }
  if value <= 0xFB36 {
    return "ז\u{05BC}".unicodeScalars
  }
  if value <= 0xFB37 {
    return String(scalar).unicodeScalars
  }
  if value <= 0xFB38 {
    return "ט\u{05BC}".unicodeScalars
  }
  if value <= 0xFB39 {
    return "י\u{05BC}".unicodeScalars
  }
  if value <= 0xFB3A {
    return "ך\u{05BC}".unicodeScalars
  }
  if value <= 0xFB3B {
    return "כ\u{05BC}".unicodeScalars
  }
  if value <= 0xFB3C {
    return "ל\u{05BC}".unicodeScalars
  }
  if value <= 0xFB3D {
    return String(scalar).unicodeScalars
  }
  if value <= 0xFB3E {
    return "מ\u{05BC}".unicodeScalars
  }
  if value <= 0xFB3F {
    return String(scalar).unicodeScalars
  }
  if value <= 0xFB40 {
    return "נ\u{05BC}".unicodeScalars
  }
  if value <= 0xFB41 {
    return "ס\u{05BC}".unicodeScalars
  }
  if value <= 0xFB42 {
    return String(scalar).unicodeScalars
  }
  if value <= 0xFB43 {
    return "ף\u{05BC}".unicodeScalars
  }
  if value <= 0xFB44 {
    return "פ\u{05BC}".unicodeScalars
  }
  if value <= 0xFB45 {
    return String(scalar).unicodeScalars
  }
  if value <= 0xFB46 {
    return "צ\u{05BC}".unicodeScalars
  }
  if value <= 0xFB47 {
    return "ק\u{05BC}".unicodeScalars
  }
  if value <= 0xFB48 {
    return "ר\u{05BC}".unicodeScalars
  }
  if value <= 0xFB49 {
    return "ש\u{05BC}".unicodeScalars
  }
  if value <= 0xFB4A {
    return "ת\u{05BC}".unicodeScalars
  }
  if value <= 0xFB4B {
    return "ו\u{05B9}".unicodeScalars
  }
  if value <= 0xFB4C {
    return "ב\u{05BF}".unicodeScalars
  }
  if value <= 0xFB4D {
    return "כ\u{05BF}".unicodeScalars
  }
  if value <= 0xFB4E {
    return "פ\u{05BF}".unicodeScalars
  }
  if value <= 0xFB4F {
    return "אל".unicodeScalars
  }
  if value <= 0xFB51 {
    return "ٱ".unicodeScalars
  }
  if value <= 0xFB55 {
    return "ٻ".unicodeScalars
  }
  if value <= 0xFB59 {
    return "پ".unicodeScalars
  }
  if value <= 0xFB5D {
    return "ڀ".unicodeScalars
  }
  if value <= 0xFB61 {
    return "ٺ".unicodeScalars
  }
  if value <= 0xFB65 {
    return "ٿ".unicodeScalars
  }
  if value <= 0xFB69 {
    return "ٹ".unicodeScalars
  }
  if value <= 0xFB6D {
    return "ڤ".unicodeScalars
  }
  if value <= 0xFB71 {
    return "ڦ".unicodeScalars
  }
  if value <= 0xFB75 {
    return "ڄ".unicodeScalars
  }
  if value <= 0xFB79 {
    return "ڃ".unicodeScalars
  }
  if value <= 0xFB7D {
    return "چ".unicodeScalars
  }
  if value <= 0xFB81 {
    return "ڇ".unicodeScalars
  }
  if value <= 0xFB83 {
    return "ڍ".unicodeScalars
  }
  if value <= 0xFB85 {
    return "ڌ".unicodeScalars
  }
  if value <= 0xFB87 {
    return "ڎ".unicodeScalars
  }
  if value <= 0xFB89 {
    return "ڈ".unicodeScalars
  }
  if value <= 0xFB8B {
    return "ژ".unicodeScalars
  }
  if value <= 0xFB8D {
    return "ڑ".unicodeScalars
  }
  if value <= 0xFB91 {
    return "ک".unicodeScalars
  }
  if value <= 0xFB95 {
    return "گ".unicodeScalars
  }
  if value <= 0xFB99 {
    return "ڳ".unicodeScalars
  }
  if value <= 0xFB9D {
    return "ڱ".unicodeScalars
  }
  if value <= 0xFB9F {
    return "ں".unicodeScalars
  }
  if value <= 0xFBA3 {
    return "ڻ".unicodeScalars
  }
  if value <= 0xFBA5 {
    return "ە\u{0654}".unicodeScalars
  }
  if value <= 0xFBA9 {
    return "ہ".unicodeScalars
  }
  if value <= 0xFBAD {
    return "ھ".unicodeScalars
  }
  if value <= 0xFBAF {
    return "ے".unicodeScalars
  }
  if value <= 0xFBB1 {
    return "ے\u{0654}".unicodeScalars
  }
  if value <= 0xFBD2 {
    return String(scalar).unicodeScalars
  }
  if value <= 0xFBD6 {
    return "ڭ".unicodeScalars
  }
  if value <= 0xFBD8 {
    return "ۇ".unicodeScalars
  }
  if value <= 0xFBDA {
    return "ۆ".unicodeScalars
  }
  if value <= 0xFBDC {
    return "ۈ".unicodeScalars
  }
  if value <= 0xFBDD {
    return "ۇٴ".unicodeScalars
  }
  if value <= 0xFBDF {
    return "ۋ".unicodeScalars
  }
  if value <= 0xFBE1 {
    return "ۅ".unicodeScalars
  }
  if value <= 0xFBE3 {
    return "ۉ".unicodeScalars
  }
  if value <= 0xFBE7 {
    return "ې".unicodeScalars
  }
  if value <= 0xFBE9 {
    return "ى".unicodeScalars
  }
  if value <= 0xFBEB {
    return "ي\u{0654}ا".unicodeScalars
  }
  if value <= 0xFBED {
    return "ي\u{0654}ە".unicodeScalars
  }
  if value <= 0xFBEF {
    return "ي\u{0654}و".unicodeScalars
  }
  if value <= 0xFBF1 {
    return "ي\u{0654}ۇ".unicodeScalars
  }
  if value <= 0xFBF3 {
    return "ي\u{0654}ۆ".unicodeScalars
  }
  if value <= 0xFBF5 {
    return "ي\u{0654}ۈ".unicodeScalars
  }
  if value <= 0xFBF8 {
    return "ي\u{0654}ې".unicodeScalars
  }
  if value <= 0xFBFB {
    return "ي\u{0654}ى".unicodeScalars
  }
  if value <= 0xFBFF {
    return "ی".unicodeScalars
  }
  if value <= 0xFC00 {
    return "ي\u{0654}ج".unicodeScalars
  }
  if value <= 0xFC01 {
    return "ي\u{0654}ح".unicodeScalars
  }
  if value <= 0xFC02 {
    return "ي\u{0654}م".unicodeScalars
  }
  if value <= 0xFC03 {
    return "ي\u{0654}ى".unicodeScalars
  }
  if value <= 0xFC04 {
    return "ي\u{0654}ي".unicodeScalars
  }
  if value <= 0xFC05 {
    return "بج".unicodeScalars
  }
  if value <= 0xFC06 {
    return "بح".unicodeScalars
  }
  if value <= 0xFC07 {
    return "بخ".unicodeScalars
  }
  if value <= 0xFC08 {
    return "بم".unicodeScalars
  }
  if value <= 0xFC09 {
    return "بى".unicodeScalars
  }
  if value <= 0xFC0A {
    return "بي".unicodeScalars
  }
  if value <= 0xFC0B {
    return "تج".unicodeScalars
  }
  if value <= 0xFC0C {
    return "تح".unicodeScalars
  }
  if value <= 0xFC0D {
    return "تخ".unicodeScalars
  }
  if value <= 0xFC0E {
    return "تم".unicodeScalars
  }
  if value <= 0xFC0F {
    return "تى".unicodeScalars
  }
  if value <= 0xFC10 {
    return "تي".unicodeScalars
  }
  if value <= 0xFC11 {
    return "ثج".unicodeScalars
  }
  if value <= 0xFC12 {
    return "ثم".unicodeScalars
  }
  if value <= 0xFC13 {
    return "ثى".unicodeScalars
  }
  if value <= 0xFC14 {
    return "ثي".unicodeScalars
  }
  if value <= 0xFC15 {
    return "جح".unicodeScalars
  }
  if value <= 0xFC16 {
    return "جم".unicodeScalars
  }
  if value <= 0xFC17 {
    return "حج".unicodeScalars
  }
  if value <= 0xFC18 {
    return "حم".unicodeScalars
  }
  if value <= 0xFC19 {
    return "خج".unicodeScalars
  }
  if value <= 0xFC1A {
    return "خح".unicodeScalars
  }
  if value <= 0xFC1B {
    return "خم".unicodeScalars
  }
  if value <= 0xFC1C {
    return "سج".unicodeScalars
  }
  if value <= 0xFC1D {
    return "سح".unicodeScalars
  }
  if value <= 0xFC1E {
    return "سخ".unicodeScalars
  }
  if value <= 0xFC1F {
    return "سم".unicodeScalars
  }
  if value <= 0xFC20 {
    return "صح".unicodeScalars
  }
  if value <= 0xFC21 {
    return "صم".unicodeScalars
  }
  if value <= 0xFC22 {
    return "ضج".unicodeScalars
  }
  if value <= 0xFC23 {
    return "ضح".unicodeScalars
  }
  if value <= 0xFC24 {
    return "ضخ".unicodeScalars
  }
  if value <= 0xFC25 {
    return "ضم".unicodeScalars
  }
  if value <= 0xFC26 {
    return "طح".unicodeScalars
  }
  if value <= 0xFC27 {
    return "طم".unicodeScalars
  }
  if value <= 0xFC28 {
    return "ظم".unicodeScalars
  }
  if value <= 0xFC29 {
    return "عج".unicodeScalars
  }
  if value <= 0xFC2A {
    return "عم".unicodeScalars
  }
  if value <= 0xFC2B {
    return "غج".unicodeScalars
  }
  if value <= 0xFC2C {
    return "غم".unicodeScalars
  }
  if value <= 0xFC2D {
    return "فج".unicodeScalars
  }
  if value <= 0xFC2E {
    return "فح".unicodeScalars
  }
  if value <= 0xFC2F {
    return "فخ".unicodeScalars
  }
  if value <= 0xFC30 {
    return "فم".unicodeScalars
  }
  if value <= 0xFC31 {
    return "فى".unicodeScalars
  }
  if value <= 0xFC32 {
    return "في".unicodeScalars
  }
  if value <= 0xFC33 {
    return "قح".unicodeScalars
  }
  if value <= 0xFC34 {
    return "قم".unicodeScalars
  }
  if value <= 0xFC35 {
    return "قى".unicodeScalars
  }
  if value <= 0xFC36 {
    return "قي".unicodeScalars
  }
  if value <= 0xFC37 {
    return "كا".unicodeScalars
  }
  if value <= 0xFC38 {
    return "كج".unicodeScalars
  }
  if value <= 0xFC39 {
    return "كح".unicodeScalars
  }
  if value <= 0xFC3A {
    return "كخ".unicodeScalars
  }
  if value <= 0xFC3B {
    return "كل".unicodeScalars
  }
  if value <= 0xFC3C {
    return "كم".unicodeScalars
  }
  if value <= 0xFC3D {
    return "كى".unicodeScalars
  }
  if value <= 0xFC3E {
    return "كي".unicodeScalars
  }
  if value <= 0xFC3F {
    return "لج".unicodeScalars
  }
  if value <= 0xFC40 {
    return "لح".unicodeScalars
  }
  if value <= 0xFC41 {
    return "لخ".unicodeScalars
  }
  if value <= 0xFC42 {
    return "لم".unicodeScalars
  }
  if value <= 0xFC43 {
    return "لى".unicodeScalars
  }
  if value <= 0xFC44 {
    return "لي".unicodeScalars
  }
  if value <= 0xFC45 {
    return "مج".unicodeScalars
  }
  if value <= 0xFC46 {
    return "مح".unicodeScalars
  }
  if value <= 0xFC47 {
    return "مخ".unicodeScalars
  }
  if value <= 0xFC48 {
    return "مم".unicodeScalars
  }
  if value <= 0xFC49 {
    return "مى".unicodeScalars
  }
  if value <= 0xFC4A {
    return "مي".unicodeScalars
  }
  if value <= 0xFC4B {
    return "نج".unicodeScalars
  }
  if value <= 0xFC4C {
    return "نح".unicodeScalars
  }
  if value <= 0xFC4D {
    return "نخ".unicodeScalars
  }
  if value <= 0xFC4E {
    return "نم".unicodeScalars
  }
  if value <= 0xFC4F {
    return "نى".unicodeScalars
  }
  if value <= 0xFC50 {
    return "ني".unicodeScalars
  }
  if value <= 0xFC51 {
    return "هج".unicodeScalars
  }
  if value <= 0xFC52 {
    return "هم".unicodeScalars
  }
  if value <= 0xFC53 {
    return "هى".unicodeScalars
  }
  if value <= 0xFC54 {
    return "هي".unicodeScalars
  }
  if value <= 0xFC55 {
    return "يج".unicodeScalars
  }
  if value <= 0xFC56 {
    return "يح".unicodeScalars
  }
  if value <= 0xFC57 {
    return "يخ".unicodeScalars
  }
  if value <= 0xFC58 {
    return "يم".unicodeScalars
  }
  if value <= 0xFC59 {
    return "يى".unicodeScalars
  }
  if value <= 0xFC5A {
    return "يي".unicodeScalars
  }
  if value <= 0xFC5B {
    return "ذ\u{0670}".unicodeScalars
  }
  if value <= 0xFC5C {
    return "ر\u{0670}".unicodeScalars
  }
  if value <= 0xFC5D {
    return "ى\u{0670}".unicodeScalars
  }
  if value <= 0xFC5E {
    return " \u{064C}\u{0651}".unicodeScalars
  }
  if value <= 0xFC5F {
    return " \u{064D}\u{0651}".unicodeScalars
  }
  if value <= 0xFC60 {
    return " \u{064E}\u{0651}".unicodeScalars
  }
  if value <= 0xFC61 {
    return " \u{064F}\u{0651}".unicodeScalars
  }
  if value <= 0xFC62 {
    return " \u{0650}\u{0651}".unicodeScalars
  }
  if value <= 0xFC63 {
    return " \u{0651}\u{0670}".unicodeScalars
  }
  if value <= 0xFC64 {
    return "ي\u{0654}ر".unicodeScalars
  }
  if value <= 0xFC65 {
    return "ي\u{0654}ز".unicodeScalars
  }
  if value <= 0xFC66 {
    return "ي\u{0654}م".unicodeScalars
  }
  if value <= 0xFC67 {
    return "ي\u{0654}ن".unicodeScalars
  }
  if value <= 0xFC68 {
    return "ي\u{0654}ى".unicodeScalars
  }
  if value <= 0xFC69 {
    return "ي\u{0654}ي".unicodeScalars
  }
  if value <= 0xFC6A {
    return "بر".unicodeScalars
  }
  if value <= 0xFC6B {
    return "بز".unicodeScalars
  }
  if value <= 0xFC6C {
    return "بم".unicodeScalars
  }
  if value <= 0xFC6D {
    return "بن".unicodeScalars
  }
  if value <= 0xFC6E {
    return "بى".unicodeScalars
  }
  if value <= 0xFC6F {
    return "بي".unicodeScalars
  }
  if value <= 0xFC70 {
    return "تر".unicodeScalars
  }
  if value <= 0xFC71 {
    return "تز".unicodeScalars
  }
  if value <= 0xFC72 {
    return "تم".unicodeScalars
  }
  if value <= 0xFC73 {
    return "تن".unicodeScalars
  }
  if value <= 0xFC74 {
    return "تى".unicodeScalars
  }
  if value <= 0xFC75 {
    return "تي".unicodeScalars
  }
  if value <= 0xFC76 {
    return "ثر".unicodeScalars
  }
  if value <= 0xFC77 {
    return "ثز".unicodeScalars
  }
  if value <= 0xFC78 {
    return "ثم".unicodeScalars
  }
  if value <= 0xFC79 {
    return "ثن".unicodeScalars
  }
  if value <= 0xFC7A {
    return "ثى".unicodeScalars
  }
  if value <= 0xFC7B {
    return "ثي".unicodeScalars
  }
  if value <= 0xFC7C {
    return "فى".unicodeScalars
  }
  if value <= 0xFC7D {
    return "في".unicodeScalars
  }
  if value <= 0xFC7E {
    return "قى".unicodeScalars
  }
  if value <= 0xFC7F {
    return "قي".unicodeScalars
  }
  if value <= 0xFC80 {
    return "كا".unicodeScalars
  }
  if value <= 0xFC81 {
    return "كل".unicodeScalars
  }
  if value <= 0xFC82 {
    return "كم".unicodeScalars
  }
  if value <= 0xFC83 {
    return "كى".unicodeScalars
  }
  if value <= 0xFC84 {
    return "كي".unicodeScalars
  }
  if value <= 0xFC85 {
    return "لم".unicodeScalars
  }
  if value <= 0xFC86 {
    return "لى".unicodeScalars
  }
  if value <= 0xFC87 {
    return "لي".unicodeScalars
  }
  if value <= 0xFC88 {
    return "ما".unicodeScalars
  }
  if value <= 0xFC89 {
    return "مم".unicodeScalars
  }
  if value <= 0xFC8A {
    return "نر".unicodeScalars
  }
  if value <= 0xFC8B {
    return "نز".unicodeScalars
  }
  if value <= 0xFC8C {
    return "نم".unicodeScalars
  }
  if value <= 0xFC8D {
    return "نن".unicodeScalars
  }
  if value <= 0xFC8E {
    return "نى".unicodeScalars
  }
  if value <= 0xFC8F {
    return "ني".unicodeScalars
  }
  if value <= 0xFC90 {
    return "ى\u{0670}".unicodeScalars
  }
  if value <= 0xFC91 {
    return "ير".unicodeScalars
  }
  if value <= 0xFC92 {
    return "يز".unicodeScalars
  }
  if value <= 0xFC93 {
    return "يم".unicodeScalars
  }
  if value <= 0xFC94 {
    return "ين".unicodeScalars
  }
  if value <= 0xFC95 {
    return "يى".unicodeScalars
  }
  if value <= 0xFC96 {
    return "يي".unicodeScalars
  }
  if value <= 0xFC97 {
    return "ي\u{0654}ج".unicodeScalars
  }
  if value <= 0xFC98 {
    return "ي\u{0654}ح".unicodeScalars
  }
  if value <= 0xFC99 {
    return "ي\u{0654}خ".unicodeScalars
  }
  if value <= 0xFC9A {
    return "ي\u{0654}م".unicodeScalars
  }
  if value <= 0xFC9B {
    return "ي\u{0654}ه".unicodeScalars
  }
  if value <= 0xFC9C {
    return "بج".unicodeScalars
  }
  if value <= 0xFC9D {
    return "بح".unicodeScalars
  }
  if value <= 0xFC9E {
    return "بخ".unicodeScalars
  }
  if value <= 0xFC9F {
    return "بم".unicodeScalars
  }
  if value <= 0xFCA0 {
    return "به".unicodeScalars
  }
  if value <= 0xFCA1 {
    return "تج".unicodeScalars
  }
  if value <= 0xFCA2 {
    return "تح".unicodeScalars
  }
  if value <= 0xFCA3 {
    return "تخ".unicodeScalars
  }
  if value <= 0xFCA4 {
    return "تم".unicodeScalars
  }
  if value <= 0xFCA5 {
    return "ته".unicodeScalars
  }
  if value <= 0xFCA6 {
    return "ثم".unicodeScalars
  }
  if value <= 0xFCA7 {
    return "جح".unicodeScalars
  }
  if value <= 0xFCA8 {
    return "جم".unicodeScalars
  }
  if value <= 0xFCA9 {
    return "حج".unicodeScalars
  }
  if value <= 0xFCAA {
    return "حم".unicodeScalars
  }
  if value <= 0xFCAB {
    return "خج".unicodeScalars
  }
  if value <= 0xFCAC {
    return "خم".unicodeScalars
  }
  if value <= 0xFCAD {
    return "سج".unicodeScalars
  }
  if value <= 0xFCAE {
    return "سح".unicodeScalars
  }
  if value <= 0xFCAF {
    return "سخ".unicodeScalars
  }
  if value <= 0xFCB0 {
    return "سم".unicodeScalars
  }
  if value <= 0xFCB1 {
    return "صح".unicodeScalars
  }
  if value <= 0xFCB2 {
    return "صخ".unicodeScalars
  }
  if value <= 0xFCB3 {
    return "صم".unicodeScalars
  }
  if value <= 0xFCB4 {
    return "ضج".unicodeScalars
  }
  if value <= 0xFCB5 {
    return "ضح".unicodeScalars
  }
  if value <= 0xFCB6 {
    return "ضخ".unicodeScalars
  }
  if value <= 0xFCB7 {
    return "ضم".unicodeScalars
  }
  if value <= 0xFCB8 {
    return "طح".unicodeScalars
  }
  if value <= 0xFCB9 {
    return "ظم".unicodeScalars
  }
  if value <= 0xFCBA {
    return "عج".unicodeScalars
  }
  if value <= 0xFCBB {
    return "عم".unicodeScalars
  }
  if value <= 0xFCBC {
    return "غج".unicodeScalars
  }
  if value <= 0xFCBD {
    return "غم".unicodeScalars
  }
  if value <= 0xFCBE {
    return "فج".unicodeScalars
  }
  if value <= 0xFCBF {
    return "فح".unicodeScalars
  }
  if value <= 0xFCC0 {
    return "فخ".unicodeScalars
  }
  if value <= 0xFCC1 {
    return "فم".unicodeScalars
  }
  if value <= 0xFCC2 {
    return "قح".unicodeScalars
  }
  if value <= 0xFCC3 {
    return "قم".unicodeScalars
  }
  if value <= 0xFCC4 {
    return "كج".unicodeScalars
  }
  if value <= 0xFCC5 {
    return "كح".unicodeScalars
  }
  if value <= 0xFCC6 {
    return "كخ".unicodeScalars
  }
  if value <= 0xFCC7 {
    return "كل".unicodeScalars
  }
  if value <= 0xFCC8 {
    return "كم".unicodeScalars
  }
  if value <= 0xFCC9 {
    return "لج".unicodeScalars
  }
  if value <= 0xFCCA {
    return "لح".unicodeScalars
  }
  if value <= 0xFCCB {
    return "لخ".unicodeScalars
  }
  if value <= 0xFCCC {
    return "لم".unicodeScalars
  }
  if value <= 0xFCCD {
    return "له".unicodeScalars
  }
  if value <= 0xFCCE {
    return "مج".unicodeScalars
  }
  if value <= 0xFCCF {
    return "مح".unicodeScalars
  }
  if value <= 0xFCD0 {
    return "مخ".unicodeScalars
  }
  if value <= 0xFCD1 {
    return "مم".unicodeScalars
  }
  if value <= 0xFCD2 {
    return "نج".unicodeScalars
  }
  if value <= 0xFCD3 {
    return "نح".unicodeScalars
  }
  if value <= 0xFCD4 {
    return "نخ".unicodeScalars
  }
  if value <= 0xFCD5 {
    return "نم".unicodeScalars
  }
  if value <= 0xFCD6 {
    return "نه".unicodeScalars
  }
  if value <= 0xFCD7 {
    return "هج".unicodeScalars
  }
  if value <= 0xFCD8 {
    return "هم".unicodeScalars
  }
  if value <= 0xFCD9 {
    return "ه\u{0670}".unicodeScalars
  }
  if value <= 0xFCDA {
    return "يج".unicodeScalars
  }
  if value <= 0xFCDB {
    return "يح".unicodeScalars
  }
  if value <= 0xFCDC {
    return "يخ".unicodeScalars
  }
  if value <= 0xFCDD {
    return "يم".unicodeScalars
  }
  if value <= 0xFCDE {
    return "يه".unicodeScalars
  }
  if value <= 0xFCDF {
    return "ي\u{0654}م".unicodeScalars
  }
  if value <= 0xFCE0 {
    return "ي\u{0654}ه".unicodeScalars
  }
  if value <= 0xFCE1 {
    return "بم".unicodeScalars
  }
  if value <= 0xFCE2 {
    return "به".unicodeScalars
  }
  if value <= 0xFCE3 {
    return "تم".unicodeScalars
  }
  if value <= 0xFCE4 {
    return "ته".unicodeScalars
  }
  if value <= 0xFCE5 {
    return "ثم".unicodeScalars
  }
  if value <= 0xFCE6 {
    return "ثه".unicodeScalars
  }
  if value <= 0xFCE7 {
    return "سم".unicodeScalars
  }
  if value <= 0xFCE8 {
    return "سه".unicodeScalars
  }
  if value <= 0xFCE9 {
    return "شم".unicodeScalars
  }
  if value <= 0xFCEA {
    return "شه".unicodeScalars
  }
  if value <= 0xFCEB {
    return "كل".unicodeScalars
  }
  if value <= 0xFCEC {
    return "كم".unicodeScalars
  }
  if value <= 0xFCED {
    return "لم".unicodeScalars
  }
  if value <= 0xFCEE {
    return "نم".unicodeScalars
  }
  if value <= 0xFCEF {
    return "نه".unicodeScalars
  }
  if value <= 0xFCF0 {
    return "يم".unicodeScalars
  }
  if value <= 0xFCF1 {
    return "يه".unicodeScalars
  }
  if value <= 0xFCF2 {
    return "ـ\u{064E}\u{0651}".unicodeScalars
  }
  if value <= 0xFCF3 {
    return "ـ\u{064F}\u{0651}".unicodeScalars
  }
  if value <= 0xFCF4 {
    return "ـ\u{0650}\u{0651}".unicodeScalars
  }
  if value <= 0xFCF5 {
    return "طى".unicodeScalars
  }
  if value <= 0xFCF6 {
    return "طي".unicodeScalars
  }
  if value <= 0xFCF7 {
    return "عى".unicodeScalars
  }
  if value <= 0xFCF8 {
    return "عي".unicodeScalars
  }
  if value <= 0xFCF9 {
    return "غى".unicodeScalars
  }
  if value <= 0xFCFA {
    return "غي".unicodeScalars
  }
  if value <= 0xFCFB {
    return "سى".unicodeScalars
  }
  if value <= 0xFCFC {
    return "سي".unicodeScalars
  }
  if value <= 0xFCFD {
    return "شى".unicodeScalars
  }
  if value <= 0xFCFE {
    return "شي".unicodeScalars
  }
  if value <= 0xFCFF {
    return "حى".unicodeScalars
  }
  if value <= 0xFD00 {
    return "حي".unicodeScalars
  }
  if value <= 0xFD01 {
    return "جى".unicodeScalars
  }
  if value <= 0xFD02 {
    return "جي".unicodeScalars
  }
  if value <= 0xFD03 {
    return "خى".unicodeScalars
  }
  if value <= 0xFD04 {
    return "خي".unicodeScalars
  }
  if value <= 0xFD05 {
    return "صى".unicodeScalars
  }
  if value <= 0xFD06 {
    return "صي".unicodeScalars
  }
  if value <= 0xFD07 {
    return "ضى".unicodeScalars
  }
  if value <= 0xFD08 {
    return "ضي".unicodeScalars
  }
  if value <= 0xFD09 {
    return "شج".unicodeScalars
  }
  if value <= 0xFD0A {
    return "شح".unicodeScalars
  }
  if value <= 0xFD0B {
    return "شخ".unicodeScalars
  }
  if value <= 0xFD0C {
    return "شم".unicodeScalars
  }
  if value <= 0xFD0D {
    return "شر".unicodeScalars
  }
  if value <= 0xFD0E {
    return "سر".unicodeScalars
  }
  if value <= 0xFD0F {
    return "صر".unicodeScalars
  }
  if value <= 0xFD10 {
    return "ضر".unicodeScalars
  }
  if value <= 0xFD11 {
    return "طى".unicodeScalars
  }
  if value <= 0xFD12 {
    return "طي".unicodeScalars
  }
  if value <= 0xFD13 {
    return "عى".unicodeScalars
  }
  if value <= 0xFD14 {
    return "عي".unicodeScalars
  }
  if value <= 0xFD15 {
    return "غى".unicodeScalars
  }
  if value <= 0xFD16 {
    return "غي".unicodeScalars
  }
  if value <= 0xFD17 {
    return "سى".unicodeScalars
  }
  if value <= 0xFD18 {
    return "سي".unicodeScalars
  }
  if value <= 0xFD19 {
    return "شى".unicodeScalars
  }
  if value <= 0xFD1A {
    return "شي".unicodeScalars
  }
  if value <= 0xFD1B {
    return "حى".unicodeScalars
  }
  if value <= 0xFD1C {
    return "حي".unicodeScalars
  }
  if value <= 0xFD1D {
    return "جى".unicodeScalars
  }
  if value <= 0xFD1E {
    return "جي".unicodeScalars
  }
  if value <= 0xFD1F {
    return "خى".unicodeScalars
  }
  if value <= 0xFD20 {
    return "خي".unicodeScalars
  }
  if value <= 0xFD21 {
    return "صى".unicodeScalars
  }
  if value <= 0xFD22 {
    return "صي".unicodeScalars
  }
  if value <= 0xFD23 {
    return "ضى".unicodeScalars
  }
  if value <= 0xFD24 {
    return "ضي".unicodeScalars
  }
  if value <= 0xFD25 {
    return "شج".unicodeScalars
  }
  if value <= 0xFD26 {
    return "شح".unicodeScalars
  }
  if value <= 0xFD27 {
    return "شخ".unicodeScalars
  }
  if value <= 0xFD28 {
    return "شم".unicodeScalars
  }
  if value <= 0xFD29 {
    return "شر".unicodeScalars
  }
  if value <= 0xFD2A {
    return "سر".unicodeScalars
  }
  if value <= 0xFD2B {
    return "صر".unicodeScalars
  }
  if value <= 0xFD2C {
    return "ضر".unicodeScalars
  }
  if value <= 0xFD2D {
    return "شج".unicodeScalars
  }
  if value <= 0xFD2E {
    return "شح".unicodeScalars
  }
  if value <= 0xFD2F {
    return "شخ".unicodeScalars
  }
  if value <= 0xFD30 {
    return "شم".unicodeScalars
  }
  if value <= 0xFD31 {
    return "سه".unicodeScalars
  }
  if value <= 0xFD32 {
    return "شه".unicodeScalars
  }
  if value <= 0xFD33 {
    return "طم".unicodeScalars
  }
  if value <= 0xFD34 {
    return "سج".unicodeScalars
  }
  if value <= 0xFD35 {
    return "سح".unicodeScalars
  }
  if value <= 0xFD36 {
    return "سخ".unicodeScalars
  }
  if value <= 0xFD37 {
    return "شج".unicodeScalars
  }
  if value <= 0xFD38 {
    return "شح".unicodeScalars
  }
  if value <= 0xFD39 {
    return "شخ".unicodeScalars
  }
  if value <= 0xFD3A {
    return "طم".unicodeScalars
  }
  if value <= 0xFD3B {
    return "ظم".unicodeScalars
  }
  if value <= 0xFD3D {
    return "ا\u{064B}".unicodeScalars
  }
  if value <= 0xFD4F {
    return String(scalar).unicodeScalars
  }
  if value <= 0xFD50 {
    return "تجم".unicodeScalars
  }
  if value <= 0xFD52 {
    return "تحج".unicodeScalars
  }
  if value <= 0xFD53 {
    return "تحم".unicodeScalars
  }
  if value <= 0xFD54 {
    return "تخم".unicodeScalars
  }
  if value <= 0xFD55 {
    return "تمج".unicodeScalars
  }
  if value <= 0xFD56 {
    return "تمح".unicodeScalars
  }
  if value <= 0xFD57 {
    return "تمخ".unicodeScalars
  }
  if value <= 0xFD59 {
    return "جمح".unicodeScalars
  }
  if value <= 0xFD5A {
    return "حمي".unicodeScalars
  }
  if value <= 0xFD5B {
    return "حمى".unicodeScalars
  }
  if value <= 0xFD5C {
    return "سحج".unicodeScalars
  }
  if value <= 0xFD5D {
    return "سجح".unicodeScalars
  }
  if value <= 0xFD5E {
    return "سجى".unicodeScalars
  }
  if value <= 0xFD60 {
    return "سمح".unicodeScalars
  }
  if value <= 0xFD61 {
    return "سمج".unicodeScalars
  }
  if value <= 0xFD63 {
    return "سمم".unicodeScalars
  }
  if value <= 0xFD65 {
    return "صحح".unicodeScalars
  }
  if value <= 0xFD66 {
    return "صمم".unicodeScalars
  }
  if value <= 0xFD68 {
    return "شحم".unicodeScalars
  }
  if value <= 0xFD69 {
    return "شجي".unicodeScalars
  }
  if value <= 0xFD6B {
    return "شمخ".unicodeScalars
  }
  if value <= 0xFD6D {
    return "شمم".unicodeScalars
  }
  if value <= 0xFD6E {
    return "ضحى".unicodeScalars
  }
  if value <= 0xFD70 {
    return "ضخم".unicodeScalars
  }
  if value <= 0xFD72 {
    return "طمح".unicodeScalars
  }
  if value <= 0xFD73 {
    return "طمم".unicodeScalars
  }
  if value <= 0xFD74 {
    return "طمي".unicodeScalars
  }
  if value <= 0xFD75 {
    return "عجم".unicodeScalars
  }
  if value <= 0xFD77 {
    return "عمم".unicodeScalars
  }
  if value <= 0xFD78 {
    return "عمى".unicodeScalars
  }
  if value <= 0xFD79 {
    return "غمم".unicodeScalars
  }
  if value <= 0xFD7A {
    return "غمي".unicodeScalars
  }
  if value <= 0xFD7B {
    return "غمى".unicodeScalars
  }
  if value <= 0xFD7D {
    return "فخم".unicodeScalars
  }
  if value <= 0xFD7E {
    return "قمح".unicodeScalars
  }
  if value <= 0xFD7F {
    return "قمم".unicodeScalars
  }
  if value <= 0xFD80 {
    return "لحم".unicodeScalars
  }
  if value <= 0xFD81 {
    return "لحي".unicodeScalars
  }
  if value <= 0xFD82 {
    return "لحى".unicodeScalars
  }
  if value <= 0xFD84 {
    return "لجج".unicodeScalars
  }
  if value <= 0xFD86 {
    return "لخم".unicodeScalars
  }
  if value <= 0xFD88 {
    return "لمح".unicodeScalars
  }
  if value <= 0xFD89 {
    return "محج".unicodeScalars
  }
  if value <= 0xFD8A {
    return "محم".unicodeScalars
  }
  if value <= 0xFD8B {
    return "محي".unicodeScalars
  }
  if value <= 0xFD8C {
    return "مجح".unicodeScalars
  }
  if value <= 0xFD8D {
    return "مجم".unicodeScalars
  }
  if value <= 0xFD8E {
    return "مخج".unicodeScalars
  }
  if value <= 0xFD8F {
    return "مخم".unicodeScalars
  }
  if value <= 0xFD91 {
    return String(scalar).unicodeScalars
  }
  if value <= 0xFD92 {
    return "مجخ".unicodeScalars
  }
  if value <= 0xFD93 {
    return "همج".unicodeScalars
  }
  if value <= 0xFD94 {
    return "همم".unicodeScalars
  }
  if value <= 0xFD95 {
    return "نحم".unicodeScalars
  }
  if value <= 0xFD96 {
    return "نحى".unicodeScalars
  }
  if value <= 0xFD98 {
    return "نجم".unicodeScalars
  }
  if value <= 0xFD99 {
    return "نجى".unicodeScalars
  }
  if value <= 0xFD9A {
    return "نمي".unicodeScalars
  }
  if value <= 0xFD9B {
    return "نمى".unicodeScalars
  }
  if value <= 0xFD9D {
    return "يمم".unicodeScalars
  }
  if value <= 0xFD9E {
    return "بخي".unicodeScalars
  }
  if value <= 0xFD9F {
    return "تجي".unicodeScalars
  }
  if value <= 0xFDA0 {
    return "تجى".unicodeScalars
  }
  if value <= 0xFDA1 {
    return "تخي".unicodeScalars
  }
  if value <= 0xFDA2 {
    return "تخى".unicodeScalars
  }
  if value <= 0xFDA3 {
    return "تمي".unicodeScalars
  }
  if value <= 0xFDA4 {
    return "تمى".unicodeScalars
  }
  if value <= 0xFDA5 {
    return "جمي".unicodeScalars
  }
  if value <= 0xFDA6 {
    return "جحى".unicodeScalars
  }
  if value <= 0xFDA7 {
    return "جمى".unicodeScalars
  }
  if value <= 0xFDA8 {
    return "سخى".unicodeScalars
  }
  if value <= 0xFDA9 {
    return "صحي".unicodeScalars
  }
  if value <= 0xFDAA {
    return "شحي".unicodeScalars
  }
  if value <= 0xFDAB {
    return "ضحي".unicodeScalars
  }
  if value <= 0xFDAC {
    return "لجي".unicodeScalars
  }
  if value <= 0xFDAD {
    return "لمي".unicodeScalars
  }
  if value <= 0xFDAE {
    return "يحي".unicodeScalars
  }
  if value <= 0xFDAF {
    return "يجي".unicodeScalars
  }
  if value <= 0xFDB0 {
    return "يمي".unicodeScalars
  }
  if value <= 0xFDB1 {
    return "ممي".unicodeScalars
  }
  if value <= 0xFDB2 {
    return "قمي".unicodeScalars
  }
  if value <= 0xFDB3 {
    return "نحي".unicodeScalars
  }
  if value <= 0xFDB4 {
    return "قمح".unicodeScalars
  }
  if value <= 0xFDB5 {
    return "لحم".unicodeScalars
  }
  if value <= 0xFDB6 {
    return "عمي".unicodeScalars
  }
  if value <= 0xFDB7 {
    return "كمي".unicodeScalars
  }
  if value <= 0xFDB8 {
    return "نجح".unicodeScalars
  }
  if value <= 0xFDB9 {
    return "مخي".unicodeScalars
  }
  if value <= 0xFDBA {
    return "لجم".unicodeScalars
  }
  if value <= 0xFDBB {
    return "كمم".unicodeScalars
  }
  if value <= 0xFDBC {
    return "لجم".unicodeScalars
  }
  if value <= 0xFDBD {
    return "نجح".unicodeScalars
  }
  if value <= 0xFDBE {
    return "جحي".unicodeScalars
  }
  if value <= 0xFDBF {
    return "حجي".unicodeScalars
  }
  if value <= 0xFDC0 {
    return "مجي".unicodeScalars
  }
  if value <= 0xFDC1 {
    return "فمي".unicodeScalars
  }
  if value <= 0xFDC2 {
    return "بحي".unicodeScalars
  }
  if value <= 0xFDC3 {
    return "كمم".unicodeScalars
  }
  if value <= 0xFDC4 {
    return "عجم".unicodeScalars
  }
  if value <= 0xFDC5 {
    return "صمم".unicodeScalars
  }
  if value <= 0xFDC6 {
    return "سخي".unicodeScalars
  }
  if value <= 0xFDC7 {
    return "نجي".unicodeScalars
  }
  if value <= 0xFDEF {
    return String(scalar).unicodeScalars
  }
  if value <= 0xFDF0 {
    return "صلے".unicodeScalars
  }
  if value <= 0xFDF1 {
    return "قلے".unicodeScalars
  }
  if value <= 0xFDF2 {
    return "الله".unicodeScalars
  }
  if value <= 0xFDF3 {
    return "اكبر".unicodeScalars
  }
  if value <= 0xFDF4 {
    return "محمد".unicodeScalars
  }
  if value <= 0xFDF5 {
    return "صلعم".unicodeScalars
  }
  if value <= 0xFDF6 {
    return "رسول".unicodeScalars
  }
  if value <= 0xFDF7 {
    return "عليه".unicodeScalars
  }
  if value <= 0xFDF8 {
    return "وسلم".unicodeScalars
  }
  if value <= 0xFDF9 {
    return "صلى".unicodeScalars
  }
  if value <= 0xFDFA {
    return "صلى الله عليه وسلم".unicodeScalars
  }
  if value <= 0xFDFB {
    return "جل جلاله".unicodeScalars
  }
  if value <= 0xFDFC {
    return "ریال".unicodeScalars
  }
  if value <= 0xFE0F {
    return String(scalar).unicodeScalars
  }
  if value <= 0xFE10 {
    return ",".unicodeScalars
  }
  if value <= 0xFE11 {
    return "、".unicodeScalars
  }
  if value <= 0xFE12 {
    return "。".unicodeScalars
  }
  if value <= 0xFE13 {
    return ":".unicodeScalars
  }
  if value <= 0xFE14 {
    return ";".unicodeScalars
  }
  if value <= 0xFE15 {
    return "!".unicodeScalars
  }
  if value <= 0xFE16 {
    return "?".unicodeScalars
  }
  if value <= 0xFE17 {
    return "〖".unicodeScalars
  }
  if value <= 0xFE18 {
    return "〗".unicodeScalars
  }
  if value <= 0xFE19 {
    return "...".unicodeScalars
  }
  if value <= 0xFE2F {
    return String(scalar).unicodeScalars
  }
  if value <= 0xFE30 {
    return "..".unicodeScalars
  }
  if value <= 0xFE31 {
    return "—".unicodeScalars
  }
  if value <= 0xFE32 {
    return "–".unicodeScalars
  }
  if value <= 0xFE34 {
    return "_".unicodeScalars
  }
  if value <= 0xFE35 {
    return "(".unicodeScalars
  }
  if value <= 0xFE36 {
    return ")".unicodeScalars
  }
  if value <= 0xFE37 {
    return "{".unicodeScalars
  }
  if value <= 0xFE38 {
    return "}".unicodeScalars
  }
  if value <= 0xFE39 {
    return "〔".unicodeScalars
  }
  if value <= 0xFE3A {
    return "〕".unicodeScalars
  }
  if value <= 0xFE3B {
    return "【".unicodeScalars
  }
  if value <= 0xFE3C {
    return "】".unicodeScalars
  }
  if value <= 0xFE3D {
    return "《".unicodeScalars
  }
  if value <= 0xFE3E {
    return "》".unicodeScalars
  }
  if value <= 0xFE3F {
    return "〈".unicodeScalars
  }
  if value <= 0xFE40 {
    return "〉".unicodeScalars
  }
  if value <= 0xFE41 {
    return "「".unicodeScalars
  }
  if value <= 0xFE42 {
    return "」".unicodeScalars
  }
  if value <= 0xFE43 {
    return "『".unicodeScalars
  }
  if value <= 0xFE44 {
    return "』".unicodeScalars
  }
  if value <= 0xFE46 {
    return String(scalar).unicodeScalars
  }
  if value <= 0xFE47 {
    return "[".unicodeScalars
  }
  if value <= 0xFE48 {
    return "]".unicodeScalars
  }
  if value <= 0xFE4C {
    return " \u{0305}".unicodeScalars
  }
  if value <= 0xFE4F {
    return "_".unicodeScalars
  }
  if value <= 0xFE50 {
    return ",".unicodeScalars
  }
  if value <= 0xFE51 {
    return "、".unicodeScalars
  }
  if value <= 0xFE52 {
    return ".".unicodeScalars
  }
  if value <= 0xFE53 {
    return String(scalar).unicodeScalars
  }
  if value <= 0xFE54 {
    return ";".unicodeScalars
  }
  if value <= 0xFE55 {
    return ":".unicodeScalars
  }
  if value <= 0xFE56 {
    return "?".unicodeScalars
  }
  if value <= 0xFE57 {
    return "!".unicodeScalars
  }
  if value <= 0xFE58 {
    return "—".unicodeScalars
  }
  if value <= 0xFE59 {
    return "(".unicodeScalars
  }
  if value <= 0xFE5A {
    return ")".unicodeScalars
  }
  if value <= 0xFE5B {
    return "{".unicodeScalars
  }
  if value <= 0xFE5C {
    return "}".unicodeScalars
  }
  if value <= 0xFE5D {
    return "〔".unicodeScalars
  }
  if value <= 0xFE5E {
    return "〕".unicodeScalars
  }
  if value <= 0xFE5F {
    return "#".unicodeScalars
  }
  if value <= 0xFE60 {
    return "&".unicodeScalars
  }
  if value <= 0xFE61 {
    return "*".unicodeScalars
  }
  if value <= 0xFE62 {
    return "+".unicodeScalars
  }
  if value <= 0xFE63 {
    return "-".unicodeScalars
  }
  if value <= 0xFE64 {
    return "<".unicodeScalars
  }
  if value <= 0xFE65 {
    return ">".unicodeScalars
  }
  if value <= 0xFE66 {
    return "=".unicodeScalars
  }
  if value <= 0xFE67 {
    return String(scalar).unicodeScalars
  }
  if value <= 0xFE68 {
    return "\u{005C}".unicodeScalars
  }
  if value <= 0xFE69 {
    return "$".unicodeScalars
  }
  if value <= 0xFE6A {
    return "%".unicodeScalars
  }
  if value <= 0xFE6B {
    return "@".unicodeScalars
  }
  if value <= 0xFE6F {
    return String(scalar).unicodeScalars
  }
  if value <= 0xFE70 {
    return " \u{064B}".unicodeScalars
  }
  if value <= 0xFE71 {
    return "ـ\u{064B}".unicodeScalars
  }
  if value <= 0xFE72 {
    return " \u{064C}".unicodeScalars
  }
  if value <= 0xFE73 {
    return String(scalar).unicodeScalars
  }
  if value <= 0xFE74 {
    return " \u{064D}".unicodeScalars
  }
  if value <= 0xFE75 {
    return String(scalar).unicodeScalars
  }
  if value <= 0xFE76 {
    return " \u{064E}".unicodeScalars
  }
  if value <= 0xFE77 {
    return "ـ\u{064E}".unicodeScalars
  }
  if value <= 0xFE78 {
    return " \u{064F}".unicodeScalars
  }
  if value <= 0xFE79 {
    return "ـ\u{064F}".unicodeScalars
  }
  if value <= 0xFE7A {
    return " \u{0650}".unicodeScalars
  }
  if value <= 0xFE7B {
    return "ـ\u{0650}".unicodeScalars
  }
  if value <= 0xFE7C {
    return " \u{0651}".unicodeScalars
  }
  if value <= 0xFE7D {
    return "ـ\u{0651}".unicodeScalars
  }
  if value <= 0xFE7E {
    return " \u{0652}".unicodeScalars
  }
  if value <= 0xFE7F {
    return "ـ\u{0652}".unicodeScalars
  }
  if value <= 0xFE80 {
    return "ء".unicodeScalars
  }
  if value <= 0xFE82 {
    return "ا\u{0653}".unicodeScalars
  }
  if value <= 0xFE84 {
    return "ا\u{0654}".unicodeScalars
  }
  if value <= 0xFE86 {
    return "و\u{0654}".unicodeScalars
  }
  if value <= 0xFE88 {
    return "ا\u{0655}".unicodeScalars
  }
  if value <= 0xFE8C {
    return "ي\u{0654}".unicodeScalars
  }
  if value <= 0xFE8E {
    return "ا".unicodeScalars
  }
  if value <= 0xFE92 {
    return "ب".unicodeScalars
  }
  if value <= 0xFE94 {
    return "ة".unicodeScalars
  }
  if value <= 0xFE98 {
    return "ت".unicodeScalars
  }
  if value <= 0xFE9C {
    return "ث".unicodeScalars
  }
  if value <= 0xFEA0 {
    return "ج".unicodeScalars
  }
  if value <= 0xFEA4 {
    return "ح".unicodeScalars
  }
  if value <= 0xFEA8 {
    return "خ".unicodeScalars
  }
  if value <= 0xFEAA {
    return "د".unicodeScalars
  }
  if value <= 0xFEAC {
    return "ذ".unicodeScalars
  }
  if value <= 0xFEAE {
    return "ر".unicodeScalars
  }
  if value <= 0xFEB0 {
    return "ز".unicodeScalars
  }
  if value <= 0xFEB4 {
    return "س".unicodeScalars
  }
  if value <= 0xFEB8 {
    return "ش".unicodeScalars
  }
  if value <= 0xFEBC {
    return "ص".unicodeScalars
  }
  if value <= 0xFEC0 {
    return "ض".unicodeScalars
  }
  if value <= 0xFEC4 {
    return "ط".unicodeScalars
  }
  if value <= 0xFEC8 {
    return "ظ".unicodeScalars
  }
  if value <= 0xFECC {
    return "ع".unicodeScalars
  }
  if value <= 0xFED0 {
    return "غ".unicodeScalars
  }
  if value <= 0xFED4 {
    return "ف".unicodeScalars
  }
  if value <= 0xFED8 {
    return "ق".unicodeScalars
  }
  if value <= 0xFEDC {
    return "ك".unicodeScalars
  }
  if value <= 0xFEE0 {
    return "ل".unicodeScalars
  }
  if value <= 0xFEE4 {
    return "م".unicodeScalars
  }
  if value <= 0xFEE8 {
    return "ن".unicodeScalars
  }
  if value <= 0xFEEC {
    return "ه".unicodeScalars
  }
  if value <= 0xFEEE {
    return "و".unicodeScalars
  }
  if value <= 0xFEF0 {
    return "ى".unicodeScalars
  }
  if value <= 0xFEF4 {
    return "ي".unicodeScalars
  }
  if value <= 0xFEF6 {
    return "لا\u{0653}".unicodeScalars
  }
  if value <= 0xFEF8 {
    return "لا\u{0654}".unicodeScalars
  }
  if value <= 0xFEFA {
    return "لا\u{0655}".unicodeScalars
  }
  if value <= 0xFEFC {
    return "لا".unicodeScalars
  }
  if value <= 0xFF00 {
    return String(scalar).unicodeScalars
  }
  if value <= 0xFF01 {
    return "!".unicodeScalars
  }
  if value <= 0xFF02 {
    return "\u{0022}".unicodeScalars
  }
  if value <= 0xFF03 {
    return "#".unicodeScalars
  }
  if value <= 0xFF04 {
    return "$".unicodeScalars
  }
  if value <= 0xFF05 {
    return "%".unicodeScalars
  }
  if value <= 0xFF06 {
    return "&".unicodeScalars
  }
  if value <= 0xFF07 {
    return "'".unicodeScalars
  }
  if value <= 0xFF08 {
    return "(".unicodeScalars
  }
  if value <= 0xFF09 {
    return ")".unicodeScalars
  }
  if value <= 0xFF0A {
    return "*".unicodeScalars
  }
  if value <= 0xFF0B {
    return "+".unicodeScalars
  }
  if value <= 0xFF0C {
    return ",".unicodeScalars
  }
  if value <= 0xFF0D {
    return "-".unicodeScalars
  }
  if value <= 0xFF0E {
    return ".".unicodeScalars
  }
  if value <= 0xFF0F {
    return "/".unicodeScalars
  }
  if value <= 0xFF10 {
    return "0".unicodeScalars
  }
  if value <= 0xFF11 {
    return "1".unicodeScalars
  }
  if value <= 0xFF12 {
    return "2".unicodeScalars
  }
  if value <= 0xFF13 {
    return "3".unicodeScalars
  }
  if value <= 0xFF14 {
    return "4".unicodeScalars
  }
  if value <= 0xFF15 {
    return "5".unicodeScalars
  }
  if value <= 0xFF16 {
    return "6".unicodeScalars
  }
  if value <= 0xFF17 {
    return "7".unicodeScalars
  }
  if value <= 0xFF18 {
    return "8".unicodeScalars
  }
  if value <= 0xFF19 {
    return "9".unicodeScalars
  }
  if value <= 0xFF1A {
    return ":".unicodeScalars
  }
  if value <= 0xFF1B {
    return ";".unicodeScalars
  }
  if value <= 0xFF1C {
    return "<".unicodeScalars
  }
  if value <= 0xFF1D {
    return "=".unicodeScalars
  }
  if value <= 0xFF1E {
    return ">".unicodeScalars
  }
  if value <= 0xFF1F {
    return "?".unicodeScalars
  }
  if value <= 0xFF20 {
    return "@".unicodeScalars
  }
  if value <= 0xFF21 {
    return "A".unicodeScalars
  }
  if value <= 0xFF22 {
    return "B".unicodeScalars
  }
  if value <= 0xFF23 {
    return "C".unicodeScalars
  }
  if value <= 0xFF24 {
    return "D".unicodeScalars
  }
  if value <= 0xFF25 {
    return "E".unicodeScalars
  }
  if value <= 0xFF26 {
    return "F".unicodeScalars
  }
  if value <= 0xFF27 {
    return "G".unicodeScalars
  }
  if value <= 0xFF28 {
    return "H".unicodeScalars
  }
  if value <= 0xFF29 {
    return "I".unicodeScalars
  }
  if value <= 0xFF2A {
    return "J".unicodeScalars
  }
  if value <= 0xFF2B {
    return "K".unicodeScalars
  }
  if value <= 0xFF2C {
    return "L".unicodeScalars
  }
  if value <= 0xFF2D {
    return "M".unicodeScalars
  }
  if value <= 0xFF2E {
    return "N".unicodeScalars
  }
  if value <= 0xFF2F {
    return "O".unicodeScalars
  }
  if value <= 0xFF30 {
    return "P".unicodeScalars
  }
  if value <= 0xFF31 {
    return "Q".unicodeScalars
  }
  if value <= 0xFF32 {
    return "R".unicodeScalars
  }
  if value <= 0xFF33 {
    return "S".unicodeScalars
  }
  if value <= 0xFF34 {
    return "T".unicodeScalars
  }
  if value <= 0xFF35 {
    return "U".unicodeScalars
  }
  if value <= 0xFF36 {
    return "V".unicodeScalars
  }
  if value <= 0xFF37 {
    return "W".unicodeScalars
  }
  if value <= 0xFF38 {
    return "X".unicodeScalars
  }
  if value <= 0xFF39 {
    return "Y".unicodeScalars
  }
  if value <= 0xFF3A {
    return "Z".unicodeScalars
  }
  if value <= 0xFF3B {
    return "[".unicodeScalars
  }
  if value <= 0xFF3C {
    return "\u{005C}".unicodeScalars
  }
  if value <= 0xFF3D {
    return "]".unicodeScalars
  }
  if value <= 0xFF3E {
    return "^".unicodeScalars
  }
  if value <= 0xFF3F {
    return "_".unicodeScalars
  }
  if value <= 0xFF40 {
    return "`".unicodeScalars
  }
  if value <= 0xFF41 {
    return "a".unicodeScalars
  }
  if value <= 0xFF42 {
    return "b".unicodeScalars
  }
  if value <= 0xFF43 {
    return "c".unicodeScalars
  }
  if value <= 0xFF44 {
    return "d".unicodeScalars
  }
  if value <= 0xFF45 {
    return "e".unicodeScalars
  }
  if value <= 0xFF46 {
    return "f".unicodeScalars
  }
  if value <= 0xFF47 {
    return "g".unicodeScalars
  }
  if value <= 0xFF48 {
    return "h".unicodeScalars
  }
  if value <= 0xFF49 {
    return "i".unicodeScalars
  }
  if value <= 0xFF4A {
    return "j".unicodeScalars
  }
  if value <= 0xFF4B {
    return "k".unicodeScalars
  }
  if value <= 0xFF4C {
    return "l".unicodeScalars
  }
  if value <= 0xFF4D {
    return "m".unicodeScalars
  }
  if value <= 0xFF4E {
    return "n".unicodeScalars
  }
  if value <= 0xFF4F {
    return "o".unicodeScalars
  }
  if value <= 0xFF50 {
    return "p".unicodeScalars
  }
  if value <= 0xFF51 {
    return "q".unicodeScalars
  }
  if value <= 0xFF52 {
    return "r".unicodeScalars
  }
  if value <= 0xFF53 {
    return "s".unicodeScalars
  }
  if value <= 0xFF54 {
    return "t".unicodeScalars
  }
  if value <= 0xFF55 {
    return "u".unicodeScalars
  }
  if value <= 0xFF56 {
    return "v".unicodeScalars
  }
  if value <= 0xFF57 {
    return "w".unicodeScalars
  }
  if value <= 0xFF58 {
    return "x".unicodeScalars
  }
  if value <= 0xFF59 {
    return "y".unicodeScalars
  }
  if value <= 0xFF5A {
    return "z".unicodeScalars
  }
  if value <= 0xFF5B {
    return "{".unicodeScalars
  }
  if value <= 0xFF5C {
    return "|".unicodeScalars
  }
  if value <= 0xFF5D {
    return "}".unicodeScalars
  }
  if value <= 0xFF5E {
    return "~".unicodeScalars
  }
  if value <= 0xFF5F {
    return "⦅".unicodeScalars
  }
  if value <= 0xFF60 {
    return "⦆".unicodeScalars
  }
  if value <= 0xFF61 {
    return "。".unicodeScalars
  }
  if value <= 0xFF62 {
    return "「".unicodeScalars
  }
  if value <= 0xFF63 {
    return "」".unicodeScalars
  }
  if value <= 0xFF64 {
    return "、".unicodeScalars
  }
  if value <= 0xFF65 {
    return "・".unicodeScalars
  }
  if value <= 0xFF66 {
    return "ヲ".unicodeScalars
  }
  if value <= 0xFF67 {
    return "ァ".unicodeScalars
  }
  if value <= 0xFF68 {
    return "ィ".unicodeScalars
  }
  if value <= 0xFF69 {
    return "ゥ".unicodeScalars
  }
  if value <= 0xFF6A {
    return "ェ".unicodeScalars
  }
  if value <= 0xFF6B {
    return "ォ".unicodeScalars
  }
  if value <= 0xFF6C {
    return "ャ".unicodeScalars
  }
  if value <= 0xFF6D {
    return "ュ".unicodeScalars
  }
  if value <= 0xFF6E {
    return "ョ".unicodeScalars
  }
  if value <= 0xFF6F {
    return "ッ".unicodeScalars
  }
  if value <= 0xFF70 {
    return "ー".unicodeScalars
  }
  if value <= 0xFF71 {
    return "ア".unicodeScalars
  }
  if value <= 0xFF72 {
    return "イ".unicodeScalars
  }
  if value <= 0xFF73 {
    return "ウ".unicodeScalars
  }
  if value <= 0xFF74 {
    return "エ".unicodeScalars
  }
  if value <= 0xFF75 {
    return "オ".unicodeScalars
  }
  if value <= 0xFF76 {
    return "カ".unicodeScalars
  }
  if value <= 0xFF77 {
    return "キ".unicodeScalars
  }
  if value <= 0xFF78 {
    return "ク".unicodeScalars
  }
  if value <= 0xFF79 {
    return "ケ".unicodeScalars
  }
  if value <= 0xFF7A {
    return "コ".unicodeScalars
  }
  if value <= 0xFF7B {
    return "サ".unicodeScalars
  }
  if value <= 0xFF7C {
    return "シ".unicodeScalars
  }
  if value <= 0xFF7D {
    return "ス".unicodeScalars
  }
  if value <= 0xFF7E {
    return "セ".unicodeScalars
  }
  if value <= 0xFF7F {
    return "ソ".unicodeScalars
  }
  if value <= 0xFF80 {
    return "タ".unicodeScalars
  }
  if value <= 0xFF81 {
    return "チ".unicodeScalars
  }
  if value <= 0xFF82 {
    return "ツ".unicodeScalars
  }
  if value <= 0xFF83 {
    return "テ".unicodeScalars
  }
  if value <= 0xFF84 {
    return "ト".unicodeScalars
  }
  if value <= 0xFF85 {
    return "ナ".unicodeScalars
  }
  if value <= 0xFF86 {
    return "ニ".unicodeScalars
  }
  if value <= 0xFF87 {
    return "ヌ".unicodeScalars
  }
  if value <= 0xFF88 {
    return "ネ".unicodeScalars
  }
  if value <= 0xFF89 {
    return "ノ".unicodeScalars
  }
  if value <= 0xFF8A {
    return "ハ".unicodeScalars
  }
  if value <= 0xFF8B {
    return "ヒ".unicodeScalars
  }
  if value <= 0xFF8C {
    return "フ".unicodeScalars
  }
  if value <= 0xFF8D {
    return "ヘ".unicodeScalars
  }
  if value <= 0xFF8E {
    return "ホ".unicodeScalars
  }
  if value <= 0xFF8F {
    return "マ".unicodeScalars
  }
  if value <= 0xFF90 {
    return "ミ".unicodeScalars
  }
  if value <= 0xFF91 {
    return "ム".unicodeScalars
  }
  if value <= 0xFF92 {
    return "メ".unicodeScalars
  }
  if value <= 0xFF93 {
    return "モ".unicodeScalars
  }
  if value <= 0xFF94 {
    return "ヤ".unicodeScalars
  }
  if value <= 0xFF95 {
    return "ユ".unicodeScalars
  }
  if value <= 0xFF96 {
    return "ヨ".unicodeScalars
  }
  if value <= 0xFF97 {
    return "ラ".unicodeScalars
  }
  if value <= 0xFF98 {
    return "リ".unicodeScalars
  }
  if value <= 0xFF99 {
    return "ル".unicodeScalars
  }
  if value <= 0xFF9A {
    return "レ".unicodeScalars
  }
  if value <= 0xFF9B {
    return "ロ".unicodeScalars
  }
  if value <= 0xFF9C {
    return "ワ".unicodeScalars
  }
  if value <= 0xFF9D {
    return "ン".unicodeScalars
  }
  if value <= 0xFF9E {
    return "\u{3099}".unicodeScalars
  }
  if value <= 0xFF9F {
    return "\u{309A}".unicodeScalars
  }
  if value <= 0xFFA0 {
    return "ᅠ".unicodeScalars
  }
  if value <= 0xFFA1 {
    return "ᄀ".unicodeScalars
  }
  if value <= 0xFFA2 {
    return "ᄁ".unicodeScalars
  }
  if value <= 0xFFA3 {
    return "ᆪ".unicodeScalars
  }
  if value <= 0xFFA4 {
    return "ᄂ".unicodeScalars
  }
  if value <= 0xFFA5 {
    return "ᆬ".unicodeScalars
  }
  if value <= 0xFFA6 {
    return "ᆭ".unicodeScalars
  }
  if value <= 0xFFA7 {
    return "ᄃ".unicodeScalars
  }
  if value <= 0xFFA8 {
    return "ᄄ".unicodeScalars
  }
  if value <= 0xFFA9 {
    return "ᄅ".unicodeScalars
  }
  if value <= 0xFFAA {
    return "ᆰ".unicodeScalars
  }
  if value <= 0xFFAB {
    return "ᆱ".unicodeScalars
  }
  if value <= 0xFFAC {
    return "ᆲ".unicodeScalars
  }
  if value <= 0xFFAD {
    return "ᆳ".unicodeScalars
  }
  if value <= 0xFFAE {
    return "ᆴ".unicodeScalars
  }
  if value <= 0xFFAF {
    return "ᆵ".unicodeScalars
  }
  if value <= 0xFFB0 {
    return "ᄚ".unicodeScalars
  }
  if value <= 0xFFB1 {
    return "ᄆ".unicodeScalars
  }
  if value <= 0xFFB2 {
    return "ᄇ".unicodeScalars
  }
  if value <= 0xFFB3 {
    return "ᄈ".unicodeScalars
  }
  if value <= 0xFFB4 {
    return "ᄡ".unicodeScalars
  }
  if value <= 0xFFB5 {
    return "ᄉ".unicodeScalars
  }
  if value <= 0xFFB6 {
    return "ᄊ".unicodeScalars
  }
  if value <= 0xFFB7 {
    return "ᄋ".unicodeScalars
  }
  if value <= 0xFFB8 {
    return "ᄌ".unicodeScalars
  }
  if value <= 0xFFB9 {
    return "ᄍ".unicodeScalars
  }
  if value <= 0xFFBA {
    return "ᄎ".unicodeScalars
  }
  if value <= 0xFFBB {
    return "ᄏ".unicodeScalars
  }
  if value <= 0xFFBC {
    return "ᄐ".unicodeScalars
  }
  if value <= 0xFFBD {
    return "ᄑ".unicodeScalars
  }
  if value <= 0xFFBE {
    return "ᄒ".unicodeScalars
  }
  if value <= 0xFFC1 {
    return String(scalar).unicodeScalars
  }
  if value <= 0xFFC2 {
    return "ᅡ".unicodeScalars
  }
  if value <= 0xFFC3 {
    return "ᅢ".unicodeScalars
  }
  if value <= 0xFFC4 {
    return "ᅣ".unicodeScalars
  }
  if value <= 0xFFC5 {
    return "ᅤ".unicodeScalars
  }
  if value <= 0xFFC6 {
    return "ᅥ".unicodeScalars
  }
  if value <= 0xFFC7 {
    return "ᅦ".unicodeScalars
  }
  if value <= 0xFFC9 {
    return String(scalar).unicodeScalars
  }
  if value <= 0xFFCA {
    return "ᅧ".unicodeScalars
  }
  if value <= 0xFFCB {
    return "ᅨ".unicodeScalars
  }
  if value <= 0xFFCC {
    return "ᅩ".unicodeScalars
  }
  if value <= 0xFFCD {
    return "ᅪ".unicodeScalars
  }
  if value <= 0xFFCE {
    return "ᅫ".unicodeScalars
  }
  if value <= 0xFFCF {
    return "ᅬ".unicodeScalars
  }
  if value <= 0xFFD1 {
    return String(scalar).unicodeScalars
  }
  if value <= 0xFFD2 {
    return "ᅭ".unicodeScalars
  }
  if value <= 0xFFD3 {
    return "ᅮ".unicodeScalars
  }
  if value <= 0xFFD4 {
    return "ᅯ".unicodeScalars
  }
  if value <= 0xFFD5 {
    return "ᅰ".unicodeScalars
  }
  if value <= 0xFFD6 {
    return "ᅱ".unicodeScalars
  }
  if value <= 0xFFD7 {
    return "ᅲ".unicodeScalars
  }
  if value <= 0xFFD9 {
    return String(scalar).unicodeScalars
  }
  if value <= 0xFFDA {
    return "ᅳ".unicodeScalars
  }
  if value <= 0xFFDB {
    return "ᅴ".unicodeScalars
  }
  if value <= 0xFFDC {
    return "ᅵ".unicodeScalars
  }
  if value <= 0xFFDF {
    return String(scalar).unicodeScalars
  }
  if value <= 0xFFE0 {
    return "¢".unicodeScalars
  }
  if value <= 0xFFE1 {
    return "£".unicodeScalars
  }
  if value <= 0xFFE2 {
    return "¬".unicodeScalars
  }
  if value <= 0xFFE3 {
    return " \u{0304}".unicodeScalars
  }
  if value <= 0xFFE4 {
    return "¦".unicodeScalars
  }
  if value <= 0xFFE5 {
    return "¥".unicodeScalars
  }
  if value <= 0xFFE6 {
    return "₩".unicodeScalars
  }
  if value <= 0xFFE7 {
    return String(scalar).unicodeScalars
  }
  if value <= 0xFFE8 {
    return "│".unicodeScalars
  }
  if value <= 0xFFE9 {
    return "←".unicodeScalars
  }
  if value <= 0xFFEA {
    return "↑".unicodeScalars
  }
  if value <= 0xFFEB {
    return "→".unicodeScalars
  }
  if value <= 0xFFEC {
    return "↓".unicodeScalars
  }
  if value <= 0xFFED {
    return "■".unicodeScalars
  }
  if value <= 0xFFEE {
    return "○".unicodeScalars
  }
  if value <= 0x105C8 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x105C9 {
    return "𐗒\u{0307}".unicodeScalars
  }
  if value <= 0x105E3 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x105E4 {
    return "𐗚\u{0307}".unicodeScalars
  }
  if value <= 0x10780 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x10781 {
    return "ː".unicodeScalars
  }
  if value <= 0x10782 {
    return "ˑ".unicodeScalars
  }
  if value <= 0x10783 {
    return "æ".unicodeScalars
  }
  if value <= 0x10784 {
    return "ʙ".unicodeScalars
  }
  if value <= 0x10785 {
    return "ɓ".unicodeScalars
  }
  if value <= 0x10786 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x10787 {
    return "ʣ".unicodeScalars
  }
  if value <= 0x10788 {
    return "ꭦ".unicodeScalars
  }
  if value <= 0x10789 {
    return "ʥ".unicodeScalars
  }
  if value <= 0x1078A {
    return "ʤ".unicodeScalars
  }
  if value <= 0x1078B {
    return "ɖ".unicodeScalars
  }
  if value <= 0x1078C {
    return "ɗ".unicodeScalars
  }
  if value <= 0x1078D {
    return "ᶑ".unicodeScalars
  }
  if value <= 0x1078E {
    return "ɘ".unicodeScalars
  }
  if value <= 0x1078F {
    return "ɞ".unicodeScalars
  }
  if value <= 0x10790 {
    return "ʩ".unicodeScalars
  }
  if value <= 0x10791 {
    return "ɤ".unicodeScalars
  }
  if value <= 0x10792 {
    return "ɢ".unicodeScalars
  }
  if value <= 0x10793 {
    return "ɠ".unicodeScalars
  }
  if value <= 0x10794 {
    return "ʛ".unicodeScalars
  }
  if value <= 0x10795 {
    return "ħ".unicodeScalars
  }
  if value <= 0x10796 {
    return "ʜ".unicodeScalars
  }
  if value <= 0x10797 {
    return "ɧ".unicodeScalars
  }
  if value <= 0x10798 {
    return "ʄ".unicodeScalars
  }
  if value <= 0x10799 {
    return "ʪ".unicodeScalars
  }
  if value <= 0x1079A {
    return "ʫ".unicodeScalars
  }
  if value <= 0x1079B {
    return "ɬ".unicodeScalars
  }
  if value <= 0x1079C {
    return "𝼄".unicodeScalars
  }
  if value <= 0x1079D {
    return "ꞎ".unicodeScalars
  }
  if value <= 0x1079E {
    return "ɮ".unicodeScalars
  }
  if value <= 0x1079F {
    return "𝼅".unicodeScalars
  }
  if value <= 0x107A0 {
    return "ʎ".unicodeScalars
  }
  if value <= 0x107A1 {
    return "𝼆".unicodeScalars
  }
  if value <= 0x107A2 {
    return "ø".unicodeScalars
  }
  if value <= 0x107A3 {
    return "ɶ".unicodeScalars
  }
  if value <= 0x107A4 {
    return "ɷ".unicodeScalars
  }
  if value <= 0x107A5 {
    return "q".unicodeScalars
  }
  if value <= 0x107A6 {
    return "ɺ".unicodeScalars
  }
  if value <= 0x107A7 {
    return "𝼈".unicodeScalars
  }
  if value <= 0x107A8 {
    return "ɽ".unicodeScalars
  }
  if value <= 0x107A9 {
    return "ɾ".unicodeScalars
  }
  if value <= 0x107AA {
    return "ʀ".unicodeScalars
  }
  if value <= 0x107AB {
    return "ʨ".unicodeScalars
  }
  if value <= 0x107AC {
    return "ʦ".unicodeScalars
  }
  if value <= 0x107AD {
    return "ꭧ".unicodeScalars
  }
  if value <= 0x107AE {
    return "ʧ".unicodeScalars
  }
  if value <= 0x107AF {
    return "ʈ".unicodeScalars
  }
  if value <= 0x107B0 {
    return "ⱱ".unicodeScalars
  }
  if value <= 0x107B1 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x107B2 {
    return "ʏ".unicodeScalars
  }
  if value <= 0x107B3 {
    return "ʡ".unicodeScalars
  }
  if value <= 0x107B4 {
    return "ʢ".unicodeScalars
  }
  if value <= 0x107B5 {
    return "ʘ".unicodeScalars
  }
  if value <= 0x107B6 {
    return "ǀ".unicodeScalars
  }
  if value <= 0x107B7 {
    return "ǁ".unicodeScalars
  }
  if value <= 0x107B8 {
    return "ǂ".unicodeScalars
  }
  if value <= 0x107B9 {
    return "𝼊".unicodeScalars
  }
  if value <= 0x107BA {
    return "𝼞".unicodeScalars
  }
  if value <= 0x11099 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1109A {
    return "𑂙\u{110BA}".unicodeScalars
  }
  if value <= 0x1109B {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1109C {
    return "𑂛\u{110BA}".unicodeScalars
  }
  if value <= 0x110AA {
    return String(scalar).unicodeScalars
  }
  if value <= 0x110AB {
    return "𑂥\u{110BA}".unicodeScalars
  }
  if value <= 0x1112D {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1112E {
    return "𑄮".unicodeScalars
  }
  if value <= 0x1112F {
    return "𑄯".unicodeScalars
  }
  if value <= 0x1134A {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1134B {
    return "𑍋".unicodeScalars
  }
  if value <= 0x1134C {
    return "𑍌".unicodeScalars
  }
  if value <= 0x11382 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x11383 {
    return "𑎃".unicodeScalars
  }
  if value <= 0x11384 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x11385 {
    return "𑎅".unicodeScalars
  }
  if value <= 0x1138D {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1138E {
    return "𑎎".unicodeScalars
  }
  if value <= 0x11390 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x11391 {
    return "𑎑".unicodeScalars
  }
  if value <= 0x113C4 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x113C5 {
    return "𑏅".unicodeScalars
  }
  if value <= 0x113C6 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x113C7 {
    return "𑏇".unicodeScalars
  }
  if value <= 0x113C8 {
    return "𑏈".unicodeScalars
  }
  if value <= 0x114BA {
    return String(scalar).unicodeScalars
  }
  if value <= 0x114BB {
    return "𑒻".unicodeScalars
  }
  if value <= 0x114BC {
    return "𑒼".unicodeScalars
  }
  if value <= 0x114BD {
    return String(scalar).unicodeScalars
  }
  if value <= 0x114BE {
    return "𑒾".unicodeScalars
  }
  if value <= 0x115B9 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x115BA {
    return "𑖺".unicodeScalars
  }
  if value <= 0x115BB {
    return "𑖻".unicodeScalars
  }
  if value <= 0x11937 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x11938 {
    return "𑤸".unicodeScalars
  }
  if value <= 0x16120 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x16121 {
    return "𖄡".unicodeScalars
  }
  if value <= 0x16122 {
    return "𖄢".unicodeScalars
  }
  if value <= 0x16123 {
    return "𖄣".unicodeScalars
  }
  if value <= 0x16124 {
    return "𖄤".unicodeScalars
  }
  if value <= 0x16125 {
    return "𖄥".unicodeScalars
  }
  if value <= 0x16126 {
    return "𖄦".unicodeScalars
  }
  if value <= 0x16127 {
    return "𖄧".unicodeScalars
  }
  if value <= 0x16128 {
    return "𖄨".unicodeScalars
  }
  if value <= 0x16D67 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x16D68 {
    return "𖵨".unicodeScalars
  }
  if value <= 0x16D69 {
    return "𖵩".unicodeScalars
  }
  if value <= 0x16D6A {
    return "𖵪".unicodeScalars
  }
  if value <= 0x1CCD5 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1CCD6 {
    return "A".unicodeScalars
  }
  if value <= 0x1CCD7 {
    return "B".unicodeScalars
  }
  if value <= 0x1CCD8 {
    return "C".unicodeScalars
  }
  if value <= 0x1CCD9 {
    return "D".unicodeScalars
  }
  if value <= 0x1CCDA {
    return "E".unicodeScalars
  }
  if value <= 0x1CCDB {
    return "F".unicodeScalars
  }
  if value <= 0x1CCDC {
    return "G".unicodeScalars
  }
  if value <= 0x1CCDD {
    return "H".unicodeScalars
  }
  if value <= 0x1CCDE {
    return "I".unicodeScalars
  }
  if value <= 0x1CCDF {
    return "J".unicodeScalars
  }
  if value <= 0x1CCE0 {
    return "K".unicodeScalars
  }
  if value <= 0x1CCE1 {
    return "L".unicodeScalars
  }
  if value <= 0x1CCE2 {
    return "M".unicodeScalars
  }
  if value <= 0x1CCE3 {
    return "N".unicodeScalars
  }
  if value <= 0x1CCE4 {
    return "O".unicodeScalars
  }
  if value <= 0x1CCE5 {
    return "P".unicodeScalars
  }
  if value <= 0x1CCE6 {
    return "Q".unicodeScalars
  }
  if value <= 0x1CCE7 {
    return "R".unicodeScalars
  }
  if value <= 0x1CCE8 {
    return "S".unicodeScalars
  }
  if value <= 0x1CCE9 {
    return "T".unicodeScalars
  }
  if value <= 0x1CCEA {
    return "U".unicodeScalars
  }
  if value <= 0x1CCEB {
    return "V".unicodeScalars
  }
  if value <= 0x1CCEC {
    return "W".unicodeScalars
  }
  if value <= 0x1CCED {
    return "X".unicodeScalars
  }
  if value <= 0x1CCEE {
    return "Y".unicodeScalars
  }
  if value <= 0x1CCEF {
    return "Z".unicodeScalars
  }
  if value <= 0x1CCF0 {
    return "0".unicodeScalars
  }
  if value <= 0x1CCF1 {
    return "1".unicodeScalars
  }
  if value <= 0x1CCF2 {
    return "2".unicodeScalars
  }
  if value <= 0x1CCF3 {
    return "3".unicodeScalars
  }
  if value <= 0x1CCF4 {
    return "4".unicodeScalars
  }
  if value <= 0x1CCF5 {
    return "5".unicodeScalars
  }
  if value <= 0x1CCF6 {
    return "6".unicodeScalars
  }
  if value <= 0x1CCF7 {
    return "7".unicodeScalars
  }
  if value <= 0x1CCF8 {
    return "8".unicodeScalars
  }
  if value <= 0x1CCF9 {
    return "9".unicodeScalars
  }
  if value <= 0x1D15D {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1D15E {
    return "𝅗\u{1D165}".unicodeScalars
  }
  if value <= 0x1D15F {
    return "𝅘\u{1D165}".unicodeScalars
  }
  if value <= 0x1D160 {
    return "𝅘\u{1D165}\u{1D16E}".unicodeScalars
  }
  if value <= 0x1D161 {
    return "𝅘\u{1D165}\u{1D16F}".unicodeScalars
  }
  if value <= 0x1D162 {
    return "𝅘\u{1D165}\u{1D170}".unicodeScalars
  }
  if value <= 0x1D163 {
    return "𝅘\u{1D165}\u{1D171}".unicodeScalars
  }
  if value <= 0x1D164 {
    return "𝅘\u{1D165}\u{1D172}".unicodeScalars
  }
  if value <= 0x1D1BA {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1D1BB {
    return "𝆹\u{1D165}".unicodeScalars
  }
  if value <= 0x1D1BC {
    return "𝆺\u{1D165}".unicodeScalars
  }
  if value <= 0x1D1BD {
    return "𝆹\u{1D165}\u{1D16E}".unicodeScalars
  }
  if value <= 0x1D1BE {
    return "𝆺\u{1D165}\u{1D16E}".unicodeScalars
  }
  if value <= 0x1D1BF {
    return "𝆹\u{1D165}\u{1D16F}".unicodeScalars
  }
  if value <= 0x1D1C0 {
    return "𝆺\u{1D165}\u{1D16F}".unicodeScalars
  }
  if value <= 0x1D3FF {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1D400 {
    return "A".unicodeScalars
  }
  if value <= 0x1D401 {
    return "B".unicodeScalars
  }
  if value <= 0x1D402 {
    return "C".unicodeScalars
  }
  if value <= 0x1D403 {
    return "D".unicodeScalars
  }
  if value <= 0x1D404 {
    return "E".unicodeScalars
  }
  if value <= 0x1D405 {
    return "F".unicodeScalars
  }
  if value <= 0x1D406 {
    return "G".unicodeScalars
  }
  if value <= 0x1D407 {
    return "H".unicodeScalars
  }
  if value <= 0x1D408 {
    return "I".unicodeScalars
  }
  if value <= 0x1D409 {
    return "J".unicodeScalars
  }
  if value <= 0x1D40A {
    return "K".unicodeScalars
  }
  if value <= 0x1D40B {
    return "L".unicodeScalars
  }
  if value <= 0x1D40C {
    return "M".unicodeScalars
  }
  if value <= 0x1D40D {
    return "N".unicodeScalars
  }
  if value <= 0x1D40E {
    return "O".unicodeScalars
  }
  if value <= 0x1D40F {
    return "P".unicodeScalars
  }
  if value <= 0x1D410 {
    return "Q".unicodeScalars
  }
  if value <= 0x1D411 {
    return "R".unicodeScalars
  }
  if value <= 0x1D412 {
    return "S".unicodeScalars
  }
  if value <= 0x1D413 {
    return "T".unicodeScalars
  }
  if value <= 0x1D414 {
    return "U".unicodeScalars
  }
  if value <= 0x1D415 {
    return "V".unicodeScalars
  }
  if value <= 0x1D416 {
    return "W".unicodeScalars
  }
  if value <= 0x1D417 {
    return "X".unicodeScalars
  }
  if value <= 0x1D418 {
    return "Y".unicodeScalars
  }
  if value <= 0x1D419 {
    return "Z".unicodeScalars
  }
  if value <= 0x1D41A {
    return "a".unicodeScalars
  }
  if value <= 0x1D41B {
    return "b".unicodeScalars
  }
  if value <= 0x1D41C {
    return "c".unicodeScalars
  }
  if value <= 0x1D41D {
    return "d".unicodeScalars
  }
  if value <= 0x1D41E {
    return "e".unicodeScalars
  }
  if value <= 0x1D41F {
    return "f".unicodeScalars
  }
  if value <= 0x1D420 {
    return "g".unicodeScalars
  }
  if value <= 0x1D421 {
    return "h".unicodeScalars
  }
  if value <= 0x1D422 {
    return "i".unicodeScalars
  }
  if value <= 0x1D423 {
    return "j".unicodeScalars
  }
  if value <= 0x1D424 {
    return "k".unicodeScalars
  }
  if value <= 0x1D425 {
    return "l".unicodeScalars
  }
  if value <= 0x1D426 {
    return "m".unicodeScalars
  }
  if value <= 0x1D427 {
    return "n".unicodeScalars
  }
  if value <= 0x1D428 {
    return "o".unicodeScalars
  }
  if value <= 0x1D429 {
    return "p".unicodeScalars
  }
  if value <= 0x1D42A {
    return "q".unicodeScalars
  }
  if value <= 0x1D42B {
    return "r".unicodeScalars
  }
  if value <= 0x1D42C {
    return "s".unicodeScalars
  }
  if value <= 0x1D42D {
    return "t".unicodeScalars
  }
  if value <= 0x1D42E {
    return "u".unicodeScalars
  }
  if value <= 0x1D42F {
    return "v".unicodeScalars
  }
  if value <= 0x1D430 {
    return "w".unicodeScalars
  }
  if value <= 0x1D431 {
    return "x".unicodeScalars
  }
  if value <= 0x1D432 {
    return "y".unicodeScalars
  }
  if value <= 0x1D433 {
    return "z".unicodeScalars
  }
  if value <= 0x1D434 {
    return "A".unicodeScalars
  }
  if value <= 0x1D435 {
    return "B".unicodeScalars
  }
  if value <= 0x1D436 {
    return "C".unicodeScalars
  }
  if value <= 0x1D437 {
    return "D".unicodeScalars
  }
  if value <= 0x1D438 {
    return "E".unicodeScalars
  }
  if value <= 0x1D439 {
    return "F".unicodeScalars
  }
  if value <= 0x1D43A {
    return "G".unicodeScalars
  }
  if value <= 0x1D43B {
    return "H".unicodeScalars
  }
  if value <= 0x1D43C {
    return "I".unicodeScalars
  }
  if value <= 0x1D43D {
    return "J".unicodeScalars
  }
  if value <= 0x1D43E {
    return "K".unicodeScalars
  }
  if value <= 0x1D43F {
    return "L".unicodeScalars
  }
  if value <= 0x1D440 {
    return "M".unicodeScalars
  }
  if value <= 0x1D441 {
    return "N".unicodeScalars
  }
  if value <= 0x1D442 {
    return "O".unicodeScalars
  }
  if value <= 0x1D443 {
    return "P".unicodeScalars
  }
  if value <= 0x1D444 {
    return "Q".unicodeScalars
  }
  if value <= 0x1D445 {
    return "R".unicodeScalars
  }
  if value <= 0x1D446 {
    return "S".unicodeScalars
  }
  if value <= 0x1D447 {
    return "T".unicodeScalars
  }
  if value <= 0x1D448 {
    return "U".unicodeScalars
  }
  if value <= 0x1D449 {
    return "V".unicodeScalars
  }
  if value <= 0x1D44A {
    return "W".unicodeScalars
  }
  if value <= 0x1D44B {
    return "X".unicodeScalars
  }
  if value <= 0x1D44C {
    return "Y".unicodeScalars
  }
  if value <= 0x1D44D {
    return "Z".unicodeScalars
  }
  if value <= 0x1D44E {
    return "a".unicodeScalars
  }
  if value <= 0x1D44F {
    return "b".unicodeScalars
  }
  if value <= 0x1D450 {
    return "c".unicodeScalars
  }
  if value <= 0x1D451 {
    return "d".unicodeScalars
  }
  if value <= 0x1D452 {
    return "e".unicodeScalars
  }
  if value <= 0x1D453 {
    return "f".unicodeScalars
  }
  if value <= 0x1D454 {
    return "g".unicodeScalars
  }
  if value <= 0x1D455 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1D456 {
    return "i".unicodeScalars
  }
  if value <= 0x1D457 {
    return "j".unicodeScalars
  }
  if value <= 0x1D458 {
    return "k".unicodeScalars
  }
  if value <= 0x1D459 {
    return "l".unicodeScalars
  }
  if value <= 0x1D45A {
    return "m".unicodeScalars
  }
  if value <= 0x1D45B {
    return "n".unicodeScalars
  }
  if value <= 0x1D45C {
    return "o".unicodeScalars
  }
  if value <= 0x1D45D {
    return "p".unicodeScalars
  }
  if value <= 0x1D45E {
    return "q".unicodeScalars
  }
  if value <= 0x1D45F {
    return "r".unicodeScalars
  }
  if value <= 0x1D460 {
    return "s".unicodeScalars
  }
  if value <= 0x1D461 {
    return "t".unicodeScalars
  }
  if value <= 0x1D462 {
    return "u".unicodeScalars
  }
  if value <= 0x1D463 {
    return "v".unicodeScalars
  }
  if value <= 0x1D464 {
    return "w".unicodeScalars
  }
  if value <= 0x1D465 {
    return "x".unicodeScalars
  }
  if value <= 0x1D466 {
    return "y".unicodeScalars
  }
  if value <= 0x1D467 {
    return "z".unicodeScalars
  }
  if value <= 0x1D468 {
    return "A".unicodeScalars
  }
  if value <= 0x1D469 {
    return "B".unicodeScalars
  }
  if value <= 0x1D46A {
    return "C".unicodeScalars
  }
  if value <= 0x1D46B {
    return "D".unicodeScalars
  }
  if value <= 0x1D46C {
    return "E".unicodeScalars
  }
  if value <= 0x1D46D {
    return "F".unicodeScalars
  }
  if value <= 0x1D46E {
    return "G".unicodeScalars
  }
  if value <= 0x1D46F {
    return "H".unicodeScalars
  }
  if value <= 0x1D470 {
    return "I".unicodeScalars
  }
  if value <= 0x1D471 {
    return "J".unicodeScalars
  }
  if value <= 0x1D472 {
    return "K".unicodeScalars
  }
  if value <= 0x1D473 {
    return "L".unicodeScalars
  }
  if value <= 0x1D474 {
    return "M".unicodeScalars
  }
  if value <= 0x1D475 {
    return "N".unicodeScalars
  }
  if value <= 0x1D476 {
    return "O".unicodeScalars
  }
  if value <= 0x1D477 {
    return "P".unicodeScalars
  }
  if value <= 0x1D478 {
    return "Q".unicodeScalars
  }
  if value <= 0x1D479 {
    return "R".unicodeScalars
  }
  if value <= 0x1D47A {
    return "S".unicodeScalars
  }
  if value <= 0x1D47B {
    return "T".unicodeScalars
  }
  if value <= 0x1D47C {
    return "U".unicodeScalars
  }
  if value <= 0x1D47D {
    return "V".unicodeScalars
  }
  if value <= 0x1D47E {
    return "W".unicodeScalars
  }
  if value <= 0x1D47F {
    return "X".unicodeScalars
  }
  if value <= 0x1D480 {
    return "Y".unicodeScalars
  }
  if value <= 0x1D481 {
    return "Z".unicodeScalars
  }
  if value <= 0x1D482 {
    return "a".unicodeScalars
  }
  if value <= 0x1D483 {
    return "b".unicodeScalars
  }
  if value <= 0x1D484 {
    return "c".unicodeScalars
  }
  if value <= 0x1D485 {
    return "d".unicodeScalars
  }
  if value <= 0x1D486 {
    return "e".unicodeScalars
  }
  if value <= 0x1D487 {
    return "f".unicodeScalars
  }
  if value <= 0x1D488 {
    return "g".unicodeScalars
  }
  if value <= 0x1D489 {
    return "h".unicodeScalars
  }
  if value <= 0x1D48A {
    return "i".unicodeScalars
  }
  if value <= 0x1D48B {
    return "j".unicodeScalars
  }
  if value <= 0x1D48C {
    return "k".unicodeScalars
  }
  if value <= 0x1D48D {
    return "l".unicodeScalars
  }
  if value <= 0x1D48E {
    return "m".unicodeScalars
  }
  if value <= 0x1D48F {
    return "n".unicodeScalars
  }
  if value <= 0x1D490 {
    return "o".unicodeScalars
  }
  if value <= 0x1D491 {
    return "p".unicodeScalars
  }
  if value <= 0x1D492 {
    return "q".unicodeScalars
  }
  if value <= 0x1D493 {
    return "r".unicodeScalars
  }
  if value <= 0x1D494 {
    return "s".unicodeScalars
  }
  if value <= 0x1D495 {
    return "t".unicodeScalars
  }
  if value <= 0x1D496 {
    return "u".unicodeScalars
  }
  if value <= 0x1D497 {
    return "v".unicodeScalars
  }
  if value <= 0x1D498 {
    return "w".unicodeScalars
  }
  if value <= 0x1D499 {
    return "x".unicodeScalars
  }
  if value <= 0x1D49A {
    return "y".unicodeScalars
  }
  if value <= 0x1D49B {
    return "z".unicodeScalars
  }
  if value <= 0x1D49C {
    return "A".unicodeScalars
  }
  if value <= 0x1D49D {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1D49E {
    return "C".unicodeScalars
  }
  if value <= 0x1D49F {
    return "D".unicodeScalars
  }
  if value <= 0x1D4A1 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1D4A2 {
    return "G".unicodeScalars
  }
  if value <= 0x1D4A4 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1D4A5 {
    return "J".unicodeScalars
  }
  if value <= 0x1D4A6 {
    return "K".unicodeScalars
  }
  if value <= 0x1D4A8 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1D4A9 {
    return "N".unicodeScalars
  }
  if value <= 0x1D4AA {
    return "O".unicodeScalars
  }
  if value <= 0x1D4AB {
    return "P".unicodeScalars
  }
  if value <= 0x1D4AC {
    return "Q".unicodeScalars
  }
  if value <= 0x1D4AD {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1D4AE {
    return "S".unicodeScalars
  }
  if value <= 0x1D4AF {
    return "T".unicodeScalars
  }
  if value <= 0x1D4B0 {
    return "U".unicodeScalars
  }
  if value <= 0x1D4B1 {
    return "V".unicodeScalars
  }
  if value <= 0x1D4B2 {
    return "W".unicodeScalars
  }
  if value <= 0x1D4B3 {
    return "X".unicodeScalars
  }
  if value <= 0x1D4B4 {
    return "Y".unicodeScalars
  }
  if value <= 0x1D4B5 {
    return "Z".unicodeScalars
  }
  if value <= 0x1D4B6 {
    return "a".unicodeScalars
  }
  if value <= 0x1D4B7 {
    return "b".unicodeScalars
  }
  if value <= 0x1D4B8 {
    return "c".unicodeScalars
  }
  if value <= 0x1D4B9 {
    return "d".unicodeScalars
  }
  if value <= 0x1D4BA {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1D4BB {
    return "f".unicodeScalars
  }
  if value <= 0x1D4BC {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1D4BD {
    return "h".unicodeScalars
  }
  if value <= 0x1D4BE {
    return "i".unicodeScalars
  }
  if value <= 0x1D4BF {
    return "j".unicodeScalars
  }
  if value <= 0x1D4C0 {
    return "k".unicodeScalars
  }
  if value <= 0x1D4C1 {
    return "l".unicodeScalars
  }
  if value <= 0x1D4C2 {
    return "m".unicodeScalars
  }
  if value <= 0x1D4C3 {
    return "n".unicodeScalars
  }
  if value <= 0x1D4C4 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1D4C5 {
    return "p".unicodeScalars
  }
  if value <= 0x1D4C6 {
    return "q".unicodeScalars
  }
  if value <= 0x1D4C7 {
    return "r".unicodeScalars
  }
  if value <= 0x1D4C8 {
    return "s".unicodeScalars
  }
  if value <= 0x1D4C9 {
    return "t".unicodeScalars
  }
  if value <= 0x1D4CA {
    return "u".unicodeScalars
  }
  if value <= 0x1D4CB {
    return "v".unicodeScalars
  }
  if value <= 0x1D4CC {
    return "w".unicodeScalars
  }
  if value <= 0x1D4CD {
    return "x".unicodeScalars
  }
  if value <= 0x1D4CE {
    return "y".unicodeScalars
  }
  if value <= 0x1D4CF {
    return "z".unicodeScalars
  }
  if value <= 0x1D4D0 {
    return "A".unicodeScalars
  }
  if value <= 0x1D4D1 {
    return "B".unicodeScalars
  }
  if value <= 0x1D4D2 {
    return "C".unicodeScalars
  }
  if value <= 0x1D4D3 {
    return "D".unicodeScalars
  }
  if value <= 0x1D4D4 {
    return "E".unicodeScalars
  }
  if value <= 0x1D4D5 {
    return "F".unicodeScalars
  }
  if value <= 0x1D4D6 {
    return "G".unicodeScalars
  }
  if value <= 0x1D4D7 {
    return "H".unicodeScalars
  }
  if value <= 0x1D4D8 {
    return "I".unicodeScalars
  }
  if value <= 0x1D4D9 {
    return "J".unicodeScalars
  }
  if value <= 0x1D4DA {
    return "K".unicodeScalars
  }
  if value <= 0x1D4DB {
    return "L".unicodeScalars
  }
  if value <= 0x1D4DC {
    return "M".unicodeScalars
  }
  if value <= 0x1D4DD {
    return "N".unicodeScalars
  }
  if value <= 0x1D4DE {
    return "O".unicodeScalars
  }
  if value <= 0x1D4DF {
    return "P".unicodeScalars
  }
  if value <= 0x1D4E0 {
    return "Q".unicodeScalars
  }
  if value <= 0x1D4E1 {
    return "R".unicodeScalars
  }
  if value <= 0x1D4E2 {
    return "S".unicodeScalars
  }
  if value <= 0x1D4E3 {
    return "T".unicodeScalars
  }
  if value <= 0x1D4E4 {
    return "U".unicodeScalars
  }
  if value <= 0x1D4E5 {
    return "V".unicodeScalars
  }
  if value <= 0x1D4E6 {
    return "W".unicodeScalars
  }
  if value <= 0x1D4E7 {
    return "X".unicodeScalars
  }
  if value <= 0x1D4E8 {
    return "Y".unicodeScalars
  }
  if value <= 0x1D4E9 {
    return "Z".unicodeScalars
  }
  if value <= 0x1D4EA {
    return "a".unicodeScalars
  }
  if value <= 0x1D4EB {
    return "b".unicodeScalars
  }
  if value <= 0x1D4EC {
    return "c".unicodeScalars
  }
  if value <= 0x1D4ED {
    return "d".unicodeScalars
  }
  if value <= 0x1D4EE {
    return "e".unicodeScalars
  }
  if value <= 0x1D4EF {
    return "f".unicodeScalars
  }
  if value <= 0x1D4F0 {
    return "g".unicodeScalars
  }
  if value <= 0x1D4F1 {
    return "h".unicodeScalars
  }
  if value <= 0x1D4F2 {
    return "i".unicodeScalars
  }
  if value <= 0x1D4F3 {
    return "j".unicodeScalars
  }
  if value <= 0x1D4F4 {
    return "k".unicodeScalars
  }
  if value <= 0x1D4F5 {
    return "l".unicodeScalars
  }
  if value <= 0x1D4F6 {
    return "m".unicodeScalars
  }
  if value <= 0x1D4F7 {
    return "n".unicodeScalars
  }
  if value <= 0x1D4F8 {
    return "o".unicodeScalars
  }
  if value <= 0x1D4F9 {
    return "p".unicodeScalars
  }
  if value <= 0x1D4FA {
    return "q".unicodeScalars
  }
  if value <= 0x1D4FB {
    return "r".unicodeScalars
  }
  if value <= 0x1D4FC {
    return "s".unicodeScalars
  }
  if value <= 0x1D4FD {
    return "t".unicodeScalars
  }
  if value <= 0x1D4FE {
    return "u".unicodeScalars
  }
  if value <= 0x1D4FF {
    return "v".unicodeScalars
  }
  if value <= 0x1D500 {
    return "w".unicodeScalars
  }
  if value <= 0x1D501 {
    return "x".unicodeScalars
  }
  if value <= 0x1D502 {
    return "y".unicodeScalars
  }
  if value <= 0x1D503 {
    return "z".unicodeScalars
  }
  if value <= 0x1D504 {
    return "A".unicodeScalars
  }
  if value <= 0x1D505 {
    return "B".unicodeScalars
  }
  if value <= 0x1D506 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1D507 {
    return "D".unicodeScalars
  }
  if value <= 0x1D508 {
    return "E".unicodeScalars
  }
  if value <= 0x1D509 {
    return "F".unicodeScalars
  }
  if value <= 0x1D50A {
    return "G".unicodeScalars
  }
  if value <= 0x1D50C {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1D50D {
    return "J".unicodeScalars
  }
  if value <= 0x1D50E {
    return "K".unicodeScalars
  }
  if value <= 0x1D50F {
    return "L".unicodeScalars
  }
  if value <= 0x1D510 {
    return "M".unicodeScalars
  }
  if value <= 0x1D511 {
    return "N".unicodeScalars
  }
  if value <= 0x1D512 {
    return "O".unicodeScalars
  }
  if value <= 0x1D513 {
    return "P".unicodeScalars
  }
  if value <= 0x1D514 {
    return "Q".unicodeScalars
  }
  if value <= 0x1D515 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1D516 {
    return "S".unicodeScalars
  }
  if value <= 0x1D517 {
    return "T".unicodeScalars
  }
  if value <= 0x1D518 {
    return "U".unicodeScalars
  }
  if value <= 0x1D519 {
    return "V".unicodeScalars
  }
  if value <= 0x1D51A {
    return "W".unicodeScalars
  }
  if value <= 0x1D51B {
    return "X".unicodeScalars
  }
  if value <= 0x1D51C {
    return "Y".unicodeScalars
  }
  if value <= 0x1D51D {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1D51E {
    return "a".unicodeScalars
  }
  if value <= 0x1D51F {
    return "b".unicodeScalars
  }
  if value <= 0x1D520 {
    return "c".unicodeScalars
  }
  if value <= 0x1D521 {
    return "d".unicodeScalars
  }
  if value <= 0x1D522 {
    return "e".unicodeScalars
  }
  if value <= 0x1D523 {
    return "f".unicodeScalars
  }
  if value <= 0x1D524 {
    return "g".unicodeScalars
  }
  if value <= 0x1D525 {
    return "h".unicodeScalars
  }
  if value <= 0x1D526 {
    return "i".unicodeScalars
  }
  if value <= 0x1D527 {
    return "j".unicodeScalars
  }
  if value <= 0x1D528 {
    return "k".unicodeScalars
  }
  if value <= 0x1D529 {
    return "l".unicodeScalars
  }
  if value <= 0x1D52A {
    return "m".unicodeScalars
  }
  if value <= 0x1D52B {
    return "n".unicodeScalars
  }
  if value <= 0x1D52C {
    return "o".unicodeScalars
  }
  if value <= 0x1D52D {
    return "p".unicodeScalars
  }
  if value <= 0x1D52E {
    return "q".unicodeScalars
  }
  if value <= 0x1D52F {
    return "r".unicodeScalars
  }
  if value <= 0x1D530 {
    return "s".unicodeScalars
  }
  if value <= 0x1D531 {
    return "t".unicodeScalars
  }
  if value <= 0x1D532 {
    return "u".unicodeScalars
  }
  if value <= 0x1D533 {
    return "v".unicodeScalars
  }
  if value <= 0x1D534 {
    return "w".unicodeScalars
  }
  if value <= 0x1D535 {
    return "x".unicodeScalars
  }
  if value <= 0x1D536 {
    return "y".unicodeScalars
  }
  if value <= 0x1D537 {
    return "z".unicodeScalars
  }
  if value <= 0x1D538 {
    return "A".unicodeScalars
  }
  if value <= 0x1D539 {
    return "B".unicodeScalars
  }
  if value <= 0x1D53A {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1D53B {
    return "D".unicodeScalars
  }
  if value <= 0x1D53C {
    return "E".unicodeScalars
  }
  if value <= 0x1D53D {
    return "F".unicodeScalars
  }
  if value <= 0x1D53E {
    return "G".unicodeScalars
  }
  if value <= 0x1D53F {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1D540 {
    return "I".unicodeScalars
  }
  if value <= 0x1D541 {
    return "J".unicodeScalars
  }
  if value <= 0x1D542 {
    return "K".unicodeScalars
  }
  if value <= 0x1D543 {
    return "L".unicodeScalars
  }
  if value <= 0x1D544 {
    return "M".unicodeScalars
  }
  if value <= 0x1D545 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1D546 {
    return "O".unicodeScalars
  }
  if value <= 0x1D549 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1D54A {
    return "S".unicodeScalars
  }
  if value <= 0x1D54B {
    return "T".unicodeScalars
  }
  if value <= 0x1D54C {
    return "U".unicodeScalars
  }
  if value <= 0x1D54D {
    return "V".unicodeScalars
  }
  if value <= 0x1D54E {
    return "W".unicodeScalars
  }
  if value <= 0x1D54F {
    return "X".unicodeScalars
  }
  if value <= 0x1D550 {
    return "Y".unicodeScalars
  }
  if value <= 0x1D551 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1D552 {
    return "a".unicodeScalars
  }
  if value <= 0x1D553 {
    return "b".unicodeScalars
  }
  if value <= 0x1D554 {
    return "c".unicodeScalars
  }
  if value <= 0x1D555 {
    return "d".unicodeScalars
  }
  if value <= 0x1D556 {
    return "e".unicodeScalars
  }
  if value <= 0x1D557 {
    return "f".unicodeScalars
  }
  if value <= 0x1D558 {
    return "g".unicodeScalars
  }
  if value <= 0x1D559 {
    return "h".unicodeScalars
  }
  if value <= 0x1D55A {
    return "i".unicodeScalars
  }
  if value <= 0x1D55B {
    return "j".unicodeScalars
  }
  if value <= 0x1D55C {
    return "k".unicodeScalars
  }
  if value <= 0x1D55D {
    return "l".unicodeScalars
  }
  if value <= 0x1D55E {
    return "m".unicodeScalars
  }
  if value <= 0x1D55F {
    return "n".unicodeScalars
  }
  if value <= 0x1D560 {
    return "o".unicodeScalars
  }
  if value <= 0x1D561 {
    return "p".unicodeScalars
  }
  if value <= 0x1D562 {
    return "q".unicodeScalars
  }
  if value <= 0x1D563 {
    return "r".unicodeScalars
  }
  if value <= 0x1D564 {
    return "s".unicodeScalars
  }
  if value <= 0x1D565 {
    return "t".unicodeScalars
  }
  if value <= 0x1D566 {
    return "u".unicodeScalars
  }
  if value <= 0x1D567 {
    return "v".unicodeScalars
  }
  if value <= 0x1D568 {
    return "w".unicodeScalars
  }
  if value <= 0x1D569 {
    return "x".unicodeScalars
  }
  if value <= 0x1D56A {
    return "y".unicodeScalars
  }
  if value <= 0x1D56B {
    return "z".unicodeScalars
  }
  if value <= 0x1D56C {
    return "A".unicodeScalars
  }
  if value <= 0x1D56D {
    return "B".unicodeScalars
  }
  if value <= 0x1D56E {
    return "C".unicodeScalars
  }
  if value <= 0x1D56F {
    return "D".unicodeScalars
  }
  if value <= 0x1D570 {
    return "E".unicodeScalars
  }
  if value <= 0x1D571 {
    return "F".unicodeScalars
  }
  if value <= 0x1D572 {
    return "G".unicodeScalars
  }
  if value <= 0x1D573 {
    return "H".unicodeScalars
  }
  if value <= 0x1D574 {
    return "I".unicodeScalars
  }
  if value <= 0x1D575 {
    return "J".unicodeScalars
  }
  if value <= 0x1D576 {
    return "K".unicodeScalars
  }
  if value <= 0x1D577 {
    return "L".unicodeScalars
  }
  if value <= 0x1D578 {
    return "M".unicodeScalars
  }
  if value <= 0x1D579 {
    return "N".unicodeScalars
  }
  if value <= 0x1D57A {
    return "O".unicodeScalars
  }
  if value <= 0x1D57B {
    return "P".unicodeScalars
  }
  if value <= 0x1D57C {
    return "Q".unicodeScalars
  }
  if value <= 0x1D57D {
    return "R".unicodeScalars
  }
  if value <= 0x1D57E {
    return "S".unicodeScalars
  }
  if value <= 0x1D57F {
    return "T".unicodeScalars
  }
  if value <= 0x1D580 {
    return "U".unicodeScalars
  }
  if value <= 0x1D581 {
    return "V".unicodeScalars
  }
  if value <= 0x1D582 {
    return "W".unicodeScalars
  }
  if value <= 0x1D583 {
    return "X".unicodeScalars
  }
  if value <= 0x1D584 {
    return "Y".unicodeScalars
  }
  if value <= 0x1D585 {
    return "Z".unicodeScalars
  }
  if value <= 0x1D586 {
    return "a".unicodeScalars
  }
  if value <= 0x1D587 {
    return "b".unicodeScalars
  }
  if value <= 0x1D588 {
    return "c".unicodeScalars
  }
  if value <= 0x1D589 {
    return "d".unicodeScalars
  }
  if value <= 0x1D58A {
    return "e".unicodeScalars
  }
  if value <= 0x1D58B {
    return "f".unicodeScalars
  }
  if value <= 0x1D58C {
    return "g".unicodeScalars
  }
  if value <= 0x1D58D {
    return "h".unicodeScalars
  }
  if value <= 0x1D58E {
    return "i".unicodeScalars
  }
  if value <= 0x1D58F {
    return "j".unicodeScalars
  }
  if value <= 0x1D590 {
    return "k".unicodeScalars
  }
  if value <= 0x1D591 {
    return "l".unicodeScalars
  }
  if value <= 0x1D592 {
    return "m".unicodeScalars
  }
  if value <= 0x1D593 {
    return "n".unicodeScalars
  }
  if value <= 0x1D594 {
    return "o".unicodeScalars
  }
  if value <= 0x1D595 {
    return "p".unicodeScalars
  }
  if value <= 0x1D596 {
    return "q".unicodeScalars
  }
  if value <= 0x1D597 {
    return "r".unicodeScalars
  }
  if value <= 0x1D598 {
    return "s".unicodeScalars
  }
  if value <= 0x1D599 {
    return "t".unicodeScalars
  }
  if value <= 0x1D59A {
    return "u".unicodeScalars
  }
  if value <= 0x1D59B {
    return "v".unicodeScalars
  }
  if value <= 0x1D59C {
    return "w".unicodeScalars
  }
  if value <= 0x1D59D {
    return "x".unicodeScalars
  }
  if value <= 0x1D59E {
    return "y".unicodeScalars
  }
  if value <= 0x1D59F {
    return "z".unicodeScalars
  }
  if value <= 0x1D5A0 {
    return "A".unicodeScalars
  }
  if value <= 0x1D5A1 {
    return "B".unicodeScalars
  }
  if value <= 0x1D5A2 {
    return "C".unicodeScalars
  }
  if value <= 0x1D5A3 {
    return "D".unicodeScalars
  }
  if value <= 0x1D5A4 {
    return "E".unicodeScalars
  }
  if value <= 0x1D5A5 {
    return "F".unicodeScalars
  }
  if value <= 0x1D5A6 {
    return "G".unicodeScalars
  }
  if value <= 0x1D5A7 {
    return "H".unicodeScalars
  }
  if value <= 0x1D5A8 {
    return "I".unicodeScalars
  }
  if value <= 0x1D5A9 {
    return "J".unicodeScalars
  }
  if value <= 0x1D5AA {
    return "K".unicodeScalars
  }
  if value <= 0x1D5AB {
    return "L".unicodeScalars
  }
  if value <= 0x1D5AC {
    return "M".unicodeScalars
  }
  if value <= 0x1D5AD {
    return "N".unicodeScalars
  }
  if value <= 0x1D5AE {
    return "O".unicodeScalars
  }
  if value <= 0x1D5AF {
    return "P".unicodeScalars
  }
  if value <= 0x1D5B0 {
    return "Q".unicodeScalars
  }
  if value <= 0x1D5B1 {
    return "R".unicodeScalars
  }
  if value <= 0x1D5B2 {
    return "S".unicodeScalars
  }
  if value <= 0x1D5B3 {
    return "T".unicodeScalars
  }
  if value <= 0x1D5B4 {
    return "U".unicodeScalars
  }
  if value <= 0x1D5B5 {
    return "V".unicodeScalars
  }
  if value <= 0x1D5B6 {
    return "W".unicodeScalars
  }
  if value <= 0x1D5B7 {
    return "X".unicodeScalars
  }
  if value <= 0x1D5B8 {
    return "Y".unicodeScalars
  }
  if value <= 0x1D5B9 {
    return "Z".unicodeScalars
  }
  if value <= 0x1D5BA {
    return "a".unicodeScalars
  }
  if value <= 0x1D5BB {
    return "b".unicodeScalars
  }
  if value <= 0x1D5BC {
    return "c".unicodeScalars
  }
  if value <= 0x1D5BD {
    return "d".unicodeScalars
  }
  if value <= 0x1D5BE {
    return "e".unicodeScalars
  }
  if value <= 0x1D5BF {
    return "f".unicodeScalars
  }
  if value <= 0x1D5C0 {
    return "g".unicodeScalars
  }
  if value <= 0x1D5C1 {
    return "h".unicodeScalars
  }
  if value <= 0x1D5C2 {
    return "i".unicodeScalars
  }
  if value <= 0x1D5C3 {
    return "j".unicodeScalars
  }
  if value <= 0x1D5C4 {
    return "k".unicodeScalars
  }
  if value <= 0x1D5C5 {
    return "l".unicodeScalars
  }
  if value <= 0x1D5C6 {
    return "m".unicodeScalars
  }
  if value <= 0x1D5C7 {
    return "n".unicodeScalars
  }
  if value <= 0x1D5C8 {
    return "o".unicodeScalars
  }
  if value <= 0x1D5C9 {
    return "p".unicodeScalars
  }
  if value <= 0x1D5CA {
    return "q".unicodeScalars
  }
  if value <= 0x1D5CB {
    return "r".unicodeScalars
  }
  if value <= 0x1D5CC {
    return "s".unicodeScalars
  }
  if value <= 0x1D5CD {
    return "t".unicodeScalars
  }
  if value <= 0x1D5CE {
    return "u".unicodeScalars
  }
  if value <= 0x1D5CF {
    return "v".unicodeScalars
  }
  if value <= 0x1D5D0 {
    return "w".unicodeScalars
  }
  if value <= 0x1D5D1 {
    return "x".unicodeScalars
  }
  if value <= 0x1D5D2 {
    return "y".unicodeScalars
  }
  if value <= 0x1D5D3 {
    return "z".unicodeScalars
  }
  if value <= 0x1D5D4 {
    return "A".unicodeScalars
  }
  if value <= 0x1D5D5 {
    return "B".unicodeScalars
  }
  if value <= 0x1D5D6 {
    return "C".unicodeScalars
  }
  if value <= 0x1D5D7 {
    return "D".unicodeScalars
  }
  if value <= 0x1D5D8 {
    return "E".unicodeScalars
  }
  if value <= 0x1D5D9 {
    return "F".unicodeScalars
  }
  if value <= 0x1D5DA {
    return "G".unicodeScalars
  }
  if value <= 0x1D5DB {
    return "H".unicodeScalars
  }
  if value <= 0x1D5DC {
    return "I".unicodeScalars
  }
  if value <= 0x1D5DD {
    return "J".unicodeScalars
  }
  if value <= 0x1D5DE {
    return "K".unicodeScalars
  }
  if value <= 0x1D5DF {
    return "L".unicodeScalars
  }
  if value <= 0x1D5E0 {
    return "M".unicodeScalars
  }
  if value <= 0x1D5E1 {
    return "N".unicodeScalars
  }
  if value <= 0x1D5E2 {
    return "O".unicodeScalars
  }
  if value <= 0x1D5E3 {
    return "P".unicodeScalars
  }
  if value <= 0x1D5E4 {
    return "Q".unicodeScalars
  }
  if value <= 0x1D5E5 {
    return "R".unicodeScalars
  }
  if value <= 0x1D5E6 {
    return "S".unicodeScalars
  }
  if value <= 0x1D5E7 {
    return "T".unicodeScalars
  }
  if value <= 0x1D5E8 {
    return "U".unicodeScalars
  }
  if value <= 0x1D5E9 {
    return "V".unicodeScalars
  }
  if value <= 0x1D5EA {
    return "W".unicodeScalars
  }
  if value <= 0x1D5EB {
    return "X".unicodeScalars
  }
  if value <= 0x1D5EC {
    return "Y".unicodeScalars
  }
  if value <= 0x1D5ED {
    return "Z".unicodeScalars
  }
  if value <= 0x1D5EE {
    return "a".unicodeScalars
  }
  if value <= 0x1D5EF {
    return "b".unicodeScalars
  }
  if value <= 0x1D5F0 {
    return "c".unicodeScalars
  }
  if value <= 0x1D5F1 {
    return "d".unicodeScalars
  }
  if value <= 0x1D5F2 {
    return "e".unicodeScalars
  }
  if value <= 0x1D5F3 {
    return "f".unicodeScalars
  }
  if value <= 0x1D5F4 {
    return "g".unicodeScalars
  }
  if value <= 0x1D5F5 {
    return "h".unicodeScalars
  }
  if value <= 0x1D5F6 {
    return "i".unicodeScalars
  }
  if value <= 0x1D5F7 {
    return "j".unicodeScalars
  }
  if value <= 0x1D5F8 {
    return "k".unicodeScalars
  }
  if value <= 0x1D5F9 {
    return "l".unicodeScalars
  }
  if value <= 0x1D5FA {
    return "m".unicodeScalars
  }
  if value <= 0x1D5FB {
    return "n".unicodeScalars
  }
  if value <= 0x1D5FC {
    return "o".unicodeScalars
  }
  if value <= 0x1D5FD {
    return "p".unicodeScalars
  }
  if value <= 0x1D5FE {
    return "q".unicodeScalars
  }
  if value <= 0x1D5FF {
    return "r".unicodeScalars
  }
  if value <= 0x1D600 {
    return "s".unicodeScalars
  }
  if value <= 0x1D601 {
    return "t".unicodeScalars
  }
  if value <= 0x1D602 {
    return "u".unicodeScalars
  }
  if value <= 0x1D603 {
    return "v".unicodeScalars
  }
  if value <= 0x1D604 {
    return "w".unicodeScalars
  }
  if value <= 0x1D605 {
    return "x".unicodeScalars
  }
  if value <= 0x1D606 {
    return "y".unicodeScalars
  }
  if value <= 0x1D607 {
    return "z".unicodeScalars
  }
  if value <= 0x1D608 {
    return "A".unicodeScalars
  }
  if value <= 0x1D609 {
    return "B".unicodeScalars
  }
  if value <= 0x1D60A {
    return "C".unicodeScalars
  }
  if value <= 0x1D60B {
    return "D".unicodeScalars
  }
  if value <= 0x1D60C {
    return "E".unicodeScalars
  }
  if value <= 0x1D60D {
    return "F".unicodeScalars
  }
  if value <= 0x1D60E {
    return "G".unicodeScalars
  }
  if value <= 0x1D60F {
    return "H".unicodeScalars
  }
  if value <= 0x1D610 {
    return "I".unicodeScalars
  }
  if value <= 0x1D611 {
    return "J".unicodeScalars
  }
  if value <= 0x1D612 {
    return "K".unicodeScalars
  }
  if value <= 0x1D613 {
    return "L".unicodeScalars
  }
  if value <= 0x1D614 {
    return "M".unicodeScalars
  }
  if value <= 0x1D615 {
    return "N".unicodeScalars
  }
  if value <= 0x1D616 {
    return "O".unicodeScalars
  }
  if value <= 0x1D617 {
    return "P".unicodeScalars
  }
  if value <= 0x1D618 {
    return "Q".unicodeScalars
  }
  if value <= 0x1D619 {
    return "R".unicodeScalars
  }
  if value <= 0x1D61A {
    return "S".unicodeScalars
  }
  if value <= 0x1D61B {
    return "T".unicodeScalars
  }
  if value <= 0x1D61C {
    return "U".unicodeScalars
  }
  if value <= 0x1D61D {
    return "V".unicodeScalars
  }
  if value <= 0x1D61E {
    return "W".unicodeScalars
  }
  if value <= 0x1D61F {
    return "X".unicodeScalars
  }
  if value <= 0x1D620 {
    return "Y".unicodeScalars
  }
  if value <= 0x1D621 {
    return "Z".unicodeScalars
  }
  if value <= 0x1D622 {
    return "a".unicodeScalars
  }
  if value <= 0x1D623 {
    return "b".unicodeScalars
  }
  if value <= 0x1D624 {
    return "c".unicodeScalars
  }
  if value <= 0x1D625 {
    return "d".unicodeScalars
  }
  if value <= 0x1D626 {
    return "e".unicodeScalars
  }
  if value <= 0x1D627 {
    return "f".unicodeScalars
  }
  if value <= 0x1D628 {
    return "g".unicodeScalars
  }
  if value <= 0x1D629 {
    return "h".unicodeScalars
  }
  if value <= 0x1D62A {
    return "i".unicodeScalars
  }
  if value <= 0x1D62B {
    return "j".unicodeScalars
  }
  if value <= 0x1D62C {
    return "k".unicodeScalars
  }
  if value <= 0x1D62D {
    return "l".unicodeScalars
  }
  if value <= 0x1D62E {
    return "m".unicodeScalars
  }
  if value <= 0x1D62F {
    return "n".unicodeScalars
  }
  if value <= 0x1D630 {
    return "o".unicodeScalars
  }
  if value <= 0x1D631 {
    return "p".unicodeScalars
  }
  if value <= 0x1D632 {
    return "q".unicodeScalars
  }
  if value <= 0x1D633 {
    return "r".unicodeScalars
  }
  if value <= 0x1D634 {
    return "s".unicodeScalars
  }
  if value <= 0x1D635 {
    return "t".unicodeScalars
  }
  if value <= 0x1D636 {
    return "u".unicodeScalars
  }
  if value <= 0x1D637 {
    return "v".unicodeScalars
  }
  if value <= 0x1D638 {
    return "w".unicodeScalars
  }
  if value <= 0x1D639 {
    return "x".unicodeScalars
  }
  if value <= 0x1D63A {
    return "y".unicodeScalars
  }
  if value <= 0x1D63B {
    return "z".unicodeScalars
  }
  if value <= 0x1D63C {
    return "A".unicodeScalars
  }
  if value <= 0x1D63D {
    return "B".unicodeScalars
  }
  if value <= 0x1D63E {
    return "C".unicodeScalars
  }
  if value <= 0x1D63F {
    return "D".unicodeScalars
  }
  if value <= 0x1D640 {
    return "E".unicodeScalars
  }
  if value <= 0x1D641 {
    return "F".unicodeScalars
  }
  if value <= 0x1D642 {
    return "G".unicodeScalars
  }
  if value <= 0x1D643 {
    return "H".unicodeScalars
  }
  if value <= 0x1D644 {
    return "I".unicodeScalars
  }
  if value <= 0x1D645 {
    return "J".unicodeScalars
  }
  if value <= 0x1D646 {
    return "K".unicodeScalars
  }
  if value <= 0x1D647 {
    return "L".unicodeScalars
  }
  if value <= 0x1D648 {
    return "M".unicodeScalars
  }
  if value <= 0x1D649 {
    return "N".unicodeScalars
  }
  if value <= 0x1D64A {
    return "O".unicodeScalars
  }
  if value <= 0x1D64B {
    return "P".unicodeScalars
  }
  if value <= 0x1D64C {
    return "Q".unicodeScalars
  }
  if value <= 0x1D64D {
    return "R".unicodeScalars
  }
  if value <= 0x1D64E {
    return "S".unicodeScalars
  }
  if value <= 0x1D64F {
    return "T".unicodeScalars
  }
  if value <= 0x1D650 {
    return "U".unicodeScalars
  }
  if value <= 0x1D651 {
    return "V".unicodeScalars
  }
  if value <= 0x1D652 {
    return "W".unicodeScalars
  }
  if value <= 0x1D653 {
    return "X".unicodeScalars
  }
  if value <= 0x1D654 {
    return "Y".unicodeScalars
  }
  if value <= 0x1D655 {
    return "Z".unicodeScalars
  }
  if value <= 0x1D656 {
    return "a".unicodeScalars
  }
  if value <= 0x1D657 {
    return "b".unicodeScalars
  }
  if value <= 0x1D658 {
    return "c".unicodeScalars
  }
  if value <= 0x1D659 {
    return "d".unicodeScalars
  }
  if value <= 0x1D65A {
    return "e".unicodeScalars
  }
  if value <= 0x1D65B {
    return "f".unicodeScalars
  }
  if value <= 0x1D65C {
    return "g".unicodeScalars
  }
  if value <= 0x1D65D {
    return "h".unicodeScalars
  }
  if value <= 0x1D65E {
    return "i".unicodeScalars
  }
  if value <= 0x1D65F {
    return "j".unicodeScalars
  }
  if value <= 0x1D660 {
    return "k".unicodeScalars
  }
  if value <= 0x1D661 {
    return "l".unicodeScalars
  }
  if value <= 0x1D662 {
    return "m".unicodeScalars
  }
  if value <= 0x1D663 {
    return "n".unicodeScalars
  }
  if value <= 0x1D664 {
    return "o".unicodeScalars
  }
  if value <= 0x1D665 {
    return "p".unicodeScalars
  }
  if value <= 0x1D666 {
    return "q".unicodeScalars
  }
  if value <= 0x1D667 {
    return "r".unicodeScalars
  }
  if value <= 0x1D668 {
    return "s".unicodeScalars
  }
  if value <= 0x1D669 {
    return "t".unicodeScalars
  }
  if value <= 0x1D66A {
    return "u".unicodeScalars
  }
  if value <= 0x1D66B {
    return "v".unicodeScalars
  }
  if value <= 0x1D66C {
    return "w".unicodeScalars
  }
  if value <= 0x1D66D {
    return "x".unicodeScalars
  }
  if value <= 0x1D66E {
    return "y".unicodeScalars
  }
  if value <= 0x1D66F {
    return "z".unicodeScalars
  }
  if value <= 0x1D670 {
    return "A".unicodeScalars
  }
  if value <= 0x1D671 {
    return "B".unicodeScalars
  }
  if value <= 0x1D672 {
    return "C".unicodeScalars
  }
  if value <= 0x1D673 {
    return "D".unicodeScalars
  }
  if value <= 0x1D674 {
    return "E".unicodeScalars
  }
  if value <= 0x1D675 {
    return "F".unicodeScalars
  }
  if value <= 0x1D676 {
    return "G".unicodeScalars
  }
  if value <= 0x1D677 {
    return "H".unicodeScalars
  }
  if value <= 0x1D678 {
    return "I".unicodeScalars
  }
  if value <= 0x1D679 {
    return "J".unicodeScalars
  }
  if value <= 0x1D67A {
    return "K".unicodeScalars
  }
  if value <= 0x1D67B {
    return "L".unicodeScalars
  }
  if value <= 0x1D67C {
    return "M".unicodeScalars
  }
  if value <= 0x1D67D {
    return "N".unicodeScalars
  }
  if value <= 0x1D67E {
    return "O".unicodeScalars
  }
  if value <= 0x1D67F {
    return "P".unicodeScalars
  }
  if value <= 0x1D680 {
    return "Q".unicodeScalars
  }
  if value <= 0x1D681 {
    return "R".unicodeScalars
  }
  if value <= 0x1D682 {
    return "S".unicodeScalars
  }
  if value <= 0x1D683 {
    return "T".unicodeScalars
  }
  if value <= 0x1D684 {
    return "U".unicodeScalars
  }
  if value <= 0x1D685 {
    return "V".unicodeScalars
  }
  if value <= 0x1D686 {
    return "W".unicodeScalars
  }
  if value <= 0x1D687 {
    return "X".unicodeScalars
  }
  if value <= 0x1D688 {
    return "Y".unicodeScalars
  }
  if value <= 0x1D689 {
    return "Z".unicodeScalars
  }
  if value <= 0x1D68A {
    return "a".unicodeScalars
  }
  if value <= 0x1D68B {
    return "b".unicodeScalars
  }
  if value <= 0x1D68C {
    return "c".unicodeScalars
  }
  if value <= 0x1D68D {
    return "d".unicodeScalars
  }
  if value <= 0x1D68E {
    return "e".unicodeScalars
  }
  if value <= 0x1D68F {
    return "f".unicodeScalars
  }
  if value <= 0x1D690 {
    return "g".unicodeScalars
  }
  if value <= 0x1D691 {
    return "h".unicodeScalars
  }
  if value <= 0x1D692 {
    return "i".unicodeScalars
  }
  if value <= 0x1D693 {
    return "j".unicodeScalars
  }
  if value <= 0x1D694 {
    return "k".unicodeScalars
  }
  if value <= 0x1D695 {
    return "l".unicodeScalars
  }
  if value <= 0x1D696 {
    return "m".unicodeScalars
  }
  if value <= 0x1D697 {
    return "n".unicodeScalars
  }
  if value <= 0x1D698 {
    return "o".unicodeScalars
  }
  if value <= 0x1D699 {
    return "p".unicodeScalars
  }
  if value <= 0x1D69A {
    return "q".unicodeScalars
  }
  if value <= 0x1D69B {
    return "r".unicodeScalars
  }
  if value <= 0x1D69C {
    return "s".unicodeScalars
  }
  if value <= 0x1D69D {
    return "t".unicodeScalars
  }
  if value <= 0x1D69E {
    return "u".unicodeScalars
  }
  if value <= 0x1D69F {
    return "v".unicodeScalars
  }
  if value <= 0x1D6A0 {
    return "w".unicodeScalars
  }
  if value <= 0x1D6A1 {
    return "x".unicodeScalars
  }
  if value <= 0x1D6A2 {
    return "y".unicodeScalars
  }
  if value <= 0x1D6A3 {
    return "z".unicodeScalars
  }
  if value <= 0x1D6A4 {
    return "ı".unicodeScalars
  }
  if value <= 0x1D6A5 {
    return "ȷ".unicodeScalars
  }
  if value <= 0x1D6A7 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1D6A8 {
    return "Α".unicodeScalars
  }
  if value <= 0x1D6A9 {
    return "Β".unicodeScalars
  }
  if value <= 0x1D6AA {
    return "Γ".unicodeScalars
  }
  if value <= 0x1D6AB {
    return "Δ".unicodeScalars
  }
  if value <= 0x1D6AC {
    return "Ε".unicodeScalars
  }
  if value <= 0x1D6AD {
    return "Ζ".unicodeScalars
  }
  if value <= 0x1D6AE {
    return "Η".unicodeScalars
  }
  if value <= 0x1D6AF {
    return "Θ".unicodeScalars
  }
  if value <= 0x1D6B0 {
    return "Ι".unicodeScalars
  }
  if value <= 0x1D6B1 {
    return "Κ".unicodeScalars
  }
  if value <= 0x1D6B2 {
    return "Λ".unicodeScalars
  }
  if value <= 0x1D6B3 {
    return "Μ".unicodeScalars
  }
  if value <= 0x1D6B4 {
    return "Ν".unicodeScalars
  }
  if value <= 0x1D6B5 {
    return "Ξ".unicodeScalars
  }
  if value <= 0x1D6B6 {
    return "Ο".unicodeScalars
  }
  if value <= 0x1D6B7 {
    return "Π".unicodeScalars
  }
  if value <= 0x1D6B8 {
    return "Ρ".unicodeScalars
  }
  if value <= 0x1D6B9 {
    return "Θ".unicodeScalars
  }
  if value <= 0x1D6BA {
    return "Σ".unicodeScalars
  }
  if value <= 0x1D6BB {
    return "Τ".unicodeScalars
  }
  if value <= 0x1D6BC {
    return "Υ".unicodeScalars
  }
  if value <= 0x1D6BD {
    return "Φ".unicodeScalars
  }
  if value <= 0x1D6BE {
    return "Χ".unicodeScalars
  }
  if value <= 0x1D6BF {
    return "Ψ".unicodeScalars
  }
  if value <= 0x1D6C0 {
    return "Ω".unicodeScalars
  }
  if value <= 0x1D6C1 {
    return "∇".unicodeScalars
  }
  if value <= 0x1D6C2 {
    return "α".unicodeScalars
  }
  if value <= 0x1D6C3 {
    return "β".unicodeScalars
  }
  if value <= 0x1D6C4 {
    return "γ".unicodeScalars
  }
  if value <= 0x1D6C5 {
    return "δ".unicodeScalars
  }
  if value <= 0x1D6C6 {
    return "ε".unicodeScalars
  }
  if value <= 0x1D6C7 {
    return "ζ".unicodeScalars
  }
  if value <= 0x1D6C8 {
    return "η".unicodeScalars
  }
  if value <= 0x1D6C9 {
    return "θ".unicodeScalars
  }
  if value <= 0x1D6CA {
    return "ι".unicodeScalars
  }
  if value <= 0x1D6CB {
    return "κ".unicodeScalars
  }
  if value <= 0x1D6CC {
    return "λ".unicodeScalars
  }
  if value <= 0x1D6CD {
    return "μ".unicodeScalars
  }
  if value <= 0x1D6CE {
    return "ν".unicodeScalars
  }
  if value <= 0x1D6CF {
    return "ξ".unicodeScalars
  }
  if value <= 0x1D6D0 {
    return "ο".unicodeScalars
  }
  if value <= 0x1D6D1 {
    return "π".unicodeScalars
  }
  if value <= 0x1D6D2 {
    return "ρ".unicodeScalars
  }
  if value <= 0x1D6D3 {
    return "ς".unicodeScalars
  }
  if value <= 0x1D6D4 {
    return "σ".unicodeScalars
  }
  if value <= 0x1D6D5 {
    return "τ".unicodeScalars
  }
  if value <= 0x1D6D6 {
    return "υ".unicodeScalars
  }
  if value <= 0x1D6D7 {
    return "φ".unicodeScalars
  }
  if value <= 0x1D6D8 {
    return "χ".unicodeScalars
  }
  if value <= 0x1D6D9 {
    return "ψ".unicodeScalars
  }
  if value <= 0x1D6DA {
    return "ω".unicodeScalars
  }
  if value <= 0x1D6DB {
    return "∂".unicodeScalars
  }
  if value <= 0x1D6DC {
    return "ε".unicodeScalars
  }
  if value <= 0x1D6DD {
    return "θ".unicodeScalars
  }
  if value <= 0x1D6DE {
    return "κ".unicodeScalars
  }
  if value <= 0x1D6DF {
    return "φ".unicodeScalars
  }
  if value <= 0x1D6E0 {
    return "ρ".unicodeScalars
  }
  if value <= 0x1D6E1 {
    return "π".unicodeScalars
  }
  if value <= 0x1D6E2 {
    return "Α".unicodeScalars
  }
  if value <= 0x1D6E3 {
    return "Β".unicodeScalars
  }
  if value <= 0x1D6E4 {
    return "Γ".unicodeScalars
  }
  if value <= 0x1D6E5 {
    return "Δ".unicodeScalars
  }
  if value <= 0x1D6E6 {
    return "Ε".unicodeScalars
  }
  if value <= 0x1D6E7 {
    return "Ζ".unicodeScalars
  }
  if value <= 0x1D6E8 {
    return "Η".unicodeScalars
  }
  if value <= 0x1D6E9 {
    return "Θ".unicodeScalars
  }
  if value <= 0x1D6EA {
    return "Ι".unicodeScalars
  }
  if value <= 0x1D6EB {
    return "Κ".unicodeScalars
  }
  if value <= 0x1D6EC {
    return "Λ".unicodeScalars
  }
  if value <= 0x1D6ED {
    return "Μ".unicodeScalars
  }
  if value <= 0x1D6EE {
    return "Ν".unicodeScalars
  }
  if value <= 0x1D6EF {
    return "Ξ".unicodeScalars
  }
  if value <= 0x1D6F0 {
    return "Ο".unicodeScalars
  }
  if value <= 0x1D6F1 {
    return "Π".unicodeScalars
  }
  if value <= 0x1D6F2 {
    return "Ρ".unicodeScalars
  }
  if value <= 0x1D6F3 {
    return "Θ".unicodeScalars
  }
  if value <= 0x1D6F4 {
    return "Σ".unicodeScalars
  }
  if value <= 0x1D6F5 {
    return "Τ".unicodeScalars
  }
  if value <= 0x1D6F6 {
    return "Υ".unicodeScalars
  }
  if value <= 0x1D6F7 {
    return "Φ".unicodeScalars
  }
  if value <= 0x1D6F8 {
    return "Χ".unicodeScalars
  }
  if value <= 0x1D6F9 {
    return "Ψ".unicodeScalars
  }
  if value <= 0x1D6FA {
    return "Ω".unicodeScalars
  }
  if value <= 0x1D6FB {
    return "∇".unicodeScalars
  }
  if value <= 0x1D6FC {
    return "α".unicodeScalars
  }
  if value <= 0x1D6FD {
    return "β".unicodeScalars
  }
  if value <= 0x1D6FE {
    return "γ".unicodeScalars
  }
  if value <= 0x1D6FF {
    return "δ".unicodeScalars
  }
  if value <= 0x1D700 {
    return "ε".unicodeScalars
  }
  if value <= 0x1D701 {
    return "ζ".unicodeScalars
  }
  if value <= 0x1D702 {
    return "η".unicodeScalars
  }
  if value <= 0x1D703 {
    return "θ".unicodeScalars
  }
  if value <= 0x1D704 {
    return "ι".unicodeScalars
  }
  if value <= 0x1D705 {
    return "κ".unicodeScalars
  }
  if value <= 0x1D706 {
    return "λ".unicodeScalars
  }
  if value <= 0x1D707 {
    return "μ".unicodeScalars
  }
  if value <= 0x1D708 {
    return "ν".unicodeScalars
  }
  if value <= 0x1D709 {
    return "ξ".unicodeScalars
  }
  if value <= 0x1D70A {
    return "ο".unicodeScalars
  }
  if value <= 0x1D70B {
    return "π".unicodeScalars
  }
  if value <= 0x1D70C {
    return "ρ".unicodeScalars
  }
  if value <= 0x1D70D {
    return "ς".unicodeScalars
  }
  if value <= 0x1D70E {
    return "σ".unicodeScalars
  }
  if value <= 0x1D70F {
    return "τ".unicodeScalars
  }
  if value <= 0x1D710 {
    return "υ".unicodeScalars
  }
  if value <= 0x1D711 {
    return "φ".unicodeScalars
  }
  if value <= 0x1D712 {
    return "χ".unicodeScalars
  }
  if value <= 0x1D713 {
    return "ψ".unicodeScalars
  }
  if value <= 0x1D714 {
    return "ω".unicodeScalars
  }
  if value <= 0x1D715 {
    return "∂".unicodeScalars
  }
  if value <= 0x1D716 {
    return "ε".unicodeScalars
  }
  if value <= 0x1D717 {
    return "θ".unicodeScalars
  }
  if value <= 0x1D718 {
    return "κ".unicodeScalars
  }
  if value <= 0x1D719 {
    return "φ".unicodeScalars
  }
  if value <= 0x1D71A {
    return "ρ".unicodeScalars
  }
  if value <= 0x1D71B {
    return "π".unicodeScalars
  }
  if value <= 0x1D71C {
    return "Α".unicodeScalars
  }
  if value <= 0x1D71D {
    return "Β".unicodeScalars
  }
  if value <= 0x1D71E {
    return "Γ".unicodeScalars
  }
  if value <= 0x1D71F {
    return "Δ".unicodeScalars
  }
  if value <= 0x1D720 {
    return "Ε".unicodeScalars
  }
  if value <= 0x1D721 {
    return "Ζ".unicodeScalars
  }
  if value <= 0x1D722 {
    return "Η".unicodeScalars
  }
  if value <= 0x1D723 {
    return "Θ".unicodeScalars
  }
  if value <= 0x1D724 {
    return "Ι".unicodeScalars
  }
  if value <= 0x1D725 {
    return "Κ".unicodeScalars
  }
  if value <= 0x1D726 {
    return "Λ".unicodeScalars
  }
  if value <= 0x1D727 {
    return "Μ".unicodeScalars
  }
  if value <= 0x1D728 {
    return "Ν".unicodeScalars
  }
  if value <= 0x1D729 {
    return "Ξ".unicodeScalars
  }
  if value <= 0x1D72A {
    return "Ο".unicodeScalars
  }
  if value <= 0x1D72B {
    return "Π".unicodeScalars
  }
  if value <= 0x1D72C {
    return "Ρ".unicodeScalars
  }
  if value <= 0x1D72D {
    return "Θ".unicodeScalars
  }
  if value <= 0x1D72E {
    return "Σ".unicodeScalars
  }
  if value <= 0x1D72F {
    return "Τ".unicodeScalars
  }
  if value <= 0x1D730 {
    return "Υ".unicodeScalars
  }
  if value <= 0x1D731 {
    return "Φ".unicodeScalars
  }
  if value <= 0x1D732 {
    return "Χ".unicodeScalars
  }
  if value <= 0x1D733 {
    return "Ψ".unicodeScalars
  }
  if value <= 0x1D734 {
    return "Ω".unicodeScalars
  }
  if value <= 0x1D735 {
    return "∇".unicodeScalars
  }
  if value <= 0x1D736 {
    return "α".unicodeScalars
  }
  if value <= 0x1D737 {
    return "β".unicodeScalars
  }
  if value <= 0x1D738 {
    return "γ".unicodeScalars
  }
  if value <= 0x1D739 {
    return "δ".unicodeScalars
  }
  if value <= 0x1D73A {
    return "ε".unicodeScalars
  }
  if value <= 0x1D73B {
    return "ζ".unicodeScalars
  }
  if value <= 0x1D73C {
    return "η".unicodeScalars
  }
  if value <= 0x1D73D {
    return "θ".unicodeScalars
  }
  if value <= 0x1D73E {
    return "ι".unicodeScalars
  }
  if value <= 0x1D73F {
    return "κ".unicodeScalars
  }
  if value <= 0x1D740 {
    return "λ".unicodeScalars
  }
  if value <= 0x1D741 {
    return "μ".unicodeScalars
  }
  if value <= 0x1D742 {
    return "ν".unicodeScalars
  }
  if value <= 0x1D743 {
    return "ξ".unicodeScalars
  }
  if value <= 0x1D744 {
    return "ο".unicodeScalars
  }
  if value <= 0x1D745 {
    return "π".unicodeScalars
  }
  if value <= 0x1D746 {
    return "ρ".unicodeScalars
  }
  if value <= 0x1D747 {
    return "ς".unicodeScalars
  }
  if value <= 0x1D748 {
    return "σ".unicodeScalars
  }
  if value <= 0x1D749 {
    return "τ".unicodeScalars
  }
  if value <= 0x1D74A {
    return "υ".unicodeScalars
  }
  if value <= 0x1D74B {
    return "φ".unicodeScalars
  }
  if value <= 0x1D74C {
    return "χ".unicodeScalars
  }
  if value <= 0x1D74D {
    return "ψ".unicodeScalars
  }
  if value <= 0x1D74E {
    return "ω".unicodeScalars
  }
  if value <= 0x1D74F {
    return "∂".unicodeScalars
  }
  if value <= 0x1D750 {
    return "ε".unicodeScalars
  }
  if value <= 0x1D751 {
    return "θ".unicodeScalars
  }
  if value <= 0x1D752 {
    return "κ".unicodeScalars
  }
  if value <= 0x1D753 {
    return "φ".unicodeScalars
  }
  if value <= 0x1D754 {
    return "ρ".unicodeScalars
  }
  if value <= 0x1D755 {
    return "π".unicodeScalars
  }
  if value <= 0x1D756 {
    return "Α".unicodeScalars
  }
  if value <= 0x1D757 {
    return "Β".unicodeScalars
  }
  if value <= 0x1D758 {
    return "Γ".unicodeScalars
  }
  if value <= 0x1D759 {
    return "Δ".unicodeScalars
  }
  if value <= 0x1D75A {
    return "Ε".unicodeScalars
  }
  if value <= 0x1D75B {
    return "Ζ".unicodeScalars
  }
  if value <= 0x1D75C {
    return "Η".unicodeScalars
  }
  if value <= 0x1D75D {
    return "Θ".unicodeScalars
  }
  if value <= 0x1D75E {
    return "Ι".unicodeScalars
  }
  if value <= 0x1D75F {
    return "Κ".unicodeScalars
  }
  if value <= 0x1D760 {
    return "Λ".unicodeScalars
  }
  if value <= 0x1D761 {
    return "Μ".unicodeScalars
  }
  if value <= 0x1D762 {
    return "Ν".unicodeScalars
  }
  if value <= 0x1D763 {
    return "Ξ".unicodeScalars
  }
  if value <= 0x1D764 {
    return "Ο".unicodeScalars
  }
  if value <= 0x1D765 {
    return "Π".unicodeScalars
  }
  if value <= 0x1D766 {
    return "Ρ".unicodeScalars
  }
  if value <= 0x1D767 {
    return "Θ".unicodeScalars
  }
  if value <= 0x1D768 {
    return "Σ".unicodeScalars
  }
  if value <= 0x1D769 {
    return "Τ".unicodeScalars
  }
  if value <= 0x1D76A {
    return "Υ".unicodeScalars
  }
  if value <= 0x1D76B {
    return "Φ".unicodeScalars
  }
  if value <= 0x1D76C {
    return "Χ".unicodeScalars
  }
  if value <= 0x1D76D {
    return "Ψ".unicodeScalars
  }
  if value <= 0x1D76E {
    return "Ω".unicodeScalars
  }
  if value <= 0x1D76F {
    return "∇".unicodeScalars
  }
  if value <= 0x1D770 {
    return "α".unicodeScalars
  }
  if value <= 0x1D771 {
    return "β".unicodeScalars
  }
  if value <= 0x1D772 {
    return "γ".unicodeScalars
  }
  if value <= 0x1D773 {
    return "δ".unicodeScalars
  }
  if value <= 0x1D774 {
    return "ε".unicodeScalars
  }
  if value <= 0x1D775 {
    return "ζ".unicodeScalars
  }
  if value <= 0x1D776 {
    return "η".unicodeScalars
  }
  if value <= 0x1D777 {
    return "θ".unicodeScalars
  }
  if value <= 0x1D778 {
    return "ι".unicodeScalars
  }
  if value <= 0x1D779 {
    return "κ".unicodeScalars
  }
  if value <= 0x1D77A {
    return "λ".unicodeScalars
  }
  if value <= 0x1D77B {
    return "μ".unicodeScalars
  }
  if value <= 0x1D77C {
    return "ν".unicodeScalars
  }
  if value <= 0x1D77D {
    return "ξ".unicodeScalars
  }
  if value <= 0x1D77E {
    return "ο".unicodeScalars
  }
  if value <= 0x1D77F {
    return "π".unicodeScalars
  }
  if value <= 0x1D780 {
    return "ρ".unicodeScalars
  }
  if value <= 0x1D781 {
    return "ς".unicodeScalars
  }
  if value <= 0x1D782 {
    return "σ".unicodeScalars
  }
  if value <= 0x1D783 {
    return "τ".unicodeScalars
  }
  if value <= 0x1D784 {
    return "υ".unicodeScalars
  }
  if value <= 0x1D785 {
    return "φ".unicodeScalars
  }
  if value <= 0x1D786 {
    return "χ".unicodeScalars
  }
  if value <= 0x1D787 {
    return "ψ".unicodeScalars
  }
  if value <= 0x1D788 {
    return "ω".unicodeScalars
  }
  if value <= 0x1D789 {
    return "∂".unicodeScalars
  }
  if value <= 0x1D78A {
    return "ε".unicodeScalars
  }
  if value <= 0x1D78B {
    return "θ".unicodeScalars
  }
  if value <= 0x1D78C {
    return "κ".unicodeScalars
  }
  if value <= 0x1D78D {
    return "φ".unicodeScalars
  }
  if value <= 0x1D78E {
    return "ρ".unicodeScalars
  }
  if value <= 0x1D78F {
    return "π".unicodeScalars
  }
  if value <= 0x1D790 {
    return "Α".unicodeScalars
  }
  if value <= 0x1D791 {
    return "Β".unicodeScalars
  }
  if value <= 0x1D792 {
    return "Γ".unicodeScalars
  }
  if value <= 0x1D793 {
    return "Δ".unicodeScalars
  }
  if value <= 0x1D794 {
    return "Ε".unicodeScalars
  }
  if value <= 0x1D795 {
    return "Ζ".unicodeScalars
  }
  if value <= 0x1D796 {
    return "Η".unicodeScalars
  }
  if value <= 0x1D797 {
    return "Θ".unicodeScalars
  }
  if value <= 0x1D798 {
    return "Ι".unicodeScalars
  }
  if value <= 0x1D799 {
    return "Κ".unicodeScalars
  }
  if value <= 0x1D79A {
    return "Λ".unicodeScalars
  }
  if value <= 0x1D79B {
    return "Μ".unicodeScalars
  }
  if value <= 0x1D79C {
    return "Ν".unicodeScalars
  }
  if value <= 0x1D79D {
    return "Ξ".unicodeScalars
  }
  if value <= 0x1D79E {
    return "Ο".unicodeScalars
  }
  if value <= 0x1D79F {
    return "Π".unicodeScalars
  }
  if value <= 0x1D7A0 {
    return "Ρ".unicodeScalars
  }
  if value <= 0x1D7A1 {
    return "Θ".unicodeScalars
  }
  if value <= 0x1D7A2 {
    return "Σ".unicodeScalars
  }
  if value <= 0x1D7A3 {
    return "Τ".unicodeScalars
  }
  if value <= 0x1D7A4 {
    return "Υ".unicodeScalars
  }
  if value <= 0x1D7A5 {
    return "Φ".unicodeScalars
  }
  if value <= 0x1D7A6 {
    return "Χ".unicodeScalars
  }
  if value <= 0x1D7A7 {
    return "Ψ".unicodeScalars
  }
  if value <= 0x1D7A8 {
    return "Ω".unicodeScalars
  }
  if value <= 0x1D7A9 {
    return "∇".unicodeScalars
  }
  if value <= 0x1D7AA {
    return "α".unicodeScalars
  }
  if value <= 0x1D7AB {
    return "β".unicodeScalars
  }
  if value <= 0x1D7AC {
    return "γ".unicodeScalars
  }
  if value <= 0x1D7AD {
    return "δ".unicodeScalars
  }
  if value <= 0x1D7AE {
    return "ε".unicodeScalars
  }
  if value <= 0x1D7AF {
    return "ζ".unicodeScalars
  }
  if value <= 0x1D7B0 {
    return "η".unicodeScalars
  }
  if value <= 0x1D7B1 {
    return "θ".unicodeScalars
  }
  if value <= 0x1D7B2 {
    return "ι".unicodeScalars
  }
  if value <= 0x1D7B3 {
    return "κ".unicodeScalars
  }
  if value <= 0x1D7B4 {
    return "λ".unicodeScalars
  }
  if value <= 0x1D7B5 {
    return "μ".unicodeScalars
  }
  if value <= 0x1D7B6 {
    return "ν".unicodeScalars
  }
  if value <= 0x1D7B7 {
    return "ξ".unicodeScalars
  }
  if value <= 0x1D7B8 {
    return "ο".unicodeScalars
  }
  if value <= 0x1D7B9 {
    return "π".unicodeScalars
  }
  if value <= 0x1D7BA {
    return "ρ".unicodeScalars
  }
  if value <= 0x1D7BB {
    return "ς".unicodeScalars
  }
  if value <= 0x1D7BC {
    return "σ".unicodeScalars
  }
  if value <= 0x1D7BD {
    return "τ".unicodeScalars
  }
  if value <= 0x1D7BE {
    return "υ".unicodeScalars
  }
  if value <= 0x1D7BF {
    return "φ".unicodeScalars
  }
  if value <= 0x1D7C0 {
    return "χ".unicodeScalars
  }
  if value <= 0x1D7C1 {
    return "ψ".unicodeScalars
  }
  if value <= 0x1D7C2 {
    return "ω".unicodeScalars
  }
  if value <= 0x1D7C3 {
    return "∂".unicodeScalars
  }
  if value <= 0x1D7C4 {
    return "ε".unicodeScalars
  }
  if value <= 0x1D7C5 {
    return "θ".unicodeScalars
  }
  if value <= 0x1D7C6 {
    return "κ".unicodeScalars
  }
  if value <= 0x1D7C7 {
    return "φ".unicodeScalars
  }
  if value <= 0x1D7C8 {
    return "ρ".unicodeScalars
  }
  if value <= 0x1D7C9 {
    return "π".unicodeScalars
  }
  if value <= 0x1D7CA {
    return "Ϝ".unicodeScalars
  }
  if value <= 0x1D7CB {
    return "ϝ".unicodeScalars
  }
  if value <= 0x1D7CD {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1D7CE {
    return "0".unicodeScalars
  }
  if value <= 0x1D7CF {
    return "1".unicodeScalars
  }
  if value <= 0x1D7D0 {
    return "2".unicodeScalars
  }
  if value <= 0x1D7D1 {
    return "3".unicodeScalars
  }
  if value <= 0x1D7D2 {
    return "4".unicodeScalars
  }
  if value <= 0x1D7D3 {
    return "5".unicodeScalars
  }
  if value <= 0x1D7D4 {
    return "6".unicodeScalars
  }
  if value <= 0x1D7D5 {
    return "7".unicodeScalars
  }
  if value <= 0x1D7D6 {
    return "8".unicodeScalars
  }
  if value <= 0x1D7D7 {
    return "9".unicodeScalars
  }
  if value <= 0x1D7D8 {
    return "0".unicodeScalars
  }
  if value <= 0x1D7D9 {
    return "1".unicodeScalars
  }
  if value <= 0x1D7DA {
    return "2".unicodeScalars
  }
  if value <= 0x1D7DB {
    return "3".unicodeScalars
  }
  if value <= 0x1D7DC {
    return "4".unicodeScalars
  }
  if value <= 0x1D7DD {
    return "5".unicodeScalars
  }
  if value <= 0x1D7DE {
    return "6".unicodeScalars
  }
  if value <= 0x1D7DF {
    return "7".unicodeScalars
  }
  if value <= 0x1D7E0 {
    return "8".unicodeScalars
  }
  if value <= 0x1D7E1 {
    return "9".unicodeScalars
  }
  if value <= 0x1D7E2 {
    return "0".unicodeScalars
  }
  if value <= 0x1D7E3 {
    return "1".unicodeScalars
  }
  if value <= 0x1D7E4 {
    return "2".unicodeScalars
  }
  if value <= 0x1D7E5 {
    return "3".unicodeScalars
  }
  if value <= 0x1D7E6 {
    return "4".unicodeScalars
  }
  if value <= 0x1D7E7 {
    return "5".unicodeScalars
  }
  if value <= 0x1D7E8 {
    return "6".unicodeScalars
  }
  if value <= 0x1D7E9 {
    return "7".unicodeScalars
  }
  if value <= 0x1D7EA {
    return "8".unicodeScalars
  }
  if value <= 0x1D7EB {
    return "9".unicodeScalars
  }
  if value <= 0x1D7EC {
    return "0".unicodeScalars
  }
  if value <= 0x1D7ED {
    return "1".unicodeScalars
  }
  if value <= 0x1D7EE {
    return "2".unicodeScalars
  }
  if value <= 0x1D7EF {
    return "3".unicodeScalars
  }
  if value <= 0x1D7F0 {
    return "4".unicodeScalars
  }
  if value <= 0x1D7F1 {
    return "5".unicodeScalars
  }
  if value <= 0x1D7F2 {
    return "6".unicodeScalars
  }
  if value <= 0x1D7F3 {
    return "7".unicodeScalars
  }
  if value <= 0x1D7F4 {
    return "8".unicodeScalars
  }
  if value <= 0x1D7F5 {
    return "9".unicodeScalars
  }
  if value <= 0x1D7F6 {
    return "0".unicodeScalars
  }
  if value <= 0x1D7F7 {
    return "1".unicodeScalars
  }
  if value <= 0x1D7F8 {
    return "2".unicodeScalars
  }
  if value <= 0x1D7F9 {
    return "3".unicodeScalars
  }
  if value <= 0x1D7FA {
    return "4".unicodeScalars
  }
  if value <= 0x1D7FB {
    return "5".unicodeScalars
  }
  if value <= 0x1D7FC {
    return "6".unicodeScalars
  }
  if value <= 0x1D7FD {
    return "7".unicodeScalars
  }
  if value <= 0x1D7FE {
    return "8".unicodeScalars
  }
  if value <= 0x1D7FF {
    return "9".unicodeScalars
  }
  if value <= 0x1E02F {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1E030 {
    return "а".unicodeScalars
  }
  if value <= 0x1E031 {
    return "б".unicodeScalars
  }
  if value <= 0x1E032 {
    return "в".unicodeScalars
  }
  if value <= 0x1E033 {
    return "г".unicodeScalars
  }
  if value <= 0x1E034 {
    return "д".unicodeScalars
  }
  if value <= 0x1E035 {
    return "е".unicodeScalars
  }
  if value <= 0x1E036 {
    return "ж".unicodeScalars
  }
  if value <= 0x1E037 {
    return "з".unicodeScalars
  }
  if value <= 0x1E038 {
    return "и".unicodeScalars
  }
  if value <= 0x1E039 {
    return "к".unicodeScalars
  }
  if value <= 0x1E03A {
    return "л".unicodeScalars
  }
  if value <= 0x1E03B {
    return "м".unicodeScalars
  }
  if value <= 0x1E03C {
    return "о".unicodeScalars
  }
  if value <= 0x1E03D {
    return "п".unicodeScalars
  }
  if value <= 0x1E03E {
    return "р".unicodeScalars
  }
  if value <= 0x1E03F {
    return "с".unicodeScalars
  }
  if value <= 0x1E040 {
    return "т".unicodeScalars
  }
  if value <= 0x1E041 {
    return "у".unicodeScalars
  }
  if value <= 0x1E042 {
    return "ф".unicodeScalars
  }
  if value <= 0x1E043 {
    return "х".unicodeScalars
  }
  if value <= 0x1E044 {
    return "ц".unicodeScalars
  }
  if value <= 0x1E045 {
    return "ч".unicodeScalars
  }
  if value <= 0x1E046 {
    return "ш".unicodeScalars
  }
  if value <= 0x1E047 {
    return "ы".unicodeScalars
  }
  if value <= 0x1E048 {
    return "э".unicodeScalars
  }
  if value <= 0x1E049 {
    return "ю".unicodeScalars
  }
  if value <= 0x1E04A {
    return "ꚉ".unicodeScalars
  }
  if value <= 0x1E04B {
    return "ә".unicodeScalars
  }
  if value <= 0x1E04C {
    return "і".unicodeScalars
  }
  if value <= 0x1E04D {
    return "ј".unicodeScalars
  }
  if value <= 0x1E04E {
    return "ө".unicodeScalars
  }
  if value <= 0x1E04F {
    return "ү".unicodeScalars
  }
  if value <= 0x1E050 {
    return "ӏ".unicodeScalars
  }
  if value <= 0x1E051 {
    return "а".unicodeScalars
  }
  if value <= 0x1E052 {
    return "б".unicodeScalars
  }
  if value <= 0x1E053 {
    return "в".unicodeScalars
  }
  if value <= 0x1E054 {
    return "г".unicodeScalars
  }
  if value <= 0x1E055 {
    return "д".unicodeScalars
  }
  if value <= 0x1E056 {
    return "е".unicodeScalars
  }
  if value <= 0x1E057 {
    return "ж".unicodeScalars
  }
  if value <= 0x1E058 {
    return "з".unicodeScalars
  }
  if value <= 0x1E059 {
    return "и".unicodeScalars
  }
  if value <= 0x1E05A {
    return "к".unicodeScalars
  }
  if value <= 0x1E05B {
    return "л".unicodeScalars
  }
  if value <= 0x1E05C {
    return "о".unicodeScalars
  }
  if value <= 0x1E05D {
    return "п".unicodeScalars
  }
  if value <= 0x1E05E {
    return "с".unicodeScalars
  }
  if value <= 0x1E05F {
    return "у".unicodeScalars
  }
  if value <= 0x1E060 {
    return "ф".unicodeScalars
  }
  if value <= 0x1E061 {
    return "х".unicodeScalars
  }
  if value <= 0x1E062 {
    return "ц".unicodeScalars
  }
  if value <= 0x1E063 {
    return "ч".unicodeScalars
  }
  if value <= 0x1E064 {
    return "ш".unicodeScalars
  }
  if value <= 0x1E065 {
    return "ъ".unicodeScalars
  }
  if value <= 0x1E066 {
    return "ы".unicodeScalars
  }
  if value <= 0x1E067 {
    return "ґ".unicodeScalars
  }
  if value <= 0x1E068 {
    return "і".unicodeScalars
  }
  if value <= 0x1E069 {
    return "ѕ".unicodeScalars
  }
  if value <= 0x1E06A {
    return "џ".unicodeScalars
  }
  if value <= 0x1E06B {
    return "ҫ".unicodeScalars
  }
  if value <= 0x1E06C {
    return "ꙑ".unicodeScalars
  }
  if value <= 0x1E06D {
    return "ұ".unicodeScalars
  }
  if value <= 0x1EDFF {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1EE00 {
    return "ا".unicodeScalars
  }
  if value <= 0x1EE01 {
    return "ب".unicodeScalars
  }
  if value <= 0x1EE02 {
    return "ج".unicodeScalars
  }
  if value <= 0x1EE03 {
    return "د".unicodeScalars
  }
  if value <= 0x1EE04 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1EE05 {
    return "و".unicodeScalars
  }
  if value <= 0x1EE06 {
    return "ز".unicodeScalars
  }
  if value <= 0x1EE07 {
    return "ح".unicodeScalars
  }
  if value <= 0x1EE08 {
    return "ط".unicodeScalars
  }
  if value <= 0x1EE09 {
    return "ي".unicodeScalars
  }
  if value <= 0x1EE0A {
    return "ك".unicodeScalars
  }
  if value <= 0x1EE0B {
    return "ل".unicodeScalars
  }
  if value <= 0x1EE0C {
    return "م".unicodeScalars
  }
  if value <= 0x1EE0D {
    return "ن".unicodeScalars
  }
  if value <= 0x1EE0E {
    return "س".unicodeScalars
  }
  if value <= 0x1EE0F {
    return "ع".unicodeScalars
  }
  if value <= 0x1EE10 {
    return "ف".unicodeScalars
  }
  if value <= 0x1EE11 {
    return "ص".unicodeScalars
  }
  if value <= 0x1EE12 {
    return "ق".unicodeScalars
  }
  if value <= 0x1EE13 {
    return "ر".unicodeScalars
  }
  if value <= 0x1EE14 {
    return "ش".unicodeScalars
  }
  if value <= 0x1EE15 {
    return "ت".unicodeScalars
  }
  if value <= 0x1EE16 {
    return "ث".unicodeScalars
  }
  if value <= 0x1EE17 {
    return "خ".unicodeScalars
  }
  if value <= 0x1EE18 {
    return "ذ".unicodeScalars
  }
  if value <= 0x1EE19 {
    return "ض".unicodeScalars
  }
  if value <= 0x1EE1A {
    return "ظ".unicodeScalars
  }
  if value <= 0x1EE1B {
    return "غ".unicodeScalars
  }
  if value <= 0x1EE1C {
    return "ٮ".unicodeScalars
  }
  if value <= 0x1EE1D {
    return "ں".unicodeScalars
  }
  if value <= 0x1EE1E {
    return "ڡ".unicodeScalars
  }
  if value <= 0x1EE1F {
    return "ٯ".unicodeScalars
  }
  if value <= 0x1EE20 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1EE21 {
    return "ب".unicodeScalars
  }
  if value <= 0x1EE22 {
    return "ج".unicodeScalars
  }
  if value <= 0x1EE23 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1EE24 {
    return "ه".unicodeScalars
  }
  if value <= 0x1EE26 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1EE27 {
    return "ح".unicodeScalars
  }
  if value <= 0x1EE28 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1EE29 {
    return "ي".unicodeScalars
  }
  if value <= 0x1EE2A {
    return "ك".unicodeScalars
  }
  if value <= 0x1EE2B {
    return "ل".unicodeScalars
  }
  if value <= 0x1EE2C {
    return "م".unicodeScalars
  }
  if value <= 0x1EE2D {
    return "ن".unicodeScalars
  }
  if value <= 0x1EE2E {
    return "س".unicodeScalars
  }
  if value <= 0x1EE2F {
    return "ع".unicodeScalars
  }
  if value <= 0x1EE30 {
    return "ف".unicodeScalars
  }
  if value <= 0x1EE31 {
    return "ص".unicodeScalars
  }
  if value <= 0x1EE32 {
    return "ق".unicodeScalars
  }
  if value <= 0x1EE33 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1EE34 {
    return "ش".unicodeScalars
  }
  if value <= 0x1EE35 {
    return "ت".unicodeScalars
  }
  if value <= 0x1EE36 {
    return "ث".unicodeScalars
  }
  if value <= 0x1EE37 {
    return "خ".unicodeScalars
  }
  if value <= 0x1EE38 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1EE39 {
    return "ض".unicodeScalars
  }
  if value <= 0x1EE3A {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1EE3B {
    return "غ".unicodeScalars
  }
  if value <= 0x1EE41 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1EE42 {
    return "ج".unicodeScalars
  }
  if value <= 0x1EE46 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1EE47 {
    return "ح".unicodeScalars
  }
  if value <= 0x1EE48 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1EE49 {
    return "ي".unicodeScalars
  }
  if value <= 0x1EE4A {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1EE4B {
    return "ل".unicodeScalars
  }
  if value <= 0x1EE4C {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1EE4D {
    return "ن".unicodeScalars
  }
  if value <= 0x1EE4E {
    return "س".unicodeScalars
  }
  if value <= 0x1EE4F {
    return "ع".unicodeScalars
  }
  if value <= 0x1EE50 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1EE51 {
    return "ص".unicodeScalars
  }
  if value <= 0x1EE52 {
    return "ق".unicodeScalars
  }
  if value <= 0x1EE53 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1EE54 {
    return "ش".unicodeScalars
  }
  if value <= 0x1EE56 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1EE57 {
    return "خ".unicodeScalars
  }
  if value <= 0x1EE58 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1EE59 {
    return "ض".unicodeScalars
  }
  if value <= 0x1EE5A {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1EE5B {
    return "غ".unicodeScalars
  }
  if value <= 0x1EE5C {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1EE5D {
    return "ں".unicodeScalars
  }
  if value <= 0x1EE5E {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1EE5F {
    return "ٯ".unicodeScalars
  }
  if value <= 0x1EE60 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1EE61 {
    return "ب".unicodeScalars
  }
  if value <= 0x1EE62 {
    return "ج".unicodeScalars
  }
  if value <= 0x1EE63 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1EE64 {
    return "ه".unicodeScalars
  }
  if value <= 0x1EE66 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1EE67 {
    return "ح".unicodeScalars
  }
  if value <= 0x1EE68 {
    return "ط".unicodeScalars
  }
  if value <= 0x1EE69 {
    return "ي".unicodeScalars
  }
  if value <= 0x1EE6A {
    return "ك".unicodeScalars
  }
  if value <= 0x1EE6B {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1EE6C {
    return "م".unicodeScalars
  }
  if value <= 0x1EE6D {
    return "ن".unicodeScalars
  }
  if value <= 0x1EE6E {
    return "س".unicodeScalars
  }
  if value <= 0x1EE6F {
    return "ع".unicodeScalars
  }
  if value <= 0x1EE70 {
    return "ف".unicodeScalars
  }
  if value <= 0x1EE71 {
    return "ص".unicodeScalars
  }
  if value <= 0x1EE72 {
    return "ق".unicodeScalars
  }
  if value <= 0x1EE73 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1EE74 {
    return "ش".unicodeScalars
  }
  if value <= 0x1EE75 {
    return "ت".unicodeScalars
  }
  if value <= 0x1EE76 {
    return "ث".unicodeScalars
  }
  if value <= 0x1EE77 {
    return "خ".unicodeScalars
  }
  if value <= 0x1EE78 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1EE79 {
    return "ض".unicodeScalars
  }
  if value <= 0x1EE7A {
    return "ظ".unicodeScalars
  }
  if value <= 0x1EE7B {
    return "غ".unicodeScalars
  }
  if value <= 0x1EE7C {
    return "ٮ".unicodeScalars
  }
  if value <= 0x1EE7D {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1EE7E {
    return "ڡ".unicodeScalars
  }
  if value <= 0x1EE7F {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1EE80 {
    return "ا".unicodeScalars
  }
  if value <= 0x1EE81 {
    return "ب".unicodeScalars
  }
  if value <= 0x1EE82 {
    return "ج".unicodeScalars
  }
  if value <= 0x1EE83 {
    return "د".unicodeScalars
  }
  if value <= 0x1EE84 {
    return "ه".unicodeScalars
  }
  if value <= 0x1EE85 {
    return "و".unicodeScalars
  }
  if value <= 0x1EE86 {
    return "ز".unicodeScalars
  }
  if value <= 0x1EE87 {
    return "ح".unicodeScalars
  }
  if value <= 0x1EE88 {
    return "ط".unicodeScalars
  }
  if value <= 0x1EE89 {
    return "ي".unicodeScalars
  }
  if value <= 0x1EE8A {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1EE8B {
    return "ل".unicodeScalars
  }
  if value <= 0x1EE8C {
    return "م".unicodeScalars
  }
  if value <= 0x1EE8D {
    return "ن".unicodeScalars
  }
  if value <= 0x1EE8E {
    return "س".unicodeScalars
  }
  if value <= 0x1EE8F {
    return "ع".unicodeScalars
  }
  if value <= 0x1EE90 {
    return "ف".unicodeScalars
  }
  if value <= 0x1EE91 {
    return "ص".unicodeScalars
  }
  if value <= 0x1EE92 {
    return "ق".unicodeScalars
  }
  if value <= 0x1EE93 {
    return "ر".unicodeScalars
  }
  if value <= 0x1EE94 {
    return "ش".unicodeScalars
  }
  if value <= 0x1EE95 {
    return "ت".unicodeScalars
  }
  if value <= 0x1EE96 {
    return "ث".unicodeScalars
  }
  if value <= 0x1EE97 {
    return "خ".unicodeScalars
  }
  if value <= 0x1EE98 {
    return "ذ".unicodeScalars
  }
  if value <= 0x1EE99 {
    return "ض".unicodeScalars
  }
  if value <= 0x1EE9A {
    return "ظ".unicodeScalars
  }
  if value <= 0x1EE9B {
    return "غ".unicodeScalars
  }
  if value <= 0x1EEA0 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1EEA1 {
    return "ب".unicodeScalars
  }
  if value <= 0x1EEA2 {
    return "ج".unicodeScalars
  }
  if value <= 0x1EEA3 {
    return "د".unicodeScalars
  }
  if value <= 0x1EEA4 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1EEA5 {
    return "و".unicodeScalars
  }
  if value <= 0x1EEA6 {
    return "ز".unicodeScalars
  }
  if value <= 0x1EEA7 {
    return "ح".unicodeScalars
  }
  if value <= 0x1EEA8 {
    return "ط".unicodeScalars
  }
  if value <= 0x1EEA9 {
    return "ي".unicodeScalars
  }
  if value <= 0x1EEAA {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1EEAB {
    return "ل".unicodeScalars
  }
  if value <= 0x1EEAC {
    return "م".unicodeScalars
  }
  if value <= 0x1EEAD {
    return "ن".unicodeScalars
  }
  if value <= 0x1EEAE {
    return "س".unicodeScalars
  }
  if value <= 0x1EEAF {
    return "ع".unicodeScalars
  }
  if value <= 0x1EEB0 {
    return "ف".unicodeScalars
  }
  if value <= 0x1EEB1 {
    return "ص".unicodeScalars
  }
  if value <= 0x1EEB2 {
    return "ق".unicodeScalars
  }
  if value <= 0x1EEB3 {
    return "ر".unicodeScalars
  }
  if value <= 0x1EEB4 {
    return "ش".unicodeScalars
  }
  if value <= 0x1EEB5 {
    return "ت".unicodeScalars
  }
  if value <= 0x1EEB6 {
    return "ث".unicodeScalars
  }
  if value <= 0x1EEB7 {
    return "خ".unicodeScalars
  }
  if value <= 0x1EEB8 {
    return "ذ".unicodeScalars
  }
  if value <= 0x1EEB9 {
    return "ض".unicodeScalars
  }
  if value <= 0x1EEBA {
    return "ظ".unicodeScalars
  }
  if value <= 0x1EEBB {
    return "غ".unicodeScalars
  }
  if value <= 0x1F0FF {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1F100 {
    return "0.".unicodeScalars
  }
  if value <= 0x1F101 {
    return "0,".unicodeScalars
  }
  if value <= 0x1F102 {
    return "1,".unicodeScalars
  }
  if value <= 0x1F103 {
    return "2,".unicodeScalars
  }
  if value <= 0x1F104 {
    return "3,".unicodeScalars
  }
  if value <= 0x1F105 {
    return "4,".unicodeScalars
  }
  if value <= 0x1F106 {
    return "5,".unicodeScalars
  }
  if value <= 0x1F107 {
    return "6,".unicodeScalars
  }
  if value <= 0x1F108 {
    return "7,".unicodeScalars
  }
  if value <= 0x1F109 {
    return "8,".unicodeScalars
  }
  if value <= 0x1F10A {
    return "9,".unicodeScalars
  }
  if value <= 0x1F10F {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1F110 {
    return "(A)".unicodeScalars
  }
  if value <= 0x1F111 {
    return "(B)".unicodeScalars
  }
  if value <= 0x1F112 {
    return "(C)".unicodeScalars
  }
  if value <= 0x1F113 {
    return "(D)".unicodeScalars
  }
  if value <= 0x1F114 {
    return "(E)".unicodeScalars
  }
  if value <= 0x1F115 {
    return "(F)".unicodeScalars
  }
  if value <= 0x1F116 {
    return "(G)".unicodeScalars
  }
  if value <= 0x1F117 {
    return "(H)".unicodeScalars
  }
  if value <= 0x1F118 {
    return "(I)".unicodeScalars
  }
  if value <= 0x1F119 {
    return "(J)".unicodeScalars
  }
  if value <= 0x1F11A {
    return "(K)".unicodeScalars
  }
  if value <= 0x1F11B {
    return "(L)".unicodeScalars
  }
  if value <= 0x1F11C {
    return "(M)".unicodeScalars
  }
  if value <= 0x1F11D {
    return "(N)".unicodeScalars
  }
  if value <= 0x1F11E {
    return "(O)".unicodeScalars
  }
  if value <= 0x1F11F {
    return "(P)".unicodeScalars
  }
  if value <= 0x1F120 {
    return "(Q)".unicodeScalars
  }
  if value <= 0x1F121 {
    return "(R)".unicodeScalars
  }
  if value <= 0x1F122 {
    return "(S)".unicodeScalars
  }
  if value <= 0x1F123 {
    return "(T)".unicodeScalars
  }
  if value <= 0x1F124 {
    return "(U)".unicodeScalars
  }
  if value <= 0x1F125 {
    return "(V)".unicodeScalars
  }
  if value <= 0x1F126 {
    return "(W)".unicodeScalars
  }
  if value <= 0x1F127 {
    return "(X)".unicodeScalars
  }
  if value <= 0x1F128 {
    return "(Y)".unicodeScalars
  }
  if value <= 0x1F129 {
    return "(Z)".unicodeScalars
  }
  if value <= 0x1F12A {
    return "〔S〕".unicodeScalars
  }
  if value <= 0x1F12B {
    return "C".unicodeScalars
  }
  if value <= 0x1F12C {
    return "R".unicodeScalars
  }
  if value <= 0x1F12D {
    return "CD".unicodeScalars
  }
  if value <= 0x1F12E {
    return "WZ".unicodeScalars
  }
  if value <= 0x1F12F {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1F130 {
    return "A".unicodeScalars
  }
  if value <= 0x1F131 {
    return "B".unicodeScalars
  }
  if value <= 0x1F132 {
    return "C".unicodeScalars
  }
  if value <= 0x1F133 {
    return "D".unicodeScalars
  }
  if value <= 0x1F134 {
    return "E".unicodeScalars
  }
  if value <= 0x1F135 {
    return "F".unicodeScalars
  }
  if value <= 0x1F136 {
    return "G".unicodeScalars
  }
  if value <= 0x1F137 {
    return "H".unicodeScalars
  }
  if value <= 0x1F138 {
    return "I".unicodeScalars
  }
  if value <= 0x1F139 {
    return "J".unicodeScalars
  }
  if value <= 0x1F13A {
    return "K".unicodeScalars
  }
  if value <= 0x1F13B {
    return "L".unicodeScalars
  }
  if value <= 0x1F13C {
    return "M".unicodeScalars
  }
  if value <= 0x1F13D {
    return "N".unicodeScalars
  }
  if value <= 0x1F13E {
    return "O".unicodeScalars
  }
  if value <= 0x1F13F {
    return "P".unicodeScalars
  }
  if value <= 0x1F140 {
    return "Q".unicodeScalars
  }
  if value <= 0x1F141 {
    return "R".unicodeScalars
  }
  if value <= 0x1F142 {
    return "S".unicodeScalars
  }
  if value <= 0x1F143 {
    return "T".unicodeScalars
  }
  if value <= 0x1F144 {
    return "U".unicodeScalars
  }
  if value <= 0x1F145 {
    return "V".unicodeScalars
  }
  if value <= 0x1F146 {
    return "W".unicodeScalars
  }
  if value <= 0x1F147 {
    return "X".unicodeScalars
  }
  if value <= 0x1F148 {
    return "Y".unicodeScalars
  }
  if value <= 0x1F149 {
    return "Z".unicodeScalars
  }
  if value <= 0x1F14A {
    return "HV".unicodeScalars
  }
  if value <= 0x1F14B {
    return "MV".unicodeScalars
  }
  if value <= 0x1F14C {
    return "SD".unicodeScalars
  }
  if value <= 0x1F14D {
    return "SS".unicodeScalars
  }
  if value <= 0x1F14E {
    return "PPV".unicodeScalars
  }
  if value <= 0x1F14F {
    return "WC".unicodeScalars
  }
  if value <= 0x1F169 {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1F16A {
    return "MC".unicodeScalars
  }
  if value <= 0x1F16B {
    return "MD".unicodeScalars
  }
  if value <= 0x1F16C {
    return "MR".unicodeScalars
  }
  if value <= 0x1F18F {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1F190 {
    return "DJ".unicodeScalars
  }
  if value <= 0x1F1FF {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1F200 {
    return "ほか".unicodeScalars
  }
  if value <= 0x1F201 {
    return "ココ".unicodeScalars
  }
  if value <= 0x1F202 {
    return "サ".unicodeScalars
  }
  if value <= 0x1F20F {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1F210 {
    return "手".unicodeScalars
  }
  if value <= 0x1F211 {
    return "字".unicodeScalars
  }
  if value <= 0x1F212 {
    return "双".unicodeScalars
  }
  if value <= 0x1F213 {
    return "テ\u{3099}".unicodeScalars
  }
  if value <= 0x1F214 {
    return "二".unicodeScalars
  }
  if value <= 0x1F215 {
    return "多".unicodeScalars
  }
  if value <= 0x1F216 {
    return "解".unicodeScalars
  }
  if value <= 0x1F217 {
    return "天".unicodeScalars
  }
  if value <= 0x1F218 {
    return "交".unicodeScalars
  }
  if value <= 0x1F219 {
    return "映".unicodeScalars
  }
  if value <= 0x1F21A {
    return "無".unicodeScalars
  }
  if value <= 0x1F21B {
    return "料".unicodeScalars
  }
  if value <= 0x1F21C {
    return "前".unicodeScalars
  }
  if value <= 0x1F21D {
    return "後".unicodeScalars
  }
  if value <= 0x1F21E {
    return "再".unicodeScalars
  }
  if value <= 0x1F21F {
    return "新".unicodeScalars
  }
  if value <= 0x1F220 {
    return "初".unicodeScalars
  }
  if value <= 0x1F221 {
    return "終".unicodeScalars
  }
  if value <= 0x1F222 {
    return "生".unicodeScalars
  }
  if value <= 0x1F223 {
    return "販".unicodeScalars
  }
  if value <= 0x1F224 {
    return "声".unicodeScalars
  }
  if value <= 0x1F225 {
    return "吹".unicodeScalars
  }
  if value <= 0x1F226 {
    return "演".unicodeScalars
  }
  if value <= 0x1F227 {
    return "投".unicodeScalars
  }
  if value <= 0x1F228 {
    return "捕".unicodeScalars
  }
  if value <= 0x1F229 {
    return "一".unicodeScalars
  }
  if value <= 0x1F22A {
    return "三".unicodeScalars
  }
  if value <= 0x1F22B {
    return "遊".unicodeScalars
  }
  if value <= 0x1F22C {
    return "左".unicodeScalars
  }
  if value <= 0x1F22D {
    return "中".unicodeScalars
  }
  if value <= 0x1F22E {
    return "右".unicodeScalars
  }
  if value <= 0x1F22F {
    return "指".unicodeScalars
  }
  if value <= 0x1F230 {
    return "走".unicodeScalars
  }
  if value <= 0x1F231 {
    return "打".unicodeScalars
  }
  if value <= 0x1F232 {
    return "禁".unicodeScalars
  }
  if value <= 0x1F233 {
    return "空".unicodeScalars
  }
  if value <= 0x1F234 {
    return "合".unicodeScalars
  }
  if value <= 0x1F235 {
    return "満".unicodeScalars
  }
  if value <= 0x1F236 {
    return "有".unicodeScalars
  }
  if value <= 0x1F237 {
    return "月".unicodeScalars
  }
  if value <= 0x1F238 {
    return "申".unicodeScalars
  }
  if value <= 0x1F239 {
    return "割".unicodeScalars
  }
  if value <= 0x1F23A {
    return "営".unicodeScalars
  }
  if value <= 0x1F23B {
    return "配".unicodeScalars
  }
  if value <= 0x1F23F {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1F240 {
    return "〔本〕".unicodeScalars
  }
  if value <= 0x1F241 {
    return "〔三〕".unicodeScalars
  }
  if value <= 0x1F242 {
    return "〔二〕".unicodeScalars
  }
  if value <= 0x1F243 {
    return "〔安〕".unicodeScalars
  }
  if value <= 0x1F244 {
    return "〔点〕".unicodeScalars
  }
  if value <= 0x1F245 {
    return "〔打〕".unicodeScalars
  }
  if value <= 0x1F246 {
    return "〔盗〕".unicodeScalars
  }
  if value <= 0x1F247 {
    return "〔勝〕".unicodeScalars
  }
  if value <= 0x1F248 {
    return "〔敗〕".unicodeScalars
  }
  if value <= 0x1F24F {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1F250 {
    return "得".unicodeScalars
  }
  if value <= 0x1F251 {
    return "可".unicodeScalars
  }
  if value <= 0x1FBEF {
    return String(scalar).unicodeScalars
  }
  if value <= 0x1FBF0 {
    return "0".unicodeScalars
  }
  if value <= 0x1FBF1 {
    return "1".unicodeScalars
  }
  if value <= 0x1FBF2 {
    return "2".unicodeScalars
  }
  if value <= 0x1FBF3 {
    return "3".unicodeScalars
  }
  if value <= 0x1FBF4 {
    return "4".unicodeScalars
  }
  if value <= 0x1FBF5 {
    return "5".unicodeScalars
  }
  if value <= 0x1FBF6 {
    return "6".unicodeScalars
  }
  if value <= 0x1FBF7 {
    return "7".unicodeScalars
  }
  if value <= 0x1FBF8 {
    return "8".unicodeScalars
  }
  if value <= 0x1FBF9 {
    return "9".unicodeScalars
  }
  if value <= 0x2F7FF {
    return String(scalar).unicodeScalars
  }
  if value <= 0x2F800 {
    return "丽".unicodeScalars
  }
  if value <= 0x2F801 {
    return "丸".unicodeScalars
  }
  if value <= 0x2F802 {
    return "乁".unicodeScalars
  }
  if value <= 0x2F803 {
    return "𠄢".unicodeScalars
  }
  if value <= 0x2F804 {
    return "你".unicodeScalars
  }
  if value <= 0x2F805 {
    return "侮".unicodeScalars
  }
  if value <= 0x2F806 {
    return "侻".unicodeScalars
  }
  if value <= 0x2F807 {
    return "倂".unicodeScalars
  }
  if value <= 0x2F808 {
    return "偺".unicodeScalars
  }
  if value <= 0x2F809 {
    return "備".unicodeScalars
  }
  if value <= 0x2F80A {
    return "僧".unicodeScalars
  }
  if value <= 0x2F80B {
    return "像".unicodeScalars
  }
  if value <= 0x2F80C {
    return "㒞".unicodeScalars
  }
  if value <= 0x2F80D {
    return "𠘺".unicodeScalars
  }
  if value <= 0x2F80E {
    return "免".unicodeScalars
  }
  if value <= 0x2F80F {
    return "兔".unicodeScalars
  }
  if value <= 0x2F810 {
    return "兤".unicodeScalars
  }
  if value <= 0x2F811 {
    return "具".unicodeScalars
  }
  if value <= 0x2F812 {
    return "𠔜".unicodeScalars
  }
  if value <= 0x2F813 {
    return "㒹".unicodeScalars
  }
  if value <= 0x2F814 {
    return "內".unicodeScalars
  }
  if value <= 0x2F815 {
    return "再".unicodeScalars
  }
  if value <= 0x2F816 {
    return "𠕋".unicodeScalars
  }
  if value <= 0x2F817 {
    return "冗".unicodeScalars
  }
  if value <= 0x2F818 {
    return "冤".unicodeScalars
  }
  if value <= 0x2F819 {
    return "仌".unicodeScalars
  }
  if value <= 0x2F81A {
    return "冬".unicodeScalars
  }
  if value <= 0x2F81B {
    return "况".unicodeScalars
  }
  if value <= 0x2F81C {
    return "𩇟".unicodeScalars
  }
  if value <= 0x2F81D {
    return "凵".unicodeScalars
  }
  if value <= 0x2F81E {
    return "刃".unicodeScalars
  }
  if value <= 0x2F81F {
    return "㓟".unicodeScalars
  }
  if value <= 0x2F820 {
    return "刻".unicodeScalars
  }
  if value <= 0x2F821 {
    return "剆".unicodeScalars
  }
  if value <= 0x2F822 {
    return "割".unicodeScalars
  }
  if value <= 0x2F823 {
    return "剷".unicodeScalars
  }
  if value <= 0x2F824 {
    return "㔕".unicodeScalars
  }
  if value <= 0x2F825 {
    return "勇".unicodeScalars
  }
  if value <= 0x2F826 {
    return "勉".unicodeScalars
  }
  if value <= 0x2F827 {
    return "勤".unicodeScalars
  }
  if value <= 0x2F828 {
    return "勺".unicodeScalars
  }
  if value <= 0x2F829 {
    return "包".unicodeScalars
  }
  if value <= 0x2F82A {
    return "匆".unicodeScalars
  }
  if value <= 0x2F82B {
    return "北".unicodeScalars
  }
  if value <= 0x2F82C {
    return "卉".unicodeScalars
  }
  if value <= 0x2F82D {
    return "卑".unicodeScalars
  }
  if value <= 0x2F82E {
    return "博".unicodeScalars
  }
  if value <= 0x2F82F {
    return "即".unicodeScalars
  }
  if value <= 0x2F830 {
    return "卽".unicodeScalars
  }
  if value <= 0x2F833 {
    return "卿".unicodeScalars
  }
  if value <= 0x2F834 {
    return "𠨬".unicodeScalars
  }
  if value <= 0x2F835 {
    return "灰".unicodeScalars
  }
  if value <= 0x2F836 {
    return "及".unicodeScalars
  }
  if value <= 0x2F837 {
    return "叟".unicodeScalars
  }
  if value <= 0x2F838 {
    return "𠭣".unicodeScalars
  }
  if value <= 0x2F839 {
    return "叫".unicodeScalars
  }
  if value <= 0x2F83A {
    return "叱".unicodeScalars
  }
  if value <= 0x2F83B {
    return "吆".unicodeScalars
  }
  if value <= 0x2F83C {
    return "咞".unicodeScalars
  }
  if value <= 0x2F83D {
    return "吸".unicodeScalars
  }
  if value <= 0x2F83E {
    return "呈".unicodeScalars
  }
  if value <= 0x2F83F {
    return "周".unicodeScalars
  }
  if value <= 0x2F840 {
    return "咢".unicodeScalars
  }
  if value <= 0x2F841 {
    return "哶".unicodeScalars
  }
  if value <= 0x2F842 {
    return "唐".unicodeScalars
  }
  if value <= 0x2F843 {
    return "啓".unicodeScalars
  }
  if value <= 0x2F844 {
    return "啣".unicodeScalars
  }
  if value <= 0x2F846 {
    return "善".unicodeScalars
  }
  if value <= 0x2F847 {
    return "喙".unicodeScalars
  }
  if value <= 0x2F848 {
    return "喫".unicodeScalars
  }
  if value <= 0x2F849 {
    return "喳".unicodeScalars
  }
  if value <= 0x2F84A {
    return "嗂".unicodeScalars
  }
  if value <= 0x2F84B {
    return "圖".unicodeScalars
  }
  if value <= 0x2F84C {
    return "嘆".unicodeScalars
  }
  if value <= 0x2F84D {
    return "圗".unicodeScalars
  }
  if value <= 0x2F84E {
    return "噑".unicodeScalars
  }
  if value <= 0x2F84F {
    return "噴".unicodeScalars
  }
  if value <= 0x2F850 {
    return "切".unicodeScalars
  }
  if value <= 0x2F851 {
    return "壮".unicodeScalars
  }
  if value <= 0x2F852 {
    return "城".unicodeScalars
  }
  if value <= 0x2F853 {
    return "埴".unicodeScalars
  }
  if value <= 0x2F854 {
    return "堍".unicodeScalars
  }
  if value <= 0x2F855 {
    return "型".unicodeScalars
  }
  if value <= 0x2F856 {
    return "堲".unicodeScalars
  }
  if value <= 0x2F857 {
    return "報".unicodeScalars
  }
  if value <= 0x2F858 {
    return "墬".unicodeScalars
  }
  if value <= 0x2F859 {
    return "𡓤".unicodeScalars
  }
  if value <= 0x2F85A {
    return "売".unicodeScalars
  }
  if value <= 0x2F85B {
    return "壷".unicodeScalars
  }
  if value <= 0x2F85C {
    return "夆".unicodeScalars
  }
  if value <= 0x2F85D {
    return "多".unicodeScalars
  }
  if value <= 0x2F85E {
    return "夢".unicodeScalars
  }
  if value <= 0x2F85F {
    return "奢".unicodeScalars
  }
  if value <= 0x2F860 {
    return "𡚨".unicodeScalars
  }
  if value <= 0x2F861 {
    return "𡛪".unicodeScalars
  }
  if value <= 0x2F862 {
    return "姬".unicodeScalars
  }
  if value <= 0x2F863 {
    return "娛".unicodeScalars
  }
  if value <= 0x2F864 {
    return "娧".unicodeScalars
  }
  if value <= 0x2F865 {
    return "姘".unicodeScalars
  }
  if value <= 0x2F866 {
    return "婦".unicodeScalars
  }
  if value <= 0x2F867 {
    return "㛮".unicodeScalars
  }
  if value <= 0x2F868 {
    return "㛼".unicodeScalars
  }
  if value <= 0x2F869 {
    return "嬈".unicodeScalars
  }
  if value <= 0x2F86B {
    return "嬾".unicodeScalars
  }
  if value <= 0x2F86C {
    return "𡧈".unicodeScalars
  }
  if value <= 0x2F86D {
    return "寃".unicodeScalars
  }
  if value <= 0x2F86E {
    return "寘".unicodeScalars
  }
  if value <= 0x2F86F {
    return "寧".unicodeScalars
  }
  if value <= 0x2F870 {
    return "寳".unicodeScalars
  }
  if value <= 0x2F871 {
    return "𡬘".unicodeScalars
  }
  if value <= 0x2F872 {
    return "寿".unicodeScalars
  }
  if value <= 0x2F873 {
    return "将".unicodeScalars
  }
  if value <= 0x2F874 {
    return "当".unicodeScalars
  }
  if value <= 0x2F875 {
    return "尢".unicodeScalars
  }
  if value <= 0x2F876 {
    return "㞁".unicodeScalars
  }
  if value <= 0x2F877 {
    return "屠".unicodeScalars
  }
  if value <= 0x2F878 {
    return "屮".unicodeScalars
  }
  if value <= 0x2F879 {
    return "峀".unicodeScalars
  }
  if value <= 0x2F87A {
    return "岍".unicodeScalars
  }
  if value <= 0x2F87B {
    return "𡷤".unicodeScalars
  }
  if value <= 0x2F87C {
    return "嵃".unicodeScalars
  }
  if value <= 0x2F87D {
    return "𡷦".unicodeScalars
  }
  if value <= 0x2F87E {
    return "嵮".unicodeScalars
  }
  if value <= 0x2F87F {
    return "嵫".unicodeScalars
  }
  if value <= 0x2F880 {
    return "嵼".unicodeScalars
  }
  if value <= 0x2F881 {
    return "巡".unicodeScalars
  }
  if value <= 0x2F882 {
    return "巢".unicodeScalars
  }
  if value <= 0x2F883 {
    return "㠯".unicodeScalars
  }
  if value <= 0x2F884 {
    return "巽".unicodeScalars
  }
  if value <= 0x2F885 {
    return "帨".unicodeScalars
  }
  if value <= 0x2F886 {
    return "帽".unicodeScalars
  }
  if value <= 0x2F887 {
    return "幩".unicodeScalars
  }
  if value <= 0x2F888 {
    return "㡢".unicodeScalars
  }
  if value <= 0x2F889 {
    return "𢆃".unicodeScalars
  }
  if value <= 0x2F88A {
    return "㡼".unicodeScalars
  }
  if value <= 0x2F88B {
    return "庰".unicodeScalars
  }
  if value <= 0x2F88C {
    return "庳".unicodeScalars
  }
  if value <= 0x2F88D {
    return "庶".unicodeScalars
  }
  if value <= 0x2F88E {
    return "廊".unicodeScalars
  }
  if value <= 0x2F88F {
    return "𪎒".unicodeScalars
  }
  if value <= 0x2F890 {
    return "廾".unicodeScalars
  }
  if value <= 0x2F892 {
    return "𢌱".unicodeScalars
  }
  if value <= 0x2F893 {
    return "舁".unicodeScalars
  }
  if value <= 0x2F895 {
    return "弢".unicodeScalars
  }
  if value <= 0x2F896 {
    return "㣇".unicodeScalars
  }
  if value <= 0x2F897 {
    return "𣊸".unicodeScalars
  }
  if value <= 0x2F898 {
    return "𦇚".unicodeScalars
  }
  if value <= 0x2F899 {
    return "形".unicodeScalars
  }
  if value <= 0x2F89A {
    return "彫".unicodeScalars
  }
  if value <= 0x2F89B {
    return "㣣".unicodeScalars
  }
  if value <= 0x2F89C {
    return "徚".unicodeScalars
  }
  if value <= 0x2F89D {
    return "忍".unicodeScalars
  }
  if value <= 0x2F89E {
    return "志".unicodeScalars
  }
  if value <= 0x2F89F {
    return "忹".unicodeScalars
  }
  if value <= 0x2F8A0 {
    return "悁".unicodeScalars
  }
  if value <= 0x2F8A1 {
    return "㤺".unicodeScalars
  }
  if value <= 0x2F8A2 {
    return "㤜".unicodeScalars
  }
  if value <= 0x2F8A3 {
    return "悔".unicodeScalars
  }
  if value <= 0x2F8A4 {
    return "𢛔".unicodeScalars
  }
  if value <= 0x2F8A5 {
    return "惇".unicodeScalars
  }
  if value <= 0x2F8A6 {
    return "慈".unicodeScalars
  }
  if value <= 0x2F8A7 {
    return "慌".unicodeScalars
  }
  if value <= 0x2F8A8 {
    return "慎".unicodeScalars
  }
  if value <= 0x2F8A9 {
    return "慌".unicodeScalars
  }
  if value <= 0x2F8AA {
    return "慺".unicodeScalars
  }
  if value <= 0x2F8AB {
    return "憎".unicodeScalars
  }
  if value <= 0x2F8AC {
    return "憲".unicodeScalars
  }
  if value <= 0x2F8AD {
    return "憤".unicodeScalars
  }
  if value <= 0x2F8AE {
    return "憯".unicodeScalars
  }
  if value <= 0x2F8AF {
    return "懞".unicodeScalars
  }
  if value <= 0x2F8B0 {
    return "懲".unicodeScalars
  }
  if value <= 0x2F8B1 {
    return "懶".unicodeScalars
  }
  if value <= 0x2F8B2 {
    return "成".unicodeScalars
  }
  if value <= 0x2F8B3 {
    return "戛".unicodeScalars
  }
  if value <= 0x2F8B4 {
    return "扝".unicodeScalars
  }
  if value <= 0x2F8B5 {
    return "抱".unicodeScalars
  }
  if value <= 0x2F8B6 {
    return "拔".unicodeScalars
  }
  if value <= 0x2F8B7 {
    return "捐".unicodeScalars
  }
  if value <= 0x2F8B8 {
    return "𢬌".unicodeScalars
  }
  if value <= 0x2F8B9 {
    return "挽".unicodeScalars
  }
  if value <= 0x2F8BA {
    return "拼".unicodeScalars
  }
  if value <= 0x2F8BB {
    return "捨".unicodeScalars
  }
  if value <= 0x2F8BC {
    return "掃".unicodeScalars
  }
  if value <= 0x2F8BD {
    return "揤".unicodeScalars
  }
  if value <= 0x2F8BE {
    return "𢯱".unicodeScalars
  }
  if value <= 0x2F8BF {
    return "搢".unicodeScalars
  }
  if value <= 0x2F8C0 {
    return "揅".unicodeScalars
  }
  if value <= 0x2F8C1 {
    return "掩".unicodeScalars
  }
  if value <= 0x2F8C2 {
    return "㨮".unicodeScalars
  }
  if value <= 0x2F8C3 {
    return "摩".unicodeScalars
  }
  if value <= 0x2F8C4 {
    return "摾".unicodeScalars
  }
  if value <= 0x2F8C5 {
    return "撝".unicodeScalars
  }
  if value <= 0x2F8C6 {
    return "摷".unicodeScalars
  }
  if value <= 0x2F8C7 {
    return "㩬".unicodeScalars
  }
  if value <= 0x2F8C8 {
    return "敏".unicodeScalars
  }
  if value <= 0x2F8C9 {
    return "敬".unicodeScalars
  }
  if value <= 0x2F8CA {
    return "𣀊".unicodeScalars
  }
  if value <= 0x2F8CB {
    return "旣".unicodeScalars
  }
  if value <= 0x2F8CC {
    return "書".unicodeScalars
  }
  if value <= 0x2F8CD {
    return "晉".unicodeScalars
  }
  if value <= 0x2F8CE {
    return "㬙".unicodeScalars
  }
  if value <= 0x2F8CF {
    return "暑".unicodeScalars
  }
  if value <= 0x2F8D0 {
    return "㬈".unicodeScalars
  }
  if value <= 0x2F8D1 {
    return "㫤".unicodeScalars
  }
  if value <= 0x2F8D2 {
    return "冒".unicodeScalars
  }
  if value <= 0x2F8D3 {
    return "冕".unicodeScalars
  }
  if value <= 0x2F8D4 {
    return "最".unicodeScalars
  }
  if value <= 0x2F8D5 {
    return "暜".unicodeScalars
  }
  if value <= 0x2F8D6 {
    return "肭".unicodeScalars
  }
  if value <= 0x2F8D7 {
    return "䏙".unicodeScalars
  }
  if value <= 0x2F8D8 {
    return "朗".unicodeScalars
  }
  if value <= 0x2F8D9 {
    return "望".unicodeScalars
  }
  if value <= 0x2F8DA {
    return "朡".unicodeScalars
  }
  if value <= 0x2F8DB {
    return "杞".unicodeScalars
  }
  if value <= 0x2F8DC {
    return "杓".unicodeScalars
  }
  if value <= 0x2F8DD {
    return "𣏃".unicodeScalars
  }
  if value <= 0x2F8DE {
    return "㭉".unicodeScalars
  }
  if value <= 0x2F8DF {
    return "柺".unicodeScalars
  }
  if value <= 0x2F8E0 {
    return "枅".unicodeScalars
  }
  if value <= 0x2F8E1 {
    return "桒".unicodeScalars
  }
  if value <= 0x2F8E2 {
    return "梅".unicodeScalars
  }
  if value <= 0x2F8E3 {
    return "𣑭".unicodeScalars
  }
  if value <= 0x2F8E4 {
    return "梎".unicodeScalars
  }
  if value <= 0x2F8E5 {
    return "栟".unicodeScalars
  }
  if value <= 0x2F8E6 {
    return "椔".unicodeScalars
  }
  if value <= 0x2F8E7 {
    return "㮝".unicodeScalars
  }
  if value <= 0x2F8E8 {
    return "楂".unicodeScalars
  }
  if value <= 0x2F8E9 {
    return "榣".unicodeScalars
  }
  if value <= 0x2F8EA {
    return "槪".unicodeScalars
  }
  if value <= 0x2F8EB {
    return "檨".unicodeScalars
  }
  if value <= 0x2F8EC {
    return "𣚣".unicodeScalars
  }
  if value <= 0x2F8ED {
    return "櫛".unicodeScalars
  }
  if value <= 0x2F8EE {
    return "㰘".unicodeScalars
  }
  if value <= 0x2F8EF {
    return "次".unicodeScalars
  }
  if value <= 0x2F8F0 {
    return "𣢧".unicodeScalars
  }
  if value <= 0x2F8F1 {
    return "歔".unicodeScalars
  }
  if value <= 0x2F8F2 {
    return "㱎".unicodeScalars
  }
  if value <= 0x2F8F3 {
    return "歲".unicodeScalars
  }
  if value <= 0x2F8F4 {
    return "殟".unicodeScalars
  }
  if value <= 0x2F8F5 {
    return "殺".unicodeScalars
  }
  if value <= 0x2F8F6 {
    return "殻".unicodeScalars
  }
  if value <= 0x2F8F7 {
    return "𣪍".unicodeScalars
  }
  if value <= 0x2F8F8 {
    return "𡴋".unicodeScalars
  }
  if value <= 0x2F8F9 {
    return "𣫺".unicodeScalars
  }
  if value <= 0x2F8FA {
    return "汎".unicodeScalars
  }
  if value <= 0x2F8FB {
    return "𣲼".unicodeScalars
  }
  if value <= 0x2F8FC {
    return "沿".unicodeScalars
  }
  if value <= 0x2F8FD {
    return "泍".unicodeScalars
  }
  if value <= 0x2F8FE {
    return "汧".unicodeScalars
  }
  if value <= 0x2F8FF {
    return "洖".unicodeScalars
  }
  if value <= 0x2F900 {
    return "派".unicodeScalars
  }
  if value <= 0x2F901 {
    return "海".unicodeScalars
  }
  if value <= 0x2F902 {
    return "流".unicodeScalars
  }
  if value <= 0x2F903 {
    return "浩".unicodeScalars
  }
  if value <= 0x2F904 {
    return "浸".unicodeScalars
  }
  if value <= 0x2F905 {
    return "涅".unicodeScalars
  }
  if value <= 0x2F906 {
    return "𣴞".unicodeScalars
  }
  if value <= 0x2F907 {
    return "洴".unicodeScalars
  }
  if value <= 0x2F908 {
    return "港".unicodeScalars
  }
  if value <= 0x2F909 {
    return "湮".unicodeScalars
  }
  if value <= 0x2F90A {
    return "㴳".unicodeScalars
  }
  if value <= 0x2F90B {
    return "滋".unicodeScalars
  }
  if value <= 0x2F90C {
    return "滇".unicodeScalars
  }
  if value <= 0x2F90D {
    return "𣻑".unicodeScalars
  }
  if value <= 0x2F90E {
    return "淹".unicodeScalars
  }
  if value <= 0x2F90F {
    return "潮".unicodeScalars
  }
  if value <= 0x2F910 {
    return "𣽞".unicodeScalars
  }
  if value <= 0x2F911 {
    return "𣾎".unicodeScalars
  }
  if value <= 0x2F912 {
    return "濆".unicodeScalars
  }
  if value <= 0x2F913 {
    return "瀹".unicodeScalars
  }
  if value <= 0x2F914 {
    return "瀞".unicodeScalars
  }
  if value <= 0x2F915 {
    return "瀛".unicodeScalars
  }
  if value <= 0x2F916 {
    return "㶖".unicodeScalars
  }
  if value <= 0x2F917 {
    return "灊".unicodeScalars
  }
  if value <= 0x2F918 {
    return "災".unicodeScalars
  }
  if value <= 0x2F919 {
    return "灷".unicodeScalars
  }
  if value <= 0x2F91A {
    return "炭".unicodeScalars
  }
  if value <= 0x2F91B {
    return "𠔥".unicodeScalars
  }
  if value <= 0x2F91C {
    return "煅".unicodeScalars
  }
  if value <= 0x2F91D {
    return "𤉣".unicodeScalars
  }
  if value <= 0x2F91E {
    return "熜".unicodeScalars
  }
  if value <= 0x2F91F {
    return "𤎫".unicodeScalars
  }
  if value <= 0x2F920 {
    return "爨".unicodeScalars
  }
  if value <= 0x2F921 {
    return "爵".unicodeScalars
  }
  if value <= 0x2F922 {
    return "牐".unicodeScalars
  }
  if value <= 0x2F923 {
    return "𤘈".unicodeScalars
  }
  if value <= 0x2F924 {
    return "犀".unicodeScalars
  }
  if value <= 0x2F925 {
    return "犕".unicodeScalars
  }
  if value <= 0x2F926 {
    return "𤜵".unicodeScalars
  }
  if value <= 0x2F927 {
    return "𤠔".unicodeScalars
  }
  if value <= 0x2F928 {
    return "獺".unicodeScalars
  }
  if value <= 0x2F929 {
    return "王".unicodeScalars
  }
  if value <= 0x2F92A {
    return "㺬".unicodeScalars
  }
  if value <= 0x2F92B {
    return "玥".unicodeScalars
  }
  if value <= 0x2F92D {
    return "㺸".unicodeScalars
  }
  if value <= 0x2F92E {
    return "瑇".unicodeScalars
  }
  if value <= 0x2F92F {
    return "瑜".unicodeScalars
  }
  if value <= 0x2F930 {
    return "瑱".unicodeScalars
  }
  if value <= 0x2F931 {
    return "璅".unicodeScalars
  }
  if value <= 0x2F932 {
    return "瓊".unicodeScalars
  }
  if value <= 0x2F933 {
    return "㼛".unicodeScalars
  }
  if value <= 0x2F934 {
    return "甤".unicodeScalars
  }
  if value <= 0x2F935 {
    return "𤰶".unicodeScalars
  }
  if value <= 0x2F936 {
    return "甾".unicodeScalars
  }
  if value <= 0x2F937 {
    return "𤲒".unicodeScalars
  }
  if value <= 0x2F938 {
    return "異".unicodeScalars
  }
  if value <= 0x2F939 {
    return "𢆟".unicodeScalars
  }
  if value <= 0x2F93A {
    return "瘐".unicodeScalars
  }
  if value <= 0x2F93B {
    return "𤾡".unicodeScalars
  }
  if value <= 0x2F93C {
    return "𤾸".unicodeScalars
  }
  if value <= 0x2F93D {
    return "𥁄".unicodeScalars
  }
  if value <= 0x2F93E {
    return "㿼".unicodeScalars
  }
  if value <= 0x2F93F {
    return "䀈".unicodeScalars
  }
  if value <= 0x2F940 {
    return "直".unicodeScalars
  }
  if value <= 0x2F941 {
    return "𥃳".unicodeScalars
  }
  if value <= 0x2F942 {
    return "𥃲".unicodeScalars
  }
  if value <= 0x2F943 {
    return "𥄙".unicodeScalars
  }
  if value <= 0x2F944 {
    return "𥄳".unicodeScalars
  }
  if value <= 0x2F945 {
    return "眞".unicodeScalars
  }
  if value <= 0x2F947 {
    return "真".unicodeScalars
  }
  if value <= 0x2F948 {
    return "睊".unicodeScalars
  }
  if value <= 0x2F949 {
    return "䀹".unicodeScalars
  }
  if value <= 0x2F94A {
    return "瞋".unicodeScalars
  }
  if value <= 0x2F94B {
    return "䁆".unicodeScalars
  }
  if value <= 0x2F94C {
    return "䂖".unicodeScalars
  }
  if value <= 0x2F94D {
    return "𥐝".unicodeScalars
  }
  if value <= 0x2F94E {
    return "硎".unicodeScalars
  }
  if value <= 0x2F94F {
    return "碌".unicodeScalars
  }
  if value <= 0x2F950 {
    return "磌".unicodeScalars
  }
  if value <= 0x2F951 {
    return "䃣".unicodeScalars
  }
  if value <= 0x2F952 {
    return "𥘦".unicodeScalars
  }
  if value <= 0x2F953 {
    return "祖".unicodeScalars
  }
  if value <= 0x2F954 {
    return "𥚚".unicodeScalars
  }
  if value <= 0x2F955 {
    return "𥛅".unicodeScalars
  }
  if value <= 0x2F956 {
    return "福".unicodeScalars
  }
  if value <= 0x2F957 {
    return "秫".unicodeScalars
  }
  if value <= 0x2F958 {
    return "䄯".unicodeScalars
  }
  if value <= 0x2F959 {
    return "穀".unicodeScalars
  }
  if value <= 0x2F95A {
    return "穊".unicodeScalars
  }
  if value <= 0x2F95B {
    return "穏".unicodeScalars
  }
  if value <= 0x2F95C {
    return "𥥼".unicodeScalars
  }
  if value <= 0x2F95E {
    return "𥪧".unicodeScalars
  }
  if value <= 0x2F95F {
    return "竮".unicodeScalars
  }
  if value <= 0x2F960 {
    return "䈂".unicodeScalars
  }
  if value <= 0x2F961 {
    return "𥮫".unicodeScalars
  }
  if value <= 0x2F962 {
    return "篆".unicodeScalars
  }
  if value <= 0x2F963 {
    return "築".unicodeScalars
  }
  if value <= 0x2F964 {
    return "䈧".unicodeScalars
  }
  if value <= 0x2F965 {
    return "𥲀".unicodeScalars
  }
  if value <= 0x2F966 {
    return "糒".unicodeScalars
  }
  if value <= 0x2F967 {
    return "䊠".unicodeScalars
  }
  if value <= 0x2F968 {
    return "糨".unicodeScalars
  }
  if value <= 0x2F969 {
    return "糣".unicodeScalars
  }
  if value <= 0x2F96A {
    return "紀".unicodeScalars
  }
  if value <= 0x2F96B {
    return "𥾆".unicodeScalars
  }
  if value <= 0x2F96C {
    return "絣".unicodeScalars
  }
  if value <= 0x2F96D {
    return "䌁".unicodeScalars
  }
  if value <= 0x2F96E {
    return "緇".unicodeScalars
  }
  if value <= 0x2F96F {
    return "縂".unicodeScalars
  }
  if value <= 0x2F970 {
    return "繅".unicodeScalars
  }
  if value <= 0x2F971 {
    return "䌴".unicodeScalars
  }
  if value <= 0x2F972 {
    return "𦈨".unicodeScalars
  }
  if value <= 0x2F973 {
    return "𦉇".unicodeScalars
  }
  if value <= 0x2F974 {
    return "䍙".unicodeScalars
  }
  if value <= 0x2F975 {
    return "𦋙".unicodeScalars
  }
  if value <= 0x2F976 {
    return "罺".unicodeScalars
  }
  if value <= 0x2F977 {
    return "𦌾".unicodeScalars
  }
  if value <= 0x2F978 {
    return "羕".unicodeScalars
  }
  if value <= 0x2F979 {
    return "翺".unicodeScalars
  }
  if value <= 0x2F97A {
    return "者".unicodeScalars
  }
  if value <= 0x2F97B {
    return "𦓚".unicodeScalars
  }
  if value <= 0x2F97C {
    return "𦔣".unicodeScalars
  }
  if value <= 0x2F97D {
    return "聠".unicodeScalars
  }
  if value <= 0x2F97E {
    return "𦖨".unicodeScalars
  }
  if value <= 0x2F97F {
    return "聰".unicodeScalars
  }
  if value <= 0x2F980 {
    return "𣍟".unicodeScalars
  }
  if value <= 0x2F981 {
    return "䏕".unicodeScalars
  }
  if value <= 0x2F982 {
    return "育".unicodeScalars
  }
  if value <= 0x2F983 {
    return "脃".unicodeScalars
  }
  if value <= 0x2F984 {
    return "䐋".unicodeScalars
  }
  if value <= 0x2F985 {
    return "脾".unicodeScalars
  }
  if value <= 0x2F986 {
    return "媵".unicodeScalars
  }
  if value <= 0x2F987 {
    return "𦞧".unicodeScalars
  }
  if value <= 0x2F988 {
    return "𦞵".unicodeScalars
  }
  if value <= 0x2F989 {
    return "𣎓".unicodeScalars
  }
  if value <= 0x2F98A {
    return "𣎜".unicodeScalars
  }
  if value <= 0x2F98B {
    return "舁".unicodeScalars
  }
  if value <= 0x2F98C {
    return "舄".unicodeScalars
  }
  if value <= 0x2F98D {
    return "辞".unicodeScalars
  }
  if value <= 0x2F98E {
    return "䑫".unicodeScalars
  }
  if value <= 0x2F98F {
    return "芑".unicodeScalars
  }
  if value <= 0x2F990 {
    return "芋".unicodeScalars
  }
  if value <= 0x2F991 {
    return "芝".unicodeScalars
  }
  if value <= 0x2F992 {
    return "劳".unicodeScalars
  }
  if value <= 0x2F993 {
    return "花".unicodeScalars
  }
  if value <= 0x2F994 {
    return "芳".unicodeScalars
  }
  if value <= 0x2F995 {
    return "芽".unicodeScalars
  }
  if value <= 0x2F996 {
    return "苦".unicodeScalars
  }
  if value <= 0x2F997 {
    return "𦬼".unicodeScalars
  }
  if value <= 0x2F998 {
    return "若".unicodeScalars
  }
  if value <= 0x2F999 {
    return "茝".unicodeScalars
  }
  if value <= 0x2F99A {
    return "荣".unicodeScalars
  }
  if value <= 0x2F99B {
    return "莭".unicodeScalars
  }
  if value <= 0x2F99C {
    return "茣".unicodeScalars
  }
  if value <= 0x2F99D {
    return "莽".unicodeScalars
  }
  if value <= 0x2F99E {
    return "菧".unicodeScalars
  }
  if value <= 0x2F99F {
    return "著".unicodeScalars
  }
  if value <= 0x2F9A0 {
    return "荓".unicodeScalars
  }
  if value <= 0x2F9A1 {
    return "菊".unicodeScalars
  }
  if value <= 0x2F9A2 {
    return "菌".unicodeScalars
  }
  if value <= 0x2F9A3 {
    return "菜".unicodeScalars
  }
  if value <= 0x2F9A4 {
    return "𦰶".unicodeScalars
  }
  if value <= 0x2F9A5 {
    return "𦵫".unicodeScalars
  }
  if value <= 0x2F9A6 {
    return "𦳕".unicodeScalars
  }
  if value <= 0x2F9A7 {
    return "䔫".unicodeScalars
  }
  if value <= 0x2F9A8 {
    return "蓱".unicodeScalars
  }
  if value <= 0x2F9A9 {
    return "蓳".unicodeScalars
  }
  if value <= 0x2F9AA {
    return "蔖".unicodeScalars
  }
  if value <= 0x2F9AB {
    return "𧏊".unicodeScalars
  }
  if value <= 0x2F9AC {
    return "蕤".unicodeScalars
  }
  if value <= 0x2F9AD {
    return "𦼬".unicodeScalars
  }
  if value <= 0x2F9AE {
    return "䕝".unicodeScalars
  }
  if value <= 0x2F9AF {
    return "䕡".unicodeScalars
  }
  if value <= 0x2F9B0 {
    return "𦾱".unicodeScalars
  }
  if value <= 0x2F9B1 {
    return "𧃒".unicodeScalars
  }
  if value <= 0x2F9B2 {
    return "䕫".unicodeScalars
  }
  if value <= 0x2F9B3 {
    return "虐".unicodeScalars
  }
  if value <= 0x2F9B4 {
    return "虜".unicodeScalars
  }
  if value <= 0x2F9B5 {
    return "虧".unicodeScalars
  }
  if value <= 0x2F9B6 {
    return "虩".unicodeScalars
  }
  if value <= 0x2F9B7 {
    return "蚩".unicodeScalars
  }
  if value <= 0x2F9B8 {
    return "蚈".unicodeScalars
  }
  if value <= 0x2F9B9 {
    return "蜎".unicodeScalars
  }
  if value <= 0x2F9BA {
    return "蛢".unicodeScalars
  }
  if value <= 0x2F9BB {
    return "蝹".unicodeScalars
  }
  if value <= 0x2F9BC {
    return "蜨".unicodeScalars
  }
  if value <= 0x2F9BD {
    return "蝫".unicodeScalars
  }
  if value <= 0x2F9BE {
    return "螆".unicodeScalars
  }
  if value <= 0x2F9BF {
    return "䗗".unicodeScalars
  }
  if value <= 0x2F9C0 {
    return "蟡".unicodeScalars
  }
  if value <= 0x2F9C1 {
    return "蠁".unicodeScalars
  }
  if value <= 0x2F9C2 {
    return "䗹".unicodeScalars
  }
  if value <= 0x2F9C3 {
    return "衠".unicodeScalars
  }
  if value <= 0x2F9C4 {
    return "衣".unicodeScalars
  }
  if value <= 0x2F9C5 {
    return "𧙧".unicodeScalars
  }
  if value <= 0x2F9C6 {
    return "裗".unicodeScalars
  }
  if value <= 0x2F9C7 {
    return "裞".unicodeScalars
  }
  if value <= 0x2F9C8 {
    return "䘵".unicodeScalars
  }
  if value <= 0x2F9C9 {
    return "裺".unicodeScalars
  }
  if value <= 0x2F9CA {
    return "㒻".unicodeScalars
  }
  if value <= 0x2F9CB {
    return "𧢮".unicodeScalars
  }
  if value <= 0x2F9CC {
    return "𧥦".unicodeScalars
  }
  if value <= 0x2F9CD {
    return "䚾".unicodeScalars
  }
  if value <= 0x2F9CE {
    return "䛇".unicodeScalars
  }
  if value <= 0x2F9CF {
    return "誠".unicodeScalars
  }
  if value <= 0x2F9D0 {
    return "諭".unicodeScalars
  }
  if value <= 0x2F9D1 {
    return "變".unicodeScalars
  }
  if value <= 0x2F9D2 {
    return "豕".unicodeScalars
  }
  if value <= 0x2F9D3 {
    return "𧲨".unicodeScalars
  }
  if value <= 0x2F9D4 {
    return "貫".unicodeScalars
  }
  if value <= 0x2F9D5 {
    return "賁".unicodeScalars
  }
  if value <= 0x2F9D6 {
    return "贛".unicodeScalars
  }
  if value <= 0x2F9D7 {
    return "起".unicodeScalars
  }
  if value <= 0x2F9D8 {
    return "𧼯".unicodeScalars
  }
  if value <= 0x2F9D9 {
    return "𠠄".unicodeScalars
  }
  if value <= 0x2F9DA {
    return "跋".unicodeScalars
  }
  if value <= 0x2F9DB {
    return "趼".unicodeScalars
  }
  if value <= 0x2F9DC {
    return "跰".unicodeScalars
  }
  if value <= 0x2F9DD {
    return "𠣞".unicodeScalars
  }
  if value <= 0x2F9DE {
    return "軔".unicodeScalars
  }
  if value <= 0x2F9DF {
    return "輸".unicodeScalars
  }
  if value <= 0x2F9E0 {
    return "𨗒".unicodeScalars
  }
  if value <= 0x2F9E1 {
    return "𨗭".unicodeScalars
  }
  if value <= 0x2F9E2 {
    return "邔".unicodeScalars
  }
  if value <= 0x2F9E3 {
    return "郱".unicodeScalars
  }
  if value <= 0x2F9E4 {
    return "鄑".unicodeScalars
  }
  if value <= 0x2F9E5 {
    return "𨜮".unicodeScalars
  }
  if value <= 0x2F9E6 {
    return "鄛".unicodeScalars
  }
  if value <= 0x2F9E7 {
    return "鈸".unicodeScalars
  }
  if value <= 0x2F9E8 {
    return "鋗".unicodeScalars
  }
  if value <= 0x2F9E9 {
    return "鋘".unicodeScalars
  }
  if value <= 0x2F9EA {
    return "鉼".unicodeScalars
  }
  if value <= 0x2F9EB {
    return "鏹".unicodeScalars
  }
  if value <= 0x2F9EC {
    return "鐕".unicodeScalars
  }
  if value <= 0x2F9ED {
    return "𨯺".unicodeScalars
  }
  if value <= 0x2F9EE {
    return "開".unicodeScalars
  }
  if value <= 0x2F9EF {
    return "䦕".unicodeScalars
  }
  if value <= 0x2F9F0 {
    return "閷".unicodeScalars
  }
  if value <= 0x2F9F1 {
    return "𨵷".unicodeScalars
  }
  if value <= 0x2F9F2 {
    return "䧦".unicodeScalars
  }
  if value <= 0x2F9F3 {
    return "雃".unicodeScalars
  }
  if value <= 0x2F9F4 {
    return "嶲".unicodeScalars
  }
  if value <= 0x2F9F5 {
    return "霣".unicodeScalars
  }
  if value <= 0x2F9F6 {
    return "𩅅".unicodeScalars
  }
  if value <= 0x2F9F7 {
    return "𩈚".unicodeScalars
  }
  if value <= 0x2F9F8 {
    return "䩮".unicodeScalars
  }
  if value <= 0x2F9F9 {
    return "䩶".unicodeScalars
  }
  if value <= 0x2F9FA {
    return "韠".unicodeScalars
  }
  if value <= 0x2F9FB {
    return "𩐊".unicodeScalars
  }
  if value <= 0x2F9FC {
    return "䪲".unicodeScalars
  }
  if value <= 0x2F9FD {
    return "𩒖".unicodeScalars
  }
  if value <= 0x2F9FF {
    return "頋".unicodeScalars
  }
  if value <= 0x2FA00 {
    return "頩".unicodeScalars
  }
  if value <= 0x2FA01 {
    return "𩖶".unicodeScalars
  }
  if value <= 0x2FA02 {
    return "飢".unicodeScalars
  }
  if value <= 0x2FA03 {
    return "䬳".unicodeScalars
  }
  if value <= 0x2FA04 {
    return "餩".unicodeScalars
  }
  if value <= 0x2FA05 {
    return "馧".unicodeScalars
  }
  if value <= 0x2FA06 {
    return "駂".unicodeScalars
  }
  if value <= 0x2FA07 {
    return "駾".unicodeScalars
  }
  if value <= 0x2FA08 {
    return "䯎".unicodeScalars
  }
  if value <= 0x2FA09 {
    return "𩬰".unicodeScalars
  }
  if value <= 0x2FA0A {
    return "鬒".unicodeScalars
  }
  if value <= 0x2FA0B {
    return "鱀".unicodeScalars
  }
  if value <= 0x2FA0C {
    return "鳽".unicodeScalars
  }
  if value <= 0x2FA0D {
    return "䳎".unicodeScalars
  }
  if value <= 0x2FA0E {
    return "䳭".unicodeScalars
  }
  if value <= 0x2FA0F {
    return "鵧".unicodeScalars
  }
  if value <= 0x2FA10 {
    return "𪃎".unicodeScalars
  }
  if value <= 0x2FA11 {
    return "䳸".unicodeScalars
  }
  if value <= 0x2FA12 {
    return "𪄅".unicodeScalars
  }
  if value <= 0x2FA13 {
    return "𪈎".unicodeScalars
  }
  if value <= 0x2FA14 {
    return "𪊑".unicodeScalars
  }
  if value <= 0x2FA15 {
    return "麻".unicodeScalars
  }
  if value <= 0x2FA16 {
    return "䵖".unicodeScalars
  }
  if value <= 0x2FA17 {
    return "黹".unicodeScalars
  }
  if value <= 0x2FA18 {
    return "黾".unicodeScalars
  }
  if value <= 0x2FA19 {
    return "鼅".unicodeScalars
  }
  if value <= 0x2FA1A {
    return "鼏".unicodeScalars
  }
  if value <= 0x2FA1B {
    return "鼖".unicodeScalars
  }
  if value <= 0x2FA1C {
    return "鼻".unicodeScalars
  }
  if value <= 0x2FA1D {
    return "𪘀".unicodeScalars
  }
  return String(scalar).unicodeScalars
}

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

extension Unicode.Scalar {
  var isDecomposedAccordingtoCompatibilityDecomposition: Bool {
    return compatibility_0020decomposition_0020quick_0020check_0020of_0020_0028_0029_003AUnicode_0020scalar_0020numerical_0020value_003Aערך_0020אמת((self).value)
  }
}

extension Slice<UnicodeText> {
  var isNotEmptyAccordingToDefaultUseAsList: Bool {
    return !self.isEmpty
  }
}

fileprivate func 종성의_0020개수_0020및_0020없음_003AUnicode_0020scalar_0020numerical_0020value() -> UInt32 {
  return 0x1C
}

fileprivate func 중성의_0020개수_003AUnicode_0020scalar_0020numerical_0020value() -> UInt32 {
  return 0x15
}

fileprivate func 첫_0020글자_0020마디_003AUnicode_0020scalar_0020numerical_0020value() -> UInt32 {
  return 0xAC00
}

fileprivate func 첫_0020종성_0020직전_003AUnicode_0020scalar_0020numerical_0020value() -> UInt32 {
  return 0x11A7
}

fileprivate func 첫_0020중성_003AUnicode_0020scalar_0020numerical_0020value() -> UInt32 {
  return 0x1161
}

fileprivate func 첫_0020초성_003AUnicode_0020scalar_0020numerical_0020value() -> UInt32 {
  return 0x1100
}

fileprivate func 최종_0020쌍의_0020수_003AUnicode_0020scalar_0020numerical_0020value() -> UInt32 {
  return 중성의_0020개수_003AUnicode_0020scalar_0020numerical_0020value() &* 종성의_0020개수_0020및_0020없음_003AUnicode_0020scalar_0020numerical_0020value()
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
