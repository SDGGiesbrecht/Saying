import Foundation

import SDGControlFlow
import SDGLogic
import SDGCollections
import SDGText

protocol Platform {
  // Miscellaneous
  static var directoryName: String { get }
  static var indent: String { get }

  // Identifiers
  static var allowsAllUnicodeIdentifiers: Bool { get }
  static var allowedIdentifierStartGeneralCategories: Set<Unicode.GeneralCategory> { get }
  static var allowedIdentifierStartCharacterPoints: [UInt32] { get }
  static var additionalAllowedIdentifierContinuationGeneralCategories: Set<Unicode.GeneralCategory> { get }
  static var additionalAllowedIdentifierContinuationCharacterPoints: [UInt32] { get }
  static var disallowedStringLiteralPoints: [UInt32] { get }
  static var _allowedIdentifierStartCharactersCache: Set<Unicode.Scalar>? { get set }
  static var _allowedIdentifierContinuationCharactersCache: Set<Unicode.Scalar>? { get set }
  static var _disallowedStringLiteralCharactersCache: Set<Unicode.Scalar>? { get set }
  static func escapeForStringLiteral(character: Unicode.Scalar) -> String

  // Cases
  static func caseReference(name: String, type: String, simple: Bool, ignoringValue: Bool) -> String
  static func caseDeclaration(
    name: String,
    contents: String?,
    index: Int,
    simple: Bool,
    parentType: String
  ) -> String
  static var needsSeparateCaseStorage: Bool { get }
  static func caseStorageDeclaration(
    name: String,
    contents: String
  ) -> String?

  // Things
  static var isTyped: Bool { get }
  static func nativeType(of thing: Thing) -> NativeThingImplementationIntermediate?
  static func actionType(parameters: String, returnValue: String) -> String
  static func actionReferencePrefix(isVariable: Bool) -> String?
  static func enumerationTypeDeclaration(
    name: String,
    cases: [String],
    simple: Bool,
    storageCases: [String]
  ) -> String

  // Actions
  static func nativeImplementation(of action: ActionIntermediate) -> NativeActionImplementationIntermediate?
  static func parameterDeclaration(name: String, type: String) -> String
  static func parameterDeclaration(name: String, parameters: String, returnValue: String) -> String
  static var emptyReturnType: String? { get }
  static var emptyReturnTypeForActionType: String { get }
  static func returnSection(with returnValue: String) -> String?
  static var needsForwardDeclarations: Bool { get }
  static func forwardActionDeclaration(
    name: String,
    parameters: String,
    returnSection: String?
  ) -> String?
  static func coverageRegistration(identifier: String) -> String
  static func statement(
    expression: ActionUse,
    context: ActionIntermediate?,
    localLookup: [ReferenceDictionary],
    referenceLookup: [ReferenceDictionary],
    contextCoverageIdentifier: StrictString?,
    coverageRegionCounter: inout Int
  ) -> String
  static func actionDeclaration(
    name: String,
    parameters: String,
    returnSection: String?,
    coverageRegistration: String?,
    implementation: [String]
  ) -> String

  // Imports
  static func statementImporting(_ importTarget: String) -> String

  // Module
  static var importsNeededByTestScaffolding: Set<String> { get }
  static func coverageRegionSet(regions: [String]) -> [String]
  static var registerCoverageAction: [String] { get }
  static var actionDeclarationsContainerStart: [String]? { get }
  static var actionDeclarationsContainerEnd: [String]? { get }
  static func testSource(identifier: String, statement: String) -> [String]
  static func testCall(for identifier: String) -> String
  static func testSummary(testCalls: [String]) -> [String]

  // Package
  static func testEntryPoint() -> [String]?
  static var sourceFileName: String { get }
  static func createOtherProjectContainerFiles(projectDirectory: URL) throws
}

extension Platform {

