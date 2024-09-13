import SDGLogic
import SDGCollections
import SDGText

enum CSharp: Platform {
  
  static var allowsAllUnicodeIdentifiers: Bool {
    return true
  }
  static var allowedIdentifierStartCharacterPoints: [UInt32] {
    var values: [UInt32] = []
    values.append(0x5F) // _
    return values
  }
  static var additionalAllowedIdentifierContinuationCharacterPoints: [UInt32] {
    return []
  }
  static var _allowedIdentifierStartCharactersCache: Set<Unicode.Scalar>?
  static var _allowedIdentifierContinuationCharactersCache: Set<Unicode.Scalar>?

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
