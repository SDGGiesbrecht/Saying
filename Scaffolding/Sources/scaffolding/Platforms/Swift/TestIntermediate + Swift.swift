import SDGLogic
import SDGText

extension TestIntermediate {

  func swiftIdentifier(leading: Bool) -> StrictString {
    return location.lazy.enumerated()
      .map({ Swift.sanitize(identifier: $1.identifier(), leading: leading ∧ $0 == 0) })
      .joined(separator: "_")
  }

  func swiftSource(module: ModuleIntermediate) -> String {
    return [
      "func run_\(swiftIdentifier(leading: false))() {",
      "  \(action.swiftSource(module: module))",
      "}"
    ].joined(separator: "\n")
  }

  func swiftCall() -> String {
    return "run_\(swiftIdentifier(leading: false))()"
  }
}
