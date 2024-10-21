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

  func validateReferences(context: [Scope], testContext: Bool, errors: inout [ReferenceError]) {
    if let action = context.lookupAction(actionName) {
      if ¬testContext,
        action.testOnlyAccess {
        errors.append(.actionUnavailableOutsideTests(reference: source!))
      }
    } else {
      errors.append(.noSuchAction(name: actionName, reference: source!))
    }
    for argument in arguments {
      argument.validateReferences(context: context, testContext: testContext, errors: &errors)
    }
  }
}
