import SDGLogic
import SDGText

struct UseIntermediate {
  var ability: StrictString
  var arguments: [SimpleTypeReference]
  var actions: [ActionIntermediate]
  var access: AccessIntermediate
  var testOnlyAccess: Bool
  var declaration: ParsedUse
}

extension UseIntermediate {

  static func construct(
    _ declaration: ParsedUse,
    namespace: [Set<StrictString>]
  ) -> Result<UseIntermediate, ErrorList<UseIntermediate.ConstructionError>> {
    var errors: [UseIntermediate.ConstructionError] = []
    let abilityName = declaration.use.name()
    let useNamespace = namespace
    var actions: [ActionIntermediate] = []
    for action in declaration.fulfillments.fulfillments.fulfillments {
      switch ActionIntermediate.construct(action, namespace: useNamespace) {
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
        ability: abilityName,
        arguments: declaration.use.arguments.arguments.map({ SimpleTypeReference($0.name) }),
        actions: actions,
        access: AccessIntermediate(declaration.access),
        testOnlyAccess: declaration.testAccess?.keyword is ParsedTestsKeyword,
        declaration: declaration
      )
    )
  }
}
