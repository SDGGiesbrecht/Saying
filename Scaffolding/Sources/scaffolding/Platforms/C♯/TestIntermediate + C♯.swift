import SDGLogic
import SDGText

extension TestIntermediate {

  func cSharpIdentifier(leading: Bool) -> String {
    return location.lazy.enumerated()
      .map({ CSharp.sanitize(identifier: $1.identifier(), leading: leading ∧ $0 == 0) })
      .joined(separator: "_")
  }

  func cSharpSource(module: ModuleIntermediate) -> String {
    return [
      "    static void run_\(cSharpIdentifier(leading: false))()",
      "    {",
      "        \(CSharp.statement(expression: action, context: nil, module: module))",
      "    }"
    ].joined(separator: "\n")
  }

  func cSharpCall() -> String {
    return "run_\(cSharpIdentifier(leading: false))();"
  }
}