  static func filterUnsafe(characters: [UInt32]) -> Set<Unicode.Scalar> {
    return Set(
      characters.lazy.compactMap({ value in
        guard let scalar = Unicode.Scalar(value),
          ¬scalar.isVulnerableToNormalization else {
          return nil
        }
        return scalar
      })
    )
  }
  static var allowedIdentifierStartCharacters: Set<Unicode.Scalar> {
    return cached(in: &_allowedIdentifierStartCharactersCache) {
      return filterUnsafe(characters: allowedIdentifierStartCharacterPoints)
    }
  }
  static var allowedIdentifierContinuationCharacters: Set<Unicode.Scalar> {
    return cached(in: &_allowedIdentifierContinuationCharactersCache) {
      allowedIdentifierStartCharacters
      ∪ filterUnsafe(characters: additionalAllowedIdentifierContinuationCharacterPoints)
    }
  }
  static var disallowedStringLiteralCharacters: Set<Unicode.Scalar> {
    return cached(in: &_disallowedStringLiteralCharactersCache) {
      return Set(
        disallowedStringLiteralPoints
          .lazy.compactMap({ Unicode.Scalar($0) })
      )
    }
  }
  static func allowedAsIdentifierStart(_ scalar: Unicode.Scalar) -> Bool {
    return (scalar ∈ allowedIdentifierStartCharacters)
    ∨
    (
      (
        (allowsAllUnicodeIdentifiers ∧ scalar.properties.isIDStart)
        ∨
        (scalar.properties.generalCategory ∈ allowedIdentifierStartGeneralCategories)
      )
      ∧
      (¬scalar.isVulnerableToNormalization)
    )
  }
  static func allowedAsIdentifierContinuation(_ scalar: Unicode.Scalar) -> Bool {
    return (scalar ∈ allowedIdentifierContinuationCharacters)
    ∨
    (
      (
        (allowsAllUnicodeIdentifiers ∧ scalar.properties.isIDContinue)
        ∨
        (
          scalar.properties.generalCategory ∈ allowedIdentifierStartGeneralCategories
          ∨
          scalar.properties.generalCategory ∈ additionalAllowedIdentifierContinuationGeneralCategories
        )
      )
      ∧
      (¬scalar.isVulnerableToNormalization)
    )
  }
  static func disallowedInStringLiterals(_ scalar: Unicode.Scalar) -> Bool {
    return scalar ∈ disallowedStringLiteralCharacters
    ∨ Character(scalar).isNewline
    ∨ scalar.isVulnerableToNormalization
  }

  static func sanitize(identifier: StrictString, leading: Bool) -> String {
    var result: String = identifier.lazy
      .map({ allowedAsIdentifierContinuation($0) ∧ $0 ≠ "_" ? "\($0)" : "_\($0.hexadecimalCode)" })
      .joined()
    if leading,
      let first = result.scalars.first,
      ¬allowedAsIdentifierStart(first) {
      result.scalars.removeFirst()
      result.prepend(contentsOf: "_\(first.hexadecimalCode)")
    }
    return result
  }

  static func sanitize(stringLiteral: StrictString) -> String {
    return stringLiteral.lazy
      .map({ ¬disallowedInStringLiterals($0) ? "\($0)" : escapeForStringLiteral(character: $0) })
      .joined()
  }

  static func isSimpleEnumeration(
    _ type: ParsedTypeReference,
    referenceLookup: [ReferenceDictionary]
  ) -> Bool {
    let intermediate: Thing
    switch type {
    case .simple(let simple):
      intermediate = referenceLookup.lookupThing(simple.identifier, components: [])!
    case .compound(let identifier, let components):
      intermediate = referenceLookup.lookupThing(
        identifier.name(),
        components: components.map({ $0.key })
      )!
    case .action, .statements, .enumerationCase:
      return false
    }
    return intermediate.isSimple
  }
  static func source(for type: ParsedTypeReference, referenceLookup: [ReferenceDictionary]) -> String {
    switch type {
    case .simple(let simple):
      let type = referenceLookup.lookupThing(simple.identifier, components: [])!
      if let native = nativeType(of: type) {
        return String(native.textComponents.joined())
      } else {
        return sanitize(identifier: type.names.identifier(), leading: true)
      }
    case .compound(identifier: let identifier, components: let components):
      let type = referenceLookup.lookupThing(
        identifier.name(),
        components: components.map({ $0.key })
      )!
      if let native = nativeType(of: type) {
        var result = ""
        for index in native.textComponents.indices {
          result.append(contentsOf: String(native.textComponents[index]))
          if index ≠ native.textComponents.indices.last {
            let type = native.parameters[index].resolvedType!
            result.append(contentsOf: source(for: type, referenceLookup: referenceLookup))
          }
        }
        return result
      } else {
        return sanitize(
          identifier: type.names.identifier(),
          leading: true
        )
      }
    case .action(parameters: let actionParameters, returnValue: let actionReturn):
      return actionType(
        parameters: actionParameters
          .lazy.map({ source(for: $0, referenceLookup: referenceLookup) })
          .joined(separator: ", "),
        returnValue:
          actionReturn.map({ source(for: $0, referenceLookup: referenceLookup) })
            ?? emptyReturnTypeForActionType
      )
    case .statements:
      fatalError("Statements have no platform type.")
    case .enumerationCase(enumeration: let enumeration, identifier: _):
      return source(for: enumeration, referenceLookup: referenceLookup)
    }
  }

