func syntaxNodeTypeDeclaration(nodeTypes: [NodeNames], parsed: Bool) -> [String] {
  var source: [String] = [
    "enumeration (clients)",
    " (",
    "  English: type of \(parsed ? "parsed " : "")syntax node",
    "  Swift: \(parsed ? "Parsed" : "")SyntaxNodeType",
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
      "   \(parsed ? "parsed " : "")\(names.english)",
    ])
  }
  source.append(contentsOf: [
    " }",
    "",
    "use (clients)",
    " general use of (type of \(parsed ? "parsed " : "")syntax node)",
    " {",
    " }",
  ])
  return source
}
