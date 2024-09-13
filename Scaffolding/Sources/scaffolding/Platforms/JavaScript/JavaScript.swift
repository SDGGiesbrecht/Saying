import SDGLogic
import SDGCollections
import SDGText

enum JavaScript {

  static let identifierStartList: Set<Unicode.Scalar> = {
    var values: [UInt32] = []
    values.append(0x24) // $
    values.append(0x5F) // _
    return Set(
      values.lazy.compactMap({ value in
        guard let scalar = Unicode.Scalar(value),
          ¬scalar.isVulnerableToNormalization else {
          return nil
        }
        return scalar
      })
    )
  }()
  static func identifierStartAllowed(_ scalar: Unicode.Scalar) -> Bool {
    return scalar ∈ identifierStartList ∨ scalar.properties.isIDStart
  }

  static let identifierAllowedList: Set<Unicode.Scalar> = {
    var values: [UInt32] = []
    values.append(0x24) // $
    values.append(contentsOf: 0x200C...0x200D)
    return Set(
      values.lazy.compactMap({ value in
        guard let scalar = Unicode.Scalar(value),
          ¬scalar.isVulnerableToNormalization else {
          return nil
        }
        return scalar
      })
    )
  }()
  static func identifierAllowed(_ scalar: Unicode.Scalar) -> Bool {
    return (scalar ∈ identifierAllowedList ∨ scalar.properties.isIDContinue)
      ∧ ¬scalar.isVulnerableToNormalization
  }

  static func sanitize(identifier: StrictString, leading: Bool) -> String {
    var result: StrictString = identifier.lazy
      .map({ identifierAllowed($0) ∧ $0 ≠ "_" ? "\($0)" : "_\($0.hexadecimalCode)" })
      .joined()
    if leading,
      let first = result.first,
      identifierStartAllowed(first) {
      result.removeFirst()
      result.prepend(contentsOf: "_\(first.hexadecimalCode)")
    }
    return String(result)
  }

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
}

extension JavaScript: Platform {
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
  static func expression(doing actionUse: ActionUse, context: ActionIntermediate, module: ModuleIntermediate) -> String {
    return actionUse.javaScriptExpression(context: context, module: module)
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
