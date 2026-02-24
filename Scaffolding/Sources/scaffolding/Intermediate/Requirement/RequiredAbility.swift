struct RequiredAbility {
  var ability: UnicodeText
  var arguments: [ParsedTypeReference]
  var access: AccessIntermediate
  var testOnlyAccess: Bool
  var declaration: ParsedRequirementAbilityDeclaration
}

extension RequiredAbility {

  static func construct(
    _ declaration: ParsedRequirementAbilityDeclaration
  ) -> RequiredAbility {
    return RequiredAbility(
      ability: declaration.use.name(),
      arguments: declaration.use.arguments.arguments.map({ ParsedTypeReference($0.name) }),
      access: AccessIntermediate(declaration.access),
      testOnlyAccess: declaration.testAccess?.keyword is ParsedTestsKeyword,
      declaration: declaration
    )
  }
}

extension RequiredAbility {
  func specializing(
    for use: UseIntermediate,
    typeLookup: [UnicodeText: ParsedTypeReference]
  ) -> RequiredAbility {
    return RequiredAbility(
      ability: ability,
      arguments: arguments.map({ argument in
        argument.specializing(typeLookup: typeLookup)
      }),
      access: min(self.access, use.access),
      testOnlyAccess: self.testOnlyAccess || use.testOnlyAccess,
      declaration: declaration
    )
  }
}
