struct ParsedSeparatedNestingGroup<Leaf, Separator>: ParsedSyntaxNode
where Leaf: ParsedSyntaxNode, Separator: ParsedSyntaxNode {
  let opening: Leaf
  let openingSeparator: Separator
  let contents: ParsedSeparatedList<Leaf, Separator>
  let closingSeparator: Separator
  let closing: Leaf
}

extension ParsedSeparatedNestingGroup: DerivedLocation {
  var firstChild: ParsedSyntaxNode {
    return opening
  }
  var lastChild: ParsedSyntaxNode {
    return closing
  }
}
