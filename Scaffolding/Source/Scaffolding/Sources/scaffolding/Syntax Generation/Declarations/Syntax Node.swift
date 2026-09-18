func syntaxNodeEnumeration(nodes: [NodeNames], parsed: Bool) -> [String] {
  var source: [String] = [
    "enumeration (clients)",
    " (",
    "  English: \(parsed ? "parsed " : "")syntax node",
    "  Swift: \(parsed ? "Parsed" : "")SyntaxNode",
    " )",
    " {",
  ]
  for index in nodes.indices {
    if index != nodes.startIndex {
      source.append("")
    }
    let names = nodes[index]
    source.append(contentsOf: [
      "  case",
      "   (",
      "    English: \(names.english) node",
      "    Swift: \(names.lowercasedSwift)",
      "   )",
      "   \(parsed ? "parsed " : "")\(names.english)",
    ])
  }
  source.append(contentsOf: [
    " }",
    "",
    "use (clients)",
    " general containers of (\(parsed ? "parsed " : "")syntax node)",
    " {",
    "  action (clients)",
    "   example",
    "   \(parsed ? "parsed " : "")syntax node",
    "  {",
  ])
  if parsed {
    source.append(contentsOf: [
      "   ← wrap (parsed space syntax (placeholder: slice of Saying source)) as (space syntax node)",
    ])
  } else {
    source.append(contentsOf: [
      "   ← wrap (create space syntax) as (space syntax node)",
    ])
  }
  source.append(contentsOf: [
    "  }",
    " }",
  ])
  return source
}
