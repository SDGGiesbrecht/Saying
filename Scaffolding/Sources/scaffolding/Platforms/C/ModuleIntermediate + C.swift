extension ModuleIntermediate {

  func buildC() -> String {
    var result: [String] = []
    let regions = actions.values.lazy.flatMap({ $0.coverageRegions() }).sorted()
    let numberOfRegions = regions.count
    let longestLength = regions.lazy.map({ String($0).utf8.count }).max() ?? 0
    result.append(contentsOf: [
      "char coverage_regions[\(numberOfRegions)][\(longestLength)] = {",
    ])
    for region in regions {
      result.append("        \u{22}\(region)\u{22},")
    }
    #warning("Incomplete.")
    result.append(contentsOf: [
      "};",
      "void register_coverage_region(char identifier[\(longestLength)]) {",
      //"        Coverage.Regions.Remove(identifier);",
      "}",
      "",
      /*"    static void Assert(bool condition)",
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
      "    }",*/
    ])
    #warning("Incomplete.")
    /*for test in tests {
      result.append(contentsOf: [
        "",
        test.cSharpSource(module: self)
      ])
    }*/
    result.append(contentsOf: [
      "",
      "void test() {",
    ])
    for test in tests {
      #warning("Incomplete.")
      /*result.append(contentsOf: [
        "        \(test.cSharpCall())"
      ])*/
    }
    #warning("Incomplete.")
    result.append(contentsOf: [
      //"        Assert(!Coverage.Regions.Any(), String.Join(\u{22}, \u{22}, Coverage.Regions));",
      "}",
    ])
    return result.joined(separator: "\n").appending("\n")
  }
}
