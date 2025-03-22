import SDGText

func syntaxNodeStorage(
  englishName: StrictString,
  parsed: Bool
) -> [String] {
  let source: [String] = [
    "use (clients)",
    " storage of (\(parsed ? "parsed " : "")\(englishName))",
    " {",
    " }",
  ]
  return source
}
