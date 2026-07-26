struct ParameterIntermediate {
  var names: Set<UnicodeText>
  var type: ParsedTypeReference
  var passage: ParameterPassage
  var passAction: ActionIntermediate
  var executeAction: ActionIntermediate?
  var nativeNames: NativeActionNamesIntermediate
  var swiftLabel: UnicodeText?

  init(
    names: Set<UnicodeText>,
    type: ParsedTypeReference,
    passage: ParameterPassage,
    passAction: ActionIntermediate,
    executeAction: ActionIntermediate?,
    nativeNames: NativeActionNamesIntermediate,
    swiftLabel: UnicodeText?
  ) {
    self.names = names
    self.type = type
    self.passage = passage
    self.passAction = passAction
    self.executeAction = executeAction
    self.nativeNames = nativeNames
    self.swiftLabel = swiftLabel
  }
}

extension ParameterIntermediate {
  static func nativeParameterStub(
    names: Set<UnicodeText>,
    type: ParsedTypeReference,
    passage: ParameterPassage = .into
  ) -> ParameterIntermediate {
    return ParameterIntermediate(
      names: names,
      type: type,
      passage: passage,
      passAction: .parameterAction(names: names, parameters: .none, returnValue: type),
      executeAction: nil,
      nativeNames: NativeActionNamesIntermediate.none,
      swiftLabel: nil
    )
  }
}

extension ParameterIntermediate: InterpolationParameterProtocol {}

extension ParameterIntermediate {
  init(
    names: Set<UnicodeText>,
    nestedParameters: Interpolation<ParameterIntermediate>,
    returnValue: ParsedTypeReference,
    passage: ParameterPassage,
    nativeNames: NativeActionNamesIntermediate,
    swiftLabel: UnicodeText?
  ) {
    let actionParameters = nestedParameters.ordered(for: names.identifier())
    let passedType: ParsedTypeReference
    var executeAction: ActionIntermediate?
    switch returnValue {
    case .simple, .compound, .statements, .partReference, .enumerationCase:
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
      passage: passage,
      passAction: passAction,
      executeAction: executeAction,
      nativeNames: nativeNames,
      swiftLabel: swiftLabel
    )
  }
}

extension ParameterIntermediate {
  func resolvingExtensionContext(
    typeLookup: [UnicodeText: UnicodeText]
  ) -> ParameterIntermediate {
    return ParameterIntermediate(
      names: names,
      type: type.resolvingExtensionContext(typeLookup: typeLookup),
      passage: passage,
      passAction: passAction.resolvingExtensionContext(typeLookup: typeLookup),
      executeAction: executeAction?.resolvingExtensionContext(typeLookup: typeLookup),
      nativeNames: nativeNames,
      swiftLabel: swiftLabel
    )
  }
  func merging(requirement: ParameterIntermediate) -> ParameterIntermediate {
    return ParameterIntermediate(
      names: names.union(requirement.names),
      type: type,
      passage: passage,
      passAction: passAction,
      executeAction: executeAction,
      nativeNames: nativeNames.merging(requirement: requirement.nativeNames),
      swiftLabel: swiftLabel ?? requirement.swiftLabel
    )
  }
  func specializing(
    for use: UseIntermediate,
    typeLookup: [UnicodeText: ParsedTypeReference],
    specializationNamespace: [Set<UnicodeText>]
  ) -> ParameterIntermediate {
    return ParameterIntermediate(
      names: names,
      type: type.specializing(typeLookup: typeLookup),
      passage: passage,
      passAction: passAction.specializing(
        for: use,
        typeLookup: typeLookup,
        specializationNamespace: specializationNamespace
      ),
      executeAction: executeAction?.specializing(
        for: use,
        typeLookup: typeLookup,
        specializationNamespace: specializationNamespace
      ),
      nativeNames: nativeNames,
      swiftLabel: swiftLabel
    )
  }
}

extension ParameterIntermediate {
  func removingNativeNames() -> ParameterIntermediate {
    var copy = self
    copy.nativeNames = .none
    return copy
  }
  func prefixing(with prefix: UnicodeText) -> ParameterIntermediate {
    return ParameterIntermediate(
      names: Set(names.map({ "\(prefix)\($0)" })),
      type: type,
      passage: passage,
      passAction: passAction,
      executeAction: executeAction,
      nativeNames: nativeNames,
      swiftLabel: swiftLabel
    )
  }
}
