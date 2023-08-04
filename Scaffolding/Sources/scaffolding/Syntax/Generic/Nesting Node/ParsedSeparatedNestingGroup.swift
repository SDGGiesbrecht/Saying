struct ParsedSeparatedNestingGroup<Leaf, Separator>
where Leaf: ParsedSyntaxNode, Separator: ParsedSyntaxNode {
  let opening: Leaf
  let openingSeparator: Separator
  let contents: ParsedSeparatedList<Leaf, Separator>
  let closingSeparator: Separator
  let closing: Leaf
}

extension ParsedSeparatedNestingGroup: ParsedSyntaxNode {
  var children: [ParsedSyntaxNode] {
    return [opening, openingSeparator, contents, closingSeparator, closing]
  }
}

extension ParsedSeparatedNestingGroup: DerivedLocation {
  var firstChild: ParsedSyntaxNode {
    return opening
  }
  var lastChild: ParsedSyntaxNode {
    return closing
  }
}
