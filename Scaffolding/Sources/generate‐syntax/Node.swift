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
    Node(
      name: "IdentifierComponent",
      kind: .variableLeaf(allowed: {
        var values: [UInt32] = []
        values.append(0x2E) // .
        values.append(contentsOf: 0x30...0x39) // 0–9
        values.append(contentsOf: 0x41...0x5A) // A–Z
        values.append(contentsOf: 0x61...0x7A) // a–z
        values.append(contentsOf: 0x300...0x302) // ◌̀–◌̂
        values.append(0x308) // “◌̈”
        values.append(0x327) // “◌̧”
        values.append(contentsOf: 0x3B1...0x3C9) // α–ω
        values.append(contentsOf: 0x5D0...0x5EA) // א–ת
        return Set(values.lazy.map({ Unicode.Scalar($0)! }))
      }())
    ),
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
    var result: [StrictString] = [
      "import SDGCollections",
      "",
    ]
    result.append(contentsOf: nodes.lazy.map({ $0.source() }))
    result.append(contentsOf: [
      nodeKind(),
      parsedNodeKind(),
      leafKind(),
      parsedLeafKind(),
    ])
    return result.joined(separator: "\n\n")
  }

  func source() -> StrictString {
    var result = [
      declarationSource(),
      parsedDeclarationSource(),
      syntaxNodeConformance(),
      parsedSyntaxNodeConformance(),
      parsableSyntaxNodeConformance(),
      parseError(),
    ]
    if let leaf = syntaxLeafConformance() {
      result.append(leaf)
    }
    if let leaf = parsedSyntaxLeafConformance() {
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
  func parsedDeclarationSource() -> StrictString {
    if let location = storedLocationProperty() {
      return [
        "struct Parsed\(name) {",
        location,
        "}",
      ].joined(separator: "\n")
    } else {
      return [
        "struct Parsed\(name) {}",
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

  func storedLocationProperty() -> StrictString? {
    switch kind {
    case .fixedLeaf, .variableLeaf:
      return "  let location: Slice<UTF8Segments>"
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
  func parsedSyntaxNodeConformance() -> StrictString {
    var result: [StrictString] = [
      "extension Parsed\(name): ParsedSyntaxNode {",
      "",
      "  var nodeKind: ParsedSyntaxNodeKind {",
      "    return .\(lowercasedName)(self)",
      "  }",
      "",
      "  var children: [SyntaxNode] {",
      childrenImplementation(),
      "  }",
      "",
      "  var context: UTF8Segments {",
      contextImplementation(),
      "  }",
      "",
      "  var startIndex: UTF8Segments.Index {",
      startIndexImplementation(),
      "  }",
      "",
      "  var endIndex: UTF8Segments.Index {",
      endIndexImplementation(),
      "  }",
    ]
    if let location = locationImplementation() {
      result.append(contentsOf: [
        "",
        "  var location: Slice<UTF8Segments> {",
        location,
        "  }",
      ])
    }
    result.append(contentsOf: [
      "}",
    ])
    return result.joined(separator: "\n")
  }

  func childrenImplementation() -> StrictString {
    switch kind {
    case .fixedLeaf, .variableLeaf:
      return "    return []"
    }
  }

  func contextImplementation() -> StrictString {
    switch kind {
    case .fixedLeaf, .variableLeaf:
      return "    return location.base"
    }
  }
  
  func startIndexImplementation() -> StrictString {
    switch kind {
    case .fixedLeaf, .variableLeaf:
      return "    return location.startIndex"
    }
  }
  
  func endIndexImplementation() -> StrictString {
    switch kind {
    case .fixedLeaf, .variableLeaf:
      return "    return location.endIndex"
    }
  }

  func locationImplementation() -> StrictString? {
    switch kind {
    case .fixedLeaf, .variableLeaf:
      return nil
    }
  }
  
  func parsableSyntaxNodeConformance() -> StrictString {
    var result: [StrictString] = [
      "extension Parsed\(name): ParsableSyntaxNode {",
    ]
    if let allowed = allowedDefinition() {
      result.append(allowed)
    }
    result.append(contentsOf: [
      "",
      "  static func parse(source: Slice<UTF8Segments>) -> Result<Parsed\(name), ParseError> {",
      parseImplementation(),
      "  }",
      "}",
    ])
    return result.joined(separator: "\n")
  }

  func parseImplementation() -> StrictString {
    switch kind {
    case .fixedLeaf(let scalar):
      return [
        "guard let first = source.first,",
        "  source.dropFirst().isEmpty,",
        "  first == \u{22}\u{5C}u{\(scalar.hexadecimalCode)}\u{22} else {",
        "    return .failure(.notA\(name)(source))",
        "}",
        "return .success(Parsed\(name)(location: source))",
      ].joined(separator: "\n")
    case .variableLeaf:
      return [
        "for index in source.indices {",
        "  if source[index] ∉ allowed {",
        "    return .failure(.invalidScalarFor\(name)(source[index...].prefix(1)))",
        "  }",
        "}",
        "return .success(Parsed\(name)(location: source))",
      ].joined(separator: "\n")
    }
  }

  func parseError() -> StrictString {
    return [
      "extension Parsed\(name) {",
      "",
      "  enum ParseError: Error {",
      parseErrorCases().lazy.map({ "    \($0)" }).joined(separator: "\n"),
      "  }",
      "}",
    ].joined(separator: "\n")
  }

  func parseErrorCases() -> [StrictString] {
    switch kind {
    case .fixedLeaf:
      return [
        "case notA\(name)(Slice<UTF8Segments>)"
      ]
    case .variableLeaf:
      return [
        "case invalidScalarFor\(name)(Slice<UTF8Segments>)",
      ]
    }
  }

  func allowedDefinition() -> StrictString? {
    switch kind {
    case .fixedLeaf:
      return nil
    case .variableLeaf(let allowed):
      var result: [StrictString] = [
        "",
        "  static let allowed: Set<Unicode.Scalar> = [",
      ]
      for scalar in allowed.sorted() {
        result.append("    \u{22}\u{5C}u{\(scalar.hexadecimalCode)}\u{22},")
      }
      result.append(contentsOf: [
        "  ]",
      ])
      return result.joined(separator: "\n")
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
  func parsedSyntaxLeafConformance() -> StrictString? {
    return [
      "extension Parsed\(name): ParsedSyntaxLeaf {",
      "",
      "  var leafKind: ParsedSyntaxLeafKind {",
      "    return .\(lowercasedName)(self)",
      "  }",
      "}",
    ].joined(separator: "\n")
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
  static func parsedNodeKind() -> StrictString {
    var result: [StrictString] = [
      "enum ParsedSyntaxNodeKind {",
    ]
    result.append(contentsOf: nodes.lazy.map({ $0.parsedNodeKindCase() }))
    result.append(contentsOf: [
      "}",
    ])
    return result.joined(separator: "\n")
  }

  func nodeKindCase() -> StrictString {
    return "  case \(lowercasedName)(\(name))"
  }
  func parsedNodeKindCase() -> StrictString {
    return "  case \(lowercasedName)(Parsed\(name))"
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
  static func parsedLeafKind() -> StrictString {
    var result: [StrictString] = [
      "enum ParsedSyntaxLeafKind {",
    ]
    result.append(contentsOf: nodes.lazy.compactMap({ $0.parsedLeafKindCase() }))
    result.append(contentsOf: [
      "}",
    ])
    return result.joined(separator: "\n")
  }

  func leafKindCase() -> StrictString? {
    switch kind {
    case .variableLeaf, .fixedLeaf:
      return "  case \(lowercasedName)(\(name))"
    }
  }
  func parsedLeafKindCase() -> StrictString? {
    switch kind {
    case .variableLeaf, .fixedLeaf:
      return "  case \(lowercasedName)(Parsed\(name))"
    }
  }
}
