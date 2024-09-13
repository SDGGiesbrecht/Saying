import SDGLogic
import SDGText

extension ActionIntermediate {

  func cDeclaration(module: ModuleIntermediate) -> String? {
    if self.c ≠ nil {
      return nil
    }
    let name = C.sanitize(identifier: self.names.identifier(), leading: true)
    let parameters = self.parameters
      .lazy.map({ $0.cSource(module: module) })
      .joined(separator: ", ")
    let returnValue: StrictString = self.returnValue.map({ value in
      let type = module.lookupThing(value)!
      let identifier: StrictString
      if let c = type.c {
        identifier = c
      } else {
        identifier = C.sanitize(identifier: type.names.identifier(), leading: false)
      }
      return identifier
    }) ?? "void"
    let returnKeyword = returnValue == "" ? "" : "return "

    var result: [String] = [
      "\(returnValue) \(name)(\(parameters))",
      "{",
    ]
    if let identifier = coveredIdentifier {
      result.append("  register_coverage_region(\u{22}\(identifier)\u{22});")
    }
    result.append(contentsOf: [
      "  \(returnKeyword)\(implementation!.cExpression(context: self, module: module))",
      "}",
    ])
    return result.joined(separator: "\n")
  }
}
