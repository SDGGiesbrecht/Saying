import SDGText

func syntaxNodeGeneralUse(
  englishName: StrictString,
  parsed: Bool
) -> [String] {
  let source: [String] = [
    "use (clients)",
    " general use of (\(parsed ? "parsed " : "")\(englishName))",
    " {",
    " }",
  ]
  return source
}
