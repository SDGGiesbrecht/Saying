enum ParsedSeparatedNestingNode<Leaf, Separator>: ParsedSyntaxNode
where Leaf: ParsedSyntaxNode, Separator: ParsedSyntaxNode {
  case leaf(Leaf)
  case emptyGroup(ParsedEmptySeparatedNestingGroup<Leaf, Separator>)
  case group(ParsedSeparatedNestingGroup<Leaf, Separator>)
}

extension ParsedSeparatedNestingNode: AlternateForms {
  var form: ParsedSyntaxNode {
    switch self {
    case .leaf(let leaf):
      return leaf
    case .emptyGroup(let group):
      return group
    case .group(let group):
      return group
    }
  }
}
