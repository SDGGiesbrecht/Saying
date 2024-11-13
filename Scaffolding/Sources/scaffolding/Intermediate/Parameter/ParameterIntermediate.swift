import SDGCollections
import SDGText

struct ParameterIntermediate {
  var names: Set<StrictString>
  var type: ParsedTypeReference
  var passAction: ActionIntermediate
  var executeAction: ActionIntermediate?
}

extension ParameterIntermediate: InterpolationParameterProtocol {}

extension ParameterIntermediate {
  init(
    names: Set<StrictString>,
    nestedParameters: Interpolation<ParameterIntermediate>,
    returnValue: ParsedTypeReference
  ) {
    let actionParameters = nestedParameters.ordered(for: names.identifier())
    let passedType: ParsedTypeReference
    var executeAction: ActionIntermediate?
    switch returnValue {
    case .simple, .compound:
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
      passAction: passAction,
      executeAction: executeAction
    )
  }
}

extension ParameterIntermediate {
  func merging(requirement: ParameterIntermediate) -> ParameterIntermediate {
    return ParameterIntermediate(
      names: names ∪ requirement.names,
      type: type,
      passAction: passAction,
      executeAction: executeAction
    )
  }
  func specializing(
    for use: UseIntermediate,
    typeLookup: [StrictString: SimpleTypeReference],
    specializationNamespace: [Set<StrictString>]
  ) -> ParameterIntermediate {
    return ParameterIntermediate(
      names: names,
      type: type.specializing(typeLookup: typeLookup),
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
