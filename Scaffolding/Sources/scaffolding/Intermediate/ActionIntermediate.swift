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
  var parameters: [ParameterIntermediate] {
    return prototype.parameters
  }
  var reorderings: [StrictString: [Int]] {
    return prototype.reorderings
  }
  var returnValue: StrictString? {
    return prototype.returnValue
  }
  var access: AccessIntermediate {
    return prototype.access
  }
  var testOnlyAccess: Bool {
    return prototype.testOnlyAccess
  }
}

extension ActionIntermediate: Scope {
  func lookupAction(
    _ identifier: StrictString,
    signature: [StrictString],
    specifiedReturnValue: StrictString??
  ) -> ActionIntermediate? {
    guard let parameter = prototype.lookupParameter(identifier) else {
      return nil
    }
    return ActionIntermediate(
      prototype: ActionPrototype(
        names: parameter.names,
        namespace: [],
        parameters: [],
        reorderings: [:],
        access: .inferred,
        testOnlyAccess: false,
        completeParameterIndexTable: [:]
      )
    )
  }
}

extension ActionIntermediate {
  func unresolvedGloballyUniqueIdentifierComponents() -> [StrictString] {
    let identifier = names.identifier()
    return [identifier]
      .appending(contentsOf: signature(orderedFor: identifier))
      .appending(returnValue ?? "")
  }
  func resolve(
    globallyUniqueIdentifierComponents: [StrictString],
    module: ModuleIntermediate) -> StrictString {
    return globallyUniqueIdentifierComponents
        .lazy.map({ module.resolve(identifier: $0) })
        .joined(separator: ":")
  }
  func globallyUniqueIdentifier(module: ModuleIntermediate) -> StrictString {
    return resolve(
      globallyUniqueIdentifierComponents: unresolvedGloballyUniqueIdentifierComponents(),
      module: module
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
          implementation: implementation.expression,
          indexTable: prototype.completeParameterIndexTable
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

  func validateReferences(module: ModuleIntermediate, errors: inout [ReferenceError]) {
    prototype.validateReferences(module: module, errors: &errors)
    implementation?.validateReferences(context: [module, self], testContext: false, errors: &errors)
  }
}

extension ActionIntermediate {
  func merging(
    requirement: RequirementIntermediate,
    useAccess: AccessIntermediate,
    typeLookup: [StrictString: StrictString],
    canonicallyOrderedUseArguments: [Set<StrictString>]
  ) -> Result<ActionIntermediate, ErrorList<ReferenceError>> {
    var errors: [ReferenceError] = []
    let correlatedName = self.names.first(where: { requirement.names.contains($0) })!
    let nameToRequirement = requirement.reorderings[correlatedName]!
    let nameToSelf = self.reorderings[correlatedName]!
    let mergedParameters = self.parameters.indices.map { index in
      let nameIndex = nameToSelf.firstIndex(of: index)!
      let requirementIndex = nameToRequirement[nameIndex]
      return self.parameters[index]
        .merging(requirement: requirement.parameters[requirementIndex])
    }
    var mergedReorderings = self.reorderings
    for (name, reordering) in requirement.reorderings {
      let rearranged = reordering.map { requirementIndex in
        let correlatedNameIndex = nameToRequirement.firstIndex(of: requirementIndex)!
        let ownIndex = nameToSelf[correlatedNameIndex]
        return ownIndex
      }
      if let existing = mergedReorderings[name] {
        if existing ≠ rearranged {
          errors.append(.mismatchedParameters(name: name, declaration: self.declaration!.name))
        }
      } else {
        mergedReorderings[name] = rearranged
      }
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
      canonicallyOrderedUseArguments: canonicallyOrderedUseArguments
    )
    return .success(
      ActionIntermediate(
        prototype: ActionPrototype(
          names: names ∪ requirement.names,
          namespace: prototype.namespace,
          parameters: mergedParameters,
          reorderings: mergedReorderings,
          returnValue: returnValue,
          access: access,
          testOnlyAccess: testOnlyAccess,
          documentation: mergedDocumentation,
          completeParameterIndexTable: [:]
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
    typeLookup: [StrictString: StrictString],
    canonicallyOrderedUseArguments: [Set<StrictString>]
  ) -> ActionIntermediate {
    let newParameters = parameters.map({ parameter in
      return ParameterIntermediate(
        names: parameter.names,
        type: typeLookup[parameter.type] ?? parameter.type,
        typeDeclaration: parameter.typeDeclaration
      )
    })
    let newReturnValue = returnValue.flatMap { typeLookup[$0] ?? $0 }
    let newDocumentation = documentation.flatMap({ documentation in
      return documentation.specializing(
        typeLookup: typeLookup,
        canonicallyOrderedUseArguments: canonicallyOrderedUseArguments
      )
    })
    return ActionIntermediate(
      prototype: ActionPrototype(
        names: names,
        namespace: prototype.namespace,
        parameters: newParameters,
        reorderings: reorderings,
        returnValue: newReturnValue,
        access: min(self.access, use.access),
        testOnlyAccess: self.testOnlyAccess ∨ use.testOnlyAccess,
        documentation: newDocumentation,
        completeParameterIndexTable: [:]
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

  func signature(orderedFor name: StrictString) -> [StrictString] {
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
  func coverageTrackingReordering() -> [Int] {
    return reorderings[prototype.names.identifier()]!
  }
  func wrappedToTrackCoverage(module: ModuleIntermediate) -> ActionIntermediate? {
    if let coverageIdentifier = coverageRegionIdentifier(module: module) {
      let newName = coverageTrackingIdentifier()
      return ActionIntermediate(
        prototype: ActionPrototype(
          names: [newName],
          namespace: [],
          parameters: prototype.parameters,
          reorderings: [newName: coverageTrackingReordering()],
          returnValue: prototype.returnValue,
          access: prototype.access,
          testOnlyAccess: prototype.testOnlyAccess,
          completeParameterIndexTable: prototype.completeParameterIndexTable,
          declarationReturnValueType: prototype.declarationReturnValueType
        ),
        implementation: ActionUse(
          actionName: prototype.names.identifier(),
          arguments: prototype.parameters.map({ parameter in
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

  func coverageRegionIdentifier(module: ModuleIntermediate) -> StrictString? {
    let namespace = prototype.namespace
      .lazy.map({ $0.identifier() })
      .joined(separator: ":")
    let identifier: StrictString
    if let inherited = originalUnresolvedCoverageRegionIdentifierComponents {
      identifier = resolve(globallyUniqueIdentifierComponents: inherited, module: module)
    } else {
      identifier = globallyUniqueIdentifier(module: module)
    }
    return [namespace, identifier]
      .joined(separator: ":")
  }
}
