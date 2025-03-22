import SDGText

func syntaxNodeCreation(
  englishName: StrictString,
  deutscherName: StrictString?,
  nomFrançais: StrictString?,
  ελληνικόΌνομα: StrictString?,
  swiftName: StrictString
) -> [String] {
  var source: [String] = [
    "action (clients)",
    " [",
    "  test {ignore (create \(englishName))}",
    " ]",
    " (",
    "  English: create \(englishName)",
  ]
  if let deutsch = deutscherName {
    source.append("  Deutsch: \(deutsch) erstellen")
  }
  if let français = nomFrançais {
    source.append("  français : créer \(français)")
  }
  if let ελληνικά = ελληνικόΌνομα {
    source.append("  ελληνικά: δημιουργία σύνταξης \(StrictString(ελληνικά.dropFirst(9)))")
  }
  source.append(contentsOf: [
    "  Swift: \(swiftName).init",
    " )",
    " \(englishName)",
    " create",
  ])
  return source
}
