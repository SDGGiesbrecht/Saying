import SDGText

struct NativeActionImplementationParameter {
  var name: StrictString
  var syntaxNode: ParsedUninterruptedIdentifier
  var typeInstead: SimpleTypeReference?
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
    typeLookup: [StrictString: SimpleTypeReference]
  ) -> NativeActionImplementationParameter {
    return NativeActionImplementationParameter(
      name: name,
      syntaxNode: syntaxNode,
      typeInstead: typeLookup[typeInstead?.identifier ?? name]
    )
  }
}
