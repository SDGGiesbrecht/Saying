import SDGText

enum TypeReference: Hashable {
  case simple(StrictString)
}

extension TypeReference {
  func resolving(fromReferenceDictionary dictionary: ReferenceDictionary) -> TypeReference {
    switch self {
    case .simple(let identifier):
      return .simple(dictionary.resolve(identifier: identifier))
    }
  }
}
