import SDGLogic
import SDGText

extension ActionUse {
  
  func cSharpCall(module: ModuleIntermediate) -> String {
    let action = module.lookupAction(actionName)!
    if let cSharp = action.cSharp {
      let lambdaType: String
      let returnPrefix: String
      if let returnValue = action.returnValue {
        let thing = module.lookupThing(returnValue)!
        let type: StrictString
        if let cSharp = thing.cSharp {
          type = cSharp
        } else {
          type = thing.names.identifier()
        }
        lambdaType = "Func<\(type)>"
        returnPrefix = "return "
      } else {
        lambdaType = "Action"
        returnPrefix = ""
      }
      var result = "((\(lambdaType))(() => {Coverage.Register(\u{22}\(action.names.identifier())\u{22}); \(returnPrefix)"
      for index in cSharp.textComponents.indices {
        result.append(contentsOf: String(cSharp.textComponents[index]))
        if index ≠ cSharp.textComponents.indices.last {
          let rootIndex = cSharp.reordering[index]
          let reordered = action.reorderings[actionName]![rootIndex]
          let argument = arguments[reordered]
          result.append(contentsOf: argument.cSharpCall(module: module))
        }
      }
      result.append(contentsOf: ";}))()")
      return result
    } else {
      return String(action.names.identifier())
    }
  }
  func cSharpExpression(module: ModuleIntermediate) -> String {
    return cSharpCall(module: module).appending(";")
  }
}