  static func declaration(
    for enumerationCase: CaseIntermediate,
    index: Int,
    simple: Bool,
    parentType: String,
    referenceLookup: [ReferenceDictionary]
  ) -> String {
    let name = sanitize(
      identifier: enumerationCase.names.identifier(),
      leading: true
    )
    let contents = enumerationCase.contents
      .map({ source(for: $0, referenceLookup: referenceLookup) })
    return caseDeclaration(
      name: name,
      contents: contents,
      index: index,
      simple: simple,
      parentType: parentType
    )
  }
  static func storageDeclaration(
    for enumerationCase: CaseIntermediate,
    referenceLookup: [ReferenceDictionary]
  ) -> String? {
    if ¬needsSeparateCaseStorage {
      return nil
    }
    guard let contents = enumerationCase.contents
      .map({ source(for: $0, referenceLookup: referenceLookup) }) else {
      return nil
    }
    let name = sanitize(
      identifier: enumerationCase.names.identifier(),
      leading: true
    )
    return caseStorageDeclaration(
      name: name,
      contents: contents
    )
  }
  static func declaration(
    for thing: Thing,
    externalReferenceLookup: [ReferenceDictionary]
  ) -> String? {
    if ¬isTyped,
      thing.cases.isEmpty {
      return nil
    }
    if nativeType(of: thing) ≠ nil {
      return nil
    }
    if ¬isTyped,
      thing.cases.allSatisfy({ enumerationCase in
        return nativeImplementation(of: enumerationCase.referenceAction) ≠ nil
      }) {
      return nil
    }

    let name = sanitize(
      identifier: thing.names.identifier(),
      leading: true
    )
    if thing.cases.isEmpty {
      fatalError("Custom things not implemented yet.")
    } else {
      var cases: [String] = []
      var storageCases: [String] = []
      for enumerationCase in thing.cases {
        cases.append(
          declaration(
            for: enumerationCase,
            index: cases.endIndex,
            simple: thing.isSimple,
            parentType: name,
            referenceLookup: externalReferenceLookup
          )
        )
        if let storage = storageDeclaration(for: enumerationCase, referenceLookup: externalReferenceLookup) {
          storageCases.append(storage)
        }
      }
      return enumerationTypeDeclaration(name: name, cases: cases, simple: thing.isSimple, storageCases: storageCases)
    }
  }

  static func flowCoverageRegistration(
    contextCoverageIdentifier: StrictString?,
    coverageRegionCounter: inout Int
  ) -> String? {
    coverageRegionCounter += 1
    if let coverage = contextCoverageIdentifier {
      let appendedIdentifier: StrictString = "\(coverage):{\(coverageRegionCounter.inDigits())}"
      return "\n\(self.coverageRegistration(identifier: sanitize(stringLiteral: appendedIdentifier)))"
    } else {
      return nil
    }
  }

