struct NativeActionImplementationParameter {
  var name: UnicodeText
  var syntaxNode: ParsedUninterruptedIdentifier
  var typeInstead: ParsedTypeReference?
  var caseInstead: ParsedTypeReference?
  var copy: Bool
  var hold: Bool
  var held: Bool
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
    self.copy = false
    self.hold = false
    self.held = false
  }

  static func construct(
    _ parameter: ParsedImplementationParameter,
    typeInstead: ParsedTypeReference? = nil,
    caseInstead: ParsedTypeReference? = nil
  ) -> Result<NativeActionImplementationParameter, ErrorList<NativeActionImplementationParameter.ConstructionError>> {
    var errors: [NativeActionImplementationParameter.ConstructionError] = []

    let name: UnicodeText
    let syntaxNode: ParsedUninterruptedIdentifier
    var copy = false
    var hold = false
    var held = false
    switch parameter {
    case .simple(let simple):
      name = simple.identifierText()
      syntaxNode = simple
    case .modified(let modified):
      name = modified.parameter.identifierText()
      syntaxNode = modified.parameter
      switch modified.identifierText() {
      case "copy of ()":
        copy = true
      case "hold on ()":
        hold = true
      case "held ()":
        held = true
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
        caseInstead: caseInstead,
        copy: copy,
        hold: hold,
        held: held
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
      caseInstead: typeLookup[name] ?? caseInstead?.specializing(typeLookup: typeLookup),
      copy: copy,
      hold: hold,
      held: held
    )
  }
}
