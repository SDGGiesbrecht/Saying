import SDGCollections
import SDGText

struct ParameterIntermediate {
  private(set) var names: Set<StrictString>
  private(set) var type: ParsedTypeReference
}

extension ParameterIntermediate: InterpolationParameterProtocol {}

extension ParameterIntermediate {
  init(
    names: Set<StrictString>,
    nestedParameters: Interpolation<ParameterIntermediate>?,
    returnValue: ParsedTypeReference
  ) {
    #warning("Not implemented yet.")
    fatalError()
  }
}

extension ParameterIntermediate {
  func merging(requirement: ParameterIntermediate) -> ParameterIntermediate {
    return ParameterIntermediate(
      names: names ∪ requirement.names,
      type: type
    )
  }
}
