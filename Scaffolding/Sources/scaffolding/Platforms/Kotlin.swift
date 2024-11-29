import Foundation

import SDGText

enum Kotlin: Platform {

  static var directoryName: String {
    "Kotlin"
  }
  static var indent: String {
    return "    "
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

  static func caseReference(name: String, type: String) -> String {
    return "\(type).\(name)"
  }
  static func caseDeclaration(name: String, index: Int) -> String {
    return "\(name): \(index),"
  }

  static var isTyped: Bool {
    return true
  }

  static func nativeType(of thing: Thing) -> NativeThingImplementation? {
    return thing.kotlin
  }
  static func actionType(parameters: String, returnValue: String) -> String {
    return "(\(parameters)) -> \(returnValue)"
  }
  static func actionReferencePrefix(isVariable: Bool) -> String? {
    if isVariable {
      return nil
    } else {
      return "::"
    }
  }

  static func enumerationTypeDeclaration(name: String, cases: [String]) -> String {
    var result: [String] = [
      "const \(name) = Object.freeze({"
    ]
    for enumerationCase in cases {
      result.append("\(indent)\(enumerationCase)")
    }
    result.append(contentsOf: [
      "});"
    ])
    return result.joined(separator: "\n")
  }

  static func nativeImplementation(of action: ActionIntermediate) -> NativeActionImplementationIntermediate? {
    return action.kotlin
  }

  static func parameterDeclaration(name: String, type: String) -> String {
    "\(name): \(type)"
  }
  static func parameterDeclaration(name: String, parameters: String, returnValue: String) -> String {
    "\(name): \(actionType(parameters: parameters, returnValue: returnValue))"
  }

  static var emptyReturnType: String? {
    return nil
  }
  static var emptyReturnTypeForActionType: String {
    return "Unit"
  }
  static func returnSection(with returnValue: String) -> String? {
    return ": \(returnValue)"
  }

  static var needsForwardDeclarations: Bool { false }
  static func forwardActionDeclaration(name: String, parameters: String, returnSection: String?) -> String? {
    return nil
  }

  static func coverageRegistration(identifier: String) -> String {
    return "registerCoverage(\u{22}\(identifier)\u{22})"
  }

  static func statement(
    expression: ActionUse,
    context: ActionIntermediate?,
    localLookup: [ReferenceDictionary],
    referenceLookup: [ReferenceDictionary],
    contextCoverageIdentifier: StrictString?,
    coverageRegionCounter: inout Int
  ) -> String {
    return call(
      to: expression,
      context: context,
      localLookup: localLookup,
      referenceLookup: referenceLookup,
      contextCoverageIdentifier: contextCoverageIdentifier,
      coverageRegionCounter: &coverageRegionCounter
    )
  }

  static func actionDeclaration(name: String, parameters: String, returnSection: String?, coverageRegistration: String?, implementation: [String]) -> String {
    var result: [String] = [
      "fun \(name)(\(parameters))\(returnSection ?? "") {",
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
    return importTarget
  }

  static var importsNeededByTestScaffolding: Set<String> {
    return []
  }

  static func coverageRegionSet(regions: [String]) -> [String] {
    var result: [String] = [
      "val coverageRegions: MutableSet<String> = mutableSetOf(",
    ]
    for region in regions {
      result.append("\(indent)\u{22}\(region)\u{22},")
    }
    result.append(contentsOf: [
      ")",
    ])
    return result
  }

  static var registerCoverageAction: [String] {
    return [
      "fun registerCoverage(identifier: String) {",
      "\(indent)coverageRegions.remove(identifier)",
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
      "fun run_\(identifier)() {",
      "\(indent)\(statement)",
      "}"
    ]
  }
  static func testCall(for identifier: String) -> String {
    return "run_\(identifier)()"
  }

  static func testSummary(testCalls: [String]) -> [String] {
    var result = [
      "",
      "fun test() {",
    ]
    for test in testCalls {
      result.append(contentsOf: [
        "\(indent)\(test)",
      ])
    }
    result.append(contentsOf: [
      "\(indent)assert(coverageRegions.isEmpty()) { \u{22}$coverageRegions\u{22} }",
      "}"
    ])
    return result
  }

  static func testEntryPoint() -> [String]? {
    return [
      "fun main() {",
      "\(indent)test()",
      "}",
    ]
  }

  static var sourceFileName: String {
    return "app/src/main/kotlin/Test.kt"
  }

  static func createOtherProjectContainerFiles(projectDirectory: URL) throws {
    try ([
      "android.useAndroidX=true",
    ] as [String]).joined(separator: "\n").appending("\n")
      .save(to: projectDirectory.appendingPathComponent("gradle.properties"))
    try ([
      "pluginManagement {",
      "\(indent)repositories {",
      "\(indent)\(indent)gradlePluginPortal()",
      "\(indent)\(indent)google()",
      "\(indent)\(indent)mavenCentral()",
      "\(indent)}",
      "}",
      "",
      "dependencyResolutionManagement {",
      "\(indent)repositories {",
      "\(indent)\(indent)google()",
      "\(indent)\(indent)mavenCentral()",
      "\(indent)}",
      "}",
      "",
      "rootProject.name = \u{22}Test\u{22}",
      "include(\u{22}:app\u{22})",
    ] as [String]).joined(separator: "\n").appending("\n")
      .save(to: projectDirectory.appendingPathComponent("settings.gradle.kts"))
    try ([
      "plugins {",
      "\(indent)id(\u{22}com.android.application\u{22}) version \u{22}8.6.0\u{22} apply false",
      "\(indent)id(\u{22}org.jetbrains.kotlin.android\u{22}) version \u{22}2.0.20\u{22} apply false",
      "}",
    ] as [String]).joined(separator: "\n").appending("\n")
      .save(to: projectDirectory.appendingPathComponent("build.gradle.kts"))
    try ([
      "plugins {",
      "\(indent)id(\u{22}com.android.application\u{22})",
      "\(indent)id(\u{22}org.jetbrains.kotlin.android\u{22})",
      "}",
      "",
      "kotlin {",
      "\(indent)jvmToolchain(11)",
      "}",
      "",
      "android {",
      "\(indent)namespace = \u{22}com.example.test\u{22}",
      "\(indent)compileSdk = 34",
      "\(indent)defaultConfig {",
      "\(indent)\(indent)minSdk = 21",
      "\(indent)\(indent)testInstrumentationRunner = \u{22}androidx.test.runner.AndroidJUnitRunner\u{22}",
      "\(indent)}",
      "}",
      "",
      "dependencies {",
      "\(indent)androidTestImplementation(\u{22}androidx.test:runner:1.6.1\u{22})",
      "}",
    ] as [String]).joined(separator: "\n").appending("\n")
      .save(to: projectDirectory.appendingPathComponent("app/build.gradle.kts"))
    try ([
      "<?xml version=\u{22}1.0\u{22} encoding=\u{22}utf-8\u{22}?>",
      "<manifest xmlns:android=\u{22}http://schemas.android.com/apk/res/android\u{22}",
      "\(indent)xmlns:tools=\u{22}http://schemas.android.com/tools\u{22}>",
      "</manifest>",
    ] as [String]).joined(separator: "\n").appending("\n")
      .save(to: projectDirectory.appendingPathComponent("app/src/main/AndroidManifest.xml"))
    try ([
      "import org.junit.Test",
      "",
      "class WrappedTests {",
      "\(indent)@Test fun testProject() {",
      "\(indent)\(indent)test()",
      "\(indent)}",
      "}",
    ] as [String]).joined(separator: "\n").appending("\n")
      .save(to: projectDirectory.appendingPathComponent("app/src/androidTest/kotlin/WrappedTests.kt"))
  }
}
