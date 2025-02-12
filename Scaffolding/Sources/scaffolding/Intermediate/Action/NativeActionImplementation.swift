import SDGText

struct NativeActionImplementationIntermediate {
  var textComponents: [UnicodeText]
  var parameters: [NativeActionImplementationParameter]
  var requiredImport: UnicodeText?
  var requiredDeclarations: [NativeRequirementImplementationIntermediate] = []
}

extension NativeActionImplementationIntermediate {

  static func construct(
    implementation: ParsedNativeAction
  ) -> Result<NativeActionImplementationIntermediate, ErrorList<ConstructionError>> {
    let components = implementation.expression.components
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
    let requiredImport = implementation.importNode?.importNode.identifierText()
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
    return .success(
      NativeActionImplementationIntermediate(
        textComponents: textComponents,
        parameters: parameters,
        requiredImport: requiredImport,
        requiredDeclarations: requiredDeclarations
      )
    )
  }
}

extension NativeActionImplementationIntermediate {
  func specializing(
    typeLookup: [StrictString: ParsedTypeReference]
  ) -> NativeActionImplementationIntermediate {
    return NativeActionImplementationIntermediate(
      textComponents: textComponents,
      parameters: parameters.map({ $0.specializing(typeLookup: typeLookup) }),
      requiredImport: requiredImport,
      requiredDeclarations: requiredDeclarations.map({ $0.specializing(typeLookup: typeLookup) })
    )
  }
}
