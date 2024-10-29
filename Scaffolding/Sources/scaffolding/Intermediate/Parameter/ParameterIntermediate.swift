import SDGCollections
import SDGText

struct ParameterIntermediate {
  var names: Set<StrictString>
  var type: ParsedTypeReference
  var action: ActionIntermediate
}

extension ParameterIntermediate: InterpolationParameterProtocol {}

extension ParameterIntermediate {
  init(
    names: Set<StrictString>,
    nestedParameters: Interpolation<ParameterIntermediate>,
    returnValue: ParsedTypeReference
  ) {
    let actionParameters = nestedParameters.ordered(for: names.identifier())
    let type: ParsedTypeReference
    if actionParameters.isEmpty {
      type = returnValue
    } else {
      type = .action(
        parameters: actionParameters.map({ $0.type }),
        returnValue: returnValue
      )
    }
    let action: ActionIntermediate = .parameterAction(
      names: names,
      parameters: nestedParameters,
      returnValue: returnValue
    )
    self.init(
      names: names,
      type: type,
      action: action
    )
  }
}

extension ParameterIntermediate {
  func merging(requirement: ParameterIntermediate) -> ParameterIntermediate {
    return ParameterIntermediate(
      names: names ∪ requirement.names,
      type: type,
      action: action
    )
    #warning("Does action need merging? (Implementation will not call requirement names, but does external code need to know about the action?)")
  }
  func specializing(
    for use: UseIntermediate,
    typeLookup: [StrictString: SimpleTypeReference],
    specializationNamespace: [Set<StrictString>]
  ) -> ParameterIntermediate {
    return ParameterIntermediate(
      names: names,
      type: type.specializing(typeLookup: typeLookup),
      action: action.specializing(
        for: use,
        typeLookup: typeLookup,
        specializationNamespace: specializationNamespace
      )
    )
  }
}
