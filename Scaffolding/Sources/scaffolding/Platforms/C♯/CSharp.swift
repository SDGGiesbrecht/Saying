import SDGLogic
import SDGCollections
import SDGText

enum CSharp: Platform {

  static let identifierStartList: Set<Unicode.Scalar> = {
    var values: [UInt32] = []
    values.append(0x40) // @
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

  static func identifierAllowed(_ scalar: Unicode.Scalar) -> Bool {
    return scalar.properties.isIDContinue
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

  static func nativeName(of thing: Thing) -> StrictString? {
    return thing.cSharp
  }

  static func nativeImplementation(of action: ActionIntermediate) -> SwiftImplementation? {
    return action.cSharp
  }

  static func source(for parameter: ParameterIntermediate, module: ModuleIntermediate) -> String {
    return parameter.cSharpSource(module: module)
  }

  static var emptyReturnType: String? {
    return "void"
  }
  static func returnSection(with returnValue: String) -> String? {
    return "\(returnValue)"
  }

  static func coverageRegistration(identifier: String) -> String {
    return "        Coverage.Register(\u{22}\(identifier)\u{22});"
  }

  static func statement(expression: ActionUse, context: ActionIntermediate?, module: ModuleIntermediate) -> String {
    return call(to: expression, context: context, module: module).appending(";")
  }

  static func actionDeclaration(name: String, parameters: String, returnSection: String?, returnKeyword: String?, coverageRegistration: String?, implementation: String) -> String {
    var result: [String] = [
      "    static \(returnSection!) \(name)(\(parameters))",
      "    {",
    ]
    if let coverage = coverageRegistration {
      result.append(coverage)
    }
    result.append(contentsOf: [
      "        \(returnKeyword ?? "")\(implementation)",
      "    }",
    ])
    return result.joined(separator: "\n")
  }
}
