import SDGLogic
import SDGCollections
import SDGText

enum CSharp: Platform {
  
  static var allowsAllUnicodeIdentifiers: Bool {
    return true
  }
  static var allowedIdentifierStartCharacterPoints: [UInt32] {
    var values: [UInt32] = []
    values.append(0x5F) // _
    return values
  }
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
    return character.utf16.map({ code in
      var digits = String(code, radix: 16, uppercase: true)
      digits.scalars.fill(to: 8, with: "0", from: .start)
      return "\u{5C}U\(digits)"
    }).joined()
  }

  static func nativeName(of thing: Thing) -> StrictString? {
    return thing.cSharp
  }

  static func nativeImplementation(of action: ActionIntermediate) -> SwiftImplementation? {
    return action.cSharp
  }

  static func source(for parameter: ParameterIntermediate, module: ModuleIntermediate) -> String {
    return parameter.cSharpSource(module: module)
  }

  static var emptyReturnType: String? {
    return "void"
  }
  static func returnSection(with returnValue: String) -> String? {
    return "\(returnValue)"
  }

  static func coverageRegistration(identifier: String) -> String {
    return "        Coverage.Register(\u{22}\(identifier)\u{22});"
  }

  static func statement(expression: ActionUse, context: ActionIntermediate?, module: ModuleIntermediate) -> String {
    return call(to: expression, context: context, module: module).appending(";")
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

  static var importsNeededByTestScaffolding: [String]? {
    return [
      "using System;",
      "using System.Collections.Generic;",
      "using System.Linq;",
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
      "    static void Assert(bool condition)",
      "    {",
      "        Assert(condition, \u{22}\u{22});",
      "    }",
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

  static func source(for test: TestIntermediate, module: ModuleIntermediate) -> String {
    return test.cSharpSource(module: module)
  }
  static func testCall(for test: TestIntermediate) -> String {
    return test.cSharpCall()
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
}
