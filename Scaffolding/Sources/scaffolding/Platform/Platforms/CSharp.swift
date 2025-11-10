import Foundation

enum CSharp: Platform {

  static var directoryName: String {
    return "C♯"
  }
  static var indent: String {
    return "    "
  }
  
  static var allowsAllUnicodeIdentifiers: Bool {
    return true
  }
  static let allowedIdentifierStartGeneralCategories: Set<Unicode.GeneralCategory> = []
  static var allowedIdentifierStartCharacterPoints: [UInt32] {
    var values: [UInt32] = []
    values.append(0x5F) // _
    return values
  }
  static let additionalAllowedIdentifierContinuationGeneralCategories: Set<Unicode.GeneralCategory> = []
  static var additionalAllowedIdentifierContinuationCharacterPoints: [UInt32] {
    return []
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

  static var identifierLengthLimit: Int? {
    return nil
  }

  static func escapeForStringLiteral(character: Unicode.Scalar) -> String {
    var digits = String(character.value, radix: 16, uppercase: true)
    digits.scalars.fill(to: 8, with: "0", from: .start)
    return "\u{5C}U\(digits)"
  }

  static func literal(scalars: String) -> String {
    return "\u{22}\(scalars)\u{22}"
  }
  static func literal(scalar: Unicode.Scalar) -> String {
    return "new Rune(0x\(String(scalar.value, radix: 16, uppercase: true)))"
  }

  static func accessModifier(for access: AccessIntermediate, memberScope: Bool) -> String? {
    switch access {
    case .nowhere:
      return "private"
    case .file, .unit, .clients:
      // “file” is too new
      if memberScope {
        return "internal"
      } else {
        return nil // internal
      }
    }
  }

  static func partDeclaration(
    name: String,
    type: String,
    accessModifier: String?,
    noSetter: Bool
  ) -> String {
    let access = accessModifier.map({ "\($0) " }) ?? ""
    let readonly = noSetter ? "readonly " : ""
    return "\(access)\(readonly)\(type) \(name);"
  }

  static func caseReference(name: String, type: String, simple: Bool, ignoringValue: Bool) -> String {
    if simple {
      return "\(type).\(name)"
    } else {
      if ignoringValue {
        return "\(type).\(name)"
      } else {
        return "new \(type).\(name)()"
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
    if simple {
      return "\(name),"
    } else {
      var result: [String] = [
        "\(indent)internal sealed class \(name) : \(parentType)",
        "\(indent){",
      ]
      let parameter: String
      let implementation: String
      if let contents = contents {
        result.append(contentsOf: [
          "\(indent)\(indent)internal readonly \(contents) Value;",
        ])
        parameter = "\(contents) value"
        implementation = " this.Value = value; "
      } else {
        parameter = ""
        implementation = ""
      }
      result.append(contentsOf: [
        "\(indent)\(indent)internal \(name)(\(parameter)) : base() {\(implementation)}",
        "\(indent)}"
      ])
      return result.joined(separator: "\n")
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
    return thing.cSharp
  }
  static func repair(compoundNativeType: String) -> String {
    return compoundNativeType
  }
  static func actionType(parameters: String, returnValue: String) -> String {
    if returnValue == emptyReturnTypeForActionType {
      return "Action<\(parameters)>"
    } else {
      if parameters.isEmpty {
        return "Func<\(returnValue)>"
      } else {
        return "Func<\(parameters), \(returnValue)>"
      }
    }
  }
  static func actionReferencePrefix(isVariable: Bool) -> String? {
    return nil
  }

  static var infersConstructors: Bool {
    return false
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
    var result: [String] = [
      "\(access)struct \(name)",
      "{",
    ]
    for component in components {
      result.append("\(indent)\(component)")
    }
    if !components.isEmpty {
      result.append("")
      let constructorAccess = constructorAccessModifier.map({ "\($0) " }) ?? ""
      let constructorParameterList = constructorParameters.joined(separator: ", ")
      result.append(contentsOf: [
       "\(indent)\(constructorAccess)\(name)(\(constructorParameterList))",
       "\(indent){",
      ])
      for setter in constructorSetters {
        result.append("\(indent)\(indent)\(setter)")
      }
      result.append("\(indent)}")
    }
    for member in otherMembers {
      result.append("")
      result.append(member)
    }
    result.append(contentsOf: [
      "}"
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
    if simple {
      var result: [String] = [
        "\(access)enum \(name)",
        "{",
      ]
      for enumerationCase in cases {
        result.append("\(indent)\(enumerationCase)")
      }
      result.append(contentsOf: [
        "}"
      ])
      return result.joined(separator: "\n")
    } else {
      var result: [String] = [
        "\(access)abstract class \(name)",
        "{",
        "\(indent)private \(name)() {}",
        "",
      ]
      for enumerationCase in cases {
        result.append(enumerationCase)
      }
      for member in otherMembers {
        result.append("")
        result.append(member)
      }
      result.append(contentsOf: [
        "}"
      ])
      return result.joined(separator: "\n")
    }
  }

  static func nativeNameDeclaration(of action: ActionIntermediate) -> UnicodeText? {
    return action.nativeNames.cSharp
  }
  static func nativeName(of parameter: ParameterIntermediate) -> String? {
    return parameter.nativeNames.cSharp.map({ String($0) })
  }
  static func nativeLabel(of parameter: ParameterIntermediate, isCreation: Bool) -> String? {
    return nil
  }
  static func nativeImplementation(of action: ActionIntermediate) -> NativeActionImplementationIntermediate? {
    return action.cSharp
  }

  static func parameterDeclaration(label: String?, name: String, type: String, isThrough: Bool) -> String {
    let reference = isThrough ? "ref " : ""
    return "\(reference)\(type) \(name)"
  }
  static func parameterDeclaration(label: String?, name: String, parameters: String, returnValue: String) -> String {
    return "\(actionType(parameters: parameters, returnValue: returnValue)) \(name)"
  }
  static func constructorSetter(name: String) -> String {
    return "this.\(name) = \(name);"
  }
  static func createInstance(of type: String, parts: String) -> String {
    return "new \(type)(\(parts))"
  }
  static var needsReferencePreparation: Bool {
    return false
  }
  static func prepareReference(to argument: String, update: Bool) -> String? {
    return nil
  }
  static func passReference(to argument: String, forwarding: Bool, isAddressee: Bool) -> String {
    return "ref \(argument)"
  }
  static func unpackReference(to argument: String) -> String? {
    return nil
  }
  static func dereference(throughParameter: String, forwarding: Bool) -> String {
    return throughParameter
  }

  static var emptyReturnType: String? {
    return emptyReturnTypeForActionType
  }
  static var emptyReturnTypeForActionType: String {
    return "void"
  }
  static func returnSection(with returnValue: String, isProperty: Bool) -> String? {
    return "\(returnValue)"
  }

  static var needsForwardDeclarations: Bool { false }
  static func forwardActionDeclaration(name: String, parameters: String, returnSection: String?) -> String? {
    return nil
  }

  static func coverageRegistration(identifier: String) -> String {
    return "Coverage.Register(\u{22}\(identifier)\u{22});"
  }

  static func statement(expression: String) -> String {
    return expression.appending(";")
  }
  static func deadEnd() -> String {
    "Environment.FailFast(null); throw new Exception();"
  }
  static func returnDelayStorage(type: String?) -> String {
    if let type = type {
      return "\(type) returnValue = "
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
    let access = isOverride ? "public " : accessModifier.map({ "\($0) " }) ?? "internal "
    let override = isOverride ? "override " : ""
    var isVirtualEquals = false
    var adjustedParameters = parameters
    if isOverride && name == "Equals" {
      isVirtualEquals = true
      adjustedParameters = "object other"
    }
    let staticKeyword = isAbsorbedMember ? "" : "static "
    let parametersSection = propertyInstead ? "" : "(\(adjustedParameters))"
    var result: [String] = [
      "\(indent)\(access)\(override)\(staticKeyword)\(returnSection!) \(name)\(parametersSection)",
      "\(indent){",
    ]
    var extraIndent = ""
    if propertyInstead {
      result.append(contentsOf: [
        "\(indent)\(indent)get",
        "\(indent)\(indent){",
      ])
      extraIndent = indent
    }
    if isVirtualEquals {
      result.append(contentsOf: [
        "\(indent)\(indent)\(extraIndent)if (!(other is \(parentType!)))",
        "\(indent)\(indent)\(extraIndent){",
        "\(indent)\(indent)\(indent)\(extraIndent)return false;",
        "\(indent)\(indent)\(extraIndent)}",
        "\(indent)\(indent)\(extraIndent)\(parentType!) obj = (\(parentType!))other;",
      ])
    }
    if let coverage = coverageRegistration {
      result.append(coverage)
    }
    for statement in implementation {
      result.append(contentsOf: [
        "\(indent)\(extraIndent)\(statement)",
      ])
    }
    if propertyInstead {
      result.append(contentsOf: [
        "\(indent)\(indent)}",
      ])
    }
    result.append(contentsOf: [
      "\(indent)}",
    ])
    return UniqueDeclaration(
      full: result.joined(separator: "\n"),
      uniquenessDefinition: result.joined(separator: "\n")
    )
  }

  static var fileSettings: String? {
    return "using static Tests;"
  }
  static func statementImporting(_ importTarget: String) -> String {
    return "using \(importTarget);"
  }

  static let preexistingNativeRequirements: Set<String> = []
  static func isAlgorithmicallyPreexistingNativeRequirement(source: String) -> Bool {
    return false
  }

  static var importsNeededByMemoryManagement: Set<String> {
    return []
  }
  static var importsNeededByDeadEnd: Set<String> {
    return [
      "System",
    ]
  }
  static var importsNeededByTestScaffolding: Set<String> {
    return [
      "System",
      "System.Collections.Generic",
      "System.Linq",
    ]
  }

  static var memoryManagement: String? {
    return nil
  }

  static func coverageRegionSet(regions: [String]) -> [String] {
    var result: [String] = [
      "static class Coverage",
      "{",
      "\(indent)internal static HashSet<string> Regions = new HashSet<string>",
      "\(indent){",
    ]
    for region in regions {
      result.append("\(indent)\(indent)\u{22}\(region)\u{22},")
    }
    result.append(contentsOf: [
      "\(indent)};",
    ])
    return result
  }

  static var registerCoverageAction: [String] {
    return [
      "\(indent)internal static void Register(string identifier)",
      "\(indent){",
      " \(indent)\(indent)Coverage.Regions.Remove(identifier);",
      "\(indent)}",
      "}",
    ]
  }

  static var actionDeclarationsContainerStart: [String]? {
    return [
      "static class Tests",
      "{",
      "",
      "\(indent)static void Assert(bool condition, string message)",
      "\(indent){",
      "\(indent)\(indent)if (!condition)",
      "\(indent)\(indent){",
      "\(indent)\(indent)\(indent)Console.WriteLine(message);",
      "\(indent)\(indent)\(indent)Environment.Exit(1);",
      "\(indent)\(indent)}",
      "\(indent)}",
    ]
  }
  static var actionDeclarationsContainerEnd: [String]? {
    return [
      "}",
    ]
  }

  static func log(test: String) -> String {
    return "Console.WriteLine(\u{22}\(sanitize(stringLiteral: test))\u{22});"
  }

  static func testSummary(testCalls: [String]) -> [String] {
    var result = [
      "\(indent)internal static void Test()",
      "\(indent){",
    ]
    for test in testCalls {
      result.append(contentsOf: [
        "\(indent)\(indent)\(test)"
      ])
    }
    result.append(contentsOf: [
      "\(indent)\(indent)Assert(!Coverage.Regions.Any(), String.Join(\u{22}, \u{22}, Coverage.Regions));",
      "\(indent)}",
    ])
    return result
  }

  static func testEntryPoint() -> [String]? {
    return [
      "class Test",
      "{",
      "\(indent)static void Main()",
      "\(indent){",
      "\(indent)\(indent)Tests.Test();",
      "\(indent)}",
      "}",
    ]
  }

  static var sourceFileName: String {
    return "Test.cs"
  }

  static func createOtherProjectContainerFiles(projectDirectory: URL, dependencies: [String]) throws {
    try ([
      "<Project Sdk=\u{22}Microsoft.NET.Sdk\u{22}>",
      "  <PropertyGroup>",
      "    <OutputType>Exe</OutputType>",
      "    <TargetFrameworks>net48;netcoreapp3.0</TargetFrameworks>",
      "    <CheckEolTargetFramework>false</CheckEolTargetFramework>",
      "    <RuntimeIdentifier>win-x86</RuntimeIdentifier>",
      "  </PropertyGroup>",
      "</Project>",
    ] as [String]).joined(separator: "\n").appending("\n")
      .save(to: projectDirectory.appendingPathComponent("Project.csproj"))
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
    return "get "
  }
  static var initializerSuffix: UnicodeText? {
    return nil
  }
  static var initializerName: UnicodeText {
    return ""
  }
}
