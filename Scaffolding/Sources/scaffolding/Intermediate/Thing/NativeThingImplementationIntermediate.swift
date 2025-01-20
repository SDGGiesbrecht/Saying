import SDGText

struct NativeThingImplementationIntermediate {
  var textComponents: [UnicodeText]
  var parameters: [NativeThingImplementationParameter]
  var requiredImport: UnicodeText?
}

extension NativeThingImplementationIntermediate {

  static func construct(
    implementation: ParsedNativeThing
  ) -> Result<NativeThingImplementationIntermediate, ErrorList<ConstructionError>> {
    var errors: [ConstructionError] = []
    let components = implementation.type.components
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
    if !errors.isEmpty {
      return .failure(ErrorList(errors))
    }
    return .success(NativeThingImplementationIntermediate(
      textComponents: textComponents,
      parameters: parameters,
      requiredImport: implementation.importNode?.importNode.identifierText()
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
      requiredImport: requiredImport
    )
  }

  func specializing(
    typeLookup: [StrictString: ParsedTypeReference]
  ) -> NativeThingImplementationIntermediate {
    let mappedParameters = parameters.map { $0.specializing(typeLookup: typeLookup) }
    return NativeThingImplementationIntermediate(
      textComponents: textComponents,
      parameters: mappedParameters,
      requiredImport: requiredImport
    )
  }
}