  static func call(
    to reference: ActionUse,
    context: ActionIntermediate?,
    localLookup: [ReferenceDictionary],
    referenceLookup: [ReferenceDictionary],
    contextCoverageIdentifier: StrictString?,
    coverageRegionCounter: inout Int
  ) -> String {
    let signature = reference.arguments.map({ $0.resolvedResultType!! })
    if reference.isNew {
      return String(sanitize(identifier: reference.actionName, leading: true))
    } else if let local = localLookup.lookupAction(
      reference.actionName,
      signature: signature,
      specifiedReturnValue: reference.resolvedResultType,
      externalLookup: referenceLookup
    ) {
      return String(sanitize(identifier: local.names.identifier(), leading: true))
    } else if let parameter = context?.lookupParameter(reference.actionName) {
      if parameter.passAction.returnValue?.key.resolving(fromReferenceLookup: referenceLookup)
        == reference.resolvedResultType!?.key.resolving(fromReferenceLookup: referenceLookup) {
        return String(sanitize(identifier: parameter.names.identifier(), leading: true))
      } else {
        return call(
          to: parameter.executeAction!,
          reference: reference,
          context: context,
          localLookup: localLookup,
          referenceLookup: referenceLookup,
          parameterName: parameter.names.identifier(),
          contextCoverageIdentifier: contextCoverageIdentifier,
          coverageRegionCounter: &coverageRegionCounter
        )
      }
    } else {
      let bareAction = referenceLookup.lookupAction(
        reference.actionName,
        signature: signature,
        specifiedReturnValue: reference.resolvedResultType
      )!
      let action = (context?.isCoverageWrapper ?? false)
        ? bareAction
        : referenceLookup.lookupAction(
          bareAction.coverageTrackingIdentifier(),
          signature: signature,
          specifiedReturnValue: reference.resolvedResultType
        )!
      var result: [String] = [
        call(
          to: bareAction.isFlow ? bareAction : action,
          reference: reference,
          context: context,
          localLookup: localLookup,
          referenceLookup: referenceLookup,
          parameterName: nil,
          contextCoverageIdentifier: contextCoverageIdentifier,
          coverageRegionCounter: &coverageRegionCounter
        )
      ]
      if bareAction.isFlow,
        bareAction.returnValue == nil,
        let coveredIdentifier = action.coveredIdentifier {
        result.prepend(
          coverageRegistration(identifier: sanitize(stringLiteral: coveredIdentifier))
        )
      }
      return result.joined(separator: "\n\(indent)")
    }
  }
  static func call(
    to action: ActionIntermediate,
    reference: ActionUse,
    context: ActionIntermediate?,
    localLookup: [ReferenceDictionary],
    referenceLookup: [ReferenceDictionary],
    parameterName: StrictString?,
    contextCoverageIdentifier: StrictString?,
    coverageRegionCounter: inout Int
  ) -> String {
    if let native = nativeImplementation(of: action) {
      let usedParameters = action.parameters.ordered(for: reference.actionName)
      var result = ""
      var local = ReferenceDictionary()
      for index in native.textComponents.indices {
        result.append(contentsOf: String(native.textComponents[index]))
        if index ≠ native.textComponents.indices.last {
          let parameter = native.parameters[index]
          if let type = parameter.typeInstead {
            let typeSource = source(for: type, referenceLookup: referenceLookup)
            result.append(contentsOf: typeSource)
          } else if let enumerationCase = parameter.caseInstead {
            switch enumerationCase {
            case .simple, .compound, .action, .statements:
              fatalError("Only enumeration cases should be stored in “caseInstead”.")
            case .enumerationCase(enumeration: let type, identifier: let identifier):
              let reference = caseReference(
                name: sanitize(identifier: identifier, leading: true),
                type: source(for: type, referenceLookup: referenceLookup),
                simple: false,
                ignoringValue: false
              )
              result.append(contentsOf: reference)
            }
          } else {
            let name = parameter.name
            let argumentIndex = usedParameters.firstIndex(where: { name ∈ $0.names })!
            let argument = reference.arguments[argumentIndex]
            switch argument {
            case .action(let actionArgument):
              result.append(
                contentsOf: call(
                  to: actionArgument,
                  context: context,
                  localLookup: localLookup.appending(local),
                  referenceLookup: referenceLookup,
                  contextCoverageIdentifier: contextCoverageIdentifier,
                  coverageRegionCounter: &coverageRegionCounter
                )
              )
            case .flow(let statements):
              if let coverage = flowCoverageRegistration(
                contextCoverageIdentifier: contextCoverageIdentifier,
                coverageRegionCounter: &coverageRegionCounter
              ) {
                result.append(coverage)
              }
              result.append("\n")
              for statement in statements.statements {
                result.append(
                  source(
                    for: statement,
                    context: context,
                    localLookup: localLookup.appending(local),
                    referenceLookup: referenceLookup,
                    contextCoverageIdentifier: contextCoverageIdentifier,
                    coverageRegionCounter: &coverageRegionCounter
                  )
                )
                result.append("\n")
              }
            }
            let newActions = argument.localActions()
            for new in newActions {
              _ = local.add(action: new)
            }
            if !newActions.isEmpty {
              local.resolveTypeIdentifiers(externalLookup: referenceLookup.appending(contentsOf: localLookup))
            }
          }
        }
      }
      return result
    } else if action.isEnumerationCaseWrapper {
      let name = sanitize(identifier: action.names.identifier(), leading: true)
      let type = source(for: action.returnValue!, referenceLookup: referenceLookup)
      return caseReference(
        name: name,
        type: type,
        simple: isSimpleEnumeration(action.returnValue!, referenceLookup: referenceLookup),
        ignoringValue: (action.isFlow ∧ action.isEnumerationCaseWrapper) ∨ action.isEnumerationValueWrapper
      )
    } else {
      let name = sanitize(
        identifier: parameterName
          ?? action.globallyUniqueIdentifier(referenceLookup: referenceLookup),
        leading: true
      )
      if action.isReferenceWrapper {
        let prefix = actionReferencePrefix(isVariable: parameterName ≠ nil) ?? ""
        return "\(prefix)\(name)"
      } else {
        var argumentsArray: [String] = []
        for argument in reference.arguments {
          switch argument {
          case .action(let actionArgument):
            argumentsArray.append(
              call(
                to: actionArgument,
                context: context,
                localLookup: localLookup,
                referenceLookup: referenceLookup,
                contextCoverageIdentifier: contextCoverageIdentifier,
                coverageRegionCounter: &coverageRegionCounter
              )
            )
          case .flow:
            fatalError("Statement parameters are only supported in native implementations (so far).")
          }
        }
        let arguments = argumentsArray.joined(separator: ", ")
        return "\(name)(\(arguments))"
      }
    }
  }

