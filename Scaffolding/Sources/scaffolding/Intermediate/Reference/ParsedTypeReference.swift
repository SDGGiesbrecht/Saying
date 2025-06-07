indirect enum ParsedTypeReference {
  case simple(SimpleTypeReference)
  case compound(identifier: ParsedUseSignature, components: [ParsedTypeReference])
  case action(parameters: [ParsedTypeReference], returnValue: ParsedTypeReference?)
  case statements
  case partReference(container: ParsedTypeReference, identifier: UnicodeText)
  case enumerationCase(enumeration: ParsedTypeReference, identifier: UnicodeText)
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
    case .partReference(container: let container, identifier: let identifier):
      return .partReference(container.key, identifier: identifier)
    case .enumerationCase(enumeration: let enumeration, identifier: let identifier):
      return .enumerationCase(enumeration.key, identifier: identifier)
    }
  }
}

extension ParsedTypeReference {
  func resolvingExtensionContext(
    typeLookup: [UnicodeText: UnicodeText]
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
    case .partReference(container: let container, identifier: let identifier):
      return .partReference(
        container: container.resolvingExtensionContext(typeLookup: typeLookup),
        identifier: identifier
      )
    case .enumerationCase(enumeration: let enumeration, identifier: let identifier):
      return .enumerationCase(
        enumeration: enumeration.resolvingExtensionContext(typeLookup: typeLookup),
        identifier: identifier
      )
    }
  }

  func specializing(typeLookup: [UnicodeText: ParsedTypeReference]) -> ParsedTypeReference {
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
    case .partReference(container: let container, identifier: let identifier):
      return .partReference(
        container: container.specializing(typeLookup: typeLookup),
        identifier: identifier
      )
    case .enumerationCase(enumeration: let enumeration, identifier: let identifier):
      return .enumerationCase(
        enumeration: enumeration.specializing(typeLookup: typeLookup),
        identifier: identifier
      )
    }
  }
}

extension ParsedTypeReference {
  func derivedAccessLimit(referenceLookup: [ReferenceDictionary]) -> AccessIntermediate {
    switch self {
    case .simple(let simple):
      return referenceLookup.lookupThing(simple.identifier, components: [])?.access ?? .clients
    case .compound(identifier: let identifier, components: let components):
      var limit: AccessIntermediate = .clients
      if let thing = referenceLookup.lookupThing(
        identifier.name(),
        components: components.map({ $0.key })
      ) {
        limit = min(limit, thing.access)
      }
      for component in components {
        limit = min(limit, component.derivedAccessLimit(referenceLookup: referenceLookup))
      }
      return limit
    case .action(parameters: let parameters, returnValue: let returnValue):
      var limit: AccessIntermediate = .clients
      for parameter in parameters {
        limit = min(limit, parameter.derivedAccessLimit(referenceLookup: referenceLookup))
      }
      if let childLimit = returnValue?.derivedAccessLimit(referenceLookup: referenceLookup) {
        limit = min(limit, childLimit)
      }
      return limit
    case .statements:
      return .clients
    case .partReference(container: let type, identifier: _),
      .enumerationCase(enumeration: let type, identifier: _):
      return type.derivedAccessLimit(referenceLookup: referenceLookup)
    }
  }
  func derivedTestAccess(referenceLookup: [ReferenceDictionary]) -> Bool {
    switch self {
    case .simple(let simple):
      return referenceLookup.lookupThing(simple.identifier, components: [])?.testOnlyAccess ?? false
    case .compound(identifier: let identifier, components: let components):
      var limit = false
      if let thing = referenceLookup.lookupThing(
        identifier.name(),
        components: components.map({ $0.key })
      ) {
        limit = limit || thing.testOnlyAccess
      }
      for component in components {
        limit = limit || component.derivedTestAccess(referenceLookup: referenceLookup)
      }
      return limit
    case .action(parameters: let parameters, returnValue: let returnValue):
      var limit = false
      for parameter in parameters {
        limit = limit || parameter.derivedTestAccess(referenceLookup: referenceLookup)
      }
      if let childLimit = returnValue?.derivedTestAccess(referenceLookup: referenceLookup) {
        limit = limit || childLimit
      }
      return limit
    case .statements:
      return false
    case .partReference(container: let type, identifier: _),
      .enumerationCase(enumeration: let type, identifier: _):
      return type.derivedTestAccess(referenceLookup: referenceLookup)
    }
  }
}

