import SDGText

struct ActionPrototype {
  var isFlow: Bool
  var names: Set<StrictString>
  var namespace: [Set<StrictString>]
  var parameters: Interpolation<ParameterIntermediate>
  var returnValue: ParsedTypeReference?
  var access: AccessIntermediate
  var testOnlyAccess: Bool
  var documentation: DocumentationIntermediate?
  var nativeNames: NativeActionNamesIntermediate

  init(
    isFlow: Bool,
    names: Set<StrictString>,
    namespace: [Set<StrictString>],
    parameters: Interpolation<ParameterIntermediate>,
    returnValue: ParsedTypeReference?,
    access: AccessIntermediate,
    testOnlyAccess: Bool,
    documentation: DocumentationIntermediate?,
    nativeNames: NativeActionNamesIntermediate
  ) {
    self.isFlow = isFlow
    self.names = names
    self.namespace = namespace
    self.parameters = parameters
    self.returnValue = returnValue
    self.access = access
    self.testOnlyAccess = testOnlyAccess
    self.documentation = documentation
    self.nativeNames = nativeNames
  }
}

extension ActionPrototype {

  static func construct<S>(
    _ declaration: S,
    namespace: [Set<StrictString>]
  ) -> Result<ActionPrototype, ErrorList<ActionPrototype.ConstructionError>>
  where S: ParsedActionPrototype {
    var errors: [ActionPrototype.ConstructionError] = []
    let namesDictionary = declaration.name.names
    var parameters: Interpolation<ParameterIntermediate>
    switch Interpolation.construct(
      entries: namesDictionary.values,
      getEntryName: { $0.name() },
      getParameters: { $0.parameters() },
      getParameterName: { $0.name.name() },
      getDefinitionOrReference: { $0.definitionOrReference },
      getNestedSignature: { $0.name },
      getNestedParameters: { $0.parameters() },
      constructParameter: { ParameterIntermediate(names: $0, nestedParameters: $1!, returnValue: $2.type, isThrough: $2.isThrough, nativeNames: NativeActionNamesIntermediate.none, swiftLabel: nil) }
    ) {
    case .failure(let interpolationError):
      errors.append(contentsOf: interpolationError.errors.map({ .brokenParameterInterpolation($0) }))
      return .failure(ErrorList(errors))
    case .success(let constructed):
      parameters = constructed
    }
    var names: Set<StrictString> = []
    var nativeNames = NativeActionNamesIntermediate.none
    for (language, signature) in namesDictionary {
      let name = signature.name()
      let parameterNames = signature.parameters().map({ $0.name.name() })
      switch language {
      case "C":
        nativeNames.c = name
        parameters.apply(nativeNames: parameterNames, accordingTo: name, apply: { $0.c = $1 })
      case "C♯":
        nativeNames.cSharp = name
        parameters.apply(nativeNames: parameterNames, accordingTo: name, apply: { $0.cSharp = $1 })
      case "Kotlin":
        nativeNames.kotlin = name
        parameters.apply(nativeNames: parameterNames, accordingTo: name, apply: { $0.kotlin = $1 })
      case "Swift":
        nativeNames.swift = name
        var remainder = StrictString(name)
        if remainder.hasPrefix("var ") {
          remainder.removeFirst(4)
        }
        var labels: [StrictString] = []
        if remainder.hasPrefix("().") {
          remainder.removeFirst(3)
          labels.append("")
        }
        let parameterList = remainder.dropping(through: " ")
        labels.append(
          contentsOf: parameterList.components(separatedBy: "()").dropLast()
            .map({ component in
              var label = StrictString(component.contents)
              if label.first == " " {
                label.removeFirst()
              }
              if label.last == " " {
                label.removeLast()
              }
              return label
            })
        )
        parameters.apply(nativeNames: parameterNames, accordingTo: name, apply: { $0.swift = $1 })
        parameters.apply(swiftLabels: labels.map({ $0.isEmpty ? nil : UnicodeText($0) }), accordingTo: name)
      default:
        break
      }
      names.insert(StrictString(name))
    }
    var attachedDocumentation: DocumentationIntermediate?
    if let documentation = declaration.documentation {
      switch DocumentationIntermediate.construct(
        documentation.documentation,
        namespace: namespace
          .appending(names)
          .appending(contentsOf: parameters.ordered(for: names.identifier()).map({ parameter in return [StrictString(parameter.type.unresolvedGloballyUniqueIdentifierComponents().joined(separator: ",".unicodeScalars))] as Set<StrictString>
          }))
      ) {
      case .failure(let nested):
        errors.append(contentsOf: nested.errors.map({ ConstructionError.brokenDocumentation($0) }))
      case .success(let intermediateDocumentation):
        attachedDocumentation = intermediateDocumentation
        let existingParameters = parameters.inAnyOrder.reduce(Set(), { $0.union($1.names) })
        for parameter in intermediateDocumentation.parameters.joined() {
          if !existingParameters.contains(StrictString(parameter.name.identifierText())) {
            errors.append(ConstructionError.documentedParameterNotFound(parameter))
          }
        }
      }
    }
    if !errors.isEmpty {
      return .failure(ErrorList(errors))
    }
    return .success(
      ActionPrototype(
        isFlow: declaration.isFlow,
        names: names,
        namespace: namespace,
        parameters: parameters,
        returnValue: declaration.returnValueType.map({ ParsedTypeReference($0) }),
        access: AccessIntermediate(declaration.access),
        testOnlyAccess: declaration.testAccess?.keyword is ParsedTestsKeyword,
        documentation: attachedDocumentation,
        nativeNames: nativeNames
      )
    )
  }

  func validateReferences(referenceLookup: [ReferenceDictionary], errors: inout [ReferenceError]) {
    for parameter in parameters.inAnyOrder {
      parameter.type.validateReferences(
        requiredAccess: access,
        allowTestOnlyAccess: testOnlyAccess,
        referenceLookup: referenceLookup,
        errors: &errors
      )
    }
    returnValue?.validateReferences(
      requiredAccess: access,
      allowTestOnlyAccess: testOnlyAccess,
      referenceLookup: referenceLookup,
      errors: &errors
    )
  }
}

extension ActionPrototype {
  func lookupParameter(_ identifier: UnicodeText) -> ParameterIntermediate? {
    return parameters.parameter(named: identifier)
  }

  func parameterReferenceDictionary(externalLookup: [ReferenceDictionary]) -> ReferenceDictionary {
    var result = ReferenceDictionary()
    for parameter in parameters.inAnyOrder {
      if let execute = parameter.executeAction {
        _ = result.add(action: execute)
      } else {
        _ = result.add(action: parameter.passAction)
      }
    }

    result.resolveTypeIdentifiers(externalLookup: externalLookup)
    return result
  }

  func signature(orderedFor name: UnicodeText) -> [ParsedTypeReference] {
    return parameters.ordered(for: name).map({ $0.type })
  }
}

extension ActionPrototype {

  func requiredIdentifiers(
    moduleAndExternalReferenceLookup: [ReferenceDictionary]
  ) -> [UnicodeText] {
    var result: [UnicodeText] = []
    for parameter in parameters.inAnyOrder {
      result.append(
        contentsOf: parameter.type.requiredIdentifiers(
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
    return result
  }
}