  static func source(
    for statement: StatementIntermediate,
    context: ActionIntermediate?,
    localLookup: [ReferenceDictionary],
    referenceLookup: [ReferenceDictionary],
    contextCoverageIdentifier: StrictString?,
    coverageRegionCounter: inout Int
  ) -> String {
    var entry = ""
    if statement.isReturn {
      entry.prepend(contentsOf: "return ")
    }
    let before = coverageRegionCounter
    entry.append(
      contentsOf: self.statement(
        expression: statement.action,
        context: context,
        localLookup: localLookup,
        referenceLookup: referenceLookup,
        contextCoverageIdentifier: contextCoverageIdentifier,
        coverageRegionCounter: &coverageRegionCounter
      )
    )
    if coverageRegionCounter ≠ before,
       let coverage = flowCoverageRegistration(
        contextCoverageIdentifier: contextCoverageIdentifier,
        coverageRegionCounter: &coverageRegionCounter
       ) {
      entry.append(coverage)
    }
    return entry
  }

  static func source(
    for parameter: ParameterIntermediate,
    referenceLookup: [ReferenceDictionary]
  ) -> String {
    let name = sanitize(identifier: parameter.names.identifier(), leading: true)
    if ¬isTyped {
      return name
    } else {
      switch parameter.type {
      case .simple, .compound:
        let typeSource = source(for: parameter.type, referenceLookup: referenceLookup)
        return parameterDeclaration(name: name, type: typeSource)
      case .action(parameters: let actionParameters, returnValue: let actionReturn):
        let parameters = actionParameters
          .lazy.map({ source(for: $0, referenceLookup: referenceLookup) })
          .joined(separator: ", ")
        let returnValue: String
        if let specified = actionReturn {
          returnValue = source(for: specified, referenceLookup: referenceLookup)
        } else {
          returnValue = emptyReturnTypeForActionType
        }
        return parameterDeclaration(
          name: name,
          parameters: parameters,
          returnValue: returnValue
        )
      case .statements:
        fatalError("Statements should have been handled elsewhere.")
      case .enumerationCase:
        fatalError("Enumeration cases should have been handled elsewhere.")
      }
    }
  }

