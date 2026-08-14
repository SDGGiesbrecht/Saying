import Saying

func syntaxNodeType(
  names: NodeNames,
  parsed: Bool
) -> [String] {
  var source: [String] = [
    "action (clients)",
    " [",
  ]
  if parsed {
    source.append(contentsOf: [
      "  test (hidden) {ignore (type of (parsed \(names.english) (placeholder: slice of Saying source)))}",
    ])
  } else {
    source.append(contentsOf: [
      "  test {ignore (type of (create \(names.english)))}",
    ])
  }
  source.append(contentsOf: [
    " ]",
    " (",
    "  English: type of (node: \(parsed ? "parsed " : "")\(names.english))",
    "  Swift: var (self: [node]).type",
    " )",
    " type of \(parsed ? "parsed " : "")syntax node",
    " {",
    "  ← wrap (node) as (\(names.english) node type)",
    " }",
  ])
  return source
}
