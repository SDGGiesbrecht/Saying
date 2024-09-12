extension ModuleIntermediate {

  func buildC() -> String {
    var result: [String] = []
    let regions = actions.values.lazy.flatMap({ $0.coverageRegions() }).sorted()
    result.append(contentsOf: [
      "#include <assert.h>",
      "#include <stdbool.h>",
      "#include <stdio.h>",
      "#include <string.h>",
      "",
      "#define REGION_IDENTIFIER_LENGTH \((regions.lazy.map({ String($0).utf8.count }).max() ?? 0) + 1)",
      "#define NUMBER_OF_REGIONS \(regions.count)",
      "char coverage_regions[NUMBER_OF_REGIONS][REGION_IDENTIFIER_LENGTH] = {",
    ])
    for region in regions {
      result.append("        \u{22}\(region)\u{22},")
    }
    #warning("Incomplete.")
    result.append(contentsOf: [
      "};",
      "void register_coverage_region(char identifier[REGION_IDENTIFIER_LENGTH]) {",
      "        for(int index = 0; index < NUMBER_OF_REGIONS; index++) {",
      "                if (strcmp(coverage_regions[index], identifier))",
      "                {",
      "                        memset(coverage_regions[index], 0, REGION_IDENTIFIER_LENGTH);",
      "                }",
      "        }",
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
    result.append(contentsOf: [
      "        bool any_remaining = false;",
      "        for(int index = 0; index < NUMBER_OF_REGIONS; index++) {",
      "                if (coverage_regions[index][0] != 0)",
      "                {",
      "                        any_remaining = true;",
      "                }",
      "        }",
      "        assert(!any_remaining);",
      "}",
    ])
    return result.joined(separator: "\n").appending("\n")
  }
}
