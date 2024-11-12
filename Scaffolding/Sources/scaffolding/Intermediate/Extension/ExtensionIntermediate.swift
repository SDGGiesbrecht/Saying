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
    _ declaration: ParsedExtensionSyntax
  ) -> Result<ExtensionIntermediate, ErrorList<ExtensionIntermediate.ConstructionError>> {
    var errors: [ExtensionIntermediate.ConstructionError] = []
    let abilityName = declaration.ability.name()
    var things: [Thing] = []
    for provision in declaration.provisions.provisions?.provisions.provisions ?? [] {
      switch provision {
      case .thing(let thing):
        #warning("Not implemented yet.")
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
