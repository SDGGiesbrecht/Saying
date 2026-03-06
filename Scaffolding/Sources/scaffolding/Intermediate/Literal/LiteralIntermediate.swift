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
  static var unicodeScalarName: UnicodeText {
    return "Unicode scalar"
  }

  static var naturalNumberName: UnicodeText {
    return "natural number"
  }
  static var integerName: UnicodeText {
    return "integer"
  }
  static var platformFixedWidthNaturalNumberName: UnicodeText {
    return "platform fixed‐width natural number"
  }
  static var platformFixedWidthIntegerName: UnicodeText {
    return "platform fixed‐width integer"
  }
  static var memoryOffsetName: UnicodeText {
    return "memory offset"
  }

  static var byteName: UnicodeText {
    return "byte"
  }
  static var unicodeScalarNumericalValueName: UnicodeText {
    return "Unicode scalar numerical value"
  }

  func validate(
    as type: Thing,
    reference: ParsedTypeReference,
    errors: inout [ReferenceError]
  ) {
    if type.names.contains(LiteralIntermediate.unicodeTextName)
        || type.names.contains(LiteralIntermediate.unicodeScalarsName) {
      return
    } else if type.names.contains(LiteralIntermediate.unicodeScalarName) {
      if !string.unicodeScalars.dropFirst().isEmpty {
        errors.append(.multipleScalars(source))
      }
    } else if type.names.contains(LiteralIntermediate.naturalNumberName)
      || type.names.contains(LiteralIntermediate.platformFixedWidthNaturalNumberName) {
      if !validateNaturalNumber(literal: string) {
        errors.append(.notANaturalNumber(source))
      }
    } else if type.names.contains(LiteralIntermediate.integerName)
      || type.names.contains(LiteralIntermediate.platformFixedWidthIntegerName)
      || type.names.contains(LiteralIntermediate.memoryOffsetName) {
      if !validateInteger(literal: string) {
        errors.append(.notAnInteger(source))
      }
    } else if type.names.contains(LiteralIntermediate.byteName) {
      if !validateByte(literal: string) {
        errors.append(.notAByte(source))
      }
    } else if type.names.contains(LiteralIntermediate.unicodeScalarNumericalValueName) {
      if !validateUnicodeScalarNumericalValue(literal: string) {
        errors.append(.notAUnicodeScalarNumericalValue(source))
      }
    } else {
      errors.append(.thingCannotBeExpressedAsLiteral(source, thing: reference))
    }
  }

  private static let zeros: Set<Unicode.Scalar> = ["0"]
  private static let digits: Set<Unicode.Scalar> = zeros.union([
    "1", "2", "3", "4", "5", "6", "7", "8", "9",
  ])
  func validateNaturalNumber(literal: String) -> Bool {
    if literal.unicodeScalars.isEmpty {
      return false
    } else if literal.unicodeScalars.elementsEqual("0".unicodeScalars) {
      return true
    } else if literal.unicodeScalars.count <= 4,
      literal.unicodeScalars.allSatisfy({ LiteralIntermediate.digits.contains($0) }),
      !LiteralIntermediate.zeros.contains(literal.unicodeScalars.first!) {
      return true
    } else {
      // Larger numbers and other languages not implemented yet.
      return false
    }
  }
  func validateInteger(literal: String) -> Bool {
    var natural = literal
    // Other languages not implemented yet.
    if natural.unicodeScalars.first == "−" {
      natural.unicodeScalars.removeFirst()
    }
    return validateNaturalNumber(literal: natural)
  }

  private static let binaryDigits: Set<Unicode.Scalar> = ["0", "1"]
  private static let hexadecimalDigits: Set<Unicode.Scalar> = [
    "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"
  ]
  func validateByte(literal: String) -> Bool {
    let count = literal.unicodeScalars.count
    if count == 2 {
      return literal.unicodeScalars.allSatisfy({ LiteralIntermediate.hexadecimalDigits.contains($0) })
    } else if count == 9 {
      return literal.unicodeScalars.indices.enumerated().allSatisfy({ entry in
        let scalar = literal.unicodeScalars[entry.element]
        if entry.offset == 4 {
          return scalar == " "
        } else {
          return LiteralIntermediate.binaryDigits.contains(scalar)
        }
      })
    } else {
      return false
    }
  }
  func validateUnicodeScalarNumericalValue(literal: String) -> Bool {
    guard literal.unicodeScalars.allSatisfy({ scalar in
      return LiteralIntermediate.hexadecimalDigits.contains(scalar)
    }) else {
      return false
    }
    if literal.unicodeScalars.first == "0" {
      let count = literal.unicodeScalars.count
      if count != 1 && count != 4 {
        return false
      }
    }
    return true
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
    return (loadingAction(type: type)?.requiredIdentifiers(context: context) ?? [])
      .appending("Unicode scalars of string literal () ending at () skipping validity check")
  }
}
