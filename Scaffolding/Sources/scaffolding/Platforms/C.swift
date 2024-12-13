import Foundation

import SDGLogic
import SDGCollections
import SDGText

enum C: Platform {

  static var directoryName: String {
    return "C"
  }
  static var indent: String {
    return "        "
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

  static func caseReference(name: String, type: String, simple: Bool, ignoringValue: Bool) -> String {
    if simple {
      return "\(name)"
    } else {
      if ignoringValue {
        return "\(name)"
      } else {
        return "((\(type)) {\(name)})"
      }
    }
  }
  static func caseDeclaration(
    name: String,
    contents: String?,
    index: Int,
    simple: Bool,
    parentType: String
  ) -> String {
    return "\(name),"
  }
  static var needsSeparateCaseStorage: Bool {
    return true
  }
  static func caseStorageDeclaration(name: String, contents: String) -> String? {
    return "\(contents) \(name);"
  }

  static var isTyped: Bool {
    return true
  }

  static func nativeType(of thing: Thing) -> NativeThingImplementationIntermediate? {
    return thing.c
  }
  static func actionType(parameters: String, returnValue: String) -> String {
    return "\(returnValue) (*)(\(parameters))"
  }
  static func actionReferencePrefix(isVariable: Bool) -> String? {
    return nil
  }

  static func enumerationTypeDeclaration(
    name: String,
    cases: [String],
    simple: Bool,
    storageCases: [String]
  ) -> String {
    if simple {
      var result: [String] = [
        "typedef enum \(name) {"
      ]
      for enumerationCase in cases {
        result.append("\(indent)\(enumerationCase)")
      }
      result.append(contentsOf: [
        "} \(name);"
      ])
      return result.joined(separator: "\n")
    } else {
      var result: [String] = []
      result.append(
        enumerationTypeDeclaration(name: "\(name)_case", cases: cases, simple: true, storageCases: [])
      )
      result.append("typedef union \(name)_value {")
      for enumerationCase in storageCases {
        result.append("\(indent)\(enumerationCase)")
      }
      result.append(contentsOf: [
        "} \(name)_value;",
        "typedef struct \(name) {",
        "\(indent)\(name)_case enumeration_case;",
        "\(indent)\(name)_value value;",
        "} \(name);",
      ])
      
      return result.joined(separator: "\n")
    }
  }

  static func nativeImplementation(of action: ActionIntermediate) -> NativeActionImplementationIntermediate? {
    return action.c
  }

  static func parameterDeclaration(name: String, type: String, isThrough: Bool) -> String {
    let pointer = isThrough ? "*" : ""
    return "\(type)\(pointer) \(name)"
  }
  static func parameterDeclaration(name: String, parameters: String, returnValue: String) -> String {
    "\(returnValue) (*\(name))(\(parameters))"
  }
  static var needsReferencePreparation: Bool {
    return false
  }
  static func prepareReference(to argument: String) -> String? {
    return nil
  }
  static func passReference(to argument: String) -> String {
    return "&\(argument)"
  }
  static func unpackReference(to argument: String) -> String? {
    return nil
  }
  static func dereference(throughParameter: String) -> String {
    return "*\(throughParameter)"
  }

  static var emptyReturnType: String? {
    return emptyReturnTypeForActionType
  }
  static var emptyReturnTypeForActionType: String {
    return "void"
  }
  static func returnSection(with returnValue: String) -> String? {
    return "\(returnValue)"
  }

  static func actionDeclarationBase(name: String, parameters: String, returnSection: String?) -> String {
    return "\(returnSection!) \(name)(\(parameters))"
  }
  static var needsForwardDeclarations: Bool { true }
  static func forwardActionDeclaration(name: String, parameters: String, returnSection: String?) -> String? {
    let base = actionDeclarationBase(name: name, parameters: parameters, returnSection: returnSection)
    return "\(base);"
  }

  static func coverageRegistration(identifier: String) -> String {
    return "register_coverage_region(\u{22}\(identifier)\u{22});"
  }

  static func statement(
    expression: ActionUse,
    context: ActionIntermediate?,
    localLookup: [ReferenceDictionary],
    referenceLookup: [ReferenceDictionary],
    contextCoverageIdentifier: StrictString?,
    coverageRegionCounter: inout Int,
    inliningArguments: [StrictString: String]
  ) -> String {
    return call(
      to: expression,
      context: context,
      localLookup: localLookup,
      referenceLookup: referenceLookup,
      contextCoverageIdentifier: contextCoverageIdentifier,
      coverageRegionCounter: &coverageRegionCounter,
      inliningArguments: inliningArguments
    ).appending(";")
  }

  static func actionDeclaration(name: String, parameters: String, returnSection: String?, coverageRegistration: String?, implementation: [String]) -> String {
    var result: [String] = [
      actionDeclarationBase(name: name, parameters: parameters, returnSection: returnSection),
      "{",
    ]
    if let coverage = coverageRegistration {
      result.append(coverage)
    }
    for statement in implementation {
      result.append(contentsOf: [
        "\(indent)\(statement)",
      ])
    }
    result.append(contentsOf: [
      "}",
    ])
    return result.joined(separator: "\n")
  }

  static func statementImporting(_ importTarget: String) -> String {
    return "#include <\(importTarget).h>"
  }

  static var importsNeededByTestScaffolding: Set<String> {
    return [
      "assert",
      "stdbool",
      "stdio",
      "string",
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
      result.append("\(indent)\u{22}\(region)\u{22},")
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
    "\(indent)for(int index = 0; index < NUMBER_OF_REGIONS; index++)",
    "\(indent){",
    "\(indent)\(indent)if (!strcmp(coverage_regions[index], identifier))",
    "\(indent)\(indent){",
    "\(indent)\(indent)\(indent)memset(coverage_regions[index], 0, REGION_IDENTIFIER_LENGTH);",
    "\(indent)\(indent)}",
    "\(indent)}",
    "}",
    ]
  }
  
  static var actionDeclarationsContainerStart: [String]? {
    return nil
  }
  static var actionDeclarationsContainerEnd: [String]? {
    return nil
  }

  static func testSource(identifier: String, statements: [String]) -> [String] {
    var result: [String] = [
      "void run_\(identifier)()",
      "{",
    ]
    for statement in statements {
      result.append("\(indent)\(statement)")
    }
    result.append("}")
    return result
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
        "\(indent)\(test)",
      ])
    }
    result.append(contentsOf: [
      "",
      "\(indent)bool any_remaining = false;",
      "\(indent)for(int index = 0; index < NUMBER_OF_REGIONS; index++) {",
      "\(indent)\(indent)if (coverage_regions[index][0] != 0)",
      "\(indent)\(indent){",
      "\(indent)\(indent)\(indent)any_remaining = true;",
      "\(indent)\(indent)}",
      "\(indent)}",
      "\(indent)assert(!any_remaining);",
      "}",
    ])
    return result
  }

  static func testEntryPoint() -> [String]? {
    return [
      "int main() {",
      "\(indent)test();",
      "\(indent)return 0;",
      "}",
    ]
  }

  static var sourceFileName: String {
    return "test.c"
  }

  static func createOtherProjectContainerFiles(projectDirectory: URL) throws {}
}
