import Saying

func syntaxNodeGeneralUse(
  names: NodeNames,
  parsed: Bool
) -> [String] {
  let source: [String] = [
    "use (clients)",
    " general use of (\(parsed ? "parsed " : "")\(names.english))",
    " {",
    " }",
  ]
  return source
}
