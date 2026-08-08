extension String.UnicodeScalarView {
  public init(_ other: Slice<String.UnicodeScalarView>) {
    // The existing overload from RangeReplaceableCollection is prohibitively inefficient.
    let bounds: Range<String.UnicodeScalarView.Index> = { let slice = other; return slice.startIndex ..< slice.endIndex }()
    let whole: String.UnicodeScalarView = other.base
    self = if_0020most_0020efficient_002C_0020convert_0020_0028_0029_0020in_0020_0028_0029_0020into_0020scalars_0020by_0020extended_0020grapheme_0020clusters_003A_0028_003Arange_0020of_0020_0028_0029_003AUnicode_0020scalar_0020boundary_003A_0029_003AUnicode_0020scalars_003AUnicode_0020scalars(bounds, whole)
  }
}
