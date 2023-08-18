import SDGLogic
import SDGText

extension TestIntermediate {

  func swiftIdentifier(leading: Bool) -> StrictString {
    return location.lazy.enumerated()
      .map({ Swift.sanitize(identifier: $1.identifier(), leading: leading ∧ $0 == 0) })
      .joined(separator: "_")
  }

  func swiftSource() -> String {
    return [
      "func run_\(swiftIdentifier(leading: false))() {",
      "  print(\u{22}\(self)\u{22})",
      "}"
    ].joined(separator: "\n")
  }

  func swiftCall() -> String {
    return "run_\(swiftIdentifier(leading: false))()"
  }
}
