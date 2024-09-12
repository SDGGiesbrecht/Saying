import SDGLogic
import SDGText

extension ActionUse {
  
  func cCall(module: ModuleIntermediate) -> String {
    let action = module.lookupAction(actionName)!
    if let c = action.c {
      let lambdaType: String
      let returnPrefix: String
      if let returnValue = action.returnValue {
        let thing = module.lookupThing(returnValue)!
        let type: StrictString
        if let c = thing.c {
          type = c
        } else {
          type = thing.names.identifier()
        }
        lambdaType = "Func<\(type)>"
        returnPrefix = "return "
      } else {
        lambdaType = "Action"
        returnPrefix = ""
      }
      var result = ""// "((\(lambdaType))(() => {Coverage.Register(\u{22}\(action.names.identifier())\u{22}); \(returnPrefix)"
      for index in c.textComponents.indices {
        result.append(contentsOf: String(c.textComponents[index]))
        if index ≠ c.textComponents.indices.last {
          let rootIndex = c.reordering[index]
          let reordered = action.reorderings[actionName]![rootIndex]
          let argument = arguments[reordered]
          result.append(contentsOf: argument.cCall(module: module))
        }
      }
      //result.append(contentsOf: ";}))()")
      return result
    } else {
      return String(action.names.identifier())
    }
  }
  func cExpression(module: ModuleIntermediate) -> String {
    return cCall(module: module).appending(";")
  }
}
