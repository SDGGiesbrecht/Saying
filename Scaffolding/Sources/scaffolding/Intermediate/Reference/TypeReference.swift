indirect enum TypeReference: Hashable {
  case simple(UnicodeText)
  case compound(identifier: UnicodeText, components: [TypeReference])
  case action(parameters: [TypeReference], returnValue: TypeReference?)
  case statements
  case partReference(TypeReference, identifier: UnicodeText)
  case enumerationCase(TypeReference, identifier: UnicodeText)
}

extension TypeReference {
  func resolving(fromReferenceLookup referenceLookup: [ReferenceDictionary]) -> TypeReference {
    switch self {
    case .simple(let identifier):
      return .simple(referenceLookup.resolve(identifier: identifier))
    case .compound(identifier: let identifier, components: let components):
      return .compound(
        identifier: referenceLookup.resolve(identifier: UnicodeText(identifier)),
        components: components.map({ $0.resolving(fromReferenceLookup: referenceLookup) })
      )
    case .action(parameters: let parameters, returnValue: let returnValue):
      return .action(
        parameters: parameters.map({ $0.resolving(fromReferenceLookup: referenceLookup) }),
        returnValue: returnValue.map({ $0.resolving(fromReferenceLookup: referenceLookup) })
      )
    case .statements:
      return .statements
    case .partReference(let type, let identifier):
      return .partReference(
        type.resolving(fromReferenceLookup: referenceLookup),
        identifier: referenceLookup.resolve(identifier: UnicodeText(identifier))
      )
    case .enumerationCase(let type, let identifier):
      return .enumerationCase(
        type.resolving(fromReferenceLookup: referenceLookup),
        identifier: referenceLookup.resolve(identifier: UnicodeText(identifier))
      )
    }
  }
}
