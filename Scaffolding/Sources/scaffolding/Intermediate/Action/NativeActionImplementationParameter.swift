import SDGText

struct NativeActionImplementationParameter {
  var name: StrictString
  var syntaxNode: ParsedUninterruptedIdentifier
  var typeInstead: ParsedTypeReference?
}

extension NativeActionImplementationParameter {
  init(_ parameter: ParsedUninterruptedIdentifier) {
    name = parameter.identifierText()
    syntaxNode = parameter
    typeInstead = nil
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
