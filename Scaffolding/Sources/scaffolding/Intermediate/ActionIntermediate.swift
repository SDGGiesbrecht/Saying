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
  var declaration: ParsedActionDeclaration?
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
  var clientAccess: Bool {
    return prototype.clientAccess
  }
  var testOnlyAccess: Bool {
    return prototype.testOnlyAccess
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

  static func construct(
    _ declaration: ParsedActionDeclaration,
    namespace: [Set<StrictString>]
  ) -> Result<ActionIntermediate, ErrorList<ActionIntermediate.ConstructionError>> {
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
    for implementation in declaration.implementation.implementations {
      switch implementation {
      case .native(let native):
        switch NativeActionImplementationIntermediate.construct(
          implementation: native.expression,
          indexTable: prototype.completeParameterIndexTable
        ) {
        case .failure(let error):
          errors.append(contentsOf: error.errors.map({ ConstructionError.brokenNativeActionImplementation($0) }))
        case .success(let constructed):
          switch native.language.identifierText() {
          case "C":
            c = constructed
          case "C♯":
            cSharp = constructed
            disallowImports(in: native, errors: &errors)
          case "JavaScript":
            javaScript = constructed
            disallowImports(in: native, errors: &errors)
          case "Kotlin":
            kotlin = constructed
            disallowImports(in: native, errors: &errors)
          case "Swift":
            swift = constructed
            disallowImports(in: native, errors: &errors)
          default:
            errors.append(ConstructionError.unknownLanguage(native.language))
          }
        }
      case .source(let source):
        #warning("Not implemented yet.")
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
        declaration: declaration
      )
    )
  }

  func validateReferences(module: ModuleIntermediate, errors: inout [ReferenceError]) {
    prototype.validateReferences(module: module, errors: &errors)
  }
}

extension ActionIntermediate {
  func merging(requirement: RequirementIntermediate) -> Result<ActionIntermediate, ErrorList<ReferenceError>> {
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
    if clientAccess ≠ requirement.clientAccess {
      errors.append(.mismatchedAccess(access: self.declaration!.access!))
    }
    if testOnlyAccess ≠ requirement.testOnlyAccess {
      errors.append(.mismatchedTestAccess(testAccess: self.declaration!.testAccess!))
    }
    if ¬errors.isEmpty {
      return .failure(ErrorList(errors))
    }
    let mergedDocumentation = documentation.merging(inherited: requirement.documentation)
    return .success(
      ActionIntermediate(
        prototype: ActionPrototype(
          names: names ∪ requirement.names,
          parameters: mergedParameters,
          reorderings: mergedReorderings,
          returnValue: returnValue,
          clientAccess: clientAccess,
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
        coveredIdentifier: coveredIdentifier
      )
    )
  }
}

extension ActionIntermediate {
  func lookupParameter(_ identifier: StrictString) -> ParameterIntermediate? {
    return prototype.lookupParameter(identifier)
  }
}

extension ActionIntermediate {

  var isCoverageWrapper: Bool {
    return coveredIdentifier ≠ nil
  }

  func coverageTrackingIdentifier() -> StrictString {
    return "☐\(prototype.names.identifier())"
  }
  func wrappedToTrackCoverage() -> ActionIntermediate? {
    if let coverageIdentifier = coverageRegionIdentifier() {
      return ActionIntermediate(
        prototype: ActionPrototype(
          names: [coverageTrackingIdentifier()],
          parameters: prototype.parameters,
          reorderings: prototype.reorderings,
          returnValue: prototype.returnValue,
          clientAccess: prototype.clientAccess,
          testOnlyAccess: prototype.testOnlyAccess,
          completeParameterIndexTable: prototype.completeParameterIndexTable,
          declarationReturnValueType: prototype.declarationReturnValueType
        ),
        implementation: ActionUse(
          actionName: prototype.names.identifier(),
          arguments: prototype.parameters.map({ parameter in
            return ActionUse(
              actionName: parameter.names.identifier(),
              arguments: []
            )
          })
        ),
        coveredIdentifier: coverageIdentifier
      )
    } else {
      return nil
    }
  }

  func coverageRegionIdentifier() -> StrictString? {
    return prototype.names.identifier()
  }
}
