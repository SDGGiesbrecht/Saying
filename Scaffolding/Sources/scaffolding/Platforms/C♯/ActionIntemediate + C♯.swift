import SDGLogic
import SDGText

extension ActionIntermediate {

  func cSharpDeclaration(module: ModuleIntermediate) -> String? {
    if self.cSharp ≠ nil {
      return nil
    }
    let name = CSharp.sanitize(identifier: self.names.identifier(), leading: true)
    let parameters = self.parameters
      .lazy.map({ $0.cSharpSource(module: module) })
      .joined(separator: ", ")
    let returnValue: StrictString = self.returnValue.map({ value in
      let type = module.lookupThing(value)!
      let identifier: StrictString
      if let cSharp = type.cSharp {
        identifier = cSharp
      } else {
        identifier = CSharp.sanitize(identifier: type.names.identifier(), leading: false)
      }
      return identifier
    }) ?? "void"
    let returnKeyword = returnValue == "" ? "" : "return "

    var result: [String] = [
      "    static \(returnValue) \(name)(\(parameters))",
      "    {",
    ]
    if let identifier = coveredIdentifier {
      result.append("        Coverage.Register(\u{22}\(identifier)\u{22});")
    }
    result.append(contentsOf: [
      "        \(returnKeyword)\(implementation!.cSharpExpression(context: self, module: module))",
      "    }",
    ])
    return result.joined(separator: "\n")
  }
}
