import Saying

func syntaxNodeCreation(
  names: NodeNames,
  parsed: Bool,
  scalarName: UnicodeText?
) -> [String] {
  var source: [String] = [
    "action (\(parsed ? "unit" : "clients"))",
    " [",
  ]
  if parsed {
    source.append(contentsOf: [
      "  test {ignore ((location) of (parsed \(names.english) (placeholder: slice of Saying source)))}",
    ])
  } else {
    source.append(contentsOf: [
      "  test {ignore (create \(names.english))}",
    ])
    if let scalarName = scalarName {
      source.append(contentsOf: [
        "  test {ignore (\(scalarName))}",
      ])
    }
  }
  source.append(contentsOf: [
    " ]",
    " (",
  ])
  if parsed {
    source.append(contentsOf: [
      "  English: parsed \(names.english) (location: slice of Saying source)",
    ])
  } else {
    source.append(contentsOf: [
      "  English: create \(names.english)",
    ])
  }
  if !parsed {
    if let deutsch = names.deutscher {
      source.append("  Deutsch: \(deutsch) erstellen")
    }
    if let français = names.français {
      source.append("  français : créer \(français)")
    }
    if let ελληνικά = names.ελληνικό {
      source.append("  ελληνικά: δημιουργία σύνταξης \(UnicodeText(ελληνικά.dropFirst(9)))")
    }
    source.append(contentsOf: [
      "  Swift: \(names.swift).init",
    ])
  }
  source.append(contentsOf: [
    " )",
    " \(parsed ? "parsed " : "")\(names.english)",
    " create",
  ])
  return source
}
