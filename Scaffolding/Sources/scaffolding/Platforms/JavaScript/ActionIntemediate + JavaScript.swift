import SDGLogic
import SDGText

extension ActionIntermediate {

  func javaScriptDeclaration(module: ModuleIntermediate) -> String? {
    if self.javaScript ≠ nil {
      return nil
    }
    let name = JavaScript.sanitize(identifier: self.names.identifier(), leading: true)
    let parameters = self.parameters
      .lazy.map({ $0.javaScriptSource(module: module) })
      .joined(separator: ", ")
    let returnKeyword = returnValue == "" ? "" : "return "

    var result: [String] = [
      "function \(name)(\(parameters)) {",
    ]
    if let identifier = coveredIdentifier {
      result.append("  coverageRegions.delete(\u{22}\(identifier)\u{22})")
    }
    result.append(contentsOf: [
      "  \(returnKeyword)\(implementation!.javaScriptExpression(context: self, module: module))",
      "}",
    ])
    return result.joined(separator: "\n")
  }
}
