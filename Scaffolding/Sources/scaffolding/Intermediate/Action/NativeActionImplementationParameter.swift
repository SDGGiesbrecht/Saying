struct NativeActionImplementationParameter {
  var name: UnicodeText
  var syntaxNode: ParsedUninterruptedIdentifier
  var typeInstead: ParsedTypeReference?
  var caseInstead: ParsedTypeReference?
}

extension NativeActionImplementationParameter {

  init(
    _ parameter: ParsedUninterruptedIdentifier,
    typeInstead: ParsedTypeReference? = nil,
    caseInstead: ParsedTypeReference? = nil
  ) {
    name = parameter.identifierText()
    syntaxNode = parameter
    self.typeInstead = typeInstead
    self.caseInstead = caseInstead
  }

  static func construct(
    _ parameter: ParsedImplementationParameter,
    typeInstead: ParsedTypeReference? = nil,
    caseInstead: ParsedTypeReference? = nil
  ) -> Result<NativeActionImplementationParameter, ErrorList<NativeActionImplementationParameter.ConstructionError>> {
    var errors: [NativeActionImplementationParameter.ConstructionError] = []

    let name: UnicodeText
    let syntaxNode: ParsedUninterruptedIdentifier
    switch parameter {
    case .simple(let simple):
      name = simple.identifierText()
      syntaxNode = simple
    case .modified(let modified):
      name = modified.parameter.identifierText()
      syntaxNode = modified.parameter
      switch modified.identifierText() {
      case "modified ()":
        break
      default:
        errors.append(.unknownModifier(modified))
      }
    }

    if !errors.isEmpty {
      return .failure(ErrorList(errors))
    }
    return .success(
      NativeActionImplementationParameter(
        name: name,
        syntaxNode: syntaxNode,
        typeInstead: typeInstead,
        caseInstead: caseInstead
      )
    )
  }
}

extension NativeActionImplementationParameter {
  func specializing(
    typeLookup: [UnicodeText: ParsedTypeReference]
  ) -> NativeActionImplementationParameter {
    return NativeActionImplementationParameter(
      name: name,
      syntaxNode: syntaxNode,
      typeInstead: typeLookup[name] ?? typeInstead?.specializing(typeLookup: typeLookup),
      caseInstead: typeLookup[name] ?? caseInstead?.specializing(typeLookup: typeLookup)
    )
  }
}
