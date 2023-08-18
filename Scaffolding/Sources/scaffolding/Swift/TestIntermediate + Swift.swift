import SDGText

extension TestIntermediate {

  func swiftIdentifier() -> StrictString {
    return location.lazy
      .map({ Swift.sanitize(identifier: $0.identifier()) })
      .joined(separator: "_")
  }

  func swiftSource() -> String {
    return [
      "func run_\(swiftIdentifier())() {",
      "  print(\u{22}\(self)\u{22})",
      "}"
    ].joined(separator: "\n")
  }

  func swiftCall() -> String {
    return "run_\(swiftIdentifier())()"
  }
}
