import SDGText

func syntaxNodeCreation(
  englishName: StrictString,
  deutscherName: StrictString?,
  nomFrançais: StrictString?,
  ελληνικόΌνομα: StrictString?,
  swiftName: StrictString,
  parsed: Bool
) -> [String] {
  var source: [String] = [
    "action (\(parsed ? "unit" : "clients"))",
    " [",
  ]
  if parsed {
    source.append(contentsOf: [
      "  test {ignore ((location) of (parsed \(englishName) (entirety of (empty: Unicode segments))))}",
    ])
  } else {
    source.append(contentsOf: [
      "  test {ignore (create \(englishName))}",
    ])
  }
  source.append(contentsOf: [
    " ]",
    " (",
  ])
  if parsed {
    source.append(contentsOf: [
      "  English: parsed \(englishName) (location: slice of (Unicode segments))",
    ])
  } else {
    source.append(contentsOf: [
      "  English: create \(englishName)",
    ])
  }
  if !parsed {
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
    ])
  }
  source.append(contentsOf: [
    " )",
    " \(parsed ? "parsed " : "")\(englishName)",
    " create",
  ])
  return source
}
