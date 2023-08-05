enum ParsedSeparatedNestingNode<Leaf, Separator>: OldParsedSyntaxNode
where Leaf: OldParsedSyntaxNode, Separator: OldParsedSyntaxNode {
  case leaf(Leaf)
  case emptyGroup(ParsedEmptySeparatedNestingGroup<Leaf, Separator>)
  case group(ParsedSeparatedNestingGroup<Leaf, Separator>)
}

extension ParsedSeparatedNestingNode: AlternateForms {
  var form: OldParsedSyntaxNode {
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
