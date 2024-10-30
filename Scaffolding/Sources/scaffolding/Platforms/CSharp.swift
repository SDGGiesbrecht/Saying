import Foundation

import SDGLogic
import SDGCollections
import SDGText

enum CSharp: Platform {

  static var directoryName: String {
    return "C♯"
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

  static var isTyped: Bool {
    return true
  }

  static func nativeType(of thing: Thing) -> NativeThingImplementation? {
    return thing.cSharp
  }
  static func actionType(parameters: String, returnValue: String) -> String {
    if returnValue == emptyReturnTypeForActionType {
      return "Action<\(parameters)>"
    } else {
      return "Func<\(parameters), \(returnValue)>"
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
    return "        Coverage.Register(\u{22}\(identifier)\u{22});"
  }

  static func statement(expression: ActionUse, context: ActionIntermediate?, referenceDictionary: ReferenceDictionary) -> String {
    return call(to: expression, context: context, referenceDictionary: referenceDictionary).appending(";")
  }

  static func actionDeclaration(name: String, parameters: String, returnSection: String?, returnKeyword: String?, coverageRegistration: String?, implementation: String) -> String {
    var result: [String] = [
      "    static \(returnSection!) \(name)(\(parameters))",
      "    {",
    ]
    if let coverage = coverageRegistration {
      result.append(coverage)
    }
    result.append(contentsOf: [
      "        \(returnKeyword ?? "")\(implementation)",
      "    }",
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
      "    internal static HashSet<string> Regions = new HashSet<string> {",
    ]
    for region in regions {
      result.append("        \u{22}\(region)\u{22},")
    }
    result.append(contentsOf: [
      "    };",
    ])
    return result
  }

  static var registerCoverageAction: [String] {
    return [
      "    internal static void Register(string identifier)",
      "    {",
      "        Coverage.Regions.Remove(identifier);",
      "    }",
      "}",
    ]
  }

  static var actionDeclarationsContainerStart: [String]? {
    return [
      "static class Tests",
      "{",
      "",
      "    static void Assert(bool condition, string message)",
      "    {",
      "        if (!condition)",
      "        {",
      "            Console.WriteLine(message);",
      "            Environment.Exit(1);",
      "        }",
      "    }",
    ]
  }
  static var actionDeclarationsContainerEnd: [String]? {
    return [
      "}",
    ]
  }

  static func testSource(identifier: String, statement: String) -> [String] {
    return [
      "    static void run_\(identifier)()",
      "    {",
      "        \(statement)",
      "    }"
    ]
  }
  static func testCall(for identifier: String) -> String {
    return "run_\(identifier)();"
  }

  static func testSummary(testCalls: [String]) -> [String] {
    var result = [
      "    internal static void Test() {",
    ]
    for test in testCalls {
      result.append(contentsOf: [
        "        \(test)"
      ])
    }
    result.append(contentsOf: [
      "        Assert(!Coverage.Regions.Any(), String.Join(\u{22}, \u{22}, Coverage.Regions));",
      "    }",
    ])
    return result
  }

  static func testEntryPoint() -> [String]? {
    return [
      "class Test",
      "{",
      "    static void Main()",
      "    {",
      "        Tests.Test();",
      "    }",
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
