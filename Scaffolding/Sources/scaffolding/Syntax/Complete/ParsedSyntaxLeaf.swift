import SDGText

protocol ParsedSyntaxLeaf: ParsedSyntaxNode {
  var leafKind: ParsedSyntaxLeafKind { get }
}
