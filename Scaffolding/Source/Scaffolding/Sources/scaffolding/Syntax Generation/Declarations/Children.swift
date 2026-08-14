import Saying

func syntaxNodeChildren(
  names: NodeNames,
  parsed: Bool
) -> [String] {
  var source: [String] = [
    "action (clients)",
    " [",
  ]
  if parsed {
    source.append(contentsOf: [
      "  test (hidden) {ignore (children of (parsed \(names.english) (placeholder: slice of Saying source)))}",
    ])
  } else {
    source.append(contentsOf: [
      "  test {ignore (children of (create \(names.english)))}",
    ])
  }
  source.append(contentsOf: [
    " ]",
    " (",
    "  English: children of (node: \(parsed ? "parsed " : "")\(names.english))",
    "  Swift: var (self: [node]).children",
    " )",
    " list of (type of \(parsed ? "parsed " : "")syntax node)",
    " {",
    "  ← empty",
    " }",
  ])
  return source
}
