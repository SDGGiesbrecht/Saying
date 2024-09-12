import SDGLogic

extension ModuleIntermediate {

  func buildJavaScript() -> String {
    var result: [String] = [
      "let coverageRegions = new Set([",
    ]
    for region in actions.values
      .lazy.filter({ ¬$0.isCoverageWrapper })
      .compactMap({ $0.coverageRegionIdentifier() })
      .sorted() {
      result.append("  \u{22}\(region)\u{22},")
    }
    result.append(contentsOf: [
      "]);",
      "function registerCoverage(identifier) {",
      "  coverageRegions.delete(identifier);",
      "}",
    ])
    for test in tests {
      result.append(contentsOf: [
        "",
        test.javaScriptSource(module: self)
      ])
    }
    result.append(contentsOf: [
      "",
      "function test() {",
    ])
    for test in tests {
      result.append(contentsOf: [
        "  \(test.javaScriptCall())"
      ])
    }
    result.append(contentsOf: [
      "  console.assert(coverageRegions.size == 0, coverageRegions);",
      "}"
    ])
    return result.joined(separator: "\n")
  }
}
