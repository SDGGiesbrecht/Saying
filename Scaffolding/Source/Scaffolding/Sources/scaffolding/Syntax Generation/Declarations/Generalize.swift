import Saying

func syntaxNodeGeneralize(
  names: NodeNames,
  parsed: Bool
) -> [String] {
  var source: [String] = [
    "action (clients)",
    " [",
  ]
  if parsed {
    source.append(contentsOf: [
      "  test (hidden) {ignore ((parsed \(names.english) (placeholder: slice of Saying source)) as node)}",
    ])
  } else {
    source.append(contentsOf: [
      "  test {ignore ((create \(names.english)) as node)}",
    ])
  }
  source.append(contentsOf: [
    " ]",
    " (",
    "  English: (node: \(parsed ? "parsed " : "")\(names.english)) as node",
    "  Swift: \(parsed ? "Parsed" : "")SyntaxNode.init (node: [node])",
    " )",
    " \(parsed ? "parsed " : "")syntax node",
    " {",
    "  ← wrap (node) as (\(names.english) node)",
    " }",
  ])
  return source
}
