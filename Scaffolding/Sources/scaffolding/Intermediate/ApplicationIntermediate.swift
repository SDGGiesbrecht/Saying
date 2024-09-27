import SDGLogic
import SDGText

struct ApplicationIntermediate {
  var ability: StrictString
  var arguments: [StrictString]
  var actions: [ActionIntermediate]
  var clientAccess: Bool
  var testOnlyAccess: Bool
  var declaration: ParsedApplication
}

extension ApplicationIntermediate {

  static func construct(
    _ declaration: ParsedApplication
  ) -> Result<ApplicationIntermediate, ErrorList<ApplicationIntermediate.ConstructionError>> {
    var errors: [ApplicationIntermediate.ConstructionError] = []
    var actions: [ActionIntermediate] = []
    for action in declaration.fulfillments.fulfillments.fulfillments {
      switch ActionIntermediate.construct(action) {
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
      ApplicationIntermediate(
        ability: declaration.application.name(),
        arguments: declaration.application.arguments.arguments.map({ $0.name.identifierText() }),
        actions: actions,
        clientAccess: declaration.access?.keyword is ParsedClientsKeyword,
        testOnlyAccess: declaration.testAccess?.keyword is ParsedTestsKeyword,
        declaration: declaration
      )
    )
  }
}
