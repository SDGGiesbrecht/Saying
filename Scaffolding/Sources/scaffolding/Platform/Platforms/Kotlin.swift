import Foundation

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

  static var identifierLengthLimit: Int? {
    return 128 // 248 caused compiler‐generated files to exceed file name size limits in the Android CI.
  }

  static func escapeForStringLiteral(character: Unicode.Scalar) -> String {
    return character.utf16.map({ code in
      var digits = String(code, radix: 16, uppercase: true)
      digits.scalars.fill(to: 4, with: "0", from: .start)
      return "\u{5C}u\(digits)"
    }).joined()
  }

  static func literal(string: String) -> String {
    return "\u{22}\(string)\u{22}"
  }

  static func accessModifier(for access: AccessIntermediate, memberScope: Bool) -> String? {
    switch access {
    case .nowhere:
      return "private"
    case .file, .unit:
      // Cannot be “private”, due to differences in meaning between classes and members. A “private” member can only be used within the same class, not in the rest of the file as required. Once members are elevated to “internal”, their signatures cannot reference “private” classes as required. Elevating classes to “internal” means everything is just “internal” anyway.
      return "internal"
    case .clients:
      return "internal"
    }
  }

  static func partDeclaration(
    name: String,
    type: String,
    accessModifier: String?,
    noSetter: Bool
  ) -> String {
    let access = accessModifier.map({ "\($0) " }) ?? ""
    let keyword = noSetter ? "val" : "var"
    return "\(access)\(keyword) \(name): \(type)"
  }

  static func caseReference(name: String, type: String, simple: Bool, ignoringValue: Bool) -> String {
    return "\(type).\(name)"
  }
  static func caseDeclaration(
    name: String,
    contents: String?,
    index: Int,
    simple: Bool,
    parentType: String
  ) -> String {
    if simple {
      return "\(name),"
    } else {
      if let contents = contents {
        return "class \(name)(val value: \(contents)) : \(parentType)()"
      } else {
        return "object \(name) : \(parentType)()"
      }
    }
  }
  static var needsSeparateCaseStorage: Bool {
    return false
  }
  static func caseStorageDeclaration(name: String, contents: String, parentType: String) -> String? {
    return nil
  }

  static var isTyped: Bool {
    return true
  }

  static func nativeName(of thing: Thing) -> String? {
    return nil
  }
  static func nativeType(of thing: Thing) -> NativeThingImplementationIntermediate? {
    return thing.kotlin
  }
  static func repair(compoundNativeType: String) -> String {
    return compoundNativeType
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

  static func thingDeclaration(
    name: String,
    components: [String],
    accessModifier: String?,
    constructorParameters: [String],
    constructorAccessModifier: String?,
    constructorSetters: [String],
    otherMembers: [String]
  ) -> String? {
    let access = accessModifier.map({ "\($0) " }) ?? ""
    let constructorAccess = constructorAccessModifier == accessModifier
      ? ""
      : constructorAccessModifier.map({ " \($0) constructor" }) ?? ""
    let properties = components.joined(separator: ", ")
    var result: [String] = [
      "\(access)class \(name)\(constructorAccess)(\(properties)) {",
    ]
    for member in otherMembers {
      result.append("")
      result.append("\(indent)\(member.replacingMatches(for: "\n", with: "\n\(indent)"))")
    }
    result.append(contentsOf: [
      "}",
    ])
    return result.joined(separator: "\n")
  }
  static func enumerationTypeDeclaration(
    name: String,
    cases: [String],
    accessModifier: String?,
    simple: Bool,
    storageCases: [String],
    otherMembers: [String]
  ) -> String {
    let access = accessModifier.map({ "\($0) " }) ?? ""
    let keyword = simple ? "enum" : "sealed"
    var result: [String] = [
      "\(access)\(keyword) class \(name) {"
    ]
    for enumerationCase in cases {
      result.append("\(indent)\(enumerationCase)")
    }
    for member in otherMembers {
      result.append("")
      result.append("\(indent)\(member.replacingMatches(for: "\n", with: "\n\(indent)"))")
    }
    result.append(contentsOf: [
      "}"
    ])
    return result.joined(separator: "\n")
  }

  static func nativeNameDeclaration(of action: ActionIntermediate) -> UnicodeText? {
    return action.nativeNames.kotlin
  }
  static func nativeName(of parameter: ParameterIntermediate) -> String? {
    return parameter.nativeNames.kotlin.map({ String($0) })
  }
  static func nativeLabel(of parameter: ParameterIntermediate, isCreation: Bool) -> String? {
    return nil
  }
  static func nativeImplementation(of action: ActionIntermediate) -> NativeActionImplementationIntermediate? {
    return action.kotlin
  }

  static func parameterDeclaration(label: String?, name: String, type: String, isThrough: Bool) -> String {
    let modifiedType = isThrough ? "MutableList<\(type)>" : type
    return "\(name): \(modifiedType)"
  }
  static func parameterDeclaration(label: String?, name: String, parameters: String, returnValue: String) -> String {
    "\(name): \(actionType(parameters: parameters, returnValue: returnValue))"
  }
  static func createInstance(of type: String, parts: String) -> String {
    return "\(type)(\(parts))"
  }
  static func constructorSetter(name: String) -> String {
    return ""
  }
  static var needsReferencePreparation: Bool {
    return true
  }
  static func prepareReference(to argument: String, update: Bool) -> String? {
    let keyword = update ? "" : "var "
    let name = sanitize(identifier: UnicodeText(argument), leading: true)
    return "\(keyword)\(name)Reference = mutableListOf(\(argument)); "
  }
  static func passReference(to argument: String, forwarding: Bool) -> String {
    if forwarding {
      return argument
    } else {
      return "\(sanitize(identifier: UnicodeText(argument), leading: true))Reference"
    }
  }
  static func unpackReference(to argument: String) -> String? {
    return "; \(argument) = \(sanitize(identifier: UnicodeText(argument), leading: true))Reference[0]"
  }
  static func dereference(throughParameter: String, forwarding: Bool) -> String {
    let suffix = forwarding ? "" : "[0]"
    return "\(throughParameter)\(suffix)"
  }

  static var emptyReturnType: String? {
    return nil
  }
  static var emptyReturnTypeForActionType: String {
    return "Unit"
  }
  static func returnSection(with returnValue: String, isProperty: Bool) -> String? {
    return ": \(returnValue)"
  }

  static var needsForwardDeclarations: Bool { false }
  static func forwardActionDeclaration(name: String, parameters: String, returnSection: String?) -> String? {
    return nil
  }

  static func coverageRegistration(identifier: String) -> String {
    return "registerCoverage(\u{22}\(identifier)\u{22})"
  }

  static func statement(expression: String) -> String {
    return expression
  }
  static func deadEnd() -> String {
    "exitProcess(1)"
  }
  static func returnDelayStorage(type: String?) -> String {
    if type != nil {
      return "val returnValue = "
    } else {
      return ""
    }
  }
  static var delayedReturn: String {
    return "; return returnValue"
  }

  static func actionDeclaration(
    name: String,
    parameters: String,
    returnSection: String?,
    accessModifier: String?,
    coverageRegistration: String?,
    implementation: [String],
    parentType: String?,
    isAbsorbedMember: Bool,
    isOverride: Bool,
    propertyInstead: Bool,
    initializerInstead: Bool
  ) -> UniqueDeclaration {
    let access = isOverride ? "public " : accessModifier.map({ "\($0) " }) ?? ""
    let override = isOverride ? "override " : ""
    var isEqualsOperator = false
    var adjustedParameters = parameters
    if isOverride && name == "equals" {
      isEqualsOperator = true
      adjustedParameters = "other: Any?"
    }
    var result: [String] = [
      "\(access)\(override)fun \(name)(\(adjustedParameters))\(returnSection ?? "") {",
    ]
    if isEqualsOperator {
      result.append(contentsOf: [
        "\(indent)if (this === other) return true",
        "\(indent)if (other !is \(parentType!)) return false",
      ])
    }
    if let coverage = coverageRegistration {
      result.append(coverage)
    }
    for statement in implementation {
      result.append(contentsOf: [
        "\(statement)",
      ])
    }
    result.append(contentsOf: [
      "}",
    ])
    return UniqueDeclaration(
      full: result.joined(separator: "\n"),
      uniquenessDefinition: result.joined(separator: "\n")
    )
  }

  static var fileSettings: String? {
    return nil
  }
  static func statementImporting(_ importTarget: String) -> String {
    return "import \(importTarget).*"
  }

  static let preexistingNativeRequirements: Set<String> = []
  static func isAlgorithmicallyPreexistingNativeRequirement(source: String) -> Bool {
    return false
  }

  static var importsNeededByMemoryManagement: Set<String> {
    return []
  }
  static var importsNeededByDeadEnd: Set<String> {
    return ["kotlin.system"]
  }
  static var importsNeededByTestScaffolding: Set<String> {
    return []
  }

  static var memoryManagement: String? {
    return nil
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

  static func createOtherProjectContainerFiles(projectDirectory: URL, dependencies: [String]) throws {
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
      "<?xml version=\u{22}1.0\u{22} encoding=\u{22}UTF-8\u{22}?>",
      "<lint>",
      "\(indent)<issue id=\u{22}GradleDependency\u{22} severity=\u{22}ignore\u{22} />",
      "</lint>",
    ] as [String]).joined(separator: "\n").appending("\n")
      .save(to: projectDirectory.appendingPathComponent("lint.xml"))
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

  static var usesSnakeCase: Bool {
    return true
  }
  static var permitsParameterLabels: Bool {
    return false
  }
  static var permitsOverloads: Bool {
    return true
  }
  static var emptyParameterLabel: UnicodeText {
    return ""
  }
  static var parameterLabelSuffix: UnicodeText {
    return ""
  }
  static var memberPrefix: UnicodeText? {
    return "()."
  }
  static var overridePrefix: UnicodeText? {
    return "override "
  }
  static var variablePrefix: UnicodeText? {
    return nil
  }
  static var initializerSuffix: UnicodeText? {
    return nil
  }
  static var initializerName: UnicodeText {
    return ""
  }
}
