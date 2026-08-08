func if_0020most_0020efficient_002C_0020offset_0020from_0020_0028_0029_0020to_0020_0028_0029_0020in_0020_0028_0029_0020by_0020platform_0020offset_002C_0020storing_0020in_0020_0028_0029_003AUnicode_0020scalar_0020boundary_003AUnicode_0020scalar_0020boundary_003AUnicode_0020scalars_003A정수_003A(_ origin: String.UnicodeScalarView.Index, _ destination: String.UnicodeScalarView.Index, _ list: String.UnicodeScalarView, _ result: inout Int64) {
  result = Int64(list.distance(from: origin, to: destination))
}

func scalar_0020after_0020_0028_0029_0020in_0020_0028_0029_0020is_0020reordrant_003AUnicode_0020scalar_0020boundary_003AUnicodeText_003Aערך_0020אמת(_ cursor: String.UnicodeScalarView.Index, _ text: UnicodeText) -> Bool {
  if let index = text.entryIndex(afterBoundary: cursor) {
    return text[entryIndex: index].combiningClass != .notReordered
  }
  return false
}

func scalar_0020before_0020_0028_0029_0020in_0020_0028_0029_0020belongs_0020after_0020_0028_0029_003AUnicode_0020scalar_0020boundary_003AUnicode_0020scalars_003AUnicodeCombiningClass_003Aערך_0020אמת(_ cursor: String.UnicodeScalarView.Index, _ scalars: String.UnicodeScalarView, _ clas_0073: Unicode.CanonicalCombiningClass) -> Bool {
  if let previous = scalars.entryIndex(beforeBoundary: cursor) {
    return scalars[previous].combiningClass > clas_0073
  }
  return false
}

func scalar_0020before_0020_0028_0029_0020in_0020_0028_0029_0020is_0020reordrant_003AUnicode_0020scalar_0020boundary_003AUnicodeText_003Aערך_0020אמת(_ cursor: String.UnicodeScalarView.Index, _ text: UnicodeText) -> Bool {
  if let index = text.entryIndex(beforeBoundary: cursor) {
    return text[entryIndex: index].combiningClass != .notReordered
  }
  return false
}
