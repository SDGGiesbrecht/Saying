import Foundation

import SDGText

enum Kotlin: Platform {

  static var directoryName: String {
    "Kotlin"
  }

  static var allowsAllUnicodeIdentifiers: Bool {
    return false
  }
  static let allowedIdentifierStartGeneralCategories: Set<Unicode.GeneralCategory> = [
    .uppercaseLetter, // Lu
    .lowercaseLetter, // Ll
    .titlecaseLetter, // Lt
    .modifierLetter, // Lm
    .otherLetter, // Lo
  ]
  static var allowedIdentifierStartCharacterPoints: [UInt32] {
    var values: [UInt32] = []
    values.append(0x5F) // _
    return values
  }
  static let additionalAllowedIdentifierContinuationGeneralCategories: Set<Unicode.GeneralCategory> = [
    .decimalNumber // Nd
  ]
  static var additionalAllowedIdentifierContinuationCharacterPoints: [UInt32] {
    return []
  }
  static var disallowedStringLiteralPoints: [UInt32] {
    var values: [UInt32] = []
    values.append(0x22) // "
    values.append(0x24) // $
    values.append(0x5C) // \
    return values
  }
  static var _allowedIdentifierStartCharactersCache: Set<Unicode.Scalar>?
  static var _allowedIdentifierContinuationCharactersCache: Set<Unicode.Scalar>?
  static var _disallowedStringLiteralCharactersCache: Set<Unicode.Scalar>?

  static func escapeForStringLiteral(character: Unicode.Scalar) -> String {
    return character.utf16.map({ code in
      var digits = String(code, radix: 16, uppercase: true)
      digits.scalars.fill(to: 4, with: "0", from: .start)
      return "\u{5C}u\(digits)"
    }).joined()
  }

  static var isTyped: Bool {
    return true
  }

  static func nativeName(of thing: Thing) -> StrictString? {
    return thing.kotlin
  }

  static func nativeImplementation(of action: ActionIntermediate) -> NativeImplementation? {
    return action.kotlin
  }

  static func parameterDeclaration(name: String, type: String) -> String {
    "\(name): \(type)"
  }

  static var emptyReturnType: String? {
    return nil
  }
  static func returnSection(with returnValue: String) -> String? {
    return ": \(returnValue)"
  }

  static func coverageRegistration(identifier: String) -> String {
    return "    registerCoverage(\u{22}\(identifier)\u{22})"
  }

  static func statement(expression: ActionUse, context: ActionIntermediate?, module: ModuleIntermediate) -> String {
    return call(to: expression, context: context, module: module)
  }

  static func actionDeclaration(name: String, parameters: String, returnSection: String?, returnKeyword: String?, coverageRegistration: String?, implementation: String) -> String {
    var result: [String] = [
      "func \(name)(\(parameters))\(returnSection ?? "") {",
    ]
    if let coverage = coverageRegistration {
      result.append(coverage)
    }
    result.append(contentsOf: [
      "    \(returnKeyword ?? "")\(implementation)",
      "}",
    ])
    return result.joined(separator: "\n")
  }

  static var importsNeededByTestScaffolding: [String]? {
    return nil
  }

  static func coverageRegionSet(regions: [String]) -> [String] {
    #error("Not implemented yet.")
    return []
    /*var result: [String] = [
      "var coverageRegions: Set<String> = [",
    ]
    for region in regions {
      result.append("  \u{22}\(region)\u{22},")
    }
    result.append(contentsOf: [
      "]",
    ])
    return result*/
  }

  static var registerCoverageAction: [String] {
    #warning("Not implemented yet.")
    return []
    /*return [
      "func registerCoverage(_ identifier: String) {",
      "  coverageRegions.remove(identifier)",
      "}",
    ]*/
  }

  static var actionDeclarationsContainerStart: [String]? {
    return nil
  }
  static var actionDeclarationsContainerEnd: [String]? {
    return nil
  }

  static func testSource(identifier: String, statement: String) -> [String] {
    return [
      "func run_\(identifier)() {",
      "    \(statement)",
      "}"
    ]
  }
  static func testCall(for identifier: String) -> String {
    return "run_\(identifier)()"
  }

  static func testSummary(testCalls: [String]) -> [String] {
    #warning("Not implemented yet.")
    return []
    /*var result = [
      "",
      "func test() {",
    ]
    for test in testCalls {
      result.append(contentsOf: [
        "  \(test)",
      ])
    }
    result.append(contentsOf: [
      "  assert(coverageRegions.isEmpty, \u{22}\u{5C}(coverageRegions)\u{22})",
      "}"
    ])
    return result*/
  }

  static func testEntryPoint() -> [String]? {
    #warning("Not implemented yet.")
    return []
    //return nil
  }

  static var sourceFileName: String {
    #warning("Not implemented yet.")
    return ""
    //return "Sources/Products/Source.swift"
  }

  static func createOtherProjectContainerFiles(projectDirectory: URL) throws {
    #warning("Not implemented yet.")
    /*try ([
      "// swift-tools-version: 5.7",
      "",
      "import PackageDescription",
      "",
      "let package = Package(",
      "  name: \u{22}Package\u{22},",
      "  targets: [",
      "    .target(name: \u{22}Products\u{22}),",
      "    .executableTarget(",
      "      name: \u{22}test\u{22},",
      "      dependencies: [\u{22}Products\u{22}]",
      "    ),",
      "    .testTarget(",
      "      name: \u{22}WrappedTests\u{22},",
      "      dependencies: [\u{22}Products\u{22}]",
      "    )",
      "  ]",
      ")",
    ] as [String]).joined(separator: "\n").appending("\n")
      .save(to: projectDirectory.appendingPathComponent("Package.swift"))
    try ([
      "@testable import Products",
      "",
      "@main struct Test {",
      "",
      "  static func main() {",
      "    Products.test()",
      "  }",
      "}",
    ] as [String]).joined(separator: "\n").appending("\n")
      .save(
        to:
          projectDirectory
          .appendingPathComponent("Sources")
          .appendingPathComponent("test")
          .appendingPathComponent("Test.swift")
      )
    try ([
      "import XCTest",
      "@testable import Products",
      "",
      "class WrappedTests: XCTestCase {",
      "",
      "  func testProject() {",
      "    Products.test()",
      "  }",
      "}",
    ] as [String]).joined(separator: "\n").appending("\n")
      .save(
        to:
          projectDirectory
          .appendingPathComponent("Tests")
          .appendingPathComponent("WrappedTests")
          .appendingPathComponent("WrappedTests.swift")
      )*/
  }
}
