import SDGLogic
import SDGText

struct ActionUse {
  var actionName: StrictString
  var arguments: [ActionUse]
  var source: ParsedAction?
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

  func validateReferences(module: ModuleIntermediate, errors: inout [ReferenceError]) {
    if module.lookupAction(actionName) == nil {
      errors.append(.noSuchAction(name: actionName, reference: source!))
    }
    for argument in arguments {
      argument.validateReferences(module: module, errors: &errors)
    }
  }
}
