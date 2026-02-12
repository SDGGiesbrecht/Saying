import Foundation

enum Swift: Platform {

  static var directoryName: String {
    "Swift"
  }
  static var indent: String {
    return "  "
  }
  static var fileSizeLimit: Int? {
    return nil
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
    values.append(0xA8)
    values.append(0xAA)
    values.append(0xAD)
    values.append(0xAF)
    values.append(contentsOf: 0xB2...0xB5)
    values.append(contentsOf: 0xB7...0xBA)
    values.append(contentsOf: 0xBC...0xBE)
    values.append(contentsOf: 0xC0...0xD6)
    values.append(contentsOf: 0xD8...0xF6)
    values.append(contentsOf: 0xF8...0xFF)
    values.append(contentsOf: 0x100...0x2FF)
    values.append(contentsOf: 0x370...0x167F)
    values.append(contentsOf: 0x1681...0x180D)
    values.append(contentsOf: 0x180F...0x1DBF)
    values.append(contentsOf: 0x1E00...0x1FFF)
    values.append(contentsOf: 0x200B...0x200D)
    values.append(contentsOf: 0x202A...0x202E)
    values.append(contentsOf: 0x203F...0x2040)
    values.append(0x2054)
    values.append(contentsOf: 0x2060...0x206F)
    values.append(contentsOf: 0x2070...0x20CF)
    values.append(contentsOf: 0x2100...0x218F)
    values.append(contentsOf: 0x2460...0x24FF)
    values.append(contentsOf: 0x2776...0x2793)
    values.append(contentsOf: 0x2C00...0x2DFF)
    values.append(contentsOf: 0x2E80...0x2FFF)
    values.append(contentsOf: 0x3004...0x3007)
    values.append(contentsOf: 0x3021...0x302F)
    values.append(contentsOf: 0x3031...0x303F)
    values.append(contentsOf: 0x3040...0xD7FF)
    values.append(contentsOf: 0xF900...0xFD3D)
    values.append(contentsOf: 0xFD40...0xFDCF)
    values.append(contentsOf: 0xFDF0...0xFE1F)
    values.append(contentsOf: 0xFE30...0xFE44)
    values.append(contentsOf: 0xFE47...0xFFFD)
    values.append(contentsOf: 0x10000...0x1FFFD)
    values.append(contentsOf: 0x20000...0x2FFFD)
    values.append(contentsOf: 0x30000...0x3FFFD)
    values.append(contentsOf: 0x40000...0x4FFFD)
    values.append(contentsOf: 0x50000...0x5FFFD)
    values.append(contentsOf: 0x60000...0x6FFFD)
    values.append(contentsOf: 0x70000...0x7FFFD)
    values.append(contentsOf: 0x80000...0x8FFFD)
    values.append(contentsOf: 0x90000...0x9FFFD)
    values.append(contentsOf: 0xA0000...0xAFFFD)
    values.append(contentsOf: 0xB0000...0xBFFFD)
    values.append(contentsOf: 0xC0000...0xCFFFD)
    values.append(contentsOf: 0xD0000...0xDFFFD)
    values.append(contentsOf: 0xE0000...0xEFFFD)
    return values
  }
  static let additionalAllowedIdentifierContinuationGeneralCategories: Set<Unicode.GeneralCategory> = []
  static var additionalAllowedIdentifierContinuationCharacterPoints: [UInt32] {
    var values: [UInt32] = []
    values.append(contentsOf: 0x30...0x39) // 0–9
    values.append(contentsOf: 0x300...0x36F)
    values.append(contentsOf: 0x1DC0...0x1DFF)
    values.append(contentsOf: 0x20D0...0x20FF)
    values.append(contentsOf: 0xFE20...0xFE2F)
    return values
  }
  static var disallowedStringLiteralPoints: [UInt32] {
    var values: [UInt32] = []
    values.append(0x0) // null (compiler warning)
    values.append(0x22) // "
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

  static func literal(scalars: String, escaped: String) -> String {
    return "\u{22}\(escaped)\u{22}.unicodeScalars"
  }
  static func literal(scalar: Unicode.Scalar) -> String {
    let contents = sanitize(stringLiteral: "\(scalar)")
    return "\u{22}\(contents)\u{22}"
  }
  static func literal(number: String, typeNames: Set<UnicodeText>) -> String {
    return number.replacingOccurrences(of: "−", with: "-")
  }

  static func accessModifier(for access: AccessIntermediate, memberScope: Bool) -> String? {
    switch access {
    case .nowhere:
      return "private"
    case .file, .unit:
      return "fileprivate"
    case .clients:
      return nil // internal
    }
  }

  static var isTyped: Bool {
    return true
  }

  static func partDeclaration(
    name: String,
    type: String,
    accessModifier: String?,
    noSetter: Bool
  ) -> String {
    let access = accessModifier.map({ "\($0) " }) ?? ""
    let keyword = noSetter ? "let" : "var"
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
    var result = "case \(name)"
    if let contents = contents {
      result.append(contentsOf: "(\(contents))")
    }
    return result
  }
  static var needsSeparateCaseStorage: Bool {
    return false
  }
  static func caseStorageDeclaration(name: String, contents: String, parentType: String) -> String? {
    return nil
  }

  static func nativeNameDeclaration(of thing: Thing) -> UnicodeText? {
    return thing.swiftName
  }
  static func nativeType(of thing: Thing) -> NativeThingImplementationIntermediate? {
    return thing.swift
  }
  static func synthesizedHold(on thing: String) -> NativeActionExpressionIntermediate? {
    return nil
  }
  static func synthesizedRelease(of thing: String) -> NativeActionExpressionIntermediate? {
    return nil
  }
  static func synthesizedCopy(of thing: String) -> NativeActionExpressionIntermediate? {
    return nil
  }
  static func synthesizedDetachment(from thing: String) -> NativeActionExpressionIntermediate? {
    return nil
  }
  static func repair(compoundNativeType: String) -> String {
    if compoundNativeType.contains("].") {
      return compoundNativeType
        .replacingMatches(for: "[", with: "Array<")
        .replacingMatches(for: "].", with: ">.")
    } else {
      return compoundNativeType
    }
  }
  static func actionType(parameters: String, returnValue: String) -> String {
    return "(\(parameters)) -> \(returnValue)"
  }
  static func actionReferencePrefix(isVariable: Bool) -> String? {
    return nil
  }

  static var infersConstructors: Bool {
    return false
  }
  static func detachDeclaration(
    name: String,
    copyOld: String,
    releaseOld: String
  ) -> String {
    return ""
  }
  static func thingDeclaration(
    name: String,
    components: [String],
    accessModifier: String?,
    constructorParameters: [String],
    constructorAccessModifier: String?,
    constructorSetters: [String],
    otherMembers: [String],
    isReferenceCounted: Bool,
    synthesizeReferenceCounting: Bool,
    componentHolds: [String],
    componentReleases: [String],
    copyOld: String?,
    releaseOld: String?
  ) -> String? {
    var typeName = name
    var extraIndent = ""
    var result: [String] = []
    if typeName.contains(".") {
      let namespace = String(typeName.prefix(upTo: ".")!.contents)
      typeName = typeName.dropping(through: ".")
      extraIndent = indent
      result.append("extension \(namespace) {")
    }
    let access = accessModifier.map({ "\($0) " }) ?? ""
    result.append(contentsOf: [
      "\(extraIndent)\(access)struct \(typeName) {"
    ])
    for component in components {
      result.append("\(extraIndent)\(indent)\(component)")
    }
    result.append("")
    let constructorAccess = constructorAccessModifier.map({ "\($0) " }) ?? ""
    let constructorParameterList = constructorParameters.joined(separator: ", ")
    result.append("\(extraIndent)\(indent)\(constructorAccess)init(\(constructorParameterList)) {")
    for setter in constructorSetters {
      result.append("\(extraIndent)\(indent)\(indent)\(setter)")
    }
    result.append("\(extraIndent)\(indent)}")
    for member in otherMembers {
      result.append("")
      result.append("\(extraIndent)\(indent)\(member.replacingMatches(for: "\n", with: "\n\(extraIndent)\(indent)"))")
    }
    result.append(contentsOf: [
      "\(extraIndent)}"
    ])
    if extraIndent != "" {
      result.append("}")
    }
    return result.joined(separator: "\n")
  }
  static func enumerationTypeDeclaration(
    name: String,
    cases: [String],
    accessModifier: String?,
    simple: Bool,
    storageCases: [String],
    otherMembers: [String],
    isReferenceCounted: Bool,
    synthesizeReferenceCounting: Bool,
    componentHolds: [(String, String)],
    componentReleases: [(String, String)],
    copyOld: String?,
    releaseOld: String?
  ) -> String {
    let access = accessModifier.map({ "\($0) " }) ?? ""
    var result: [String] = [
      "\(access)enum \(name) {"
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
    return action.nativeNames.swift
  }
  static func nativeName(of parameter: ParameterIntermediate) -> String? {
    return parameter.nativeNames.swift.map({ String($0) })
  }
  static func nativeLabel(of parameter: ParameterIntermediate, isCreation: Bool) -> String? {
    return parameter.swiftLabel.map({ String($0) })
  }
  static func nativeImplementation(of action: ActionIntermediate) -> NativeActionImplementationIntermediate? {
    return action.swift
  }

  static func parameterDeclaration(label: String?, name: String, type: String, isThrough: Bool) -> String {
    let resolvedLabel = label ?? "_"
    let inoutKeyword = isThrough ? "inout " : ""
    let labelSection = resolvedLabel == name ? "" : "\(resolvedLabel) "
    return "\(labelSection)\(name): \(inoutKeyword)\(type)"
  }
  static func parameterDeclaration(label: String?, name: String, parameters: String, returnValue: String) -> String {
    "_ \(name): \(actionType(parameters: parameters, returnValue: returnValue))"
  }
  static func createInstance(of type: String, parts: String) -> String {
    return "\(type)(\(parts))"
  }
  static func constructorSetter(name: String) -> String {
    return "self.\(name) = \(name)"
  }
  static func localStorage(named name: String, ofType type: String, containing contents: String) -> String {
    return ""
  }
  static var needsReferencePreparation: Bool {
    return false
  }
  static func prepareReference(to argument: String, update: Bool) -> String? {
    return nil
  }
  static func passReference(to argument: String, forwarding: Bool, isAddressee: Bool) -> String {
    let reference = isAddressee ? "" : "&"
    return "\(reference)\(argument)"
  }
  static func unpackReference(to argument: String) -> String? {
    return nil
  }
  static func dereference(throughParameter: String, forwarding: Bool) -> String {
    return throughParameter
  }

  static var emptyReturnType: String? {
    return nil
  }
  static var emptyReturnTypeForActionType: String {
    return "Void"
  }
  static func returnSection(with returnValue: String, isProperty: Bool) -> String? {
    if isProperty {
      return ": \(returnValue)"
    } else {
      return " -> \(returnValue)"
    }
  }

  static var needsForwardDeclarations: Bool { false }
  static func forwardActionDeclaration(name: String, parameters: String, returnSection: String?) -> String? {
    return nil
  }

  static func coverageRegistration(identifier: String) -> String {
    return "registerCoverage(\u{22}\(identifier)\u{22})"
  }

  static func statement(expression: String) -> String {
    expression
  }
  static func deadEnd() -> String {
    return "fatalError()"
  }
  static func returnDelayStorage(type: String?) -> String {
    if type != nil {
      return "let returnValue = "
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
    isStatic: Bool,
    isMutating: Bool,
    isAbsorbedMember: Bool,
    isOverride: Bool,
    propertyInstead: Bool,
    initializerInstead: Bool
  ) -> UniqueDeclaration {
    var access = accessModifier.map({ "\($0) " }) ?? ""

    // Hard‐coded for now; can this be generalized to detect all cases where it is needed?
    if name == "==",
       parameters == "_ lhs: String.UnicodeScalarView, _ rhs: String.UnicodeScalarView",
       returnSection == " -> Bool" {
      access = "public "
    }
    if name == "hash",
       parameters == "into hasher: inout Hasher",
       returnSection == nil {
      access = "public "
    }

    let staticKeyword = isStatic ? "static " : ""
    let mutating = isMutating ? "mutating " : ""
    let keyword = propertyInstead ? "var "
      : initializerInstead ? ""
      : name == "subscript" ? ""
      : "func "
    let signature = propertyInstead
      ? returnSection!
      : "(\(parameters))\(returnSection ?? "")"
    var result: [String] = []
    var isNested = false
    var extraIndent = ""
    if let parent = parentType,
      !isAbsorbedMember {
      isNested = true
      extraIndent = indent
      result.append(contentsOf: [
        "extension \(parent) {",
      ])
    }
    result.append(contentsOf: [
      "\(extraIndent)\(access)\(staticKeyword)\(mutating)\(keyword)\(name)\(signature) {",
    ])
    let uniquenessDefinition = result
    let returnPrefix = "\(indent)return "
    let rawInitializer = initializerInstead && implementation.lazy.filter({ $0.hasPrefix(returnPrefix) }).count == 1
    let closureInitializer = initializerInstead && !rawInitializer
    var secondExtraIndent = ""
    if closureInitializer {
      secondExtraIndent = indent
      result.append("\(extraIndent)\(secondExtraIndent)self = {")
    }
    if let coverage = coverageRegistration {
      result.append("\(extraIndent)\(secondExtraIndent)\(coverage)")
    }
    for statement in implementation {
      var modified = statement
      if rawInitializer,
         modified.hasPrefix(returnPrefix) {
        modified.removeFirst(returnPrefix.count)
        modified.prepend(contentsOf: "\(indent)self = ")
      }
      result.append(contentsOf: [
        "\(extraIndent)\(secondExtraIndent)\(modified)",
      ])
    }
    if closureInitializer {
      result.append("\(extraIndent)\(secondExtraIndent)}()")
    }
    result.append(contentsOf: [
      "\(extraIndent)}",
    ])
    if isNested {
      result.append(contentsOf: [
        "}",
      ])
    }
    return UniqueDeclaration(
      full: result.joined(separator: "\n"),
      uniquenessDefinition: uniquenessDefinition.joined(separator: "\n")
    )
  }

  static var fileSettings: String? {
    return nil
  }
  static func statementImporting(_ importTarget: String) -> String {
    return "import \(importTarget)"
  }

  static var importsNeededByDeadEnd: Set<String> {
    return []
  }
  static var importsNeededByTestScaffolding: Set<String> {
    return []
  }

  static let preexistingNativeRequirements: Set<String> = [
    "extension Bool: Equatable {}",
    "extension Bool: Hashable {}",
    "extension Int: Comparable {}",
    "extension Int: Equatable {}",
    "extension Int: Hashable {}",
    "extension Int64: Comparable {}",
    "extension Int64: Equatable {}",
    "extension Int64: Hashable {}",
    "extension String.UnicodeScalarView: Collection {}",
    "extension String.UnicodeScalarView.Index: Comparable {}",
    "extension String.UnicodeScalarView.Index: Equatable {}",
    "extension String.UnicodeScalarView.Index: Hashable {}",
    "extension UInt: Comparable {}",
    "extension UInt: Equatable {}",
    "extension UInt: Hashable {}",
    "extension UInt64: Comparable {}",
    "extension UInt64: Equatable {}",
    "extension UInt64: Hashable {}",
    "extension Unicode.Scalar: Equatable {}",
    "extension Unicode.Scalar: Hashable {}",
    "extension UTF8.CodeUnit: Equatable {}",
    "extension UTF8.CodeUnit: Hashable {}",
  ]
  static func isAlgorithmicallyPreexistingNativeRequirement(source: String) -> Bool {
    if source.hasSuffix("?: Equatable {}")
      || source.hasSuffix("?: Hashable {}")
      || source.hasSuffix("]: Equatable {}")
      || source.hasSuffix("]: Hashable {}")
      || source.hasSuffix("]: Collection {}") {
      return true
    }
    return false
  }

  static var currentTestVariable: String {
    return "var currentTest: String = \u{22}\u{22}"
  }

  static func coverageRegionSet(regions: [String]) -> [String] {
    var result: [String] = [
      "var coverageRegions: Set<String> = [",
    ]
    for region in regions {
      result.append("\(indent)\u{22}\(region)\u{22},")
    }
    result.append(contentsOf: [
      "]",
    ])
    return result
  }

  static var registerCoverageAction: [String] {
    return [
      "func registerCoverage(_ identifier: String) {",
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

  static func register(test: String) -> String {
    return "currentTest = \u{22}\(sanitize(stringLiteral: test))\u{22}"
  }

  static func testSummary(testCalls: [String]) -> [String] {
    var result = [
      "",
      "func test() {",
    ]
    for test in testCalls {
      result.append(contentsOf: [
        "\(indent)\(test)",
      ])
    }
    result.append(contentsOf: [
      "\(indent)assert(coverageRegions.isEmpty, \u{22}\u{5C}(coverageRegions)\u{22})",
      "}"
    ])
    return result
  }

  static func testEntryPoint() -> [String]? {
    return nil
  }

  static var sourceFileName: String {
    return "Sources/Products/Source.swift"
  }

  static func createOtherProjectContainerFiles(projectDirectory: URL, dependencies: [String]) throws {
    try ([
      "// swift-tools-version: 5.7",
      "",
      "import PackageDescription",
      "",
      "let package = Package(",
      "\(indent)name: \u{22}Package\u{22},",
      "\(indent)targets: [",
      "\(indent)\(indent).target(name: \u{22}Products\u{22}),",
      "\(indent)\(indent).executableTarget(",
      "\(indent)\(indent)\(indent)name: \u{22}test\u{22},",
      "\(indent)\(indent)\(indent)dependencies: [\u{22}Products\u{22}]",
      "\(indent)\(indent)),",
      "\(indent)\(indent).testTarget(",
      "\(indent)\(indent)\(indent)name: \u{22}WrappedTests\u{22},",
      "\(indent)\(indent)\(indent)dependencies: [\u{22}Products\u{22}]",
      "\(indent)\(indent))",
      "\(indent)]",
      ")",
    ] as [String]).joined(separator: "\n").appending("\n")
      .save(to: projectDirectory.appendingPathComponent("Package.swift"))
    try ([
      "@testable import Products",
      "",
      "@main struct Test {",
      "",
      "\(indent)static func main() {",
      "\(indent)\(indent)Products.test()",
      "\(indent)}",
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
      "\(indent)func testProject() {",
      "\(indent)\(indent)Products.test()",
      "\(indent)}",
      "}",
    ] as [String]).joined(separator: "\n").appending("\n")
      .save(
        to:
          projectDirectory
          .appendingPathComponent("Tests")
          .appendingPathComponent("WrappedTests")
          .appendingPathComponent("WrappedTests.swift")
      )
  }

  static var usesSnakeCase: Bool {
    return true
  }
  static var permitsParameterLabels: Bool {
    return true
  }
  static var permitsOverloads: Bool {
    return true
  }
  static var emptyParameterLabel: UnicodeText {
    return "_"
  }
  static var parameterLabelSuffix: UnicodeText {
    return ":"
  }
  static var memberPrefix: UnicodeText? {
    return "()."
  }
  static var staticMemberPrefix: UnicodeText? {
    return "Self."
  }
  static var overridePrefix: UnicodeText? {
    return nil
  }
  static var variablePrefix: UnicodeText? {
    return "var "
  }
  static var initializerSuffix: UnicodeText? {
    return ".init"
  }
  static var initializerName: UnicodeText {
    return "init"
  }
}
