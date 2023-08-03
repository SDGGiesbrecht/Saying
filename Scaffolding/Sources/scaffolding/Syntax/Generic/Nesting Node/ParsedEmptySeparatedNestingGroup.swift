struct ParsedEmptySeparatedNestingGroup<Leaf, Separator>: ParsedSyntaxNode
where Leaf: ParsedSyntaxNode, Separator: ParsedSyntaxNode {
  let opening: Leaf
  let separator: Separator
  let closing: Leaf
}

extension ParsedEmptySeparatedNestingGroup: DerivedLocation {
  var firstChild: ParsedSyntaxNode {
    return opening
  }
  var lastChild: ParsedSyntaxNode {
    return closing
  }
}
