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
  static var disallowedStringLiteralPoints: [UInt32] {
    var values: [UInt32] = []
    values.append(0x22) // "
    values.append(0x27) // '
    values.append(0x5C) // \
    return values
  }
  static var _allowedIdentifierStartCharactersCache: Set<Unicode.Scalar>?
  static var _allowedIdentifierContinuationCharactersCache: Set<Unicode.Scalar>?
  static var _disallowedStringLiteralCharactersCache: Set<Unicode.Scalar>?

  static func escapeForStringLiteral(character: Unicode.Scalar) -> String {
    return "\u{5C}u{\(character.hexadecimalCode)}"
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

  static var importsNeededByTestScaffolding: [String]? {
    return nil
  }

  static func coverageRegionSet(regions: [String]) -> [String] {
    var result: [String] = [
      "let coverageRegions = new Set([",
    ]
    for region in regions {
      result.append("  \u{22}\(region)\u{22},")
    }
    result.append(contentsOf: [
      "]);",
    ])
    return result
  }

  static var registerCoverageAction: [String] {
    return [
      "function registerCoverage(identifier) {",
      "  coverageRegions.delete(identifier);",
      "}",
    ]
  }

  static var actionDeclarationsContainerStart: [String]? {
    return nil
  }
  static var actionDeclarationsContainerEnd: [String]? {
    return nil
  }

  static func source(for test: TestIntermediate, module: ModuleIntermediate) -> String {
    return test.javaScriptSource(module: module)
  }
  static func testCall(for test: TestIntermediate) -> String {
    return test.javaScriptCall()
  }

  static func testSummary(testCalls: [String]) -> [String] {
    var result = [
      "",
      "function test() {",
    ]
    for test in testCalls {
      result.append(contentsOf: [
        "  \(test)"
      ])
    }
    result.append(contentsOf: [
      "  console.assert(coverageRegions.size == 0, coverageRegions);",
      "}"
    ])
    return result
  }
}