  static func forwardDeclaration(
    for action: ActionIntermediate,
    referenceLookup: [ReferenceDictionary]
  ) -> String? {
    if nativeImplementation(of: action) ≠ nil
      ∨ action.isEnumerationCaseWrapper {
      return nil
    }

    let name = sanitize(
      identifier: action.globallyUniqueIdentifier(referenceLookup: referenceLookup),
      leading: true
    )
    let parameters = action.parameters.ordered(for: action.names.identifier())
      .lazy.map({ source(for: $0, referenceLookup: referenceLookup) })
      .joined(separator: ", ")

    let returnValue: String?
    if let specified = action.returnValue {
      returnValue = source(for: specified, referenceLookup: referenceLookup)
    } else {
      returnValue = emptyReturnType
    }

    let returnSection = returnValue.flatMap({ self.returnSection(with: $0) })

    return forwardActionDeclaration(
      name: name,
      parameters: parameters,
      returnSection: returnSection
    )
  }

  static func declaration(
    for action: ActionIntermediate,
    externalReferenceLookup: [ReferenceDictionary]
  ) -> String? {
    if nativeImplementation(of: action) ≠ nil
      ∨ action.isEnumerationCaseWrapper {
      return nil
    }

    let name = sanitize(
      identifier: action.globallyUniqueIdentifier(referenceLookup: externalReferenceLookup),
      leading: true
    )
    let parameters = action.parameters.ordered(for: action.names.identifier())
      .lazy.map({ source(for: $0, referenceLookup: externalReferenceLookup) })
      .joined(separator: ", ")

    let returnValue: String?
    if let specified = action.returnValue {
      returnValue = source(for: specified, referenceLookup: externalReferenceLookup)
    } else {
      returnValue = emptyReturnType
    }

    let returnSection = returnValue.flatMap({ self.returnSection(with: $0) })

    let coverageRegistration: String?
    if let identifier = action.coveredIdentifier {
      coverageRegistration = "\(indent)\(self.coverageRegistration(identifier: sanitize(stringLiteral: identifier)))"
    } else {
      coverageRegistration = nil
    }
    var locals = ReferenceDictionary()
    let nonLocalReferenceLookup = externalReferenceLookup.appending(action.parameterReferenceDictionary(externalLookup: externalReferenceLookup))
    var coverageRegionCounter = 0
    let implementation = action.implementation!.statements.map({ entry in
      let result = source(
        for: entry,
        context: action,
        localLookup: [locals],
        referenceLookup: nonLocalReferenceLookup.appending(locals),
        contextCoverageIdentifier: action.coverageRegionIdentifier(referenceLookup: externalReferenceLookup),
        coverageRegionCounter: &coverageRegionCounter
      )
      let newActions = entry.localActions()
      for local in newActions {
        _ = locals.add(action: local)
      }
      if !newActions.isEmpty {
        locals.resolveTypeIdentifiers(externalLookup: nonLocalReferenceLookup)
      }
      return result
    })
    return actionDeclaration(
      name: name,
      parameters: parameters,
      returnSection: returnSection,
      coverageRegistration: coverageRegistration,
      implementation: implementation
    )
  }

  static func identifier(for test: TestIntermediate, leading: Bool) -> String {
    return test.location.lazy.enumerated()
      .map({ sanitize(identifier: $1.identifier(), leading: leading ∧ $0 == 0) })
      .joined(separator: "_")
  }

  static func source(of test: TestIntermediate, referenceLookup: [ReferenceDictionary]) -> [String] {
    var coverageRegionCounter = 0
    return testSource(
      identifier: identifier(for: test, leading: false),
      statement: statement(
        expression: test.statement.action,
        context: nil,
        localLookup: [],
        referenceLookup: referenceLookup,
        contextCoverageIdentifier: nil,
        coverageRegionCounter: &coverageRegionCounter
      )
    )
  }

