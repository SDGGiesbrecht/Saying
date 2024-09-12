import SDGLogic
import SDGText

extension ActionUse {
  
  func cCall(module: ModuleIntermediate) -> String {
    let action = module.lookupAction(actionName)!
    if let c = action.c {
      let cSignature = action.cSignature(module: module)
      var result = "\(cSignature.registerAndExecuteName())(\u{22}\(action.names.identifier())\u{22}, "
      for index in c.textComponents.indices {
        if cSignature.equals ∨ cSignature.and ∨ cSignature.assert {
          if index ≠ c.textComponents.startIndex ∧ index ≠ c.textComponents.indices.last {
            result.append(contentsOf: ", ")
          }
        } else {
          result.append(contentsOf: String(c.textComponents[index]))
        }
        if index ≠ c.textComponents.indices.last {
          let rootIndex = c.reordering[index]
          let reordered = action.reorderings[actionName]![rootIndex]
          let argument = arguments[reordered]
          result.append(contentsOf: argument.cCall(module: module))
        }
      }
      result.append(contentsOf: ")")
      return result
    } else {
      return String(action.names.identifier())
    }
  }
  func cExpression(module: ModuleIntermediate) -> String {
    return cCall(module: module).appending(";")
  }
}
