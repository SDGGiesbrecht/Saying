import SDGLogic
import SDGCollections
import SDGText

struct ActionIntermediate {
  fileprivate var prototype: ActionPrototype
  var c: NativeActionImplementation?
  var cSharp: NativeActionImplementation?
  var javaScript: NativeActionImplementation?
  var kotlin: NativeActionImplementation?
  var swift: NativeActionImplementation?
  var implementation: ActionUse?
  var declaration: ParsedActionDeclaration?
  var coveredIdentifier: StrictString?

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
  var testOnlyAccess: Bool {
    return prototype.testOnlyAccess
  }
}

extension ActionIntermediate {

  static func disallowImports(
    in implementation: ParsedActionImplementation,
    errors: inout [ConstructionError]
  ) {
    if implementation.expression.importNode ≠ nil {
      errors.append(ConstructionError.invalidImport(implementation))
    }
  }

  static func construct(
    _ declaration: ParsedActionDeclaration
  ) -> Result<ActionIntermediate, ErrorList<ActionIntermediate.ConstructionError>> {
    var errors: [ActionIntermediate.ConstructionError] = []

    let prototype: ActionPrototype
    switch ActionPrototype.construct(declaration) {
    case .failure(let prototypeError):
      errors.append(contentsOf: prototypeError.errors.map({ .brokenPrototype($0) }))
      return .failure(ErrorList(errors))
    case .success(let constructed):
      prototype = constructed
    }
    var c: NativeActionImplementation?
    var cSharp: NativeActionImplementation?
    var javaScript: NativeActionImplementation?
    var kotlin: NativeActionImplementation?
    var swift: NativeActionImplementation?
    for implementation in declaration.implementation.implementations {
      switch NativeActionImplementation.construct(
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
  func merging(requirement: RequirementIntermediate) -> ActionIntermediate {
    #warning("Not implemented yet.")
    return self
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
