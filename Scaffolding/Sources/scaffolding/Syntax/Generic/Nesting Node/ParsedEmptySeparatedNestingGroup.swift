struct ParsedEmptySeparatedNestingGroup<Leaf, Separator>
where Leaf: ManualParsedSyntaxNode, Separator: ManualParsedSyntaxNode {
  let opening: Leaf
  let separator: Separator
  let closing: Leaf
}

extension ParsedEmptySeparatedNestingGroup: ManualParsedSyntaxNode {
  var children: [ManualParsedSyntaxNode] {
    return [opening, separator, closing]
  }
}

extension ParsedEmptySeparatedNestingGroup: DerivedLocation {
  var firstChild: ManualParsedSyntaxNode {
    return opening
  }
  var lastChild: ManualParsedSyntaxNode {
    return closing
  }
}
