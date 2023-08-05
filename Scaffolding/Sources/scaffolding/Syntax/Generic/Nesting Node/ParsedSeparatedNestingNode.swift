enum ParsedSeparatedNestingNode<Leaf, Separator>: ManualParsedSyntaxNode
where Leaf: ManualParsedSyntaxNode, Separator: ManualParsedSyntaxNode {
  case leaf(Leaf)
  case emptyGroup(ParsedEmptySeparatedNestingGroup<Leaf, Separator>)
  case group(ParsedSeparatedNestingGroup<Leaf, Separator>)
}

extension ParsedSeparatedNestingNode: AlternateForms {
  var form: ManualParsedSyntaxNode {
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
