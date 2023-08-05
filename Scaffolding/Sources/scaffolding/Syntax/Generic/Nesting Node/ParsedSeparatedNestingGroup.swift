struct ParsedSeparatedNestingGroup<Leaf, Separator>
where Leaf: ManualParsedSyntaxNode, Separator: ManualParsedSyntaxNode {
  let opening: Leaf
  let openingSeparator: Separator
  let contents: ParsedSeparatedList<Leaf, Separator>
  let closingSeparator: Separator
  let closing: Leaf
}

extension ParsedSeparatedNestingGroup: ManualParsedSyntaxNode {
  var children: [ManualParsedSyntaxNode] {
    return [opening, openingSeparator, contents, closingSeparator, closing]
  }
}

extension ParsedSeparatedNestingGroup: DerivedLocation {
  var firstChild: ManualParsedSyntaxNode {
    return opening
  }
  var lastChild: ManualParsedSyntaxNode {
    return closing
  }
}
