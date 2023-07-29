extension ParsedSeparatedNestingNode {

  enum Kind {
    case leaf(Leaf)
    case emptyGroup(ParsedEmptySeparatedNestingGroup<Leaf, Separator>)
    case group(ParsedSeparatedNestingGroup<Leaf, Separator>)
  }
}
