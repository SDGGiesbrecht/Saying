import SDGText

struct ThingParameterIntermediate {
  var names: Set<StrictString>
}

extension ThingParameterIntermediate: InterpolationParameterProtocol {}

extension ThingParameterIntermediate {
  func specializing(
    typeLookup: [StrictString: ParsedTypeReference]
  ) -> ThingParameterIntermediate {
    let identifier = names.identifier()
    let newName: StrictString
    switch typeLookup[identifier] {
    case .simple(let simple):
      newName = simple.identifier
    case .compound, .action, .statements, .none:
#warning("Not implemented yet.")
      newName = ""
    }
    return ThingParameterIntermediate(names: [newName])
  }
}
