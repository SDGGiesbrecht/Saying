import SDGCollections
import SDGText

struct ParameterIntermediate {
  var names: Set<StrictString>
  var type: ParsedTypeReference
}

extension ParameterIntermediate: InterpolationParameterProtocol {}

extension ParameterIntermediate {
  func merging(requirement: ParameterIntermediate) -> ParameterIntermediate {
    return ParameterIntermediate(
      names: names ∪ requirement.names,
      type: type
    )
  }
}
