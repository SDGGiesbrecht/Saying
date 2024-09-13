import SDGLogic
import SDGText

extension TestIntermediate {

  func cIdentifier(leading: Bool) -> String {
    return location.lazy.enumerated()
      .map({ C.sanitize(identifier: $1.identifier(), leading: leading ∧ $0 == 0) })
      .joined(separator: "_")
  }

  func cSource(module: ModuleIntermediate) -> String {
    return [
      "void run_\(cIdentifier(leading: false))()",
      "{",
      "        \(action.cExpression(context: nil, module: module))",
      "}"
    ].joined(separator: "\n")
  }

  func cCall() -> String {
    return "run_\(cIdentifier(leading: false))();"
  }
}
