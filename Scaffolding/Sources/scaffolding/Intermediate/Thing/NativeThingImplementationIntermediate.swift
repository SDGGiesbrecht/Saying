import SDGText

struct NativeThingImplementationIntermediate {
  var textComponents: [UnicodeText]
  var parameters: [NativeThingImplementationParameter]
  var hold: UnicodeText?
  var release: UnicodeText?
  var requiredImport: UnicodeText?
  var requiredDeclarations: [NativeRequirementImplementationIntermediate]
}

extension NativeThingImplementationIntermediate {

  static func construct(
    implementation: ParsedNativeThing
  ) -> Result<NativeThingImplementationIntermediate, ErrorList<ConstructionError>> {
    var errors: [ConstructionError] = []
    let type: ParsedNativeThingReference
    var holdAction: ParsedLiteral?
    var releaseAction: ParsedLiteral?
    switch implementation.type {
    case .referenceCounted(let referenceCounted):
      type = referenceCounted.type
      holdAction = referenceCounted.hold
      releaseAction = referenceCounted.release
    case .simple(let simple):
      type = simple
    }
    let components = type.components
    var textComponents: [UnicodeText] = []
    var parameters: [NativeThingImplementationParameter] = []
    for index in components.indices {
      let element = components[index]
      switch element {
      case .parameter(let parameter):
        parameters.append(NativeThingImplementationParameter(parameter))
      case .literal(let literal):
        switch LiteralIntermediate.construct(literal: literal) {
        case .failure(let error):
          errors.append(contentsOf: error.errors.map({ ConstructionError.literalError($0) }))
        case .success(let literal):
          textComponents.append(UnicodeText(StrictString(literal.string)))
        }
      }
    }
    var nativeHold: UnicodeText?
    if let hold = holdAction {
      switch LiteralIntermediate.construct(literal: hold) {
      case .failure(let error):
        errors.append(contentsOf: error.errors.map({ ConstructionError.literalError($0) }))
      case .success(let success):
        nativeHold = UnicodeText(StrictString(success.string))
      }
    }
    var nativeRelease: UnicodeText?
    if let release = releaseAction {
      switch LiteralIntermediate.construct(literal: release) {
      case .failure(let error):
        errors.append(contentsOf: error.errors.map({ ConstructionError.literalError($0) }))
      case .success(let success):
        nativeRelease = UnicodeText(StrictString(success.string))
      }
    }
    var requiredImport: UnicodeText?
    if let importLiteral = implementation.importNode?.importNode {
      switch LiteralIntermediate.construct(literal: importLiteral) {
      case .failure(let error):
        errors.append(contentsOf: error.errors.map({ ConstructionError.literalError($0) }))
      case .success(let literal):
        requiredImport = UnicodeText(StrictString(literal.string))
      }
    }
    var requiredDeclarations: [NativeRequirementImplementationIntermediate] = []
    if let requirements = implementation.requirementsNode?.requirements {
      switch NativeRequirementImplementationIntermediate.construct(implementation: requirements) {
      case .failure(let error):
        errors.append(contentsOf: error.errors.map({ ConstructionError.nativeRequirementError($0) }))
      case .success(let constructed):
        requiredDeclarations.append(constructed)
      }
    }
    if !errors.isEmpty {
      return .failure(ErrorList(errors))
    }
    return .success(NativeThingImplementationIntermediate(
      textComponents: textComponents,
      parameters: parameters,
      hold: nativeHold,
      release: nativeRelease,
      requiredImport: requiredImport,
      requiredDeclarations: requiredDeclarations
    ))
  }
}

extension NativeThingImplementationIntermediate {

  func resolvingExtensionContext(
    typeLookup: [StrictString: UnicodeText]
  ) -> NativeThingImplementationIntermediate {
    let mappedParameters = parameters.map({ parameter in
      return NativeThingImplementationParameter(
        name: typeLookup[StrictString(parameter.name)] ?? parameter.name,
        syntaxNode: parameter.syntaxNode
      )
    })
    return NativeThingImplementationIntermediate(
      textComponents: textComponents,
      parameters: mappedParameters,
      hold: hold,
      release: release,
      requiredImport: requiredImport,
      requiredDeclarations: requiredDeclarations.map({ $0.resolvingExtensionContext(typeLookup: typeLookup) })
    )
  }

  func specializing(
    typeLookup: [StrictString: ParsedTypeReference]
  ) -> NativeThingImplementationIntermediate {
    let mappedParameters = parameters.map { $0.specializing(typeLookup: typeLookup) }
    return NativeThingImplementationIntermediate(
      textComponents: textComponents,
      parameters: mappedParameters,
      hold: hold,
      release: release,
      requiredImport: requiredImport,
      requiredDeclarations: requiredDeclarations.map({ $0.specializing(typeLookup: typeLookup) })
    )
  }
}
