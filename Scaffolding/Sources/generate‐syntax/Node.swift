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

  var lowercasedName: StrictString {
    var result = name
    let first = result.removeFirst()
    result.prepend(contentsOf: first.properties.lowercaseMapping.scalars)
    return result
  }

  static func source() -> StrictString {
    var result: [StrictString] = nodes.map({ $0.source() })
    result.append(contentsOf: [
      nodeKind(),
      leafKind(),
    ])
    return result.joined(separator: "\n\n")
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
    if let text = storedTextProperty() {
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

  func storedTextProperty() -> StrictString? {
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
      "  var nodeKind: SyntaxNodeKind {",
      "    return .\(lowercasedName)(self)",
      "  }",
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
    var result: [StrictString] = [
      "extension \(name): SyntaxLeaf {",
      "",
      "  var leafKind: SyntaxLeafKind {",
      "    return .\(lowercasedName)(self)",
      "  }",
    ]
    if let text = derivedTextProperty() {
      result.append(text)
    }
    result.append(contentsOf: [
      "}",
    ])
    return result.joined(separator: "\n")
  }

  func derivedTextProperty() -> StrictString? {
    switch kind {
    case .fixedLeaf(let scalar):
      return [
        "  var text: StrictString {",
        "    return \u{22}\u{5C}u{\(scalar.hexadecimalCode)}\u{22}",
        "  }",
      ].joined(separator: "\n")
    case .variableLeaf:
      return nil
    }
  }

  static func nodeKind() -> StrictString {
    var result: [StrictString] = [
      "enum SyntaxNodeKind {",
    ]
    result.append(contentsOf: nodes.lazy.map({ $0.nodeKindCase() }))
    result.append(contentsOf: [
      "}",
    ])
    return result.joined(separator: "\n")
  }

  func nodeKindCase() -> StrictString {
    return "case \(lowercasedName)(\(name))"
  }

  static func leafKind() -> StrictString {
    var result: [StrictString] = [
      "enum SyntaxLeafKind {",
    ]
    result.append(contentsOf: nodes.lazy.compactMap({ $0.leafKindCase() }))
    result.append(contentsOf: [
      "}",
    ])
    return result.joined(separator: "\n")
  }

  func leafKindCase() -> StrictString? {
    switch kind {
    case .variableLeaf, .fixedLeaf:
      return "case \(lowercasedName)(\(name))"
    }
  }
}
