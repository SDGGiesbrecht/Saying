struct ParsedSeparatedNestingNode<Leaf, Separator>: ParsedSyntaxNode
where Leaf: ParsedSyntaxNode, Separator: ParsedSyntaxNode {
  let kind: Kind
  let location: Slice<UTF8Segments>
}
