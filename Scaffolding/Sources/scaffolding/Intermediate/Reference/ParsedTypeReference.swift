import SDGLogic
import SDGText

indirect enum ParsedTypeReference {
  case simple(SimpleTypeReference)
  case compound(identifier: ParsedUseSignature, components: [ParsedTypeReference])
  case action(parameters: [ParsedTypeReference], returnValue: ParsedTypeReference?)
}

extension ParsedTypeReference {
  init(_ identifier: ParsedUninterruptedIdentifier) {
    self = .simple(SimpleTypeReference(identifier))
  }
  init(_ reference: ParsedThingReference) {
    switch reference {
    case .simple(let simple):
      self.init(simple)
    case .compound(let compound):
      self = .compound(
        identifier: compound,
        components: compound.arguments.arguments.map({ ParsedTypeReference($0.name) })
      )
    }
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
    case .compound(identifier: let identifier, components: let components):
      return .compound(identifier: identifier.name(), components: components.map({ $0.key }))
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
    case .compound(identifier: let identifier, components: let components):
      return .compound(
        identifier: identifier,
        components: components.map({ $0.specializing(typeLookup: typeLookup) })
      )
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
      if let thing = referenceDictionary.lookupThing(simple.identifier, components: []) {
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
    case .compound(identifier: let identifier, components: let components):
      if let thing = referenceDictionary.lookupThing(
        identifier.name(),
        components: components.map({ $0.key })
      ) {
        if requiredAccess > thing.access {
          errors.append(.thingAccessNarrowerThanSignature(reference: identifier))
        }
        if ¬allowTestOnlyAccess,
          thing.testOnlyAccess {
          errors.append(.thingUnavailableOutsideTests(reference: identifier))
        }
      } else {
        errors.append(.noSuchThing(identifier.name(), reference: identifier))
      }
      for component in components {
        component.validateReferences(
          requiredAccess: requiredAccess,
          allowTestOnlyAccess: allowTestOnlyAccess,
          referenceDictionary: referenceDictionary,
          errors: &errors
        )
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
    case .compound(identifier: let identifier, components: let components):
      var result: [StrictString] = ["("]
      result.append(identifier.name())
      result.append(contentsOf: components.lazy.flatMap({ $0.unresolvedGloballyUniqueIdentifierComponents() }))
      result.append(")")
      return result
    case .action(parameters: let parameters, returnValue: let returnValue):
      var result: [StrictString] = ["(("]
      result.append(contentsOf: parameters.lazy.flatMap({ $0.unresolvedGloballyUniqueIdentifierComponents() }))
      result.append(contentsOf: returnValue.unresolvedGloballyUniqueIdentifierComponents())
      result.append("))")
      return result
    }
  }
}
extension Optional where Wrapped == ParsedTypeReference {
  func unresolvedGloballyUniqueIdentifierComponents() -> [StrictString] {
    return self?.unresolvedGloballyUniqueIdentifierComponents() ?? [""]
  }
}
