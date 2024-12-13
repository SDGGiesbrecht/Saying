import SDGCollections
import SDGText

struct ParameterIntermediate {
  var names: Set<StrictString>
  var type: ParsedTypeReference
  #warning("Collected, but not used yet.")
  var isThrough: Bool
  var passAction: ActionIntermediate
  var executeAction: ActionIntermediate?
}

extension ParameterIntermediate {
  static func nativeParameterStub(
    names: Set<StrictString>,
    type: ParsedTypeReference
  ) -> ParameterIntermediate {
    return ParameterIntermediate(
      names: names,
      type: type,
      isThrough: false,
      passAction: .parameterAction(names: names, parameters: .none, returnValue: type)
    )
  }
}

extension ParameterIntermediate: InterpolationParameterProtocol {}

extension ParameterIntermediate {
  init(
    names: Set<StrictString>,
    nestedParameters: Interpolation<ParameterIntermediate>,
    returnValue: ParsedTypeReference,
    isThrough: Bool
  ) {
    let actionParameters = nestedParameters.ordered(for: names.identifier())
    let passedType: ParsedTypeReference
    var executeAction: ActionIntermediate?
    switch returnValue {
    case .simple, .compound, .statements, .enumerationCase:
      passedType = returnValue
    case .action(parameters: _, returnValue: let actionReturn):
      passedType = .action(
        parameters: actionParameters.map({ $0.type }),
        returnValue: actionReturn
      )
      executeAction = .parameterAction(
        names: names,
        parameters: nestedParameters,
        returnValue: actionReturn
      )
    }
    let passAction: ActionIntermediate = .parameterAction(
      names: names,
      parameters: .none,
      returnValue: passedType
    )
    self.init(
      names: names,
      type: passedType,
      isThrough: isThrough,
      passAction: passAction,
      executeAction: executeAction
    )
  }
}

extension ParameterIntermediate {
  func resolvingExtensionContext(
    typeLookup: [StrictString: StrictString]
  ) -> ParameterIntermediate {
    return ParameterIntermediate(
      names: names,
      type: type.resolvingExtensionContext(typeLookup: typeLookup),
      isThrough: isThrough,
      passAction: passAction.resolvingExtensionContext(typeLookup: typeLookup),
      executeAction: executeAction?.resolvingExtensionContext(typeLookup: typeLookup)
    )
  }
  func merging(requirement: ParameterIntermediate) -> ParameterIntermediate {
    return ParameterIntermediate(
      names: names ∪ requirement.names,
      type: type,
      isThrough: isThrough,
      passAction: passAction,
      executeAction: executeAction
    )
  }
  func specializing(
    for use: UseIntermediate,
    typeLookup: [StrictString: ParsedTypeReference],
    specializationNamespace: [Set<StrictString>]
  ) -> ParameterIntermediate {
    return ParameterIntermediate(
      names: names,
      type: type.specializing(typeLookup: typeLookup),
      isThrough: isThrough,
      passAction: passAction.specializing(
        for: use,
        typeLookup: typeLookup,
        specializationNamespace: specializationNamespace
      ),
      executeAction: executeAction?.specializing(
        for: use,
        typeLookup: typeLookup,
        specializationNamespace: specializationNamespace
      )
    )
  }
}
