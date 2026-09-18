import Saying

func syntaxNodeAbility(
  names: NodeNames,
  parsed: Bool
) -> [String] {
  let source: [String] = [
    "use (clients)",
    " use of (\(parsed ? "parsed " : "")\(names.english)) as \(parsed ? "parsed " : "")syntax node",
    " {",
    "  action (clients)",
    "   (node: \(parsed ? "parsed " : "")\(names.english)) as node",
    "   \(parsed ? "parsed " : "")syntax node",
    "   {",
    "    ← wrap (node) as (\(names.english) node)",
    "   }",
    "",
    "  action (clients)",
    "   children of (node: \(parsed ? "parsed " : "")\(names.english))",
    "   list of (\(parsed ? "parsed " : "")syntax node)",
    "   {",
    "    ← empty",
    "   }",
    " }",
  ]
  return source
}
