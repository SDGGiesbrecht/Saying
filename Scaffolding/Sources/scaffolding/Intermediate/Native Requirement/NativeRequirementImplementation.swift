import SDGText

struct NativeRequirementImplementationIntermediate {
  var textComponents: [UnicodeText]
  var parameters: [NativeActionImplementationParameter]
}

extension NativeRequirementImplementationIntermediate {

  static func construct(
    implementation: ParsedNativeActionExpression
  ) -> Result<NativeRequirementImplementationIntermediate, ErrorList<ConstructionError>> {
    let components = implementation.components
    var textComponents: [UnicodeText] = []
    var parameters: [NativeActionImplementationParameter] = []
    var errors: [ConstructionError] = []
    for index in components.indices {
      let element = components[index]
      switch element {
      case .parameter(let parameter):
        parameters.append(NativeActionImplementationParameter(parameter))
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
    return .success(
      NativeRequirementImplementationIntermediate(
        textComponents: textComponents,
        parameters: parameters
      )
    )
  }
}

extension NativeRequirementImplementationIntermediate {
  func specializing(
    typeLookup: [StrictString: ParsedTypeReference]
  ) -> NativeRequirementImplementationIntermediate {
    return NativeRequirementImplementationIntermediate(
      textComponents: textComponents,
      parameters: parameters.map({ $0.specializing(typeLookup: typeLookup) })
    )
  }
}
