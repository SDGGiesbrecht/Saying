import SDGLogic

extension ActionUse {

  func swiftSource(module: ModuleIntermediate) -> String {
    let action = module.lookupAction(actionName)!
    if let swift = action.swift {
      var result = "{registerCoverage(\u{22}\(action.names.identifier())\u{22}); return "
      for index in swift.textComponents.indices {
        result.append(contentsOf: String(swift.textComponents[index]))
        if index ≠ swift.textComponents.indices.last {
          let rootIndex = swift.reordering[index]
          let reordered = action.reorderings[actionName]![rootIndex]
          let argument = arguments[reordered]
          result.append(contentsOf: argument.swiftSource(module: module))
        }
      }
      result.append(contentsOf: "}()")
      return result
    } else {
      return String(action.names.identifier())
    }
  }
}
