struct ParsedEmptySeparatedNestingGroup<Leaf, Separator>
where Leaf: OldParsedSyntaxNode, Separator: OldParsedSyntaxNode {
  let opening: Leaf
  let separator: Separator
  let closing: Leaf
}

extension ParsedEmptySeparatedNestingGroup: OldParsedSyntaxNode {
  var children: [OldParsedSyntaxNode] {
    return [opening, separator, closing]
  }
}

extension ParsedEmptySeparatedNestingGroup: DerivedLocation {
  var firstChild: OldParsedSyntaxNode {
    return opening
  }
  var lastChild: OldParsedSyntaxNode {
    return closing
  }
}
