import SDGText

indirect enum ParsedTypeReference {
  case simple(SimpleTypeReference)
  case compound(identifier: ParsedUseSignature, components: [ParsedTypeReference])
  case action(parameters: [ParsedTypeReference], returnValue: ParsedTypeReference?)
  case statements
  case enumerationCase(enumeration: ParsedTypeReference, identifier: StrictString)
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
    switch node {
    case .type(let typeNode):
      if typeNode.yieldArrow == nil {
        self.init(typeNode.type)
      } else {
        self = .action(parameters: [], returnValue: ParsedTypeReference(typeNode.type))
      }
    case .statements:
      self = .statements
    }
  }
  init?(_ node: ParsedThingSignature) {
    let reference: ParsedThingReference
    switch node {
    case .compound(let compound):
      let first: ParsedUseArgumentType
      switch compound.parameters.first {
      case .type(let type):
        first = ParsedUseArgumentType(
          openingParenthesis: type.openingParenthesis,
          name: ParsedThingReference.simple(type.name),
          closingParenthesis: type.closingParenthesis
        )
      case .reference:
        return nil
      }
      var continuations: [ParsedUseArgumentListContinuation] = []
      for continuation in compound.parameters.continuations {
        switch continuation.parameter {
        case .type(let type):
          continuations.append(
            ParsedUseArgumentListContinuation(
              identifierSegment: continuation.identifierSegment,
              argument: ParsedUseArgumentType(
                openingParenthesis: type.openingParenthesis,
                name: ParsedThingReference.simple(type.name),
                closingParenthesis: type.closingParenthesis
              )
            )
          )
        case .reference:
          return nil
        }
      }
      reference = .compound(
        ParsedUseSignature(
          initialIdentifierSegment: compound.initialIdentifierSegment,
          arguments: ParsedUseArgumentList(
            first: first,
            continuations: continuations
          ),
          finalIdentifierSegment: compound.finalIdentifierSegment
        )
      )
    case .simple(let simple):
      reference = .simple(simple)
    }
    self.init(reference)
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
    case .statements:
      return .statements
    case .enumerationCase(enumeration: let enumeration, identifier: let identifier):
      return .enumerationCase(enumeration.key, identifier: identifier)
    }
  }
}

extension ParsedTypeReference {
  func resolvingExtensionContext(
    typeLookup: [StrictString: StrictString]
  ) -> ParsedTypeReference {
    switch self {
    case .simple(let simple):
      if let found = typeLookup[simple.identifier] {
        var modified = simple
        modified.identifier = found
        return .simple(modified)
      } else {
        return self
      }
    case .compound(identifier: let identifier, components: let components):
      return .compound(
        identifier: identifier,
        components: components.map({ $0.resolvingExtensionContext(typeLookup: typeLookup) })
      )
    case .action(parameters: let parameters, returnValue: let returnValue):
      return .action(
        parameters: parameters.map({ $0.resolvingExtensionContext(typeLookup: typeLookup) }),
        returnValue: returnValue.map({ $0.resolvingExtensionContext(typeLookup: typeLookup) })
      )
    case .statements:
      return .statements
    case .enumerationCase(enumeration: let enumeration, identifier: let identifier):
      return .enumerationCase(
        enumeration: enumeration.resolvingExtensionContext(typeLookup: typeLookup),
        identifier: identifier
      )
    }
  }

  func specializing(typeLookup: [StrictString: ParsedTypeReference]) -> ParsedTypeReference {
    switch self {
    case .simple(let simple):
      if let found = typeLookup[simple.identifier] {
        return found
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
    case .statements:
      return .statements
    case .enumerationCase(enumeration: let enumeration, identifier: let identifier):
      return .enumerationCase(
        enumeration: enumeration.specializing(typeLookup: typeLookup),
        identifier: identifier
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
        if !allowTestOnlyAccess,
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
        if !allowTestOnlyAccess,
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
    case .statements:
      break
    case .enumerationCase(enumeration: let enumeration, identifier: _):
      enumeration.validateReferences(
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
    case .statements:
      return ["{}"]
    case .enumerationCase(enumeration: let enumeration, identifier: let identifier):
      var result: [StrictString] = ["((("]
      result.append(contentsOf: enumeration.unresolvedGloballyUniqueIdentifierComponents())
      result.append("•")
      result.append(identifier)
      result.append(")))")
      return result
    }
  }
}
extension Optional where Wrapped == ParsedTypeReference {
  func unresolvedGloballyUniqueIdentifierComponents() -> [StrictString] {
    return self?.unresolvedGloballyUniqueIdentifierComponents() ?? [""]
  }
}

extension ParsedTypeReference {
  func requiredIdentifiers(
    referenceDictionary: ReferenceDictionary
  ) -> [StrictString] {
    var result: [StrictString] = []
    switch self {
    case .simple(let simple):
      if let thing = referenceDictionary.lookupThing(simple.identifier, components: []) {
        result.append(thing.globallyUniqueIdentifier(referenceLookup: [referenceDictionary]))
      }
    case .compound(identifier: let identifier, components: let components):
      if let thing = referenceDictionary.lookupThing(
        identifier.name(),
        components: components.map({ $0.key })
      ) {
        result.append(thing.globallyUniqueIdentifier(referenceLookup: [referenceDictionary]))
      }
      for component in components {
        result.append(
          contentsOf: component.requiredIdentifiers(
            referenceDictionary: referenceDictionary
          )
        )
      }
    case .action(parameters: let parameters, returnValue: let returnValue):
      for parameter in parameters {
        result.append(
          contentsOf: parameter.requiredIdentifiers(
            referenceDictionary: referenceDictionary
          )
        )
      }
      if let value = returnValue {
        result.append(
          contentsOf: value.requiredIdentifiers(
            referenceDictionary: referenceDictionary
          )
        )
      }
    case .statements:
      break
    case .enumerationCase(enumeration: let enumeration, identifier: _):
      result.append(
        contentsOf: enumeration.requiredIdentifiers(
          referenceDictionary: referenceDictionary
        )
      )
    }
    return result
  }
}
