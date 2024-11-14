import SDGLogic
import SDGText

struct ExtensionIntermediate {
  var ability: StrictString
  var arguments: [SimpleTypeReference]
  var things: [Thing]
  var actions: [ActionIntermediate]
  var declaration: ParsedExtensionSyntax
}

extension ExtensionIntermediate {

  static func construct(
    _ declaration: ParsedExtensionSyntax,
    namespace: [Set<StrictString>]
  ) -> Result<ExtensionIntermediate, ErrorList<ExtensionIntermediate.ConstructionError>> {
    var errors: [ExtensionIntermediate.ConstructionError] = []
    let abilityName = declaration.ability.name()
    let extensionNamespace = namespace
    var things: [Thing] = []
    var actions: [ActionIntermediate] = []
    for provision in declaration.provisions.provisions?.provisions.provisions ?? [] {
      switch provision {
      case .thing(let thing):
        switch Thing.construct(thing, namespace: extensionNamespace) {
        case .failure(let error):
          errors.append(contentsOf: error.errors.map({ .brokenThing($0) }))
        case .success(let result):
          things.append(result)
        }
      case .action(let action):
        switch ActionIntermediate.construct(action, namespace: extensionNamespace) {
        case .failure(let error):
          errors.append(contentsOf: error.errors.map({ .brokenAction($0) }))
        case .success(let result):
          actions.append(result)
        }
      }
    }
    if ¬errors.isEmpty {
      return .failure(ErrorList(errors))
    }
    return .success(
      ExtensionIntermediate(
        ability: abilityName,
        arguments: declaration.ability.parameters.parameters.map({ SimpleTypeReference($0.name) }),
        things: things,
        actions: actions,
        declaration: declaration
      )
    )
  }
}
