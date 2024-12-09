import SDGText

struct NativeActionImplementationParameter {
  var name: StrictString
  var syntaxNode: ParsedUninterruptedIdentifier
  var typeInstead: ParsedTypeReference?
}

extension NativeActionImplementationParameter {
  init(_ parameter: ParsedUninterruptedIdentifier, typeInstead: ParsedTypeReference? = nil) {
    name = parameter.identifierText()
    syntaxNode = parameter
    self.typeInstead = typeInstead
  }
}

extension NativeActionImplementationParameter {
  func specializing(
    typeLookup: [StrictString: ParsedTypeReference]
  ) -> NativeActionImplementationParameter {
    return NativeActionImplementationParameter(
      name: name,
      syntaxNode: syntaxNode,
      typeInstead: typeLookup[name] ?? typeInstead?.specializing(typeLookup: typeLookup)
    )
  }
}
