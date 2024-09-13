import SDGLogic
import SDGText

extension ActionUse {
  
  func cCall(context: ActionIntermediate?, module: ModuleIntermediate) -> String {
    if let parameter = context?.lookupParameter(actionName) {
      return String(C.sanitize(identifier: parameter.names.identifier(), leading: false))
    } else {
      let bareAction = module.lookupAction(actionName)!
      let action = (context?.isCoverageWrapper ?? false) ? bareAction : module.lookupAction(bareAction.coverageTrackingIdentifier())!
      if let c = action.c {
        var result = ""
        for index in c.textComponents.indices {
          result.append(contentsOf: String(c.textComponents[index]))
          if index ≠ c.textComponents.indices.last {
            let rootIndex = c.reordering[index]
            let reordered = action.reorderings[actionName]![rootIndex]
            let argument = arguments[reordered]
            result.append(contentsOf: argument.cCall(context: context, module: module))
          }
        }
        return result
      } else {
        let name = C.sanitize(identifier: action.names.identifier(), leading: true)
        let arguments = self.arguments
          .lazy.map({ argument in
            return argument.cCall(context: context, module: module)
          })
          .joined(separator: ", ")
        return "\(name)(\(arguments))"
      }
    }
  }
  func cExpression(context: ActionIntermediate?, module: ModuleIntermediate) -> String {
    return cCall(context: context, module: module).appending(";")
  }
}
