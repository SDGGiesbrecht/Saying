struct ParsedEmptySeparatedNestingGroup<Leaf, Separator>
where Leaf: ParsedSyntaxNode, Separator: ParsedSyntaxNode {
  let opening: Leaf
  let separator: Separator
  let closing: Leaf
}

extension ParsedEmptySeparatedNestingGroup: ParsedSyntaxNode {
  var children: [ParsedSyntaxNode] {
    return [opening, separator, closing]
  }
}

extension ParsedEmptySeparatedNestingGroup: DerivedLocation {
  var firstChild: ParsedSyntaxNode {
    return opening
  }
  var lastChild: ParsedSyntaxNode {
    return closing
  }
}
