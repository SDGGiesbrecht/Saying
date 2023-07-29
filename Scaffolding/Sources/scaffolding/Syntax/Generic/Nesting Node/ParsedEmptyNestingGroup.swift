struct ParsedEmptySeparatedNestingGroup<Leaf, Separator> {
  let opening: Leaf
  let separator: Separator
  let closing: Leaf
  let location: Slice<UTF8Segments>
}
