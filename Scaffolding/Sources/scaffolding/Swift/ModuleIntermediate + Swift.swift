extension ModuleIntermediate {

  func buildSwift() -> String {
    var result: [String] = []
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
      "}"
    ])
    return result.joined(separator: "\n").appending("\n")
  }
}
