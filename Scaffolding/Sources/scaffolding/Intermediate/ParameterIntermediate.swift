import SDGCollections
import SDGText

struct ParameterIntermediate {
  var names: Set<StrictString>
  var type: StrictString
  var typeDeclaration: ParsedUninterruptedIdentifier
}

extension ParameterIntermediate {
  func merging(requirement: ParameterIntermediate) -> ParameterIntermediate {
    return ParameterIntermediate(
      names: names ∪ requirement.names,
      type: type,
      typeDeclaration: typeDeclaration
    )
  }
}
