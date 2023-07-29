struct ParsedSeparatedNestingGroup<Leaf, Separator>
where Leaf: ParsedSyntaxNode, Separator: ParsedSyntaxNode {
  let opening: Leaf
  let openingSeparator: Separator
  let contents: ParsedSeparatedList<Leaf, Separator>
  let closingSeparator: Separator
  let closing: Leaf
  let location: Slice<UTF8Segments>
}
