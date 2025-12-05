struct NativeActionImplementationParameter {
  var name: UnicodeText
  var syntaxNode: ParsedUninterruptedIdentifier
  var typeInstead: ParsedTypeReference?
  var caseInstead: ParsedTypeReference?
  var hold: Bool
  var release: Bool
  var copy: Bool
  var held: Bool
  var sanitizedForIdentifier: Bool
  var remainderOfScope: Bool
}

extension NativeActionImplementationParameter {

  init(
    _ parameter: ParsedUninterruptedIdentifier,
    typeInstead: ParsedTypeReference? = nil,
    caseInstead: ParsedTypeReference? = nil,
    hold: Bool = false
  ) {
    name = parameter.identifierText()
    syntaxNode = parameter
    self.typeInstead = typeInstead
    self.caseInstead = caseInstead
    self.hold = hold
    self.release = false
    self.copy = false
    self.held = false
    self.sanitizedForIdentifier = false
    self.remainderOfScope = false
  }

  static func construct(
    _ parameter: ParsedImplementationParameter,
    typeInstead: ParsedTypeReference? = nil,
    caseInstead: ParsedTypeReference? = nil
  ) -> Result<NativeActionImplementationParameter, ErrorList<NativeActionImplementationParameter.ConstructionError>> {
    var errors: [NativeActionImplementationParameter.ConstructionError] = []

    let name: UnicodeText
    let syntaxNode: ParsedUninterruptedIdentifier
    var hold = false
    var release = false
    var copy = false
    var held = false
    var sanitizedForIdentifier = false
    var remainderOfScope = false
    switch parameter {
    case .simple(let simple):
      name = simple.identifierText()
      syntaxNode = simple
    case .modified(let modified):
      name = modified.parameter.identifierText()
      syntaxNode = modified.parameter
      switch modified.identifierText() {
      case "hold on ()":
        hold = true
      case "release of ()":
        release = true
      case "copy of ()":
        copy = true
      case "held ()":
        held = true
      case "() sanitized for identifier":
        sanitizedForIdentifier = true
      case "remainder of ()":
        remainderOfScope = true
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
        hold: hold,
        release: release,
        copy: copy,
        held: held,
        sanitizedForIdentifier: sanitizedForIdentifier,
        remainderOfScope: remainderOfScope
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
      hold: hold,
      release: release,
      copy: copy,
      held: held,
      sanitizedForIdentifier: sanitizedForIdentifier,
      remainderOfScope: remainderOfScope
    )
  }
}
