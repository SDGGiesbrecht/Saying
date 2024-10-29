import SDGLogic
import SDGCollections
import SDGText

struct ActionIntermediate {
  fileprivate var prototype: ActionPrototype
  var c: NativeActionImplementationIntermediate?
  var cSharp: NativeActionImplementationIntermediate?
  var javaScript: NativeActionImplementationIntermediate?
  var kotlin: NativeActionImplementationIntermediate?
  var swift: NativeActionImplementationIntermediate?
  var implementation: ActionUse?
  var declaration: ParsedActionDeclarationPrototype?
  var originalUnresolvedCoverageRegionIdentifierComponents: [StrictString]?
  var coveredIdentifier: StrictString?

  var documentation: DocumentationIntermediate? {
    return prototype.documentation
  }
  var names: Set<StrictString> {
    return prototype.names
  }
  var parameters: Interpolation<ParameterIntermediate> {
    return prototype.parameters
  }
  var returnValue: ParsedTypeReference? {
    return prototype.returnValue
  }
  var access: AccessIntermediate {
    return prototype.access
  }
  var testOnlyAccess: Bool {
    return prototype.testOnlyAccess
  }
}

extension ActionIntermediate {
  func parameterReferenceDictionary() -> ReferenceDictionary {
    return prototype.parameterReferenceDictionary()
  }
}

extension ActionIntermediate {
  func unresolvedGloballyUniqueIdentifierComponents() -> [StrictString] {
    let identifier = names.identifier()
    return [identifier]
      .appending(contentsOf: signature(orderedFor: identifier).lazy.flatMap({ $0.unresolvedGloballyUniqueIdentifierComponents() }))
      .appending(contentsOf: returnValue.unresolvedGloballyUniqueIdentifierComponents())
  }

  func resolve(
    globallyUniqueIdentifierComponents: [StrictString],
    referenceDictionary: ReferenceDictionary
  ) -> StrictString {
    return globallyUniqueIdentifierComponents
        .lazy.map({ referenceDictionary.resolve(identifier: $0) })
        .joined(separator: ":")
  }

  func globallyUniqueIdentifier(referenceDictionary: ReferenceDictionary) -> StrictString {
    return resolve(
      globallyUniqueIdentifierComponents: unresolvedGloballyUniqueIdentifierComponents(),
      referenceDictionary: referenceDictionary
    )
  }
}

extension ActionIntermediate {

  static func disallowImports(
    in implementation: ParsedNativeActionImplementation,
    errors: inout [ConstructionError]
  ) {
    if implementation.expression.importNode ≠ nil {
      errors.append(ConstructionError.invalidImport(implementation))
    }
  }

  static func parameterAction(
    names: Set<StrictString>,
    parameters: Interpolation<ParameterIntermediate>,
    returnValue: ParsedTypeReference?
  ) -> ActionIntermediate {
    return ActionIntermediate(
      prototype: ActionPrototype(
        names: names,
        namespace: [],
        parameters: parameters,
        returnValue: returnValue,
        access: .inferred,
        testOnlyAccess: false
      )
    )
  }

