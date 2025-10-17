struct LiteralIntermediate {
  var string: String
  var source: ParsedLiteral
}

extension LiteralIntermediate {

  static let codeCharacters: Set<Unicode.Scalar> = [
    "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F",
  ]

  static func construct(
    literal: ParsedLiteral
  ) -> Result<LiteralIntermediate, ErrorList<LiteralIntermediate.ConstructionError>> {
    let contents: [ParsedLiteralComponent]
    switch literal {
    case .chevrons(let literal):
      contents = literal.contents
    case .sixNine(let literal):
      contents = literal.contents
    case .lowSix(let literal):
      contents = literal.contents
    }
    var string = ""
    var errors: [ConstructionError] = []
    for segment in contents {
      switch segment {
      case .segment(let text):
        string.unicodeScalars.append(contentsOf: text.source())
      case .escape(let symbol):
        let code = symbol.code
        let codeSource = code.source()
        if !codeSource.allSatisfy({ codeCharacters.contains($0) }) {
          errors.append(.escapeCodeNotHexadecimal(code))
        }
        if let value = UInt32(String(String.UnicodeScalarView(codeSource)), radix: 16),
           let scalar = Unicode.Scalar(value) {
          string.unicodeScalars.append(scalar)
        } else {
          errors.append(.escapeCodeNotUnicodeScalar(code))
        }
      }
    }
    if !errors.isEmpty {
      return .failure(ErrorList(errors))
    }
    return .success(LiteralIntermediate(string: string, source: literal))
  }
}

extension LiteralIntermediate {

  static var unicodeTextName: UnicodeText {
    return "Unicode text"
  }
  static var unicodeScalarsName: UnicodeText {
    return "Unicode scalars"
  }

  func validate(
    as type: Thing,
    reference: ParsedTypeReference,
    errors: inout [ReferenceError]
  ) {
    if type.names.contains(LiteralIntermediate.unicodeTextName)
        || type.names.contains(LiteralIntermediate.unicodeScalarsName) {
      return
    } else {
      errors.append(.thingCannotBeExpressedAsLiteral(source, thing: reference))
    }
  }
}

extension LiteralIntermediate {

  private func loadingAction(
    name: UnicodeText,
    result: UnicodeText
  ) -> ActionUse {
    return ActionUse(
      actionName: name,
      arguments: [
        .action(
          ActionUse(
            actionName: "",
            arguments: [],
            literal: self,
            passage: .into,
            resolvedResultType: .compilerGeneratedReference(to: LiteralIntermediate.unicodeScalarsName)
          )
        )
      ],
      passage: .into,
      resolvedResultType: .compilerGeneratedReference(to: result)
    )
  }
  func loadingAction(type: Thing) -> ActionUse? {
    if type.names.contains(LiteralIntermediate.unicodeTextName) {
      if string.unicodeScalars.allSatisfy({ $0.properties.age != nil }) {
        return loadingAction(
          name: "Unicode text skipping normalization of ()",
          result: LiteralIntermediate.unicodeTextName
        )
      } else {
        return loadingAction(
          name: "Unicode text of ()",
          result: LiteralIntermediate.unicodeTextName
        )
      }
    }
    return nil
  }
}

extension LiteralIntermediate {

  func requiredIdentifiers(
    type: Thing,
    context: [ReferenceDictionary]
  ) -> [UnicodeText] {
    return loadingAction(type: type)?.requiredIdentifiers(context: context) ?? []
  }
}
