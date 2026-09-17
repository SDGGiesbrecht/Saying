import Saying

func syntaxNodeParsedDeclaration(
  names: NodeNames
) -> [String] {
  var source: [String] = [
    "thing (clients)",
    " (",
    "  English: parsed \(names.english)",
  ]
  if let deutsch = names.deutscher {
    source.append("  Deutsch: zerteilte \(deutsch)")
  }
  if let français = names.français {
    source.append("  français : syntaxe analysée \(UnicodeText(français.dropFirst(8)))")
  }
  if let ελληνικά = names.ελληνικό {
    source.append("  ελληνικά: αναλυμένη \(ελληνικά)")
  }
  source.append(contentsOf: [
    "  Swift: Parsed\(names.swift)",
    " )",
    " {",
    "  part (clients/nowhere)",
    "  (",
    "   English: location",
    "  )",
    "  slice of Saying source",
    " }",
  ])
  return source
}
