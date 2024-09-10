extension ModuleIntermediate {

  func buildCSharp() -> String {
    var result: [String] = [
      "using System.Collections.Generic;",
      "using System.Diagnostics;",
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
      "        Debug.Assert(!Coverage.Regions.Any(), \u{22}{Coverage.Regions}\u{22});",
      "    }",
      "}",
    ])
    return result.joined(separator: "\n").appending("\n")
  }
}
