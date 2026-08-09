public func ==(_ lhs: String.UnicodeScalarView, _ rhs: String.UnicodeScalarView) -> Bool {
  return lhs.elementsEqual(rhs)
}

extension String.UnicodeScalarView {
  public func scalarsAreIndividuallyDecomposedAccordingToCompatibilityDecomposition() -> Bool {
    for scalar in self {
      if !scalar.isDecomposedAccordingtoCompatibilityDecomposition {
        return false
      }
    }
    return true
  }
}

extension String.UnicodeScalarView {
  public func isOrderedCanonically() -> Bool {
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

func _0028_0029_0020individually_0020decomposed_0020according_0020to_0020compatibility_0020decomposition_002C_0020skipping_0020necessity_0020check_003AUnicode_0020scalars_003AUnicode_0020scalars(_ scalars: String.UnicodeScalarView) -> String.UnicodeScalarView {
  var decomposed: String.UnicodeScalarView = "".unicodeScalars
  for scalar in scalars {
    decomposed += scalar.compatibilityDecomposition()
  }
  return decomposed
}

extension String.UnicodeScalarView {
  public func individuallyDecomposedAccordingToCompatibilityDecomposition() -> String.UnicodeScalarView {
    if self.scalarsAreIndividuallyDecomposedAccordingToCompatibilityDecomposition() {
      return self
    }
    return _0028_0029_0020individually_0020decomposed_0020according_0020to_0020compatibility_0020decomposition_002C_0020skipping_0020necessity_0020check_003AUnicode_0020scalars_003AUnicode_0020scalars(self)
  }
}

func _0028_0029_0020reordered_0020canonically_002C_0020skipping_0020necessity_0020check_003AUnicode_0020scalars_003AUnicode_0020scalars(_ scalars: String.UnicodeScalarView) -> String.UnicodeScalarView {
  var reordered: String.UnicodeScalarView = "".unicodeScalars
  for scalar in scalars {
    let clas_0073: Unicode.CanonicalCombiningClass = scalar.combiningClass
    if clas_0073 == .notReordered {
      reordered.append(scalar)
    } else {
      var cursor: String.UnicodeScalarView.Index = reordered.endIndex
      while (scalar_0020before_0020_0028_0029_0020in_0020_0028_0029_0020belongs_0020after_0020_0028_0029_003AUnicode_0020scalar_0020boundary_003AUnicode_0020scalars_003AUnicodeCombiningClass_003Aערך_0020אמת(cursor, reordered, clas_0073)) {
        reordered.formIndex(before: &cursor)
      }
      reordered.insert(scalar, at: cursor)
    }
  }
  return reordered
}

extension String.UnicodeScalarView {
  public func reorderedCanonically() -> String.UnicodeScalarView {
    if self.isOrderedCanonically() {
      return self
    }
    return _0028_0029_0020reordered_0020canonically_002C_0020skipping_0020necessity_0020check_003AUnicode_0020scalars_003AUnicode_0020scalars(self)
  }
}

extension String.UnicodeScalarView {
  public func compatibilityDecomposition() -> String.UnicodeScalarView {
    return self.individuallyDecomposedAccordingToCompatibilityDecomposition().reorderedCanonically()
  }
}

extension String.UnicodeScalarView {
  public init(_ other: Slice<String.UnicodeScalarView>) {
    // The existing overload from RangeReplaceableCollection is prohibitively inefficient.
    let bounds: Range<String.UnicodeScalarView.Index> = { let slice = other; return slice.startIndex ..< slice.endIndex }()
    let whole: String.UnicodeScalarView = other.base
    self = if_0020most_0020efficient_002C_0020convert_0020_0028_0029_0020in_0020_0028_0029_0020into_0020scalars_0020by_0020extended_0020grapheme_0020clusters_003A_0028_003Arange_0020of_0020_0028_0029_003AUnicode_0020scalar_0020boundary_003A_0029_003AUnicode_0020scalars_003AUnicode_0020scalars(bounds, whole)
  }
}

extension String.UnicodeScalarView {
  public func hash(into hasher: inout Hasher) {
    if_0020most_0020efficient_002C_0020hash_0020key_0020_0028_0029_0020with_0020_0028_0029_0020by_0020iteration_003AUnicode_0020scalars_003Ahasher_003A(self, &hasher)
  }
}

extension String.UnicodeScalarView: Hashable {}

func if_0020most_0020efficient_002C_0020hash_0020key_0020_0028_0029_0020with_0020_0028_0029_0020by_0020iteration_003AUnicode_0020scalars_003Ahasher_003A(_ key: String.UnicodeScalarView, _ hasher: inout Hasher) {
  for scalar in key {
    hasher.combine(scalar)
  }
}

func if_0020most_0020efficient_002C_0020number_0020of_0020entries_0020in_0020_0028_0029_0020by_0020platform_0020offset_002C_0020storing_0020in_0020_0028_0029_003AUnicode_0020scalars_003A자연수_003A(_ list: String.UnicodeScalarView, _ result: inout UInt64) {
  result = UInt64(list.count)
}

extension String.UnicodeScalarView {
  public func indexSkippingBoundsCheck(beforeBoundary boundary: String.UnicodeScalarView.Index) -> String.UnicodeScalarView.Index {
    return self.index(before: boundary)
  }
}

extension String.UnicodeScalarView {
  public func entryIndex(beforeBoundary boundary: String.UnicodeScalarView.Index) -> String.UnicodeScalarView.Index? {
    if boundary > self.startIndex {
      return self.indexSkippingBoundsCheck(beforeBoundary: boundary)
    }
    return nil
  }
}

extension String.UnicodeScalarView {
  public func numberOfEntries() -> UInt64 {
    var result: UInt64 = .arithmeticZero
    if_0020most_0020efficient_002C_0020number_0020of_0020entries_0020in_0020_0028_0029_0020by_0020platform_0020offset_002C_0020storing_0020in_0020_0028_0029_003AUnicode_0020scalars_003A자연수_003A(self, &result)
    return result
  }
}

extension String.UnicodeScalarView {
  public func offset(from origin: String.UnicodeScalarView.Index, to destination: String.UnicodeScalarView.Index) -> Int64 {
    var result: Int64 = .arithmeticZero
    if_0020most_0020efficient_002C_0020offset_0020from_0020_0028_0029_0020to_0020_0028_0029_0020in_0020_0028_0029_0020by_0020platform_0020offset_002C_0020storing_0020in_0020_0028_0029_003AUnicode_0020scalar_0020boundary_003AUnicode_0020scalar_0020boundary_003AUnicode_0020scalars_003A정수_003A(origin, destination, self, &result)
    return result
  }
}

extension String.UnicodeScalarView {
  public mutating func reorderCanonically() {
    if self.isOrderedCanonically() {
      return
    }
    self = _0028_0029_0020reordered_0020canonically_002C_0020skipping_0020necessity_0020check_003AUnicode_0020scalars_003AUnicode_0020scalars(self)
  }
}

extension String.UnicodeScalarView {
  public init(_ text: UnicodeText) {
    self = text.scalars
  }
}
