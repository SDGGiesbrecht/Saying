import SDGLogic
import SDGText

indirect enum ParsedTypeReference {
  case simple(SimpleTypeReference)
  case action(parameters: [ParsedTypeReference], returnValue: ParsedTypeReference?)
}

extension ParsedTypeReference {
  init(_ identifier: ParsedUninterruptedIdentifier) {
    self = .simple(SimpleTypeReference(identifier))
  }
  init(_ node: ParsedParameterType) {
    if node.yieldArrow == nil {
      self.init(node.type)
    } else {
      self = .action(parameters: [], returnValue: ParsedTypeReference(node.type))
    }
  }
}

extension ParsedTypeReference {
  var key: TypeReference {
    switch self {
    case .simple(let simple):
      return .simple(simple.identifier)
    case .action(parameters: let parameters, returnValue: let returnValue):
      return .action(parameters: parameters.map({ $0.key }), returnValue: returnValue.map({ $0.key }))
    }
  }
}

extension ParsedTypeReference {
  func specializing(typeLookup: [StrictString: SimpleTypeReference]) -> ParsedTypeReference {
    switch self {
    case .simple(let simple):
      if let found = typeLookup[simple.identifier] {
        return .simple(found)
      } else {
        return self
      }
    case .action(parameters: let parameters, returnValue: let returnValue):
      return .action(
        parameters: parameters.map({ $0.specializing(typeLookup: typeLookup) }),
        returnValue: returnValue.map({ $0.specializing(typeLookup: typeLookup) })
      )
    }
  }
}

extension ParsedTypeReference {
  func validateReferences(
    requiredAccess: AccessIntermediate,
    allowTestOnlyAccess: Bool,
    referenceDictionary: ReferenceDictionary,
    errors: inout [ReferenceError]
  ) {
    switch self {
    case .simple(let simple):
      if let thing = referenceDictionary.lookupThing(simple.identifier) {
        if requiredAccess > thing.access {
          errors.append(.thingAccessNarrowerThanSignature(reference: simple.syntaxNode))
        }
        if ¬allowTestOnlyAccess,
          thing.testOnlyAccess {
          errors.append(.thingUnavailableOutsideTests(reference: simple.syntaxNode))
        }
      } else {
        errors.append(.noSuchThing(simple.identifier, reference: simple.syntaxNode))
      }
    case .action(parameters: let parameters, returnValue: let returnValue):
      for parameter in parameters {
        parameter.validateReferences(
          requiredAccess: requiredAccess,
          allowTestOnlyAccess: allowTestOnlyAccess,
          referenceDictionary: referenceDictionary,
          errors: &errors
        )
      }
      returnValue?.validateReferences(
        requiredAccess: requiredAccess,
        allowTestOnlyAccess: allowTestOnlyAccess,
        referenceDictionary: referenceDictionary,
        errors: &errors
      )
    }
  }
}

extension ParsedTypeReference {
  func unresolvedGloballyUniqueIdentifierComponents() -> [StrictString] {
    switch self {
    case .simple(let simple):
      return [simple.identifier]
    case .action(parameters: let parameters, returnValue: let returnValue):
      var result: [StrictString] = ["("]
      result.append(contentsOf: parameters.lazy.flatMap({ $0.unresolvedGloballyUniqueIdentifierComponents() }))
      result.append(contentsOf: returnValue.unresolvedGloballyUniqueIdentifierComponents())
      result.append(")")
      return result
    }
  }
}
extension Optional where Wrapped == ParsedTypeReference {
  func unresolvedGloballyUniqueIdentifierComponents() -> [StrictString] {
    return self?.unresolvedGloballyUniqueIdentifierComponents() ?? [""]
  }
}
