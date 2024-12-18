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
  var implementation: StatementListIntermediate?
  var declaration: ParsedActionDeclarationPrototype?
  var isReferenceWrapper: Bool = false
  var isEnumerationCaseWrapper: Bool = false
  var isEnumerationValueWrapper: Bool = false
  var originalUnresolvedCoverageRegionIdentifierComponents: [StrictString]?
  var coveredIdentifier: StrictString?

  var isFlow: Bool {
    return prototype.isFlow
  }
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
  var swiftName: StrictString? {
    return prototype.swiftName
  }
  func allNativeImplementations() -> [NativeActionImplementationIntermediate] {
    return [c, cSharp, javaScript, kotlin, swift].compactMap({ $0 })
  }
}

extension ActionIntermediate {
  func parameterReferenceDictionary(externalLookup: [ReferenceDictionary]) -> ReferenceDictionary {
    return prototype.parameterReferenceDictionary(externalLookup: externalLookup)
  }
}

extension ActionIntermediate {
  func unresolvedGloballyUniqueIdentifierComponents() -> [StrictString] {
    let identifier = names.identifier()
    let signature = signature(orderedFor: identifier)
    let resolvedParameters: [ParsedTypeReference]
    let resolvedReturnValue: ParsedTypeReference?
    if isReferenceWrapper {
      switch returnValue {
      case .simple, .compound, .statements, .enumerationCase, .none:
        fatalError("A real action reference would produce an action.")
      case .action(parameters: let parameters, returnValue: let returnValue):
        resolvedParameters = parameters
        resolvedReturnValue = returnValue
      }
    } else {
      resolvedParameters = signature
      resolvedReturnValue = self.returnValue
    }
    return [identifier]
      .appending(contentsOf: resolvedParameters.lazy.flatMap({ $0.unresolvedGloballyUniqueIdentifierComponents() }))
      .appending(contentsOf: resolvedReturnValue.unresolvedGloballyUniqueIdentifierComponents())
  }

  func resolve(
    globallyUniqueIdentifierComponents: [StrictString],
    referenceLookup: [ReferenceDictionary]
  ) -> StrictString {
    return globallyUniqueIdentifierComponents
        .lazy.map({ referenceLookup.resolve(identifier: $0) })
        .joined(separator: ":")
  }

