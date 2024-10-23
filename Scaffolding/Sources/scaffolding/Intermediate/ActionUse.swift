import SDGLogic
import SDGText

struct ActionUse {
  var actionName: StrictString
  var arguments: [ActionUse]
  var source: ParsedAction?
  var resolvedResultType: StrictString?
}

extension ActionUse {

  init(_ use: ParsedAction) {
    actionName = use.name()
    switch use {
    case .compound(let compound):
      arguments = compound.arguments.arguments.map { ActionUse($0.argument) }
    case .simple:
      arguments = []
    }
    source = use
  }

  mutating func resolveTypes(context: ActionIntermediate?, module: ModuleIntermediate) {
    for index in arguments.indices {
      arguments[index].resolveTypes(context: context, module: module)
    }
    let signature = arguments.compactMap({ $0.resolvedResultType })
    guard signature.count == arguments.count else {
      return // aborting due to failure deeper down
    }
    if let parameter = context?.lookupParameter(actionName) {
      resolvedResultType = parameter.type
    } else if let action = module.lookupAction(actionName, signature: signature) {
      resolvedResultType = action.returnValue
    }
    #warning("Debugging...")
    if source?.source() == "example" {
      print(actionName)
      print(signature)
      print(resolvedResultType)
    }
    if source?.source() == "(example) is (example)" {
      print(actionName)
      print(signature)
      print(resolvedResultType)
      fatalError()
    }
  }

  func validateReferences(context: [Scope], testContext: Bool, errors: inout [ReferenceError]) {
    for argument in arguments {
      argument.validateReferences(context: context, testContext: testContext, errors: &errors)
    }
    let signature = arguments.compactMap({ $0.resolvedResultType })
    if signature.count == arguments.count,
      let action = context.lookupAction(actionName, signature: signature) {
      if ¬testContext,
        action.testOnlyAccess {
        errors.append(.actionUnavailableOutsideTests(reference: source!))
      }
    } else {
      errors.append(.noSuchAction(name: actionName, reference: source!))
    }
  }
}
