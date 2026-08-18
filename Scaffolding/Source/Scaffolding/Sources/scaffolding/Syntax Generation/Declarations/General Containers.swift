import Saying

func syntaxNodeGeneralContainers(
  names: NodeNames,
  parsed: Bool
) -> [String] {
  var source: [String] = [
    "use (clients)",
    " general containers of (\(parsed ? "parsed " : "")\(names.english))",
    " {",
    "  action (clients)",
    "  example",
    "  \(parsed ? "parsed " : "")\(names.english)",
    "  {",
  ]
  if parsed {
    source.append(contentsOf: [
      "   ← parsed \(names.english) (placeholder: slice of Saying source)",
    ])
  } else {
    source.append(contentsOf: [
      "   ← create \(names.english)",
    ])
  }
  source.append(contentsOf: [
    "  }",
    " }",
  ])
  return source
}
