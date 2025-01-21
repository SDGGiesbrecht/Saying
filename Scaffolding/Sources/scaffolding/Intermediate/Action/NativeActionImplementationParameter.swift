import SDGText

struct NativeActionImplementationParameter {
  var name: UnicodeText
  var syntaxNode: ParsedUninterruptedIdentifier
  var typeInstead: ParsedTypeReference?
  var caseInstead: ParsedTypeReference?
}

extension NativeActionImplementationParameter {
  init(_ parameter: ParsedUninterruptedIdentifier, typeInstead: ParsedTypeReference? = nil, caseInstead: ParsedTypeReference? = nil) {
    name = parameter.identifierText()
    syntaxNode = parameter
    self.typeInstead = typeInstead
    self.caseInstead = caseInstead
  }
}

extension NativeActionImplementationParameter {
  func specializing(
    typeLookup: [StrictString: ParsedTypeReference]
  ) -> NativeActionImplementationParameter {
    return NativeActionImplementationParameter(
      name: name,
      syntaxNode: syntaxNode,
      typeInstead: typeLookup[StrictString(name)] ?? typeInstead?.specializing(typeLookup: typeLookup),
      caseInstead: typeLookup[StrictString(name)] ?? caseInstead?.specializing(typeLookup: typeLookup)
    )
  }
}
