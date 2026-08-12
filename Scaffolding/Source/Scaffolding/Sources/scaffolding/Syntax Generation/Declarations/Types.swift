func syntaxNodeTypeDeclaration(nodeTypes: [NodeNames]) -> [String] {
  var source: [String] = [
    "enumeration (clients)",
    " (",
    "  English: type of syntax node",
    "  Swift: SyntaxNodeType",
    " )",
    " {",
  ]
  for index in nodeTypes.indices {
    if index != nodeTypes.startIndex {
      source.append("")
    }
    let names = nodeTypes[index]
    source.append(contentsOf: [
      "  case",
      "   (",
      "    English: \(names.english) node type",
      "    Swift: \(names.lowercasedSwift)",
      "   )",
      "   \(names.english)",
    ])
  }
  source.append(contentsOf: [
    " }",
    "",
    "use (clients)",
    " general use of (type of syntax node)",
    " {",
    " }",
  ])
  return source
}
