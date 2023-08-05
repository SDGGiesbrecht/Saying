struct ParsedSeparatedNestingGroup<Leaf, Separator>
where Leaf: OldParsedSyntaxNode, Separator: OldParsedSyntaxNode {
  let opening: Leaf
  let openingSeparator: Separator
  let contents: ParsedSeparatedList<Leaf, Separator>
  let closingSeparator: Separator
  let closing: Leaf
}

extension ParsedSeparatedNestingGroup: OldParsedSyntaxNode {
  var children: [OldParsedSyntaxNode] {
    return [opening, openingSeparator, contents, closingSeparator, closing]
  }
}

extension ParsedSeparatedNestingGroup: DerivedLocation {
  var firstChild: OldParsedSyntaxNode {
    return opening
  }
  var lastChild: OldParsedSyntaxNode {
    return closing
  }
}
