import SDGLogic
import SDGText

extension TestIntermediate {

  func swiftIdentifier(leading: Bool) -> String {
    return location.lazy.enumerated()
      .map({ Swift.sanitize(identifier: $1.identifier(), leading: leading ∧ $0 == 0) })
      .joined(separator: "_")
  }

  func swiftSource(module: ModuleIntermediate) -> String {
    return [
      "func run_\(swiftIdentifier(leading: false))() {",
      "  \(Swift.statement(expression: action, context: nil, module: module))",
      "}"
    ].joined(separator: "\n")
  }

  func swiftCall() -> String {
    return "run_\(swiftIdentifier(leading: false))()"
  }
}
