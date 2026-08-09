public func compare(_ first: Int, to second: Int) -> Bool? {
  if first < second {
    return true
  }
  if first > second {
    return false
  }
  return nil
}

func before_0020end_0020of_0020segment_0020before_0020_0028_0029_0020in_0020_0028_0029_002C_0020skipping_0020bounds_0020check_003Alist_0020boundary_003AUnicode_0020segments_003AUnicode_0020segments_0020boundary(_ segment_0020cursor: Int, _ list: UnicodeSegments) -> UnicodeSegments.Boundary {
  let segment_0020list: [Unicode_0020segment] = list.segments
  let beginning_0020of_0020previous_0020segment: Int = segment_0020list.index(before: segment_0020cursor)
  let segment: UnicodeText = segment_0020list[beginning_0020of_0020previous_0020segment].source
  return UnicodeSegments.Boundary(beginning_0020of_0020previous_0020segment, segment.boundary(beforeBoundary: segment.endIndex))
}
