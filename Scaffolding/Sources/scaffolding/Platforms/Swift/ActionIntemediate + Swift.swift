import SDGLogic
import SDGText

extension ActionIntermediate {

  func swiftDeclaration(module: ModuleIntermediate) -> String? {
    if self.swift ≠ nil {
      return nil
    }
    let name = Swift.sanitize(identifier: self.names.identifier(), leading: true)
    let parameters = self.parameters
      .lazy.map({ $0.swiftSource(module: module) })
      .joined(separator: ", ")
    let returnValue = self.returnValue.map({ value in
      let type = module.lookupThing(value)!
      let identifier: StrictString
      if let swift = type.swift {
        identifier = swift
      } else {
        identifier = Swift.sanitize(identifier: type.names.identifier(), leading: false)
      }
      return " -> \(identifier)"
    }) ?? ""
    let returnKeyword = returnValue == "" ? "" : "return "

    var result: [String] = [
      "func \(name)(\(parameters))\(returnValue) {",
    ]
    if let identifier = coveredIdentifier {
      result.append("  registerCoverage(\u{22}\(identifier)\u{22})")
    }
    result.append(contentsOf: [
      "  \(returnKeyword)\(implementation!.swiftExpression(context: self, module: module))",
      "}",
    ])
    return result.joined(separator: "\n")
  }
}
