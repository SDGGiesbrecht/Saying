import SDGLogic
import SDGText

struct UseIntermediate {
  var ability: StrictString
  var arguments: [StrictString]
  var actions: [ActionIntermediate]
  var clientAccess: Bool
  var testOnlyAccess: Bool
  var declaration: ParsedUse
}

extension UseIntermediate {

  static func construct(
    _ declaration: ParsedUse
  ) -> Result<UseIntermediate, ErrorList<UseIntermediate.ConstructionError>> {
    var errors: [UseIntermediate.ConstructionError] = []
    var actions: [ActionIntermediate] = []
    for action in declaration.fulfillments.fulfillments.fulfillments {
      #warning("Unknown namespace.")
      switch ActionIntermediate.construct(action, namespace: [["???"]]) {
      case .failure(let nested):
        errors.append(contentsOf: nested.errors.map({ ConstructionError.brokenAction($0) }))
      case .success(let action):
        actions.append(action)
      }
    }
    if ¬errors.isEmpty {
      return .failure(ErrorList(errors))
    }
    return .success(
      UseIntermediate(
        ability: declaration.use.name(),
        arguments: declaration.use.arguments.arguments.map({ $0.name.identifierText() }),
        actions: actions,
        clientAccess: declaration.access?.keyword is ParsedClientsKeyword,
        testOnlyAccess: declaration.testAccess?.keyword is ParsedTestsKeyword,
        declaration: declaration
      )
    )
  }
}
