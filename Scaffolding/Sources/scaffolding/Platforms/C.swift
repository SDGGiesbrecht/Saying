import Foundation

import SDGLogic
import SDGCollections
import SDGText

enum C: Platform {

  static var directoryName: String {
    return "C"
  }

  static var allowsAllUnicodeIdentifiers: Bool {
    return false
  }
  static let allowedIdentifierStartGeneralCategories: Set<Unicode.GeneralCategory> = []
  static var allowedIdentifierStartCharacterPoints: [UInt32] {
    var values: [UInt32] = []
    values.append(contentsOf: 0x41...0x5A) // A–Z
    values.append(contentsOf: 0x61...0x7A) // a–z
    values.append(0x5F) // _
    return values
  }
  static let additionalAllowedIdentifierContinuationGeneralCategories: Set<Unicode.GeneralCategory> = []
  static var additionalAllowedIdentifierContinuationCharacterPoints: [UInt32] {
    var values: [UInt32] = []
    values.append(contentsOf: 0x30...0x39) // 0–9
    return values
  }
  static var disallowedStringLiteralPoints: [UInt32] {
    var values: [UInt32] = []
    values.append(0x22) // "
    values.append(0xC5) // \
    return values
  }
  static var _allowedIdentifierStartCharactersCache: Set<Unicode.Scalar>?
  static var _allowedIdentifierContinuationCharactersCache: Set<Unicode.Scalar>?
  static var _disallowedStringLiteralCharactersCache: Set<Unicode.Scalar>?

  static func escapeForStringLiteral(character: Unicode.Scalar) -> String {
    var digits = String(character.value, radix: 16, uppercase: true)
    digits.scalars.fill(to: 8, with: "0", from: .start)
    return "\u{5C}U\(digits)"
  }

  static var isTyped: Bool {
    return true
  }

  static func nativeName(of thing: Thing) -> StrictString? {
    return thing.c
  }

  static func nativeImplementation(of action: ActionIntermediate) -> NativeImplementation? {
    return action.c
  }

  static func parameterDeclaration(name: String, type: String) -> String {
    return "\(type) \(name)"
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

  static func statement(expression: ActionUse, context: ActionIntermediate?, module: ModuleIntermediate) -> String {
    return call(to: expression, context: context, module: module).appending(";")
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

  static var importsNeededByTestScaffolding: [String]? {
    return [
      "#include <assert.h>",
      "#include <stdbool.h>",
      "#include <stdio.h>",
      "#include <string.h>",
    ]
  }

  static func coverageRegionSet(regions: [String]) -> [String] {
    var result: [String] = []
    result.append(contentsOf: [
      "#define REGION_IDENTIFIER_LENGTH \((regions.lazy.map({ String($0).utf8.count }).max() ?? 0) + 1)",
      "#define NUMBER_OF_REGIONS \(regions.count)",
      "char coverage_regions[NUMBER_OF_REGIONS][REGION_IDENTIFIER_LENGTH] = {",
    ])
    for region in regions {
      result.append("        \u{22}\(region)\u{22},")
    }
    result.append(contentsOf: [
      "};",
    ])
    return result
  }

  static var registerCoverageAction: [String] {
    return [
    "void register_coverage_region(char identifier[REGION_IDENTIFIER_LENGTH])",
    "{",
    "        for(int index = 0; index < NUMBER_OF_REGIONS; index++)",
    "        {",
    "                if (!strcmp(coverage_regions[index], identifier))",
    "                {",
    "                        memset(coverage_regions[index], 0, REGION_IDENTIFIER_LENGTH);",
    "                }",
    "        }",
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
      "void run_\(identifier)()",
      "{",
      "        \(statement)",
      "}"
    ]
  }
  static func testCall(for identifier: String) -> String {
    return "run_\(identifier)();"
  }

  static func testSummary(testCalls: [String]) -> [String] {
    var result = [
      "void test() {",
    ]
    for test in testCalls {
      result.append(contentsOf: [
        "        \(test)",
      ])
    }
    result.append(contentsOf: [
      "",
      "        bool any_remaining = false;",
      "        for(int index = 0; index < NUMBER_OF_REGIONS; index++) {",
      "                if (coverage_regions[index][0] != 0)",
      "                {",
      "                        any_remaining = true;",
      "                }",
      "        }",
      "        assert(!any_remaining);",
      "}",
    ])
    return result
  }

  static func testEntryPoint() -> [String]? {
    return [
      "int main() {",
      "        test();",
      "        return 0;",
      "}",
    ]
  }

  static var sourceFileName: String {
    return "test.c"
  }

  static func createOtherProjectContainerFiles(projectDirectory: URL) throws {}
}
