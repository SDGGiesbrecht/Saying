import SDGLogic
import SDGText

struct ExtensionIntermediate {
  var ability: StrictString
  var arguments: [SimpleTypeReference]
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
    for provision in declaration.provisions.provisions?.provisions.provisions ?? [] {
      switch provision {
      case .thing(let thing):
        switch Thing.construct(thing, namespace: extensionNamespace) {
        case .failure(let error):
          errors.append(contentsOf: error.errors.map({ .brokenThing($0) }))
        case .success(let result):
          #warning("Not implemented yet. (Reference dictionary, like in module?)")
          print("Extension is dropping constructed thing.")
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
        declaration: declaration
      )
    )
  }
}
