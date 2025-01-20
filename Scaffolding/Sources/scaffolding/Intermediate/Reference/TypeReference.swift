import SDGText

indirect enum TypeReference: Hashable {
  case simple(StrictString)
  case compound(identifier: StrictString, components: [TypeReference])
  case action(parameters: [TypeReference], returnValue: TypeReference?)
  case statements
  case enumerationCase(TypeReference, identifier: StrictString)
}

extension TypeReference {
  func resolving(fromReferenceLookup referenceLookup: [ReferenceDictionary]) -> TypeReference {
    switch self {
    case .simple(let identifier):
      return .simple(StrictString(referenceLookup.resolve(identifier: UnicodeText(identifier))))
    case .compound(identifier: let identifier, components: let components):
      return .compound(
        identifier: StrictString(referenceLookup.resolve(identifier: UnicodeText(identifier))),
        components: components.map({ $0.resolving(fromReferenceLookup: referenceLookup) })
      )
    case .action(parameters: let parameters, returnValue: let returnValue):
      return .action(
        parameters: parameters.map({ $0.resolving(fromReferenceLookup: referenceLookup) }),
        returnValue: returnValue.map({ $0.resolving(fromReferenceLookup: referenceLookup) })
      )
    case .statements:
      return .statements
    case .enumerationCase(let type, let identifier):
      return .enumerationCase(
        type.resolving(fromReferenceLookup: referenceLookup),
        identifier: StrictString(referenceLookup.resolve(identifier: UnicodeText(identifier)))
      )
    }
  }
}
