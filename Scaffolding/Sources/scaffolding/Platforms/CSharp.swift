import Foundation

import SDGLogic
import SDGCollections
import SDGText

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

  static func escapeForStringLiteral(character: Unicode.Scalar) -> String {
    var digits = String(character.value, radix: 16, uppercase: true)
    digits.scalars.fill(to: 8, with: "0", from: .start)
    return "\u{5C}U\(digits)"
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
  static func caseStorageDeclaration(name: String, contents: String) -> String? {
    return nil
  }

  static var isTyped: Bool {
    return true
  }

  static func nativeType(of thing: Thing) -> NativeThingImplementationIntermediate? {
    return thing.cSharp
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

  static func enumerationTypeDeclaration(
    name: String,
    cases: [String],
    simple: Bool,
    storageCases: [String]
  ) -> String {
    if simple {
      var result: [String] = [
        "enum \(name)",
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
        "abstract class \(name)",
        "{",
        "\(indent)private \(name)() {}",
        "",
      ]
      for enumerationCase in cases {
        result.append(enumerationCase)
      }
      result.append(contentsOf: [
        "}"
      ])
      return result.joined(separator: "\n")
    }
  }

  static func nativeImplementation(of action: ActionIntermediate) -> NativeActionImplementationIntermediate? {
    return action.cSharp
  }

  static func parameterDeclaration(name: String, type: String) -> String {
    return "\(type) \(name)"
  }
  static func parameterDeclaration(name: String, parameters: String, returnValue: String) -> String {
    return "\(actionType(parameters: parameters, returnValue: returnValue)) \(name)"
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

  static var needsForwardDeclarations: Bool { false }
  static func forwardActionDeclaration(name: String, parameters: String, returnSection: String?) -> String? {
    return nil
  }

  static func coverageRegistration(identifier: String) -> String {
    return "Coverage.Register(\u{22}\(identifier)\u{22});"
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
      "\(indent)static \(returnSection!) \(name)(\(parameters))",
      "\(indent){",
    ]
    if let coverage = coverageRegistration {
      result.append(coverage)
    }
    for statement in implementation {
      result.append(contentsOf: [
        "\(indent)\(indent)\(statement)",
      ])
    }
    result.append(contentsOf: [
      "\(indent)}",
    ])
    return result.joined(separator: "\n")
  }

  static func statementImporting(_ importTarget: String) -> String {
    return "using \(importTarget);"
  }

  static var importsNeededByTestScaffolding: Set<String> {
    return [
      "System",
      "System.Collections.Generic",
      "System.Linq",
    ]
  }

  static func coverageRegionSet(regions: [String]) -> [String] {
    var result: [String] = [
      "static class Coverage",
      "{",
      "\(indent)internal static HashSet<string> Regions = new HashSet<string> {",
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

  static func testSource(identifier: String, statement: String) -> [String] {
    return [
      "\(indent)static void run_\(identifier)()",
      "\(indent){",
      "\(indent)\(indent)\(statement)",
      "\(indent)}"
    ]
  }
  static func testCall(for identifier: String) -> String {
    return "run_\(identifier)();"
  }

  static func testSummary(testCalls: [String]) -> [String] {
    var result = [
      "\(indent)internal static void Test() {",
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

  static func createOtherProjectContainerFiles(projectDirectory: URL) throws {
    try ([
      "<Project>",
      "  <ItemGroup>",
      "    <Compile Include=\u{22}Test.cs\u{22} />",
      "  </ItemGroup>",
      "  <Target Name=\u{22}Test\u{22}>",
      "    <Csc Sources=\u{22}@(Compile)\u{22} />",
      "  </Target>",
      "</Project>",
    ] as [String]).joined(separator: "\n").appending("\n")
      .save(to: projectDirectory.appendingPathComponent("Project.csproj"))
  }
}
