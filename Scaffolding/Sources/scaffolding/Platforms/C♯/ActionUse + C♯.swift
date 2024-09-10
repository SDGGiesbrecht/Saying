import SDGLogic

extension ActionUse {
  
  func cSharpCall(module: ModuleIntermediate) -> String {
    #warning("Not implemented yet (see commented code).")
    let action = module.lookupAction(actionName)!
    /*if let javaScript = action.javaScript {
      var result = "(function(){registerCoverage(\u{22}\(JavaScript.sanitize(stringLiteral: action.names.identifier()))\u{22}); return "
      for index in javaScript.textComponents.indices {
        result.append(contentsOf: String(javaScript.textComponents[index]))
        if index ≠ javaScript.textComponents.indices.last {
          let rootIndex = javaScript.reordering[index]
          let reordered = action.reorderings[actionName]![rootIndex]
          let argument = arguments[reordered]
          result.append(contentsOf: argument.javaScriptCall(module: module))
        }
      }
      result.append(contentsOf: "})()")
      return result
    } else {*/
      return String(action.names.identifier())
    //}
  }
  func cSharpExpression(module: ModuleIntermediate) -> String {
    return ""// cSharpCall(module: module).appending(";")
  }
}
