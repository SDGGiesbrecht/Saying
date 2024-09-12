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
    return [
      "func \(name)(\(parameters))\(returnValue) {",
      //"  \(implementation!.swiftSource(module: module))",
      "}",
    ].joined(separator: "\n")
  }
}
