import SDGLogic
import SDGText

extension TestIntermediate {

  func javaScriptIdentifier(leading: Bool) -> String {
    return location.lazy.enumerated()
      .map({ JavaScript.sanitize(identifier: $1.identifier(), leading: leading ∧ $0 == 0) })
      .joined(separator: "_")
  }
  
  func javaScriptSource(module: ModuleIntermediate) -> String {
    return [
      "function run_\(javaScriptIdentifier(leading: false))() {",
      "  \(action.javaScriptExpression(context: nil, module: module))",
      "}"
    ].joined(separator: "\n")
  }

  func javaScriptCall() -> String {
    return "run_\(javaScriptIdentifier(leading: false))();"
  }
}
