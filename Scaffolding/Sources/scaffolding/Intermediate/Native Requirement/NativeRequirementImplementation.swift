import SDGText

struct NativeRequirementImplementationIntermediate {
  var textComponents: [UnicodeText]
  var parameters: [NativeThingImplementationParameter]
}

extension NativeRequirementImplementationIntermediate {

  static func construct(
    implementation: ParsedNativeThingReference
  ) -> Result<NativeRequirementImplementationIntermediate, ErrorList<ConstructionError>> {
    let components = implementation.components
    var textComponents: [UnicodeText] = []
    var parameters: [NativeThingImplementationParameter] = []
    var errors: [ConstructionError] = []
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
    if !errors.isEmpty {
      return .failure(ErrorList(errors))
    }
    return .success(
      NativeRequirementImplementationIntermediate(
        textComponents: textComponents,
        parameters: parameters
      )
    )
  }
}

extension NativeRequirementImplementationIntermediate {
  func resolvingExtensionContext(
    typeLookup: [StrictString: UnicodeText]
  ) -> NativeRequirementImplementationIntermediate {
    let mappedParameters = parameters.map({ parameter in
      return NativeThingImplementationParameter (
        name: typeLookup[StrictString(parameter.name)] ?? parameter.name,
        syntaxNode: parameter.syntaxNode
      )
    })
    return NativeRequirementImplementationIntermediate(
      textComponents: textComponents,
      parameters: mappedParameters
    )
  }

  func specializing(
    typeLookup: [StrictString: ParsedTypeReference]
  ) -> NativeRequirementImplementationIntermediate {
    return NativeRequirementImplementationIntermediate(
      textComponents: textComponents,
      parameters: parameters.map({ $0.specializing(typeLookup: typeLookup) })
    )
  }
}
