import SDGText

func syntaxNodeParsedLocation(
  englishName: StrictString
) -> [String] {
  let source: [String] = [
    "action (clients)",
    " (",
    "  English: location of (syntax: parsed \(englishName))",
    "  Swift: var (self: [syntax]).location",
    " )",
    " slice of (Unicode segments)",
    " {",
    "  ← (stored location) of (syntax)",
    " }",
  ]
  return source
}
