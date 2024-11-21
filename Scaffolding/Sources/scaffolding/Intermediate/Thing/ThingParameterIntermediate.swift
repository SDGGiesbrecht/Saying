import SDGText

struct ThingParameterIntermediate {
  var names: Set<StrictString>
}

extension ThingParameterIntermediate: InterpolationParameterProtocol {}
