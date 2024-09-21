import SDGLogic
import SDGText

struct Ability {
  var names: Set<StrictString>
  var clientAccess: Bool
  var testOnlyAccess: Bool
  var declaration: ParsedAbilityDeclaration
}

extension Ability {

  static func construct(
    _ declaration: ParsedAbilityDeclaration
  ) -> Result<Ability, ErrorList<Ability.ConstructionError>> {
    var errors: [Ability.ConstructionError] = []

    #warning("Not implemented yet.")
    let names: Set<StrictString> = []/* Set(
      declaration.name.names.names
        .lazy.map({ $0.name.identifierText() })
    )*/

    if ¬errors.isEmpty {
      return .failure(ErrorList(errors))
    }
    return .success(
      Ability(
        names: names,
        clientAccess: declaration.access?.keyword is ParsedClientsKeyword,
        testOnlyAccess: declaration.testAccess?.keyword is ParsedTestsKeyword,
        declaration: declaration
      )
    )
  }
}
