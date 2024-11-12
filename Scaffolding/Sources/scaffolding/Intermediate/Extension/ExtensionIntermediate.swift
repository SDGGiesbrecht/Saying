import SDGLogic
import SDGText

struct ExtensionIntermediate {
  var ability: StrictString
  var arguments: [SimpleTypeReference]
  var things: [Thing]
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
    for provision in declaration.provisions.provisions?.provisions.provisions ?? [] {
      switch provision {
      case .thing(let thing):
        switch Thing.construct(thing, namespace: extensionNamespace) {
        case .failure(let error):
          errors.append(contentsOf: error.errors.map({ .brokenThing($0) }))
        case .success(let result):
          things.append(result)
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
        declaration: declaration
      )
    )
  }
}