  static func construct<Declaration>(
    _ declaration: Declaration,
    namespace: [Set<StrictString>]
  ) -> Result<ActionIntermediate, ErrorList<ActionIntermediate.ConstructionError>>
  where Declaration: ParsedActionDeclarationPrototype {
    var errors: [ActionIntermediate.ConstructionError] = []

    let prototype: ActionPrototype
    switch ActionPrototype.construct(declaration, namespace: namespace) {
    case .failure(let prototypeError):
      errors.append(contentsOf: prototypeError.errors.map({ .brokenPrototype($0) }))
      return .failure(ErrorList(errors))
    case .success(let constructed):
      prototype = constructed
    }
    var c: NativeActionImplementationIntermediate?
    var cSharp: NativeActionImplementationIntermediate?
    var javaScript: NativeActionImplementationIntermediate?
    var kotlin: NativeActionImplementationIntermediate?
    var swift: NativeActionImplementationIntermediate?
    if let native = declaration.implementation.native {
      for implementation in native.implementations {
        switch NativeActionImplementationIntermediate.construct(
          prototype: prototype,
          implementation: implementation.expression
        ) {
        case .failure(let error):
          errors.append(contentsOf: error.errors.map({ ConstructionError.brokenNativeActionImplementation($0) }))
        case .success(let constructed):
          for parameterReference in constructed.parameters {
            if prototype.parameters.parameter(named: parameterReference.name) == nil {
              errors.append(.parameterNotFound(parameterReference.syntaxNode))
            }
          }
          switch implementation.language.identifierText() {
          case "C":
            c = constructed
          case "C♯":
            cSharp = constructed
            disallowImports(in: implementation, errors: &errors)
          case "JavaScript":
            javaScript = constructed
            disallowImports(in: implementation, errors: &errors)
          case "Kotlin":
            kotlin = constructed
            disallowImports(in: implementation, errors: &errors)
          case "Swift":
            swift = constructed
            disallowImports(in: implementation, errors: &errors)
          default:
            errors.append(ConstructionError.unknownLanguage(implementation.language))
          }
        }
      }
    }
    var implementation: ActionUse?
    if let source = declaration.implementation.source {
      implementation = ActionUse(source.action)
    } else {
      if c == nil {
        errors.append(ConstructionError.missingImplementation(language: "C", action: declaration.name))
      }
      if cSharp == nil {
        errors.append(ConstructionError.missingImplementation(language: "C♯", action: declaration.name))
      }
      if javaScript == nil {
        errors.append(ConstructionError.missingImplementation(language: "JavaScript", action: declaration.name))
      }
      if kotlin == nil {
        errors.append(ConstructionError.missingImplementation(language: "Kotlin", action: declaration.name))
      }
      if swift == nil {
        errors.append(ConstructionError.missingImplementation(language: "Swift", action: declaration.name))
      }
    }
    if ¬errors.isEmpty {
      return .failure(ErrorList(errors))
    }
    return .success(
      ActionIntermediate(
        prototype: prototype,
        c: c,
        cSharp: cSharp,
        javaScript: javaScript,
        kotlin: kotlin,
        swift: swift,
        implementation: implementation,
        declaration: declaration
      )
    )
  }

  func validateReferences(moduleReferenceDictionary: ReferenceDictionary, errors: inout [ReferenceError]) {
    prototype.validateReferences(
      referenceDictionary: moduleReferenceDictionary,
      errors: &errors
    )
    implementation?.validateReferences(
      context: [moduleReferenceDictionary, self.parameterReferenceDictionary()],
      testContext: false,
      errors: &errors
    )
  }
}

extension ActionIntermediate {
  func merging(
    requirement: RequirementIntermediate,
    useAccess: AccessIntermediate,
    typeLookup: [StrictString: SimpleTypeReference],
    specializationNamespace: [Set<StrictString>]
  ) -> Result<ActionIntermediate, ErrorList<ReferenceError>> {
    var errors: [ReferenceError] = []
    let mergedParameters: Interpolation<ParameterIntermediate>
    switch parameters.merging(
      requirement: requirement.parameters,
      provisionDeclarationName: self.declaration!.name
    ) {
    case .failure(let error):
      errors.append(contentsOf: error.errors)
      return .failure(ErrorList(errors))
    case .success(let parameters):
      mergedParameters = parameters
    }
    if access < min(requirement.access, useAccess) {
      errors.append(.fulfillmentAccessNarrowerThanRequirement(declaration: self.declaration!.name))
    }
    if testOnlyAccess ≠ requirement.testOnlyAccess {
      errors.append(.mismatchedTestAccess(testAccess: self.declaration!.testAccess!))
    }
    if ¬errors.isEmpty {
      return .failure(ErrorList(errors))
    }
    let mergedDocumentation = documentation.merging(
      inherited: requirement.documentation,
      typeLookup: typeLookup,
      specializationNamespace: specializationNamespace
    )
    return .success(
      ActionIntermediate(
        prototype: ActionPrototype(
          names: names ∪ requirement.names,
          namespace: prototype.namespace,
          parameters: mergedParameters,
          returnValue: returnValue,
          access: access,
          testOnlyAccess: testOnlyAccess,
          documentation: mergedDocumentation
        ),
        c: c,
        cSharp: cSharp,
        javaScript: javaScript,
        kotlin: kotlin,
        swift: swift,
        implementation: implementation,
        declaration: nil,
        originalUnresolvedCoverageRegionIdentifierComponents: nil,
        coveredIdentifier: coveredIdentifier
      )
    )
  }

