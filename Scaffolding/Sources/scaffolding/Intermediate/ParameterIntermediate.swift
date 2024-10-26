import SDGCollections
import SDGText

struct ParameterIntermediate {
  var names: Set<StrictString>
  var type: TypeReference
}

extension ParameterIntermediate {
  func merging(requirement: ParameterIntermediate) -> ParameterIntermediate {
    return ParameterIntermediate(
      names: names ∪ requirement.names,
      type: type
    )
  }
}
