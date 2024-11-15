import SDGText

indirect enum TypeReference: Hashable {
  case simple(StrictString)
  case compound(identifier: StrictString, components: [TypeReference])
  case action(parameters: [TypeReference], returnValue: TypeReference?)
}

extension TypeReference {
  func resolving(fromReferenceLookup referenceLookup: [ReferenceDictionary]) -> TypeReference {
    switch self {
    case .simple(let identifier):
      return .simple(referenceLookup.resolve(identifier: identifier))
    case .compound(identifier: let identifier, components: let components):
      return .compound(
        identifier: referenceLookup.resolve(identifier: identifier),
        components: components.map({ $0.resolving(fromReferenceLookup: referenceLookup) })
      )
    case .action(parameters: let parameters, returnValue: let returnValue):
      return .action(
        parameters: parameters.map({ $0.resolving(fromReferenceLookup: referenceLookup) }),
        returnValue: returnValue.map({ $0.resolving(fromReferenceLookup: referenceLookup) })
      )
    }
  }
}
