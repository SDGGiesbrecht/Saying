func syntaxNodeCreation(
  englishName: UnicodeText,
  deutscherName: UnicodeText?,
  nomFrançais: UnicodeText?,
  ελληνικόΌνομα: UnicodeText?,
  swiftName: UnicodeText,
  parsed: Bool
) -> [String] {
  var source: [String] = [
    "action (\(parsed ? "unit" : "clients"))",
    " [",
  ]
  if parsed {
    source.append(contentsOf: [
      "  test {ignore ((location) of (parsed \(englishName) (placeholder: slice of Saying source)))}",
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
      "  English: parsed \(englishName) (location: slice of Saying source)",
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
      source.append("  ελληνικά: δημιουργία σύνταξης \(UnicodeText(ελληνικά.dropFirst(9)))")
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
