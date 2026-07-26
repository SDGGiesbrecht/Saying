struct ThingParameterIntermediate {
  var names: Set<UnicodeText>
  var resolvedType: ParsedTypeReference?
}

extension ThingParameterIntermediate: InterpolationParameterProtocol {}

extension ThingParameterIntermediate {
  func specializing(
    typeLookup: [UnicodeText: ParsedTypeReference]
  ) -> ThingParameterIntermediate {
    let identifier = names.identifier()
    return ThingParameterIntermediate(
      names: names,
      resolvedType: typeLookup[identifier] ?? resolvedType?.specializing(typeLookup: typeLookup)
    )
  }
}
