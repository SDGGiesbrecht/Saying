import SDGText

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
    result.append(contentsOf: [
      "};",
      "void register_coverage_region(char identifier[REGION_IDENTIFIER_LENGTH]) {",
      "        for(int index = 0; index < NUMBER_OF_REGIONS; index++) {",
      "                if (!strcmp(coverage_regions[index], identifier))",
      "                {",
      "                        memset(coverage_regions[index], 0, REGION_IDENTIFIER_LENGTH);",
      "                }",
      "        }",
      "}",
    ])
    var signatures: Set<CSignature> = []
    for (_, action) in actions {
      signatures.insert(action.cSignature(module: self))
    }
    for signature in signatures.sorted() {
      let disambiguator: StrictString = "\(signature.parameters.joined(separator: ", ")) → \(signature.returnValue)"
      let sanitizedDisambiguator = C.sanitize(identifier: disambiguator, leading: false)
      let signatureParameters = signature.parameters
        .joined(separator: ", ")
      let parametersIn = signature.parameters
        .enumerated()
        .lazy.map({ "\($1) _\($0 + 1)" })
        .joined(separator: ", ")
      let parametersOut = (0..<signature.parameters.count)
        .lazy.map({ "_\($0 + 1)" })
        .joined(separator: ", ")
      result.append(contentsOf: [
        "",
        "\(signature.returnValue) register_and_execute_\(sanitizedDisambiguator)(char identifier[REGION_IDENTIFIER_LENGTH], \(signature.returnValue) (*function)(\(signatureParameters))\(parametersIn == "" ? "" : ", \(parametersIn)"))",
        "{",
        "        register_coverage_region(identifier);",
        "        return function(\(parametersOut));",
        "}",
      ])
    }
    
    for test in tests {
      result.append(contentsOf: [
        "",
        test.cSource(module: self)
      ])
    }
    result.append(contentsOf: [
      "",
      "void test() {",
    ])
    for test in tests {
      result.append(contentsOf: [
        "        \(test.cCall())"
      ])
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
