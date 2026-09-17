import Saying

func syntaxNodeGeneralContainers(
  names: NodeNames,
  parsed: Bool
) -> [String] {
  let containers = false
  let ability = containers ? "containers" : "use"
  var source: [String] = [
    "use (clients)",
    " general \(ability) of (\(parsed ? "parsed " : "")\(names.english))",
    " {",
  ]
  if !containers {
    source.append(contentsOf: [
      " }",
      "",
    ])
  }
  source.append(contentsOf: [
    "  action (clients)",
  ])
  if !containers {
    source.append(contentsOf: [
      "  [",
      "   test {ignore (example: \(parsed ? "parsed " : "")\(names.english))}",
      "  ]",
    ])
  }
  source.append(contentsOf: [
    "  example",
    "  \(parsed ? "parsed " : "")\(names.english)",
    "  {",
  ])
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
  ])
  if containers {
    source.append(contentsOf: [
      " }",
    ])
  }
  return source
}