  static func call(test: TestIntermediate) -> String {
    return testCall(for: identifier(for: test, leading: false))
  }

  static func nativeImports(for referenceDictionary: ReferenceDictionary) -> Set<String> {
    var imports: Set<String> = []
    for thing in referenceDictionary.allThings() {
      if let requiredImport = nativeType(of: thing)?.requiredImport {
        imports.insert(String(requiredImport))
      }
    }
    for action in referenceDictionary.allActions() {
      if let requiredImport = nativeImplementation(of: action)?.requiredImport {
        imports.insert(String(requiredImport))
      }
    }
    return imports
  }

  static func source(for module: ModuleIntermediate) -> String {
    var result: [String] = []

    var imports = nativeImports(for: module.referenceDictionary)
    imports ∪= importsNeededByTestScaffolding
    if ¬imports.isEmpty {
      for importTarget in imports.sorted() {
        result.append(statementImporting(importTarget))
      }
      result.append("")
    }

    let moduleReferenceLookup = module.referenceDictionary
    let actionRegions: [StrictString] = moduleReferenceLookup.allActions()
      .lazy.filter({ action in
        return ¬action.isCoverageWrapper
        ∧ ¬(action.isFlow ∧ action.returnValue != nil)
      })
      .lazy.flatMap({ $0.allCoverageRegionIdentifiers(referenceLookup: [moduleReferenceLookup]) })
    let choiceRegions: [StrictString] = moduleReferenceLookup.allAbilities()
      .lazy.flatMap({ $0.defaults.values })
      .lazy.flatMap({ $0.allCoverageRegionIdentifiers(referenceLookup: [moduleReferenceLookup]) })
    let regions = Set([
      actionRegions,
      choiceRegions
    ].joined())
      .sorted()
      .map({ sanitize(stringLiteral: $0) })
    result.append(contentsOf: coverageRegionSet(regions: regions))
    result.append(contentsOf: registerCoverageAction)

    let allThings = moduleReferenceLookup.allThings(sorted: true)
    for thing in allThings {
      if let declaration = self.declaration(for: thing, externalReferenceLookup: [moduleReferenceLookup]) {
        result.append(contentsOf: [
          "",
          declaration
        ])
      }
    }

    if let start = actionDeclarationsContainerStart {
      result.append("")
      result.append(contentsOf: start)
    }
    let allActions = moduleReferenceLookup.allActions(sorted: true)
    if needsForwardDeclarations {
      for action in allActions where ¬action.isFlow {
        if let declaration = forwardDeclaration(for: action, referenceLookup: [moduleReferenceLookup]) {
          result.append(contentsOf: [
            "",
            declaration
          ])
        }
      }
    }
    for action in allActions where ¬action.isFlow {
      if let declaration = self.declaration(for: action, externalReferenceLookup: [moduleReferenceLookup]) {
        result.append(contentsOf: [
          "",
          declaration
        ])
      }
    }
    let allTests = module.allTests(sorted: true)
    for test in allTests {
      result.append("")
      result.append(contentsOf: source(of: test, referenceLookup: [moduleReferenceLookup]))
    }
    result.append("")
    result.append(contentsOf: testSummary(testCalls: allTests.map({ call(test: $0) })))
    if let end = actionDeclarationsContainerEnd {
      result.append(contentsOf: end)
    }

    return result.joined(separator: "\n").appending("\n")
  }

  static func source(for module: Module) throws -> String {
    return try source(for: module.build())
  }

  static func preparedDirectory(for package: Package) -> URL {
    return package.constructionDirectory
      .appendingPathComponent(self.directoryName)
  }

  static func prepare(package: Package) throws {
    let constructionDirectory = preparedDirectory(for: package)

    var source: [String] = [
      try package.modules()
        .lazy.map({ try self.source(for: $0) })
        .joined(separator: "\n\n")
    ]
    if let entryPoint = testEntryPoint() {
      source.append("")
      source.append(contentsOf: entryPoint)
    }
    try source.joined(separator: "\n").appending("\n")
      .save(to: constructionDirectory.appendingPathComponent(sourceFileName))
    try createOtherProjectContainerFiles(projectDirectory: constructionDirectory)
  }
}
