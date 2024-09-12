import SDGLogic

extension ActionIntermediate {

  func swiftDeclaration(module: ModuleIntermediate) -> String? {
    if self.swift ≠ nil {
      return nil
    }
    #warning("Incomplete.")
    let name = Swift.sanitize(identifier: self.names.identifier(), leading: true)
    let parameters = self.parameters
      .lazy.map({ $0.swiftSource(module: module) })
      .joined(separator: ", ")
    return [
      "func \(name)(\(parameters)) {",
      //"  \(implementation!.swiftSource(module: module))",
      "}",
    ].joined(separator: "\n")
  }
}