  func specializing(
    for use: UseIntermediate,
    typeLookup: [StrictString: SimpleTypeReference],
    specializationNamespace: [Set<StrictString>]
  ) -> ActionIntermediate {
    let newParameters = parameters.mappingParameters({ parameter in
      return ParameterIntermediate(
        names: parameter.names,
        type: parameter.type.specializing(typeLookup: typeLookup)
      )
    })
    let newReturnValue = returnValue.flatMap { $0.specializing(typeLookup: typeLookup) }
    let newDocumentation = documentation.flatMap({ documentation in
      return documentation.specializing(
        typeLookup: typeLookup,
        specializationNamespace: specializationNamespace
      )
    })
    return ActionIntermediate(
      prototype: ActionPrototype(
        names: names,
        namespace: prototype.namespace,
        parameters: newParameters,
        returnValue: newReturnValue,
        access: min(self.access, use.access),
        testOnlyAccess: self.testOnlyAccess ∨ use.testOnlyAccess,
        documentation: newDocumentation
      ),
      c: c,
      cSharp: cSharp,
      javaScript: javaScript,
      kotlin: kotlin,
      swift: swift,
      implementation: implementation,
      declaration: nil,
      originalUnresolvedCoverageRegionIdentifierComponents: unresolvedGloballyUniqueIdentifierComponents(),
      coveredIdentifier: coveredIdentifier
    )
  }
}

extension ActionIntermediate {
  func lookupParameter(_ identifier: StrictString) -> ParameterIntermediate? {
    return prototype.lookupParameter(identifier)
  }

  func signature(orderedFor name: StrictString) -> [ParsedTypeReference] {
    return prototype.signature(orderedFor: name)
  }
}

extension ActionIntermediate {

  var isCoverageWrapper: Bool {
    return coveredIdentifier ≠ nil
  }

  func coverageTrackingIdentifier() -> StrictString {
    return "☐\(prototype.names.identifier())"
  }
  func wrappedToTrackCoverage(referenceDictionary: ReferenceDictionary) -> ActionIntermediate? {
    if let coverageIdentifier = coverageRegionIdentifier(referenceDictionary: referenceDictionary) {
      let baseName = names.identifier()
      let wrapperName = coverageTrackingIdentifier()
      return ActionIntermediate(
        prototype: ActionPrototype(
          names: [wrapperName],
          namespace: [],
          parameters: prototype.parameters.removingOtherNamesAnd(replacing: baseName, with: wrapperName),
          returnValue: prototype.returnValue,
          access: prototype.access,
          testOnlyAccess: prototype.testOnlyAccess
        ),
        implementation: ActionUse(
          actionName: baseName,
          arguments: prototype.parameters.ordered(for: baseName).map({ parameter in
            return ActionUse(
              actionName: parameter.names.identifier(),
              arguments: [],
              resolvedResultType: parameter.type
            )
          }),
          resolvedResultType: returnValue
        ),
        originalUnresolvedCoverageRegionIdentifierComponents: nil,
        coveredIdentifier: coverageIdentifier
      )
    } else {
      return nil
    }
  }

  func coverageRegionIdentifier(referenceDictionary: ReferenceDictionary) -> StrictString? {
    let namespace = prototype.namespace
      .lazy.map({ $0.identifier() })
      .joined(separator: ":")
    let identifier: StrictString
    if let inherited = originalUnresolvedCoverageRegionIdentifierComponents {
      identifier = resolve(globallyUniqueIdentifierComponents: inherited, referenceDictionary: referenceDictionary)
    } else {
      identifier = globallyUniqueIdentifier(referenceDictionary: referenceDictionary)
    }
    return [namespace, identifier]
      .joined(separator: ":")
  }
}
