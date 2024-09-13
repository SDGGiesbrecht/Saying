import SDGLogic

extension ActionUse {

  func javaScriptCall(context: ActionIntermediate?, module: ModuleIntermediate) -> String {
    if let parameter = context?.lookupParameter(actionName) {
      return String(JavaScript.sanitize(identifier: parameter.names.identifier(), leading: false))
    } else {
      let bareAction = module.lookupAction(actionName)!
      let action = (context?.isCoverageWrapper ?? false) ? bareAction : module.lookupAction(bareAction.coverageTrackingIdentifier())!
      if let javaScript = action.javaScript {
        var result = ""
        for index in javaScript.textComponents.indices {
          result.append(contentsOf: String(javaScript.textComponents[index]))
          if index ≠ javaScript.textComponents.indices.last {
            let rootIndex = javaScript.reordering[index]
            let reordered = action.reorderings[actionName]![rootIndex]
            let argument = arguments[reordered]
            result.append(contentsOf: argument.javaScriptCall(context: context, module: module))
          }
        }
        return result
      } else {
        let name = JavaScript.sanitize(identifier: action.names.identifier(), leading: true)
        let arguments = self.arguments
          .lazy.map({ argument in
            return argument.javaScriptCall(context: context, module: module)
          })
          .joined(separator: ", ")
        return "\(name)(\(arguments))"
      }
    }
  }
  func javaScriptExpression(context: ActionIntermediate?, module: ModuleIntermediate) -> String {
    return javaScriptCall(context: context, module: module).appending(";")
  }
}
