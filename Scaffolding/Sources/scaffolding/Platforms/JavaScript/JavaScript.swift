import SDGLogic
import SDGCollections
import SDGText

enum JavaScript: Platform {

  static var allowsAllUnicodeIdentifiers: Bool {
    return true
  }
  static var allowedIdentifierStartCharacterPoints: [UInt32] {
    var values: [UInt32] = []
    values.append(0x24) // $
    values.append(0x5F) // _
    return values
  }
  static var additionalAllowedIdentifierContinuationCharacterPoints: [UInt32] {
    var values: [UInt32] = []
    values.append(contentsOf: 0x200C...0x200D) // ZWNJ–ZWJ
    return values
  }
  static var _allowedIdentifierStartCharactersCache: Set<Unicode.Scalar>?
  static var _allowedIdentifierContinuationCharactersCache: Set<Unicode.Scalar>?

  static let stringLiteralDisallowedList: Set<Unicode.Scalar> = {
    var values: [UInt32] = []
    values.append(0x5C) // \
    values.append(0xD) // CR
    values.append(0xA) // LF
    values.append(0x22) // "
    values.append(0x27) // '
    return Set(
      values.lazy.compactMap({ value in
        guard let scalar = Unicode.Scalar(value),
          scalar.isVulnerableToNormalization else {
          return nil
        }
        return scalar
      })
    )
  }()
  static func stringLiteralDisallowed(_ scalar: Unicode.Scalar) -> Bool {
    return scalar ∈ stringLiteralDisallowedList
      ∧ ¬scalar.isVulnerableToNormalization
  }
  static func sanitize(stringLiteral: StrictString) -> StrictString {
    return stringLiteral.lazy
      .map({ ¬stringLiteralDisallowed($0) ? "\($0)" : "\u{5C}u{\($0.hexadecimalCode)}" })
      .joined()
  }

  static func nativeName(of thing: Thing) -> StrictString? {
    return nil
  }

  static func nativeImplementation(of action: ActionIntermediate) -> SwiftImplementation? {
    return action.javaScript
  }

  static func source(for parameter: ParameterIntermediate, module: ModuleIntermediate) -> String {
    return parameter.javaScriptSource(module: module)
  }

  static var emptyReturnType: String? {
    return nil
  }
  static func returnSection(with returnValue: String) -> String? {
    return nil
  }

  static func coverageRegistration(identifier: String) -> String {
    return "  coverageRegions.delete(\u{22}\(identifier)\u{22});"
  }

  static func statement(expression: ActionUse, context: ActionIntermediate?, module: ModuleIntermediate) -> String {
    return call(to: expression, context: context, module: module).appending(";")
  }

  static func actionDeclaration(name: String, parameters: String, returnSection: String?, returnKeyword: String?, coverageRegistration: String?, implementation: String) -> String {
    var result: [String] = [
      "function \(name)(\(parameters)) {",
    ]
    if let coverage = coverageRegistration {
      result.append(coverage)
    }
    result.append(contentsOf: [
      "  \(returnKeyword ?? "")\(implementation)",
      "}",
    ])
    return result.joined(separator: "\n")
  }
}
