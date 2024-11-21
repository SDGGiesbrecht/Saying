import SDGText

struct ThingParameterIntermediate {
  var names: Set<StrictString>
  var resolvedType: ParsedTypeReference?
}

extension ThingParameterIntermediate: InterpolationParameterProtocol {}

extension ThingParameterIntermediate {
  func specializing(
    typeLookup: [StrictString: ParsedTypeReference]
  ) -> ThingParameterIntermediate {
    let identifier = names.identifier()
    return ThingParameterIntermediate(
      names: names,
      resolvedType: typeLookup[identifier] ?? resolvedType?.specializing(typeLookup: typeLookup)
    )
  }
}
