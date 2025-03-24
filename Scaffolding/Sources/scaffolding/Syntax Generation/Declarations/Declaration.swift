import SDGText

func syntaxNodeParsedDeclaration(
  englishName: StrictString,
  deutscherName: StrictString?,
  nomFrançais: StrictString?,
  ελληνικόΌνομα: StrictString?,
  swiftName: StrictString
) -> [String] {
  var source: [String] = [
    "thing (clients)",
    " (",
    "  English: parsed \(englishName)",
  ]
  if let deutsch = deutscherName {
    source.append("  Deutsch: zerteilte \(deutsch)")
  }
  if let français = nomFrançais {
    source.append("  français : syntaxe analysée \(StrictString(français.dropFirst(8)))")
  }
  if let ελληνικά = ελληνικόΌνομα {
    source.append("  ελληνικά: αναλυμένη \(ελληνικά)")
  }
  source.append(contentsOf: [
    "  Swift: Parsed\(swiftName)",
    " )",
    " {",
    "  part (clients/nowhere)",
    "  (",
    "   English: location",
    "  )",
    "  slice of (Unicode segments)",
    " }",
  ])
  return source
}
