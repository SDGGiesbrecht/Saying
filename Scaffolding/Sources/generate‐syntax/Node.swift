import SDGText

struct Node {

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
      syntaxUtilities(parsed: false),
      syntaxUtilities(parsed: true),
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
    var result: [StrictString] = [
      "struct \(name) {"
    ]
    result.append(contentsOf: childrenProperties())
    if let text = storedTextProperty() {
      result.append(text)
    }
    result.append(contentsOf: [
      "}",
    ])
    return result.joined(separator: "\n")
  }
  func parsedDeclarationSource() -> StrictString {
    var result: [StrictString] = [
      "struct Parsed\(name) {"
    ]
    result.append(contentsOf: parsedChildrenProperties())
    if let location = storedLocationProperty() {
      result.append(location)
    }
    result.append(contentsOf: [
      "}",
    ])
    return result.joined(separator: "\n")
  }

  func childrenProperties() -> [StrictString] {
    switch kind {
    case .fixedLeaf, .variableLeaf:
      return []
    case .compound(let children):
      return children.map { child in
        switch child.kind {
        case .required:
          return "  var \(child.name): \(child.type)"
        case .optional:
          return "  var \(child.name): \(child.type)?"
        }
      }
    }
  }
  func parsedChildrenProperties() -> [StrictString] {
    switch kind {
    case .fixedLeaf, .variableLeaf:
      return []
    case .compound(let children):
      return children.map { child in
        switch child.kind {
        case .required:
          return "  let \(child.name): Parsed\(child.type)"
        case .optional:
          return "  let \(child.name): Parsed\(child.type)?"
        }
      }
    }
  }

  func storedTextProperty() -> StrictString? {
    switch kind {
    case .fixedLeaf, .compound:
      return nil
    case .variableLeaf:
      return "  let text: StrictString"
    }
  }

  func storedLocationProperty() -> StrictString? {
    switch kind {
    case .fixedLeaf, .variableLeaf:
      return "  let location: Slice<UTF8Segments>"
    case .compound(let children):
      if children.guaranteedNonEmpty {
        return nil
      } else {
        return "  let location: Slice<UTF8Segments>"
      }
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
      "  var children: [ParsedSyntaxNode] {",
      parsedChildrenImplementation(),
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
    case .compound(let children):
      var result: [StrictString] = [
        "    var result: [SyntaxNode] = []",
      ]
      for child in children {
        switch child.kind {
        case .required:
          result.append("    result.append(\(child.name))")
        case .optional:
          result.append(contentsOf: [
            "    if let \(child.name) = self.\(child.name) {",
            "      result.append(\(child.name))",
            "    }",
          ])
        }
      }
      result.append(contentsOf: [
        "    return result"
      ])
      return result.joined(separator: "\n")
    }
  }
  func parsedChildrenImplementation() -> StrictString {
    switch kind {
    case .fixedLeaf, .variableLeaf:
      return "    return []"
    case .compound(let children):
      var result: [StrictString] = [
        "    var result: [ParsedSyntaxNode] = []",
      ]
      for child in children {
        switch child.kind {
        case .required:
          result.append("    result.append(\(child.name))")
        case .optional:
          result.append(contentsOf: [
            "    if let \(child.name) = self.\(child.name) {",
            "      result.append(\(child.name))",
            "    }",
          ])
        }
      }
      result.append(contentsOf: [
        "    return result"
      ])
      return result.joined(separator: "\n")
    }
  }

  func contextImplementation() -> StrictString {
    switch kind {
    case .fixedLeaf, .variableLeaf:
      return "    return location.base"
    case .compound(let children):
      if children.guaranteedNonEmpty {
        return "    return firstChild.context"
      } else {
        return "    return location.base"
      }
    }
  }
  
  func startIndexImplementation() -> StrictString {
    switch kind {
    case .fixedLeaf, .variableLeaf:
      return "    return location.startIndex"
    case .compound(let children):
      if children.guaranteedNonEmpty {
        return "    return firstChild.startIndex"
      } else {
        return "    return location.startIndex"
      }
    }
  }
  
  func endIndexImplementation() -> StrictString {
    switch kind {
    case .fixedLeaf, .variableLeaf:
      return "    return location.endIndex"
    case .compound(let children):
      if children.guaranteedNonEmpty {
        return "    return lastChild.endIndex"
      } else {
        return "    return location.endIndex"
      }
    }
  }

  func locationImplementation() -> StrictString? {
    switch kind {
    case .fixedLeaf, .variableLeaf:
      return nil
    case .compound(let children):
      if children.guaranteedNonEmpty {
        return "    return context[startIndex..<endIndex]"
      } else {
        return nil
      }
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
    case .compound(let children):
      #warning("Not implemented yet.")
      return [
        "fatalError()",
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
    case .compound(let children):
      #warning("Not implemented yet.")
      return []
    }
  }

  func allowedDefinition() -> StrictString? {
    switch kind {
    case .fixedLeaf, .compound:
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
    switch kind {
    case .fixedLeaf, .variableLeaf:
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
    case .compound:
      return nil
    }
  }
  func parsedSyntaxLeafConformance() -> StrictString? {
    switch kind {
    case .fixedLeaf, .variableLeaf:
      return [
        "extension Parsed\(name): ParsedSyntaxLeaf {",
        "",
        "  var leafKind: ParsedSyntaxLeafKind {",
        "    return .\(lowercasedName)(self)",
        "  }",
        "}",
      ].joined(separator: "\n")
    case .compound:
      return nil
    }
  }

  func derivedTextProperty() -> StrictString? {
    switch kind {
    case .fixedLeaf(let scalar):
      return [
        "  var text: StrictString {",
        "    return \u{22}\u{5C}u{\(scalar.hexadecimalCode)}\u{22}",
        "  }",
      ].joined(separator: "\n")
    case .variableLeaf, .compound:
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
    case .compound:
      return nil
    }
  }
  func parsedLeafKindCase() -> StrictString? {
    switch kind {
    case .variableLeaf, .fixedLeaf:
      return "  case \(lowercasedName)(Parsed\(name))"
    case .compound:
      return nil
    }
  }

  func syntaxUtilities(parsed: Bool) -> StrictString {
    var result: [StrictString] = [
      "extension \(parsed ? "Parsed" : "")\(name) {",
    ]
    if let first = borderChild(parsed: parsed, last: false) {
      result.append(first)
    }
    if let last = borderChild(parsed: parsed, last: true) {
      result.append(last)
    }
    result.append(contentsOf: [
      "}"
    ])
    return result.joined(separator: "\n")
  }

  func borderChild(parsed: Bool, last: Bool) -> StrictString? {
    switch kind {
    case .fixedLeaf, .variableLeaf:
      return nil
    case .compound(let children):
      if children.guaranteedNonEmpty {
        let childList = last ? children.reversed() : children
        var resolution: [StrictString] = []
        accumulator: for child in childList {
          switch child.kind {
          case .required:
            resolution.append("\(child.name)")
            break accumulator
          case .optional:
            resolution.append("\(child.name) ??")
          }
        }
        return [
          "",
          "  var \(last ? "last" : "first")Child: \(parsed ? "Parsed" : "")SyntaxNode {",
          "    return \(resolution.joined(separator: " "))",
          "  }",
        ].joined(separator: "\n")
      } else {
        return nil
      }
    }
  }
}
