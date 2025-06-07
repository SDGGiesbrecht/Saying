struct NativeThingImplementationIntermediate {
  var textComponents: [UnicodeText]
  var parameters: [NativeThingImplementationParameter]
  var hold: NativeActionExpressionIntermediate?
  var release: NativeActionExpressionIntermediate?
  var requiredImports: [UnicodeText]
  var indirectRequirements: [NativeRequirementImplementationIntermediate]
  var requiredDeclarations: [NativeRequirementImplementationIntermediate]
}

extension NativeThingImplementationIntermediate {

  static func construct(
    implementation: ParsedNativeThing
  ) -> Result<NativeThingImplementationIntermediate, ErrorList<ConstructionError>> {
    var errors: [ConstructionError] = []
    let type: ParsedNativeThingReference
    var holdAction: ParsedNativeActionExpression?
    var releaseAction: ParsedNativeActionExpression?
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
          textComponents.append(UnicodeText(literal.string))
        }
      }
    }
    var nativeHold: NativeActionExpressionIntermediate?
    if let hold = holdAction {
      switch NativeActionExpressionIntermediate.construct(expression: hold) {
      case .failure(let error):
        errors.append(contentsOf: error.errors.map({ ConstructionError.nativeExpressionError($0) }))
      case .success(let success):
        nativeHold = success
      }
    }
    var nativeRelease: NativeActionExpressionIntermediate?
    if let release = releaseAction {
      switch NativeActionExpressionIntermediate.construct(expression: release) {
      case .failure(let error):
        errors.append(contentsOf: error.errors.map({ ConstructionError.nativeExpressionError($0) }))
      case .success(let success):
        nativeRelease = success
      }
    }
    var requiredImports: [UnicodeText] = []
    for importLiteral in implementation.importNode?.imports.imports ?? [] {
      switch LiteralIntermediate.construct(literal: importLiteral) {
      case .failure(let error):
        errors.append(contentsOf: error.errors.map({ ConstructionError.literalError($0) }))
      case .success(let literal):
        requiredImports.append(UnicodeText(literal.string))
      }
    }
    var indirectRequirments: [NativeRequirementImplementationIntermediate] = []
    for requirement in implementation.indirectNode?.requirements.requirements ?? [] {
      switch NativeRequirementImplementationIntermediate.construct(implementation: requirement) {
      case .failure(let error):
        errors.append(contentsOf: error.errors.map({ ConstructionError.nativeRequirementError($0) }))
      case .success(let constructed):
        indirectRequirments.append(constructed)
      }
    }
    var requiredDeclarations: [NativeRequirementImplementationIntermediate] = []
    for requirement in implementation.code?.requirements.requirements ?? [] {
      switch NativeRequirementImplementationIntermediate.construct(implementation: requirement) {
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
      requiredImports: requiredImports,
      indirectRequirements: indirectRequirments,
      requiredDeclarations: requiredDeclarations
    ))
  }
}

extension NativeThingImplementationIntermediate {

  func resolvingExtensionContext(
    typeLookup: [UnicodeText: UnicodeText]
  ) -> NativeThingImplementationIntermediate {
    let mappedParameters = parameters.map({ parameter in
      return NativeThingImplementationParameter(
        name: typeLookup[parameter.name] ?? parameter.name,
        syntaxNode: parameter.syntaxNode
      )
    })
    return NativeThingImplementationIntermediate(
      textComponents: textComponents,
      parameters: mappedParameters,
      hold: hold,
      release: release,
      requiredImports: requiredImports,
      indirectRequirements: indirectRequirements.map({ $0.resolvingExtensionContext(typeLookup: typeLookup) }),
      requiredDeclarations: requiredDeclarations.map({ $0.resolvingExtensionContext(typeLookup: typeLookup) })
    )
  }

  func specializing(
    typeLookup: [UnicodeText: ParsedTypeReference]
  ) -> NativeThingImplementationIntermediate {
    let mappedParameters = parameters.map { $0.specializing(typeLookup: typeLookup) }
    return NativeThingImplementationIntermediate(
      textComponents: textComponents,
      parameters: mappedParameters,
      hold: hold,
      release: release,
      requiredImports: requiredImports,
      indirectRequirements: indirectRequirements.map({ $0.specializing(typeLookup: typeLookup) }),
      requiredDeclarations: requiredDeclarations.map({ $0.specializing(typeLookup: typeLookup) })
    )
  }
}
