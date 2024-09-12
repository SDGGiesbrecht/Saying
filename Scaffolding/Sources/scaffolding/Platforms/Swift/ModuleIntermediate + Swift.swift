import SDGLogic

extension ModuleIntermediate {

  func buildSwift() -> String {
    var result: [String] = [
      "var coverageRegions: Set<String> = [",
    ]
    for region in actions.values
      .lazy.filter({ ¬$0.isCoverageWrapper })
      .compactMap({ $0.coverageRegionIdentifier() })
      .sorted() {
      result.append("  \u{22}\(region)\u{22},")
    }
    result.append(contentsOf: [
      "]",
      "func registerCoverage(_ identifier: String) {",
      "  coverageRegions.remove(identifier)",
      "}",
    ])
    for actionIdentifier in actions.keys.sorted() {
      let action = actions[actionIdentifier]
    }
    for test in tests {
      result.append(contentsOf: [
        "",
        test.swiftSource(module: self)
      ])
    }
    result.append(contentsOf: [
      "",
      "func test() {",
    ])
    for test in tests {
      result.append(contentsOf: [
        "  \(test.swiftCall())"
      ])
    }
    result.append(contentsOf: [
      "  assert(coverageRegions.isEmpty, \u{22}\u{5C}(coverageRegions)\u{22})",
      "}"
    ])
    return result.joined(separator: "\n").appending("\n")
  }
}
