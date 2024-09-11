extension ModuleIntermediate {

  func buildCSharp() -> String {
    var result: [String] = [
      "using System;",
      "using System.Collections.Generic;",
      "using System.Linq;",
      "",
      "static class Coverage",
      "{",
      "    internal static HashSet<string> Regions = new HashSet<string> {",
    ]
    for region in actions.values.lazy.flatMap({ $0.coverageRegions() }).sorted() {
      result.append("        \u{22}\(region)\u{22},")
    }
    result.append(contentsOf: [
      "    };",
      "    static void Register(string identifier)",
      "    {",
      "        Coverage.Regions.Remove(identifier);",
      "    }",
      "}",
      "",
      "static class Tests",
      "{",
      "",
      "    internal static bool Passing = true;",
      "",
      "    static void Assert (bool condition, string message)",
      "    {",
      "        if (!condition)",
      "        {",
      "            Console.WriteLine(message);",
      "            Environment.Exit(1);",
      "        }",
      "    }",
    ])
    for test in tests {
      result.append(contentsOf: [
        "",
        test.cSharpSource(module: self)
      ])
    }
    result.append(contentsOf: [
      "",
      "    internal static void Test() {",
    ])
    for test in tests {
      result.append(contentsOf: [
        "        \(test.cSharpCall())"
      ])
    }
    result.append(contentsOf: [
      "        Assert(!Coverage.Regions.Any(), String.Join(\u{22}, \u{22}, Coverage.Regions));",
      "    }",
      "}",
    ])
    return result.joined(separator: "\n").appending("\n")
  }
}
