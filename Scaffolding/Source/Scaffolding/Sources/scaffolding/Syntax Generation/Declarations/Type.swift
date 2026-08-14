import Saying

func syntaxNodeType(
  names: NodeNames
) -> [String] {
  let source: [String] = [
    "action (clients)",
    " [",
    "  test {ignore (type of (create \(names.english)))}",
    " ]",
    " (",
    "  English: type of (node: \(names.english))",
    "  Swift: var (self: [node]).type",
    " )",
    " type of syntax node",
    " {",
    "  ← wrap (node) as (\(names.english) node type)",
    " }",
  ]
  return source
}
