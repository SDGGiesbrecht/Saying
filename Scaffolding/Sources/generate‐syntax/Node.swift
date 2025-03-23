struct Node {

  let name: String
  let kind: Kind
  var isIdentifierSegment = false
  var isIndirect = false
  var utilities: [String] = []
  var parsedUtilities: [String] = []

  var lowercasedName: String {
    var result = name
    let first = result.unicodeScalars.removeFirst()
    result.unicodeScalars.prepend(contentsOf: first.properties.lowercaseMapping.scalars)
    return result
  }

  static func source() -> String {
    var result: [String] = []
    result.append(contentsOf: nodes.lazy.map({ $0.source() }))
    result.append(contentsOf: [
      nodeKind(parsed: false),
      nodeKind(parsed: true),
      leafKind(parsed: false),
      leafKind(parsed: true),
      identifierSegmentKind(parsed: false),
      identifierSegmentKind(parsed: true),
    ])
    return result.joined(separator: "\n\n")
  }

  func source() -> String {
    var result = [
      declarationSource(parsed: false),
      declarationSource(parsed: true),
    ]
    result.append(contentsOf: [
      syntaxNodeConformance(parsed: false),
      syntaxNodeConformance(parsed: true),
      parsableSyntaxNodeConformance(),
      parseError(),
      syntaxUtilities(parsed: false),
      syntaxUtilities(parsed: true),
    ])
    if let leaf = syntaxLeafConformance(parsed: false) {
      result.append(leaf)
    }
    if let leaf = syntaxLeafConformance(parsed: true) {
      result.append(leaf)
    }
    if let identifier = identifierSegmentConformance(parsed: false) {
      result.append(identifier)
    }
    if let identifier = identifierSegmentConformance(parsed: true) {
      result.append(identifier)
    }
    result.append(contentsOf: [
      parsedConversions()
    ])
    if !utilities.isEmpty {
      result.append("extension \(name) {")
      for utility in utilities {
        result.append(utility)
      }
      result.append("}")
    }
    if !parsedUtilities.isEmpty {
      result.append("extension Parsed\(name) {")
      for utility in parsedUtilities {
        result.append(utility)
      }
      result.append("}")
    }
    return result.joined(separator: "\n\n")
  }

  func declarationSource(parsed: Bool) -> String {
    switch kind {
    case .fixedLeaf:
      return ""
    case .keyword, .variableLeaf, .compound, .alternates:
      break
    }

    var result: [String] = [
      "\(typeKeyword()) \(parsed ? "Parsed" : "")\(name) {"
    ]
    result.append(contentsOf: childrenProperties(parsed: parsed))
    if let text = storedTextProperty(parsed: parsed) {
      result.append(text)
    }
    if let location = storedLocationProperty(parsed: parsed) {
      result.append(location)
    }
    result.append(contentsOf: [
      "}",
    ])
    return result.joined(separator: "\n")
  }

  func typeKeyword() -> String {
    let keyword: String
    switch kind {
    case .fixedLeaf, .keyword, .variableLeaf, .compound:
      keyword = "struct"
    case .alternates:
      keyword = "enum"
    }
    return "\(isIndirect ? "indirect " : "")\(keyword)"
  }

  func childrenProperties(parsed: Bool) -> [String] {
    switch kind {
    case .fixedLeaf, .keyword, .variableLeaf:
      return []
    case .compound(let children):
      return children.map { child in
        switch child.kind {
        case .fixed:
          if parsed {
            return "  let \(child.name): Parsed\(child.type)"
          } else {
            return [
              "  var \(child.name): \(child.type) {",
              "    return \(child.type)()",
              "  }",
            ].joined(separator: "\n")
          }
        case .required:
          return "  \(parsed ? "let" : "var") \(child.name): \(parsed ? "Parsed" : "")\(child.type)"
        case .optional:
          return "  \(parsed ? "let" : "var") \(child.name): \(parsed ? "Parsed" : "")\(child.type)?"
        case .array:
          return "  \(parsed ? "let" : "var") \(child.name): [\(parsed ? "Parsed" : "")\(child.type)]"
        }
      }
    case .alternates(let alternates):
      return alternates.map { alternate in
        return "  case \(alternate.name)(\(parsed ? "Parsed" : "")\(alternate.type))"
      }
    }
  }

  func storedTextProperty(parsed: Bool) -> String? {
    if parsed {
      return nil
    } else {
      switch kind {
      case .fixedLeaf, .compound, .alternates:
        return nil
      case .keyword, .variableLeaf:
        return "  let text: UnicodeText"
      }
    }
  }

  func storedLocationProperty(parsed: Bool) -> String? {
    if !parsed {
      return nil
    } else {
      switch kind {
      case .fixedLeaf, .keyword, .variableLeaf:
        return "  let location: Slice<UnicodeSegments>"
      case .compound, .alternates:
        return nil
      }
    }
  }

  func syntaxNodeConformance(parsed: Bool) -> String {
    var result: [String] = [
      "extension \(parsed ? "Parsed" : "")\(name): \(parsed ? "Parsed" : "")SyntaxNode {",
      "",
      "  var nodeKind: \(parsed ? "Parsed" : "")SyntaxNodeKind {",
      "    return .\(lowercasedName)(self)",
      "  }",
      "",
      "  var children: [\(parsed ? "Parsed" : "")SyntaxNode] {",
      childrenImplementation(parsed: parsed),
      "  }",
    ]
    if parsed {
      result.append(contentsOf: [
        "",
        "  var context: UnicodeSegments {",
        contextImplementation(),
        "  }",
        "",
        "  var startIndex: UnicodeSegments.Index {",
        startIndexImplementation(),
        "  }",
        "",
        "  var endIndex: UnicodeSegments.Index {",
        endIndexImplementation(),
        "  }",
      ])
      if let location = locationImplementation() {
        result.append(contentsOf: [
          "",
          "  var location: Slice<UnicodeSegments> {",
          location,
          "  }",
        ])
      }
    }
    if parsed {
      result.append(contentsOf: [
        "",
        "  func mutableNode() -> SyntaxNode {",
        "    return mutable()",
        "  }",
      ])
    } else {
      result.append(contentsOf: [
        "",
        "  func parsedNode() -> ParsedSyntaxNode {",
        "    return parsed()",
        "  }",
      ])
    }
    result.append(contentsOf: [
      "}",
    ])
    return result.joined(separator: "\n")
  }

  func childrenImplementation(parsed: Bool) -> String {
    switch kind {
    case .fixedLeaf, .keyword, .variableLeaf:
      return "    return []"
    case .compound(let children):
      var result: [String] = [
        "    var result: [\(parsed ? "Parsed" : "")SyntaxNode] = []",
      ]
      for child in children {
        switch child.kind {
        case .fixed, .required:
          result.append("    result.append(\(child.name))")
        case .optional:
          result.append(contentsOf: [
            "    if let \(child.name) = self.\(child.name) {",
            "      result.append(\(child.name))",
            "    }",
          ])
        case .array:
          result.append("    result.append(contentsOf: \(child.name))")
        }
      }
      result.append(contentsOf: [
        "    return result"
      ])
      return result.joined(separator: "\n")
    case .alternates(let alternates):
      var result: [String] = [
        "    switch self {",
      ]
      for alternate in alternates {
        result.append(contentsOf: [
          "    case .\(alternate.name)(let \(alternate.name)):",
          "      return [\(alternate.name)]",
        ])
      }
      result.append(contentsOf: [
        "    }",
      ])
      return result.joined(separator: "\n")
    }
  }

  func contextImplementation() -> String {
    switch kind {
    case .fixedLeaf, .keyword, .variableLeaf:
      return "    return location.base"
    case .compound, .alternates:
      return "    return firstChild.context"
    }
  }
  
  func startIndexImplementation() -> String {
    switch kind {
    case .fixedLeaf, .keyword, .variableLeaf:
      return "    return location.startIndex"
    case .compound, .alternates:
      return "    return firstChild.startIndex"
    }
  }
  
  func endIndexImplementation() -> String {
    switch kind {
    case .fixedLeaf, .keyword, .variableLeaf:
      return "    return location.endIndex"
    case .compound, .alternates:
      return "    return lastChild.endIndex"
    }
  }

  func locationImplementation() -> String? {
    switch kind {
    case .fixedLeaf, .keyword, .variableLeaf:
      return nil
    case .compound, .alternates:
      return "    return context[startIndex..<endIndex]"
    }
  }
  
  func parsableSyntaxNodeConformance() -> String {
    var result: [String] = [
      "extension Parsed\(name): ParsableSyntaxNode {",
    ]
    if let allowed = allowedDefinition() {
      result.append(allowed)
    }
    result.append(contentsOf: [
      "",
      "  static func diagnosticParseNext(",
      "    in remainder: Slice<UnicodeSegments>",
      "  ) -> Result<DiagnosticParseResult<Parsed\(name)>, ErrorList<ParseError>> {",
      diagnosticParseImplementation(),
      "  }",
      "",
      "  static func fastParseNext(in remainder: Slice<UnicodeSegments>) -> Parsed\(name)? {",
      fastParseImplementation(),
      "  }",
      "}",
    ])
    return result.joined(separator: "\n")
  }

  func diagnosticParseImplementation() -> String {
    switch kind {
    case .fixedLeaf(let scalar):
      return [
        "    guard let first = remainder.first,",
        "      first == \u{22}\u{5C}u{\(scalar.hexadecimalCode)}\u{22} else {",
        "        return .failure([.notA\(name)(remainder.prefix(1))])",
        "    }",
        "    return .success(DiagnosticParseResult(result: Parsed\(name)(location: remainder.prefix(1)), reasonNotContinued: nil))",
      ].joined(separator: "\n")
    case .keyword:
      return [
        "    var cursor = remainder.startIndex",
        "    while let nextIndex = remainder[cursor...].indices.first,",
        "      ParsedIdentifierComponent.allowed.contains(remainder[nextIndex]) {",
        "        cursor = remainder.index(after: cursor)",
        "    }",
        "    let slice = remainder[remainder.startIndex..<cursor]",
        "    guard allowed.contains(StrictString(slice)) else {",
        "      return .failure([.notA\(name)(slice)])",
        "    }",
        "    return .success(DiagnosticParseResult(result: Parsed\(name)(location: slice), reasonNotContinued: nil))",
      ].joined(separator: "\n")
    case .variableLeaf:
      return [
        "    var cursor = remainder.startIndex",
        "    while let nextIndex = remainder[cursor...].indices.first,",
        "      allowed.contains(remainder[nextIndex]) {",
        "        cursor = remainder.index(after: cursor)",
        "    }",
        "    let range = remainder.startIndex..<cursor",
        "    guard !range.isEmpty else {",
        "      return .failure([.notA\(name)(remainder.prefix(1))])",
        "    }",
        "    return .success(DiagnosticParseResult(result: Parsed\(name)(location: remainder[range]), reasonNotContinued: nil))",
      ].joined(separator: "\n")
    case .compound(let children):
      var result: [String] = [
        "    var remainder = remainder",
        "    var reasonsNotContinued: [Parsed\(name).ParseError] = []",
      ]
      for child in children {
        switch child.kind {
        case .fixed, .required, .optional:
          result.append(contentsOf: [
            "    let \(child.name) = Parsed\(child.type).diagnosticParseNext(in: remainder)",
            "    switch \(child.name) {",
          ])
          switch child.kind {
          case .fixed, .required:
            result.append(contentsOf: [
              "    case .failure(let error):",
              "      return .failure(ErrorList(reasonsNotContinued + error.errors.map({ .broken\(child.uppercasedName)($0) })))",
            ])
          case .optional:
            result.append(contentsOf: [
              "    case .failure(let errors):",
              "      reasonsNotContinued.append(contentsOf: errors.map({ .broken\(child.uppercasedName)($0) }).errors)",
              "      break",
            ])
          case .array:
            break
          }
          result.append(contentsOf: [
            "    case .success(let parsed):",
            "      if let reason = parsed.reasonNotContinued {",
            "        reasonsNotContinued.append(.broken\(child.uppercasedName)(reason))",
            "      }",
            "      remainder = remainder[parsed.result.location.endIndex...]",
            "    }",
          ])
        case .array:
          result.append(contentsOf: [
            "    var \(child.name): [Parsed\(child.type)] = []",
            "    while let parsed = try? Parsed\(child.type).diagnosticParseNext(in: remainder).get() {",
            "      \(child.name).append(parsed.result)",
            "      remainder = remainder[parsed.result.location.endIndex...]",
            "    }",
            "    switch Parsed\(child.type).diagnosticParseNext(in: remainder) {",
            "    case .failure(let errors):",
            "      reasonsNotContinued.append(contentsOf: errors.map({ .broken\(child.uppercasedName)($0) }).errors)",
            "    case .success:",
            "      fatalError(\u{22}If this succeeds, it should have been included in the previous iteration.\u{22})",
            "    }",
          ])
        }
      }
      result.append(contentsOf: [
        "    return .success(",
        "      DiagnosticParseResult(",
        "        result: Parsed\(name)(",
      ])
      for childIndex in children.indices {
        let child = children[childIndex]
        switch child.kind {
        case .fixed, .required:
          result.append(contentsOf: [
            "          \(child.name): (try? \(child.name).get())!.result\(childIndex == children.indices.last ? "" : ",")",
          ])
        case .optional:
          result.append(contentsOf: [
            "          \(child.name): try? \(child.name).get().result\(childIndex == children.indices.last ? "" : ",")",
          ])
        case .array:
          result.append(contentsOf: [
            "          \(child.name): \(child.name)\(childIndex == children.indices.last ? "" : ",")",
          ])
        }
      }
      result.append(contentsOf: [
        "        ),",
        "        reasonNotContinued: reasonsNotContinued",
        "          .max(by: { $0.range.startIndex < $1.range.startIndex })",
        "      )",
        "    )",
      ])
      return result.joined(separator: "\n")
    case .alternates(let alternates):
      var result: [String] = [
        "    var errors: [ParseError] = []",
      ]
      for alternate in alternates {
        result.append(contentsOf: [
          "    let \(alternate.name) = Parsed\(alternate.type).diagnosticParseNext(in: remainder)",
          "    switch \(alternate.name) {",
          "    case .failure(let error):",
          "      errors.append(contentsOf: error.errors.map({ .broken\(alternate.uppercasedName)($0) }))",
          "    case .success(let parsed):",
          "      return .success(",
          "        DiagnosticParseResult<Parsed\(name)>(",
          "          result: .\(alternate.name)(parsed.result),",
          "          reasonNotContinued: parsed.reasonNotContinued.map({ .broken\(alternate.uppercasedName)($0) })",
          "        )",
          "      )",
          "    }",
        ])
      }
      result.append(contentsOf: [
        "    return .failure(",
        "      errors",
        "        .max(by: { $0.range.startIndex < $1.range.startIndex })",
        "        .map({ [$0] })!",
        "    )",
      ])
      return result.joined(separator: "\n")
    }
  }

  func fastParseImplementation() -> String {
    switch kind {
    case .fixedLeaf(let scalar):
      return [
        "    guard let first = remainder.first,",
        "      first == \u{22}\u{5C}u{\(scalar.hexadecimalCode)}\u{22} else {",
        "        return nil",
        "    }",
        "    return Parsed\(name)(location: remainder.prefix(1))",
      ].joined(separator: "\n")
    case .keyword:
      return [
        "    var cursor = remainder.startIndex",
        "    while let nextIndex = remainder[cursor...].indices.first,",
        "      ParsedIdentifierComponent.allowed.contains(remainder[nextIndex]) {",
        "        cursor = remainder.index(after: cursor)",
        "    }",
        "    let slice = remainder[remainder.startIndex..<cursor]",
        "    guard allowed.contains(StrictString(slice)) else {",
        "      return nil",
        "    }",
        "    return Parsed\(name)(location: slice)",
      ].joined(separator: "\n")
    case .variableLeaf:
      return [
        "    var cursor = remainder.startIndex",
        "    while let nextIndex = remainder[cursor...].indices.first,",
        "      allowed.contains(remainder[nextIndex]) {",
        "        cursor = remainder.index(after: cursor)",
        "    }",
        "    let range = remainder.startIndex..<cursor",
        "    guard !range.isEmpty else {",
        "      return nil",
        "    }",
        "    return Parsed\(name)(location: remainder[range])",
      ].joined(separator: "\n")
    case .compound(let children):
      var result: [String] = [
        "    var remainder = remainder",
      ]
      for child in children {
        switch child.kind {
        case .fixed, .required, .optional:
          result.append(contentsOf: [
            "    let \(child.name) = Parsed\(child.type).fastParseNext(in: remainder)",
            "    switch \(child.name) {",
            "    case .none:",
          ])
          switch child.kind {
          case .fixed, .required:
            result.append(contentsOf: [
              "      return nil",
            ])
          case .optional:
            result.append(contentsOf: [
              "      break",
            ])
          case .array:
            break
          }
          result.append(contentsOf: [
            "    case .some(let parsed):",
            "      remainder = remainder[parsed.location.endIndex...]",
            "    }",
          ])
        case .array:
          result.append(contentsOf: [
            "    var \(child.name): [Parsed\(child.type)] = []",
            "    while let parsed = Parsed\(child.type).fastParseNext(in: remainder) {",
            "      \(child.name).append(parsed)",
            "      remainder = remainder[parsed.location.endIndex...]",
            "    }",
          ])
        }
      }
      result.append(contentsOf: [
        "    return Parsed\(name)(",
      ])
      for childIndex in children.indices {
        let child = children[childIndex]
        switch child.kind {
        case .fixed, .required:
          result.append(contentsOf: [
            "      \(child.name): \(child.name)!\(childIndex == children.indices.last ? "" : ",")",
          ])
        case .optional, .array:
          result.append(contentsOf: [
            "      \(child.name): \(child.name)\(childIndex == children.indices.last ? "" : ",")",
          ])
        }
      }
      result.append(contentsOf: [
        "    )",
      ])
      return result.joined(separator: "\n")
    case .alternates(let alternates):
      var result: [String] = []
      for alternate in alternates {
        result.append(contentsOf: [
          "    if let \(alternate.name) = Parsed\(alternate.type).fastParseNext(in: remainder) {",
          "      return .\(alternate.name)(\(alternate.name))",
          "    }",
        ])
      }
      result.append(contentsOf: [
        "    return nil",
      ])
      return result.joined(separator: "\n")
    }
  }

  func parseError() -> String {
    return [
      "extension Parsed\(name) {",
      "",
      "  \(isIndirect ? "indirect " : "")enum ParseError: DiagnosticError {",
      parseErrorCases().lazy.map({ "    \($0)" }).joined(separator: "\n"),
      "",
      "    var message: String {",
      "      switch self {",
      parseDiagnosticMessageCases().lazy.map({ "      \($0)" }).joined(separator: "\n"),
      "      }",
      "    }",
      "",
      "    var range: Slice<UnicodeSegments> {",
      "      switch self {",
      parseDiagnosticRangeCases().lazy.map({ "      \($0)" }).joined(separator: "\n"),
      "      }",
      "    }",
      "  }",
      "}",
    ].joined(separator: "\n")
  }

  func parseErrorCases() -> [String] {
    switch kind {
    case .fixedLeaf, .keyword, .variableLeaf:
      return [
        "case notA\(name)(Slice<UnicodeSegments>)"
      ]
    case .compound(let children):
      return children.compactMap { child in
        switch child.kind {
        case .fixed, .required, .optional:
          return "case broken\(child.uppercasedName)(Parsed\(child.type).ParseError)"
        case .array:
          return "case broken\(child.uppercasedName)(Parsed\(child.type).ParseError)"
        }
      }
    case .alternates(let alternates):
      return alternates.map { alternate in
        return "case broken\(alternate.uppercasedName)(Parsed\(alternate.type).ParseError)"
      }
    }
  }
  
  func parseDiagnosticMessageCases() -> [String] {
    switch kind {
    case .fixedLeaf, .keyword, .variableLeaf:
      return [
        "case .notA\(name):",
        "  return defaultMessage",
      ]
    case .compound(let children):
      return children.flatMap { child in
        return [
          "case .broken\(child.uppercasedName)(let error):",
          "  return error.message",
        ] as [String]
      }
    case .alternates(let alternates):
      return alternates.flatMap { alternate in
        return [
          "case .broken\(alternate.uppercasedName)(let error):",
          "  return error.message",
        ]
      }
    }
  }

  func parseDiagnosticRangeCases() -> [String] {
    switch kind {
    case .fixedLeaf, .keyword, .variableLeaf:
      return [
        "case .notA\(name)(let location):",
        "  return location",
      ]
    case .compound(let children):
      return children.flatMap { child in
        return [
          "case .broken\(child.uppercasedName)(let error):",
          "  return error.range",
        ] as [String]
      }
    case .alternates(let alternates):
      return alternates.flatMap { alternate in
        return [
          "case .broken\(alternate.uppercasedName)(let error):",
          "  return error.range",
        ]
      }
    }
  }

  func allowedDefinition() -> String? {
    switch kind {
    case .fixedLeaf, .compound, .alternates:
      return nil
    case .keyword(let allowed):
      var result: [String] = [
        "",
        "  static let allowed: Set<StrictString> = [",
      ]
      for keyword in allowed.sorted() {
        result.append("    \u{22}\(keyword)\u{22},")
      }
      result.append(contentsOf: [
        "  ]",
      ])
      return result.joined(separator: "\n")
    case .variableLeaf(let allowed):
      var result: [String] = [
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

  func syntaxLeafConformance(parsed: Bool) -> String? {
    switch kind {
    case .fixedLeaf, .keyword, .variableLeaf:
      var result: [String] = [
        "extension \(parsed ? "Parsed" : "")\(name): \(parsed ? "Parsed" : "")SyntaxLeaf {",
        "",
        "  var leafKind: \(parsed ? "Parsed" : "")SyntaxLeafKind {",
        "    return .\(lowercasedName)(self)",
        "  }",
      ]
      if let text = derivedTextProperty(parsed: parsed) {
        result.append(text)
      }
      result.append(contentsOf: [
        "}",
      ])
      return result.joined(separator: "\n")
    case .compound, .alternates:
      return nil
    }
  }

  func derivedTextProperty(parsed: Bool) -> String? {
    if parsed {
      return nil
    } else {
      switch kind {
      case .fixedLeaf(let scalar):
        return [
          "  var text: UnicodeText {",
          "    return UnicodeText(\u{22}\u{5C}u{\(scalar.hexadecimalCode)}\u{22})",
          "  }",
        ].joined(separator: "\n")
      case .keyword, .variableLeaf, .compound, .alternates:
        return nil
      }
    }
  }

  func identifierSegmentConformance(parsed: Bool) -> String? {
    if isIdentifierSegment {
      return [
        "extension \(parsed ? "Parsed" : "")\(name): \(parsed ? "Parsed" : "")IdentifierSegment {",
        "",
        "  var identifierSegmentKind: \(parsed ? "Parsed" : "")IdentifierSegmentKind {",
        "    return .\(lowercasedName)(self)",
        "  }",
        "}",
      ].joined(separator: "\n")
    } else {
      return nil
    }
  }

  func parsedConversions() -> String {
    var result: [String] = [
      "",
      "extension \(name) {",
      "  func parsed() -> Parsed\(name) {",
      "    return Parsed\(name).fastParse(source: source())!",
      "  }",
      "}",
      "",
      "extension Parsed\(name) {",
      "  func mutable() -> \(name) {",
    ]
    var arguments: [String] = []
    var isEnumeration = false
    switch kind {
    case .fixedLeaf:
      break
    case .keyword, .variableLeaf:
      arguments.append("text: UnicodeText(StrictString(location))")
    case .compound(let children):
      for child in children {
        switch child.kind {
        case .fixed:
          break
        case .required:
          arguments.append("\(child.name): \(child.name).mutable()")
        case .optional:
          arguments.append("\(child.name): \(child.name)?.mutable()")
        case .array:
          arguments.append("\(child.name): \(child.name).map({ $0.mutable() })")
        }
      }
    case .alternates(let alternates):
      isEnumeration = true
      result.append(contentsOf: [
        "    switch self {",
      ])
      for alternate in alternates {
        result.append(contentsOf: [
          "    case .\(alternate.name)(let \(alternate.name)):",
          "      return .\(alternate.name)(\(alternate.name).mutable())",
        ])
      }
      result.append(contentsOf: [
        "    }",
      ])
    }
    let combinedArguments = arguments.joined(separator: ",\n      ")
    if !isEnumeration {
      result.append("    \(name)(")
      if !combinedArguments.isEmpty {
        result.append("      \(combinedArguments)")
      }
      result.append("    )")
    }
    result.append(contentsOf: [
      "  }",
      "}",
    ])
    return result.joined(separator: "\n")
  }

  static func nodeKind(parsed: Bool) -> String {
    var result: [String] = [
      "enum \(parsed ? "Parsed" : "")SyntaxNodeKind {",
    ]
    result.append(contentsOf: nodes.lazy.map({ $0.nodeKindCase(parsed: parsed) }))
    result.append(contentsOf: [
      "}",
    ])
    return result.joined(separator: "\n")
  }

  func nodeKindCase(parsed: Bool) -> String {
    return "  case \(lowercasedName)(\(parsed ? "Parsed" : "")\(name))"
  }

  static func leafKind(parsed: Bool) -> String {
    var result: [String] = [
      "enum \(parsed ? "Parsed" : "")SyntaxLeafKind {",
    ]
    result.append(contentsOf: nodes.lazy.compactMap({ $0.leafKindCase(parsed: parsed) }))
    result.append(contentsOf: [
      "}",
    ])
    return result.joined(separator: "\n")
  }

  func leafKindCase(parsed: Bool) -> String? {
    switch kind {
    case .fixedLeaf, .keyword, .variableLeaf:
      return "  case \(lowercasedName)(\(parsed ? "Parsed" : "")\(name))"
    case .compound, .alternates:
      return nil
    }
  }

  static func identifierSegmentKind(parsed: Bool) -> String {
    var result: [String] = [
      "enum \(parsed ? "Parsed" : "")IdentifierSegmentKind {",
    ]
    result.append(contentsOf: nodes.lazy.compactMap({ $0.identifierSegmentKindCase(parsed: parsed) }))
    result.append(contentsOf: [
      "}",
    ])
    return result.joined(separator: "\n")
  }

  func identifierSegmentKindCase(parsed: Bool) -> String? {
    if isIdentifierSegment {
      return "  case \(lowercasedName)(\(parsed ? "Parsed" : "")\(name))"
    } else {
      return nil
    }
  }

  func syntaxUtilities(parsed: Bool) -> String {
    var result: [String] = [
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

  func borderChild(parsed: Bool, last: Bool) -> String? {
    switch kind {
    case .fixedLeaf, .keyword, .variableLeaf:
      return nil
    case .compound(let children):
      let childList = last ? children.reversed() : children
      var resolution: [String] = []
      accumulator: for child in childList {
        switch child.kind {
        case .fixed, .required:
          resolution.append("\(child.name) as \(parsed ? "Parsed" : "")SyntaxNode")
          break accumulator
        case .optional:
          resolution.append("\(child.name) ??")
        case .array:
          resolution.append("\(child.name).\(last ? "last" : "first") ??")
        }
      }
      return [
        "",
        "  var \(last ? "last" : "first")Child: \(parsed ? "Parsed" : "")SyntaxNode {",
        "    return \(resolution.joined(separator: " "))",
        "  }",
      ].joined(separator: "\n")
    case .alternates(let alternates):
      var result: [String] = [
        "  var \(last ? "last" : "first")Child: \(parsed ? "Parsed" : "")SyntaxNode {",
        "    switch self {"
      ]
      for alternate in alternates {
        result.append(contentsOf: [
          "    case .\(alternate.name)(let \(alternate.name)):",
          "      return \(alternate.name)",
        ])
      }
      result.append(contentsOf: [
        "    }",
        "  }",
      ])
      return result.joined(separator: "\n")
    }
  }
}
