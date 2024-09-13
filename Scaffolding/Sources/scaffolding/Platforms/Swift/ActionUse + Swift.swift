import SDGLogic

extension ActionUse {

  func swiftSource(context: ActionIntermediate?, module: ModuleIntermediate) -> String {
    if let parameter = context?.lookupParameter(actionName) {
      return String(Swift.sanitize(identifier: parameter.names.identifier(), leading: false))
    } else {
      var bareAction = module.lookupAction(actionName)!
      let action = (context?.isCoverageWrapper ?? false) ? bareAction : module.lookupAction(bareAction.coverageTrackingIdentifier())!
      if let swift = action.swift {
        var result = ""
        for index in swift.textComponents.indices {
          result.append(contentsOf: String(swift.textComponents[index]))
          if index ≠ swift.textComponents.indices.last {
            let rootIndex = swift.reordering[index]
            let reordered = action.reorderings[actionName]![rootIndex]
            let argument = arguments[reordered]
            result.append(contentsOf: argument.swiftSource(context: context, module: module))
          }
        }
        result.append(contentsOf: "")
        return result
      } else {
        return "..."// String(action.names.identifier())
      }
    }
  }
}
