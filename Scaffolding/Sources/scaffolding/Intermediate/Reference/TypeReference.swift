import SDGText

indirect enum TypeReference: Hashable {
  case simple(StrictString)
  case action(parameters: [TypeReference], returnValue: TypeReference?)
}

extension TypeReference {
  func resolving(fromReferenceDictionary dictionary: ReferenceDictionary) -> TypeReference {
    switch self {
    case .simple(let identifier):
      return .simple(dictionary.resolve(identifier: identifier))
    case .action(parameters: let parameters, returnValue: let returnValue):
      return .action(
        parameters: parameters.map({ $0.resolving(fromReferenceDictionary: dictionary) }),
        returnValue: returnValue.map({ $0.resolving(fromReferenceDictionary: dictionary) })
      )
    }
  }
}
