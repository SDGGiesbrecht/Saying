import SDGText

struct AbilityParameterIntermediate {
  var names: Set<StrictString>
}

extension AbilityParameterIntermediate: InterpolationParameterProtocol {}
