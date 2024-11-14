import Foundation

import SDGLogic
import SDGCollections
import SDGText

enum JavaScript: Platform {

  static var directoryName: String {
    return "JavaScript"
  }

  static var allowsAllUnicodeIdentifiers: Bool {
    return true
  }
  static let allowedIdentifierStartGeneralCategories: Set<Unicode.GeneralCategory> = []
  static var allowedIdentifierStartCharacterPoints: [UInt32] {
    var values: [UInt32] = []
    values.append(0x24) // $
    values.append(0x5F) // _
    return values
  }
  static let additionalAllowedIdentifierContinuationGeneralCategories: Set<Unicode.GeneralCategory> = []
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

  static var isTyped: Bool {
    return false
  }

  static func nativeType(of thing: Thing) -> NativeThingImplementation? {
    return nil
  }
  static func actionType(parameters: String, returnValue: String) -> String {
    return ""
  }
  static func actionReferencePrefix(isVariable: Bool) -> String? {
    return nil
  }

  static func nativeImplementation(of action: ActionIntermediate) -> NativeActionImplementationIntermediate? {
    return action.javaScript
  }

  static func parameterDeclaration(name: String, type: String) -> String {
    return name
  }
  static func parameterDeclaration(name: String, parameters: String, returnValue: String) -> String {
    return name
  }

  static var emptyReturnType: String? {
    return nil
  }
  static var emptyReturnTypeForActionType: String {
    return ""
  }
  static func returnSection(with returnValue: String) -> String? {
    return nil
  }

  static var needsForwardDeclarations: Bool { false }
  static func forwardActionDeclaration(name: String, parameters: String, returnSection: String?) -> String? {
    return nil
  }

  static func coverageRegistration(identifier: String) -> String {
    return "  coverageRegions.delete(\u{22}\(identifier)\u{22});"
  }

  static func statement(expression: ActionUse, context: ActionIntermediate?, referenceDictionary: ReferenceDictionary) -> String {
    return call(to: expression, context: context, referenceDictionary: referenceDictionary).appending(";")
  }

  static func actionDeclaration(name: String, parameters: String, returnSection: String?, returnKeyword: String?, coverageRegistration: String?, implementation: [String]) -> String {
    var result: [String] = [
      "function \(name)(\(parameters)) {",
    ]
    if let coverage = coverageRegistration {
      result.append(coverage)
    }
    for statement in implementation.dropLast() {
      #warning("Not implemented yet.")
    }
    if let last = implementation.last {
      result.append(contentsOf: [
        "  \(returnKeyword ?? "")\(last)",
        "}",
      ])
    }
    return result.joined(separator: "\n")
  }
  
  static func statementImporting(_ importTarget: String) -> String {
    return importTarget
  }

  static var importsNeededByTestScaffolding: Set<String> {
    return []
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

  static func testSource(identifier: String, statement: String) -> [String] {
    return [
      "function run_\(identifier)() {",
      "  \(statement)",
      "}"
    ]
  }
  static func testCall(for identifier: String) -> String {
    return "run_\(identifier)();"
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

  static func testEntryPoint() -> [String]? {
    return [
      "test();",
    ]
  }

  static var sourceFileName: String {
    "Package.js"
  }

  static func createOtherProjectContainerFiles(projectDirectory: URL) throws {
    try ([
      "<html>",
      "  <head>",
      "    <script src=\u{22}Package.js\u{22}></script>",
      "  </head>",
      "  <body>",
      "    <script>",
      "      test();",
      "    </script>",
      "  </body>",
      "</html>",
    ] as [String]).joined(separator: "\n").appending("\n")
      .save(to: projectDirectory.appendingPathComponent("Test.html"))
  }
}
