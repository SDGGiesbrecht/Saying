import Foundation

enum JavaScript: Platform {

  static var directoryName: String {
    return "JavaScript"
  }
  static var indent: String {
    return "  "
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

  static var identifierLengthLimit: Int? {
    return nil
  }

  static func escapeForStringLiteral(character: Unicode.Scalar) -> String {
    return "\u{5C}u{\(character.hexadecimalCode)}"
  }

  static func literal(scalars: String) -> String {
    return "\u{22}\(scalars)\u{22}"
  }
  static func literal(scalar: Unicode.Scalar) -> String {
    return "0x\(String(scalar.value, radix: 16, uppercase: true))"
  }

  static func accessModifier(for access: AccessIntermediate, memberScope: Bool) -> String? {
    return nil
  }
  
  static func partDeclaration(
    name: String,
    type: String,
    accessModifier: String?,
    noSetter: Bool
  ) -> String {
    return ""
  }

  static func caseReference(name: String, type: String, simple: Bool, ignoringValue: Bool) -> String {
    if simple {
      return "\(type).\(name)"
    } else {
      if ignoringValue {
        return "\(type).\(name)"
      } else {
        return "{ enumerationCase: \(type).\(name) }"
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
    return "\(name): \(index),"
  }
  static var needsSeparateCaseStorage: Bool {
    return false
  }
  static func caseStorageDeclaration(name: String, contents: String, parentType: String) -> String? {
    return nil
  }

  static var isTyped: Bool {
    return false
  }

  static func nativeName(of thing: Thing) -> String? {
    return nil
  }
  static func nativeType(of thing: Thing) -> NativeThingImplementationIntermediate? {
    return nil
  }
  static func repair(compoundNativeType: String) -> String {
    return compoundNativeType
  }
  static func actionType(parameters: String, returnValue: String) -> String {
    return ""
  }
  static func actionReferencePrefix(isVariable: Bool) -> String? {
    return nil
  }

  static var infersConstructors: Bool {
    true
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
    return nil
  }
  static func enumerationTypeDeclaration(
    name: String,
    cases: [String],
    accessModifier: String?,
    simple: Bool,
    storageCases: [String],
    otherMembers: [String]
  ) -> String {
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

  static func nativeNameDeclaration(of action: ActionIntermediate) -> UnicodeText? {
    return nil
  }
  static func nativeName(of parameter: ParameterIntermediate) -> String? {
    return nil
  }
  static func nativeLabel(of parameter: ParameterIntermediate, isCreation: Bool) -> String? {
    if isCreation {
      return sanitize(identifier: parameter.names.identifier(), leading: true)
    } else {
      return nil
    }
  }
  static func nativeImplementation(of action: ActionIntermediate) -> NativeActionImplementationIntermediate? {
    return action.javaScript
  }

  static func parameterDeclaration(label: String?, name: String, type: String, isThrough: Bool) -> String {
    return name
  }
  static func parameterDeclaration(label: String?, name: String, parameters: String, returnValue: String) -> String {
    return name
  }
  static func createInstance(of type: String, parts: String) -> String {
    return "{\(parts)}"
  }
  static func constructorSetter(name: String) -> String {
    return ""
  }
  static var needsReferencePreparation: Bool {
    return true
  }
  static func prepareReference(to argument: String, update: Bool) -> String? {
    let keyword = update ? "" : "let "
    let name = sanitize(identifier: UnicodeText(argument), leading: true)
    return "\(keyword)\(name)Reference = { value: \(argument) }; "
  }
  static func passReference(to argument: String, forwarding: Bool, isAddressee: Bool) -> String {
    if forwarding {
      return argument
    } else {
      return "\(sanitize(identifier: UnicodeText(argument), leading: true))Reference"
    }
  }
  static func unpackReference(to argument: String) -> String? {
    return " \(argument) = \(sanitize(identifier: UnicodeText(argument), leading: true))Reference.value;"
  }
  static func dereference(throughParameter: String, forwarding: Bool) -> String {
    let suffix = forwarding ? "" : ".value"
    return "\(throughParameter)\(suffix)"
  }

  static var emptyReturnType: String? {
    return nil
  }
  static var emptyReturnTypeForActionType: String {
    return ""
  }
  static func returnSection(with returnValue: String, isProperty: Bool) -> String? {
    return nil
  }

  static var needsForwardDeclarations: Bool { false }
  static func forwardActionDeclaration(name: String, parameters: String, returnSection: String?) -> String? {
    return nil
  }

  static func coverageRegistration(identifier: String) -> String {
    return "coverageRegions.delete(\u{22}\(identifier)\u{22});"
  }

  static func statement(expression: String) -> String {
    return expression.appending(";")
  }
  static func deadEnd() -> String {
    "throw new Error();"
  }
  static func returnDelayStorage(type: String?) -> String {
    if type != nil {
      return "const returnValue = "
    } else {
      return ""
    }
  }
  static var delayedReturn: String {
    return " return returnValue;"
  }

  static func actionDeclaration(
    name: String,
    parameters: String,
    returnSection: String?,
    accessModifier: String?,
    coverageRegistration: String?,
    implementation: [String],
    parentType: String?,
    isMutating: Bool,
    isAbsorbedMember: Bool,
    isOverride: Bool,
    propertyInstead: Bool,
    initializerInstead: Bool
  ) -> UniqueDeclaration {
    var result: [String] = [
      "function \(name)(\(parameters)) {",
    ]
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
    return importTarget
  }

  static let preexistingNativeRequirements: Set<String> = []
  static func isAlgorithmicallyPreexistingNativeRequirement(source: String) -> Bool {
    return false
  }

  static var importsNeededByMemoryManagement: Set<String> {
    return []
  }
  static var importsNeededByDeadEnd: Set<String> {
    return []
  }
  static var importsNeededByTestScaffolding: Set<String> {
    return []
  }

  static var memoryManagement: String? {
    return nil
  }

  static func coverageRegionSet(regions: [String]) -> [String] {
    var result: [String] = [
      "let coverageRegions = new Set([",
    ]
    for region in regions {
      result.append("\(indent)\u{22}\(region)\u{22},")
    }
    result.append(contentsOf: [
      "]);",
    ])
    return result
  }

  static var registerCoverageAction: [String] {
    return [
      "function registerCoverage(identifier) {",
      "\(indent)coverageRegions.delete(identifier);",
      "}",
    ]
  }

  static var actionDeclarationsContainerStart: [String]? {
    return nil
  }
  static var actionDeclarationsContainerEnd: [String]? {
    return nil
  }

  static func log(test: String) -> String {
    return "console.log(\u{22}\(sanitize(stringLiteral: test))\u{22});"
  }

  static func testSummary(testCalls: [String]) -> [String] {
    var result = [
      "",
      "function test() {",
    ]
    for test in testCalls {
      result.append(contentsOf: [
        "\(indent)\(test)"
      ])
    }
    result.append(contentsOf: [
      "\(indent)console.assert(coverageRegions.size == 0, coverageRegions);",
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

  static func createOtherProjectContainerFiles(projectDirectory: URL, dependencies: [String]) throws {
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

  static var usesSnakeCase: Bool {
    return true
  }
  static var permitsParameterLabels: Bool {
    return false
  }
  static var permitsOverloads: Bool {
    return false
  }
  static var emptyParameterLabel: UnicodeText {
    return ""
  }
  static var parameterLabelSuffix: UnicodeText {
    return ""
  }
  static var memberPrefix: UnicodeText? {
    return nil
  }
  static var overridePrefix: UnicodeText? {
    return nil
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