extension ParsedTypeReference {
  func validateReferences(
    requiredAccess: AccessIntermediate,
    allowTestOnlyAccess: Bool,
    referenceLookup: [ReferenceDictionary],
    errors: inout [ReferenceError]
  ) {
    switch self {
    case .simple(let simple):
      if let thing = referenceLookup.lookupThing(simple.identifier, components: []) {
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
      if let thing = referenceLookup.lookupThing(
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
          referenceLookup: referenceLookup,
          errors: &errors
        )
      }
    case .action(parameters: let parameters, returnValue: let returnValue):
      for parameter in parameters {
        parameter.validateReferences(
          requiredAccess: requiredAccess,
          allowTestOnlyAccess: allowTestOnlyAccess,
          referenceLookup: referenceLookup,
          errors: &errors
        )
      }
      returnValue?.validateReferences(
        requiredAccess: requiredAccess,
        allowTestOnlyAccess: allowTestOnlyAccess,
        referenceLookup: referenceLookup,
        errors: &errors
      )
    case .statements:
      break
    case .partReference(container: let type, identifier: _),
      .enumerationCase(enumeration: let type, identifier: _):
      type.validateReferences(
        requiredAccess: requiredAccess,
        allowTestOnlyAccess: allowTestOnlyAccess,
        referenceLookup: referenceLookup,
        errors: &errors
      )
    }
  }
}

extension ParsedTypeReference {
  func unresolvedGloballyUniqueIdentifierComponents() -> [UnicodeText] {
    switch self {
    case .simple(let simple):
      return [simple.identifier]
    case .compound(identifier: let identifier, components: let components):
      var result: [UnicodeText] = ["("].map({ UnicodeText($0) })
      result.append(identifier.name())
      result.append(contentsOf: components.lazy.flatMap({ $0.unresolvedGloballyUniqueIdentifierComponents() }))
      result.append(UnicodeText(")"))
      return result
    case .action(parameters: let parameters, returnValue: let returnValue):
      var result: [UnicodeText] = ["(("].map({ UnicodeText($0) })
      result.append(contentsOf: parameters.lazy.flatMap({ $0.unresolvedGloballyUniqueIdentifierComponents() }))
      result.append(contentsOf: returnValue.unresolvedGloballyUniqueIdentifierComponents())
      result.append(UnicodeText("))"))
      return result
    case .statements:
      return ["{}"].map({ UnicodeText($0) })
    case .partReference(container: let type, identifier: let identifier),
      .enumerationCase(enumeration: let type, identifier: let identifier):
      var result: [UnicodeText] = ["((("].map({ UnicodeText($0) })
      result.append(contentsOf: type.unresolvedGloballyUniqueIdentifierComponents())
      result.append(UnicodeText("•"))
      result.append(identifier)
      result.append(UnicodeText(")))"))
      return result
    }
  }
}
extension Optional where Wrapped == ParsedTypeReference {
  func unresolvedGloballyUniqueIdentifierComponents() -> [UnicodeText] {
    return self?.unresolvedGloballyUniqueIdentifierComponents() ?? [""].map({ UnicodeText($0) })
  }
}

extension ParsedTypeReference {
  func requiredIdentifiers(
    moduleAndExternalReferenceLookup: [ReferenceDictionary]
  ) -> [UnicodeText] {
    var result: [UnicodeText] = []
    switch self {
    case .simple(let simple):
      if let thing = moduleAndExternalReferenceLookup.lookupThing(simple.identifier, components: []) {
        result.append(thing.globallyUniqueIdentifier(referenceLookup: moduleAndExternalReferenceLookup))
      }
    case .compound(identifier: let identifier, components: let components):
      if let thing = moduleAndExternalReferenceLookup.lookupThing(
        identifier.name(),
        components: components.map({ $0.key })
      ) {
        result.append(thing.globallyUniqueIdentifier(referenceLookup: moduleAndExternalReferenceLookup))
      }
      for component in components {
        result.append(
          contentsOf: component.requiredIdentifiers(
            moduleAndExternalReferenceLookup: moduleAndExternalReferenceLookup
          )
        )
      }
    case .action(parameters: let parameters, returnValue: let returnValue):
      for parameter in parameters {
        result.append(
          contentsOf: parameter.requiredIdentifiers(
            moduleAndExternalReferenceLookup: moduleAndExternalReferenceLookup
          )
        )
      }
      if let value = returnValue {
        result.append(
          contentsOf: value.requiredIdentifiers(
            moduleAndExternalReferenceLookup: moduleAndExternalReferenceLookup
          )
        )
      }
    case .statements:
      break
    case .partReference(container: let type, identifier: _),
      .enumerationCase(enumeration: let type, identifier: _):
      result.append(
        contentsOf: type.requiredIdentifiers(
          moduleAndExternalReferenceLookup: moduleAndExternalReferenceLookup
        )
      )
    }
    return result
  }
}
