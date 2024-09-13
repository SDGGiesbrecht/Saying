import SDGLogic
import SDGCollections
import SDGText

enum C {

  static let identifierStartList: Set<Unicode.Scalar> = {
    var values: [UInt32] = []
    values.append(contentsOf: 0x41...0x5A) // A–Z
    values.append(contentsOf: 0x61...0x7A) // a–z
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
    return scalar ∈ identifierStartList
  }

  static let identifierAllowedList: Set<Unicode.Scalar> = {
    var values: [UInt32] = []
    values.append(contentsOf: identifierStartList.lazy.map({ $0.value }))
    values.append(contentsOf: 0x30...0x39) // 0–9
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
    return scalar ∈ identifierAllowedList
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
}

extension C: Platform {
  static func nativeName(of thing: Thing) -> StrictString? {
    return thing.c
  }
  static func nativeImplementation(of action: ActionIntermediate) -> SwiftImplementation? {
    return action.c
  }
  static func source(for parameter: ParameterIntermediate, module: ModuleIntermediate) -> String {
    return parameter.cSource(module: module)
  }
  static var emptyReturnType: String? {
    return "void"
  }
  static func returnSection(with returnValue: String) -> String? {
    return "\(returnValue)"
  }
  static func coverageRegistration(identifier: String) -> String {
    return "  register_coverage_region(\u{22}\(identifier)\u{22});"
  }
  static func expression(doing actionUse: ActionUse, context: ActionIntermediate, module: ModuleIntermediate) -> String {
    return actionUse.cExpression(context: context, module: module)
  }
  static func actionDeclaration(name: String, parameters: String, returnSection: String?, returnKeyword: String?, coverageRegistration: String?, implementation: String) -> String {
    var result: [String] = [
      "\(returnSection!) \(name)(\(parameters))",
      "{",
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
