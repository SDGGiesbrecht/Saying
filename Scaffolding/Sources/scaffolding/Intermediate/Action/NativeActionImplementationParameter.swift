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
    let lookupName: StrictString
    switch typeInstead {
    case .simple(let simple):
      lookupName = simple.identifier
    case .compound, .action, .statements:
      #warning("Not implemented yet.")
      lookupName = ""
    case .none:
      lookupName = name
    }
    return NativeActionImplementationParameter(
      name: name,
      syntaxNode: syntaxNode,
      typeInstead: typeLookup[lookupName]
    )
  }
}
