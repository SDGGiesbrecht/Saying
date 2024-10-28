import SDGText

struct TypeReference: Hashable {
  var identifier: StrictString
}

extension TypeReference {
  func resolving(fromReferenceDictionary dictionary: ReferenceDictionary) -> TypeReference {
    let newIdentifier = dictionary.resolve(identifier: identifier)
    return TypeReference(identifier: newIdentifier)
  }
}