  func globallyUniqueIdentifier(referenceLookup: [ReferenceDictionary]) -> StrictString {
    return resolve(
      globallyUniqueIdentifierComponents: unresolvedGloballyUniqueIdentifierComponents(),
      referenceLookup: referenceLookup
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
        isFlow: false,
        names: names,
        namespace: [],
        parameters: parameters,
        returnValue: returnValue,
        access: .inferred,
        testOnlyAccess: false,
        documentation: nil,
        swiftName: nil
      )
    )
  }

  static func enumerationCase(
    names: Set<StrictString>,
    enumerationType: ParsedTypeReference,
    access: AccessIntermediate,
    testOnlyAccess: Bool
  ) -> ActionIntermediate {
    return ActionIntermediate(
      prototype: ActionPrototype(
        isFlow: true,
        names: names,
        namespace: [],
        parameters: .none,
        returnValue: .enumerationCase(enumeration: enumerationType, identifier: names.identifier()),
        access: access,
        testOnlyAccess: testOnlyAccess,
        documentation: nil,
        swiftName: nil
      ),
      isEnumerationCaseWrapper: true
    )
  }

  static func enumerationWrap(
    enumerationType: ParsedTypeReference,
    caseIdentifier: StrictString,
    valueType: ParsedTypeReference,
    access: AccessIntermediate,
    testOnlyAccess: Bool,
    c: NativeActionImplementationIntermediate?,
    cSharp: NativeActionImplementationIntermediate?,
    javaScript: NativeActionImplementationIntermediate?,
    kotlin: NativeActionImplementationIntermediate?,
    swift: NativeActionImplementationIntermediate?
  ) -> ActionIntermediate {
    let parameters = Interpolation<ParameterIntermediate>.enumerationWrap(
      enumerationType: enumerationType,
      caseIdentifier: caseIdentifier,
      valueType: valueType
    )
    return ActionIntermediate(
      prototype: ActionPrototype(
        isFlow: true,
        names: parameters.names(),
        namespace: [],
        parameters: parameters,
        returnValue: enumerationType,
        access: access,
        testOnlyAccess: testOnlyAccess,
        documentation: nil,
        swiftName: nil
      ),
      c: c ?? NativeActionImplementationIntermediate(
        textComponents: ["((", ") {", ", ", "})"],
        parameters: [
          NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: "case")!, typeInstead: enumerationType),
          NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: "case")!),
          NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: "value")!)
        ]
      ),
      cSharp: cSharp ?? NativeActionImplementationIntermediate(
        textComponents: ["new ", "(", ")"],
        parameters: [
          NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: "case")!),
          NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: "value")!)
        ]
      ),
      javaScript: javaScript ?? NativeActionImplementationIntermediate(
        textComponents: ["Object.freeze({ enumerationCase: ", ", value: ", " })"],
        parameters: [
          NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: "case")!),
          NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: "value")!)
        ]
      ),
      kotlin: kotlin ?? NativeActionImplementationIntermediate(
        textComponents: ["", "(", ")"],
        parameters: [
          NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: "case")!),
          NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: "value")!)
        ]
      ),
      swift: swift ?? NativeActionImplementationIntermediate(
        textComponents: ["", "(", ")"],
        parameters: [
          NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: "case")!),
          NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: "value")!)
        ]
      ),
      isEnumerationValueWrapper: true
    )
  }

  static func enumerationWrapNothing(
    names: Set<StrictString>,
    returnValue: ParsedTypeReference,
    access: AccessIntermediate,
    testOnlyAccess: Bool,
    c: NativeActionImplementationIntermediate?,
    cSharp: NativeActionImplementationIntermediate?,
    javaScript: NativeActionImplementationIntermediate?,
    kotlin: NativeActionImplementationIntermediate?,
    swift: NativeActionImplementationIntermediate?
  ) -> ActionIntermediate {
    return ActionIntermediate(
      prototype: ActionPrototype(
        isFlow: false,
        names: names,
        namespace: [],
        parameters: .none,
        returnValue: returnValue,
        access: access,
        testOnlyAccess: testOnlyAccess,
        documentation: nil,
        swiftName: nil
      ),
      c: c,
      cSharp: cSharp,
      javaScript: javaScript,
      kotlin: kotlin,
      swift: swift,
      isEnumerationCaseWrapper: true
    )
  }

  static func enumerationUnwrap(
    enumerationType: ParsedTypeReference,
    caseIdentifier: StrictString,
    valueType: ParsedTypeReference,
    access: AccessIntermediate,
    testOnlyAccess: Bool,
    c: NativeActionImplementationIntermediate?,
    cSharp: NativeActionImplementationIntermediate?,
    javaScript: NativeActionImplementationIntermediate?,
    kotlin: NativeActionImplementationIntermediate?,
    swift: NativeActionImplementationIntermediate?
  ) -> ActionIntermediate {
    let parameters = Interpolation<ParameterIntermediate>.enumerationUnwrap(
      enumerationType: enumerationType,
      caseIdentifier: caseIdentifier,
      valueType: valueType
    )
    return ActionIntermediate(
      prototype: ActionPrototype(
        isFlow: true,
        names: parameters.names(),
        namespace: [],
        parameters: parameters,
        returnValue: nil,
        access: access,
        testOnlyAccess: testOnlyAccess,
        documentation: nil,
        swiftName: nil
      ),
      c: c ?? NativeActionImplementationIntermediate(
        textComponents: ["", " enumeration = ", "; if (enumeration.enumeration_case == ", ") { ", " ", " = enumeration.value.", ";", "}"],
        parameters: [
          NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: "enumeration")!, typeInstead: enumerationType),
          NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: "enumeration")!),
          NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: "case")!),
          NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: "value")!, typeInstead: valueType),
          NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: "value")!),
          NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: "case")!),
          NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: "consequence")!),
        ]
      ),
      cSharp: cSharp ?? NativeActionImplementationIntermediate(
        textComponents: ["if (", " is ", " enumerationCase) { ", " ", " = enumerationCase.Value;", "}"],
        parameters: [
          NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: "enumeration")!),
          NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: "case")!),
          NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: "value")!, typeInstead: valueType),
          NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: "value")!),
          NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: "consequence")!),
        ]
      ),
      javaScript: javaScript ?? NativeActionImplementationIntermediate(
        textComponents: ["let enumeration = ", "; if (enumeration.enumerationCase == ", ") { let ", " = enumeration.value;", "}"],
        parameters: [
          NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: "enumeration")!),
          NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: "case")!),
          NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: "value")!),
          NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: "consequence")!),
        ]
      ),
      kotlin: kotlin ?? NativeActionImplementationIntermediate(
        textComponents: ["if (", " is ", ") { val ", " = ", ".value", "}"],
        parameters: [
          NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: "enumeration")!),
          NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: "case")!),
          NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: "value")!),
          NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: "enumeration")!),
          NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: "consequence")!),
        ]
      ),
      swift: swift ?? NativeActionImplementationIntermediate(
        textComponents: ["if case ", "(let ", ") = ", " {", "}"],
        parameters: [
          NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: "case")!),
          NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: "value")!),
          NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: "enumeration")!),
          NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: "consequence")!),
        ]
      )
    )
  }

  static func enumerationCheck(
    enumerationType: ParsedTypeReference,
    caseIdentifier: StrictString,
    empty: Bool,
    access: AccessIntermediate,
    testOnlyAccess: Bool,
    c: NativeActionImplementationIntermediate?,
    cSharp: NativeActionImplementationIntermediate?,
    javaScript: NativeActionImplementationIntermediate?,
    kotlin: NativeActionImplementationIntermediate?,
    swift: NativeActionImplementationIntermediate?
  ) -> ActionIntermediate {
    let parameters = Interpolation<ParameterIntermediate>.enumerationCheck(
      enumerationType: enumerationType,
      caseIdentifier: caseIdentifier,
      empty: empty
    )
    let caseInstead: ParsedTypeReference? = empty ? .enumerationCase(enumeration: enumerationType, identifier: caseIdentifier) : nil
    return ActionIntermediate(
      prototype: ActionPrototype(
        isFlow: true,
        names: parameters.names(),
        namespace: [],
        parameters: parameters,
        returnValue: .simple(SimpleTypeReference(ParsedUninterruptedIdentifier(source: "truth value")!)),
        access: access,
        testOnlyAccess: testOnlyAccess,
        documentation: nil,
        swiftName: nil
      ),
      c: c ?? NativeActionImplementationIntermediate(
        textComponents: ["(", ").enumeration_case == ", ""],
        parameters: [
          NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: "enumeration")!),
          NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: "case")!, caseInstead: caseInstead),
        ]
      ),
      cSharp: cSharp ?? NativeActionImplementationIntermediate(
        textComponents: ["(", ") is ", ""],
        parameters: [
          NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: "enumeration")!),
          NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: "case")!, caseInstead: caseInstead),
        ]
      ),
      javaScript: javaScript ?? NativeActionImplementationIntermediate(
        textComponents: ["(", ").enumerationCase == ", ""],
        parameters: [
          NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: "enumeration")!),
          NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: "case")!, caseInstead: caseInstead),
        ]
      ),
      kotlin: kotlin ?? NativeActionImplementationIntermediate(
        textComponents: ["(", ") is ", ""],
        parameters: [
          NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: "enumeration")!),
          NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: "case")!, caseInstead: caseInstead),
        ]
      ),
      swift: swift ?? NativeActionImplementationIntermediate(
        textComponents: ["{ if case ", " = ", " { return true } else { return false } }()"],
        parameters: [
          NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: "case")!, caseInstead: caseInstead),
          NativeActionImplementationParameter(ParsedUninterruptedIdentifier(source: "enumeration")!),
        ]
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
          implementation: implementation.expression
        ) {
        case .failure(let error):
          errors.append(contentsOf: error.errors.map({ ConstructionError.brokenNativeActionImplementation($0) }))
        case .success(let constructed):
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
    var implementation: StatementListIntermediate?
    if let source = declaration.implementation.source {
      implementation = StatementListIntermediate(source.statements)
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
    if !errors.isEmpty {
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
    for native in allNativeImplementations() {
      for parameterReference in native.parameters {
        if let typeInstead = parameterReference.typeInstead {
          typeInstead.validateReferences(
            requiredAccess: access,
            allowTestOnlyAccess: testOnlyAccess,
            referenceDictionary: moduleReferenceDictionary,
            errors: &errors
          )
        } else {
          if prototype.parameters.parameter(named: parameterReference.name) == nil {
            errors.append(.noSuchParameter(parameterReference.syntaxNode))
          }
        }
      }
    }
    let externalAndParameters = [moduleReferenceDictionary, self.parameterReferenceDictionary(externalLookup: [moduleReferenceDictionary])]
    implementation?.validateReferences(
      context: externalAndParameters,
      testContext: false,
      errors: &errors
    )
    documentation?.validateReferences(
      referenceLookup: externalAndParameters,
      errors: &errors
    )
  }
}

extension ActionIntermediate {
  func resolvingExtensionContext(
    typeLookup: [StrictString: StrictString]
  ) -> ActionIntermediate {
    let newParameters = parameters.mappingParameters({ parameter in
      return parameter.resolvingExtensionContext(typeLookup: typeLookup)
    })
    let newReturnValue = returnValue.flatMap { $0.resolvingExtensionContext(typeLookup: typeLookup) }
    let newDocumentation = documentation.flatMap({ documentation in
      return documentation.resolvingExtensionContext(typeLookup: typeLookup)
    })
    return ActionIntermediate(
      prototype: ActionPrototype(
        isFlow: isFlow,
        names: names,
        namespace: prototype.namespace,
        parameters: newParameters,
        returnValue: newReturnValue,
        access: access,
        testOnlyAccess: testOnlyAccess,
        documentation: newDocumentation,
        swiftName: swiftName
      ),
      c: c,
      cSharp: cSharp,
      javaScript: javaScript,
      kotlin: kotlin,
      swift: swift,
      implementation: implementation,
      declaration: declaration,
      isReferenceWrapper: isReferenceWrapper,
      isEnumerationCaseWrapper: isEnumerationCaseWrapper,
      isEnumerationValueWrapper: isEnumerationValueWrapper,
      originalUnresolvedCoverageRegionIdentifierComponents: unresolvedGloballyUniqueIdentifierComponents(),
      coveredIdentifier: coveredIdentifier
    )
  }

  func merging(
    requirement: RequirementIntermediate,
    useAccess: AccessIntermediate,
    typeLookup: [StrictString: ParsedTypeReference],
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
    if !errors.isEmpty {
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
          isFlow: isFlow,
          names: names ∪ requirement.names,
          namespace: prototype.namespace,
          parameters: mergedParameters,
          returnValue: returnValue,
          access: access,
          testOnlyAccess: testOnlyAccess,
          documentation: mergedDocumentation,
          swiftName: swiftName
        ),
        c: c,
        cSharp: cSharp,
        javaScript: javaScript,
        kotlin: kotlin,
        swift: swift,
        implementation: implementation,
        declaration: nil,
        isReferenceWrapper: isReferenceWrapper,
        isEnumerationCaseWrapper: isEnumerationCaseWrapper,
        isEnumerationValueWrapper: isEnumerationValueWrapper,
        originalUnresolvedCoverageRegionIdentifierComponents: nil,
        coveredIdentifier: coveredIdentifier
      )
    )
  }

  func specializing(
    for use: UseIntermediate,
    typeLookup: [StrictString: ParsedTypeReference],
    specializationNamespace: [Set<StrictString>]
  ) -> ActionIntermediate {
    let newParameters = parameters.mappingParameters({ parameter in
      return parameter.specializing(
        for: use,
        typeLookup: typeLookup,
        specializationNamespace: specializationNamespace
      )
    })
    let newReturnValue = returnValue.flatMap { $0.specializing(typeLookup: typeLookup) }
    let newDocumentation = documentation.flatMap({ documentation in
      return documentation.specializing(
        typeLookup: typeLookup,
        specializationNamespace: specializationNamespace
      )
    })
    var implementationTypeLookup = typeLookup
    for parameter in newParameters.inAnyOrder {
      for name in parameter.names {
        implementationTypeLookup[name] = nil
      }
    }
    return ActionIntermediate(
      prototype: ActionPrototype(
        isFlow: isFlow,
        names: names,
        namespace: prototype.namespace,
        parameters: newParameters,
        returnValue: newReturnValue,
        access: min(self.access, use.access),
        testOnlyAccess: self.testOnlyAccess ∨ use.testOnlyAccess,
        documentation: newDocumentation,
        swiftName: swiftName
      ),
      c: c?.specializing(typeLookup: implementationTypeLookup),
      cSharp: cSharp?.specializing(typeLookup: implementationTypeLookup),
      javaScript: javaScript?.specializing(typeLookup: implementationTypeLookup),
      kotlin: kotlin?.specializing(typeLookup: implementationTypeLookup),
      swift: swift?.specializing(typeLookup: implementationTypeLookup),
      implementation: implementation?.specializing(typeLookup: implementationTypeLookup),
      declaration: nil,
      isReferenceWrapper: isReferenceWrapper,
      isEnumerationCaseWrapper: isEnumerationCaseWrapper,
      isEnumerationValueWrapper: isEnumerationValueWrapper,
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
  func asReference() -> ActionIntermediate {
    return ActionIntermediate(
      prototype: ActionPrototype(
        isFlow: false,
        names: names,
        namespace: [],
        parameters: .none,
        returnValue: .action(
          parameters: parameters.ordered(for: names.identifier()).map({ $0.type }),
          returnValue: returnValue),
        access: access,
        testOnlyAccess: testOnlyAccess,
        documentation: nil,
        swiftName: nil
      ),
      isReferenceWrapper: true
    )
  }
}

extension ActionIntermediate {

  var isCoverageWrapper: Bool {
    return coveredIdentifier ≠ nil
  }

  func coverageTrackingIdentifier() -> StrictString {
    return "☐\(prototype.names.identifier())"
  }
  func wrappedToTrackCoverage(referenceLookup: [ReferenceDictionary]) -> ActionIntermediate? {
    if let coverageIdentifier = coverageRegionIdentifier(referenceLookup: referenceLookup) {
      let baseName = names.identifier()
      let wrapperName = coverageTrackingIdentifier()
      return ActionIntermediate(
        prototype: ActionPrototype(
          isFlow: isFlow,
          names: [wrapperName],
          namespace: [],
          parameters: prototype.parameters
            .removingOtherNamesAnd(replacing: baseName, with: wrapperName)
            .prefixingEach(with: "→"),
          returnValue: prototype.returnValue,
          access: prototype.access,
          testOnlyAccess: prototype.testOnlyAccess,
          documentation: nil,
          swiftName: nil
        ),
        implementation: StatementListIntermediate(
          statements: [
            StatementIntermediate(
              isReturn: returnValue != nil,
              action: ActionUse(
                actionName: baseName,
                arguments: prototype.parameters
                  .prefixingEach(with: "→")
                  .ordered(for: baseName).map({ parameter in
                  return .action(
                    ActionUse(
                      actionName: parameter.names.identifier(),
                      arguments: [],
                      passage: parameter.isThrough ? .through : .into,
                      resolvedResultType: parameter.type
                    )
                  )
                }),
                passage: .into,
                resolvedResultType: returnValue
              )
            )
          ]
        ),
        originalUnresolvedCoverageRegionIdentifierComponents: nil,
        coveredIdentifier: coverageIdentifier
      )
    } else {
      return nil
    }
  }

  func coverageRegionIdentifier(referenceLookup: [ReferenceDictionary]) -> StrictString? {
    let namespace = prototype.namespace
      .lazy.map({ $0.identifier() })
      .joined(separator: ":")
    let identifier: StrictString
    if let inherited = originalUnresolvedCoverageRegionIdentifierComponents {
      identifier = resolve(globallyUniqueIdentifierComponents: inherited, referenceLookup: referenceLookup)
    } else {
      identifier = globallyUniqueIdentifier(referenceLookup: referenceLookup)
    }
    return [namespace, identifier]
      .joined(separator: ":")
  }

  func allCoverageRegionIdentifiers(
    referenceLookup: [ReferenceDictionary],
    skippingSubregions: Bool
  ) -> [StrictString] {
    var result: [StrictString] = []
    if let base = coverageRegionIdentifier(referenceLookup: referenceLookup) {
      result.append(base)
      if !skippingSubregions {
        for entry in 0 ..< countCoverageSubregions() {
          result.append("\(base):{\((entry + 1).inDigits())}")
        }
      }
    }
    return result
  }

  func countCoverageSubregions() -> Int {
    var count: Int = 0
    implementation?.countCoverageSubregions(count: &count)
    return count
  }
}

extension ActionIntermediate {
  func swiftIdentifier() -> StrictString? {
    guard var name = swiftName else {
      return nil
    }
    guard let firstSpace = name.firstIndex(of: " ") else {
      fatalError("Swift name lacks space to indicate end of function name (where the opening parenthesis should be in Swift.")
    }
    let functionName = StrictString(name[..<firstSpace])
    name.removeSubrange(...firstSpace)
    var parameterNames: [StrictString] = []
    while !name.isEmpty {
      if name.hasPrefix("()".scalars.literal()) {
        parameterNames.append("_")
        name.removeFirst(2)
      } else {
        guard let next = name.firstIndex(of: "(") else {
          fatalError("Swift cannot have postfix name components.")
        }
        var parameterName = StrictString(name[..<next])
        name.removeSubrange(..<next)
        if parameterName.last == " " {
          parameterName.removeLast()
        }
        parameterNames.append(parameterName)
        if name.hasPrefix("()") {
          name.removeFirst(2)
        }
      }
      if name.hasPrefix(" ") {
        name.removeFirst()
      }
    }
    return "\(functionName)(\(parameterNames.joined(separator: ":")):)"
  }
  func swiftSignature(referenceLookup: [ReferenceDictionary]) -> StrictString? {
    guard let name = swiftName,
      let identifier = swiftIdentifier() else {
      return nil
    }
    let components = identifier.components(separatedBy: ":")
    let parameters = self.parameters.ordered(for: name)
    var result: StrictString = ""
    for index in parameters.indices {
      if index != parameters.startIndex {
        result.append(contentsOf: ", ")
      }
      result.append(contentsOf: components[index].contents)
      result.append(contentsOf: ": ".scalars)
      result.append(contentsOf: Swift.source(for: parameters[index].type, referenceLookup: referenceLookup).scalars)
    }
    result.append(contentsOf: components.last!.contents)
    return result
  }
}

extension ActionIntermediate {

  func requiredIdentifiers(
    moduleReferenceDictionary: ReferenceDictionary
  ) -> [StrictString] {
    var result: [StrictString] = []
    result.append(
      contentsOf: prototype.requiredIdentifiers(
        referenceDictionary: moduleReferenceDictionary
      )
    )
    for native in allNativeImplementations() {
      for parameterReference in native.parameters {
        if let typeInstead = parameterReference.typeInstead {
          result.append(
            contentsOf: typeInstead.requiredIdentifiers(
              referenceDictionary: moduleReferenceDictionary
            )
          )
        }
      }
    }
    if let implementation = self.implementation {
      result.append(
        contentsOf: implementation.requiredIdentifiers(
          context: [moduleReferenceDictionary]
        )
      )
    }
    return result
  }
}
