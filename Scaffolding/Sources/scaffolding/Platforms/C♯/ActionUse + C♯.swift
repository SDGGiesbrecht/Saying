import SDGLogic
import SDGText

extension ActionUse {
  
  func cSharpCall(context: ActionIntermediate?, module: ModuleIntermediate) -> String {
    if let parameter = context?.lookupParameter(actionName) {
      return String(CSharp.sanitize(identifier: parameter.names.identifier(), leading: false))
    } else {
      let bareAction = module.lookupAction(actionName)!
      let action = (context?.isCoverageWrapper ?? false) ? bareAction : module.lookupAction(bareAction.coverageTrackingIdentifier())!
      if let cSharp = action.cSharp {
        var result = ""
        for index in cSharp.textComponents.indices {
          result.append(contentsOf: String(cSharp.textComponents[index]))
          if index ≠ cSharp.textComponents.indices.last {
            let rootIndex = cSharp.reordering[index]
            let reordered = action.reorderings[actionName]![rootIndex]
            let argument = arguments[reordered]
            result.append(contentsOf: argument.cSharpCall(context: context, module: module))
          }
        }
        return result
      } else {
        let name = CSharp.sanitize(identifier: action.names.identifier(), leading: true)
        let arguments = self.arguments
          .lazy.map({ argument in
            return argument.cSharpCall(context: context, module: module)
          })
          .joined(separator: ", ")
        return "\(name)(\(arguments))"
      }
    }
  }
  func cSharpExpression(context: ActionIntermediate?, module: ModuleIntermediate) -> String {
    return cSharpCall(context: context, module: module).appending(";")
  }
}
