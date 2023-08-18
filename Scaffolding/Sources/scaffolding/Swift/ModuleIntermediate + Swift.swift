extension ModuleIntermediate {

  func buildSwift() -> String {
    var result: [String] = []
    result.append(contentsOf: [
      "func test() {",
      "  print(\u{22}Hello, world!\u{22})",
    ])
    result.append(contentsOf: [
      "}"
    ])
    return result.joined(separator: "\n").appending("\n")
  }
}
