import SDGText

struct Node {

  static let nodes: [Node] = [
    Node(name: "ParagraphBreak", kind: .fixedLeaf("\u{2029}")),
    Node(name: "LineBreak", kind: .fixedLeaf("\u{2028}")),
    Node(name: "OpeningParenthesis", kind: .fixedLeaf("(")),
    Node(name: "ClosingParenthesis", kind: .fixedLeaf(")")),
    Node(name: "OpeningBracket", kind: .fixedLeaf("[")),
    Node(name: "ClosingBracket", kind: .fixedLeaf("]")),
    Node(name: "OpeningQuotationMark", kind: .fixedLeaf("“")),
    Node(name: "ClosingQuotationMark", kind: .fixedLeaf("”")),
    Node(name: "Colon", kind: .fixedLeaf(":")),
    Node(name: "SymbolInsertionMark", kind: .fixedLeaf("¤")),
    Node(name: "Space", kind: .fixedLeaf(" ")),
    Node(name: "IdentifierComponent", kind: .variableLeaf),
  ]

  let name: StrictString
  let kind: Kind

  static func source() -> StrictString {
    return nodes.lazy.map({ $0.source() }).joined(separator: "\n\n")
  }
  func source() -> StrictString {
    var result = [
      declarationSource(),
      syntaxNodeConformance(),
    ]
    if let leaf = syntaxLeafConformance() {
      result.append(leaf)
    }
    return result.joined(separator: "\n\n")
  }

  func declarationSource() -> StrictString {
    if let text = textProperty() {
      return [
        "struct \(name) {",
        text,
        "}",
      ].joined(separator: "\n")
    } else {
      return [
        "struct \(name) {}",
      ].joined(separator: "\n")
    }
  }

  func textProperty() -> StrictString? {
    switch kind {
    case .fixedLeaf:
      return nil
    case .variableLeaf:
      return "  let text: StrictString"
    }
  }

  func syntaxNodeConformance() -> StrictString {
    return [
      "extension \(name): SyntaxNode {",
      "",
      "  var children: [SyntaxNode] {",
      childrenImplementation(),
      "  }",
      "}",
    ].joined(separator: "\n")
  }

  func childrenImplementation() -> StrictString {
    switch kind {
    case .fixedLeaf, .variableLeaf:
      return "    return []"
    }
  }

  func syntaxLeafConformance() -> StrictString? {
    switch kind {
    case .fixedLeaf(let scalar):
      return [
        "extension \(name): SyntaxLeaf {",
        "",
        "  var text: StrictString {",
        "    return \u{22}\u{5C}u{\(scalar.hexadecimalCode)}\u{22}",
        "  }",
        "}",
      ].joined(separator: "\n")
    case .variableLeaf:
      return [
        "extension \(name): SyntaxLeaf {}"
      ].joined(separator: "\n")
    }
  }
}
