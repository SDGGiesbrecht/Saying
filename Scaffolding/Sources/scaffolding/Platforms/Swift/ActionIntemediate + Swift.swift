import SDGLogic

extension ActionIntermediate {

  func swiftDeclaration(module: ModuleIntermediate) -> String? {
    if self.swift ≠ nil {
      return nil
    }
    #warning("Incomplete.")
    return [
      "func \(Swift.sanitize(identifier: self.names.identifier(), leading: true))() {",
      //"  \(implementation!.swiftSource(module: module))",
      "}",
    ].joined(separator: "\n")
  }
}
