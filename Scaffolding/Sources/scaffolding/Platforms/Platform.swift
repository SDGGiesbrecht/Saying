import SDGControlFlow
import SDGLogic
import SDGCollections
import SDGText

protocol Platform {
  // Identifiers
  static var allowsAllUnicodeIdentifiers: Bool { get }
  static var allowedIdentifierStartCharacterPoints: [UInt32] { get }
  static var additionalAllowedIdentifierContinuationCharacterPoints: [UInt32] { get }
  static var disallowedStringLiteralPoints: [UInt32] { get }
  static var _allowedIdentifierStartCharactersCache: Set<Unicode.Scalar>? { get set }
  static var _allowedIdentifierContinuationCharactersCache: Set<Unicode.Scalar>? { get set }
  static var _disallowedStringLiteralCharactersCache: Set<Unicode.Scalar>? { get set }
  static func escapeForStringLiteral(character: Unicode.Scalar) -> String

  // Things
  static func nativeName(of thing: Thing) -> StrictString?

  // Actions
  static func nativeImplementation(of action: ActionIntermediate) -> SwiftImplementation?
  static func source(for parameter: ParameterIntermediate, module: ModuleIntermediate) -> String
  static var emptyReturnType: String? { get }
  static func returnSection(with returnValue: String) -> String?
  static func coverageRegistration(identifier: String) -> String
  static func statement(expression: ActionUse, context: ActionIntermediate?, module: ModuleIntermediate) -> String
  static func actionDeclaration(
    name: String,
    parameters: String,
    returnSection: String?,
    returnKeyword: String?,
    coverageRegistration: String?,
    implementation: String
  ) -> String

  // Module
  static var importsNeededByTestScaffolding: [String]? { get }
  static func coverageRegionSet(regions: [String]) -> [String]
  static var registerCoverageAction: [String] { get }
  static var actionDeclarationsContainerStart: [String]? { get }
  static var actionDeclarationsContainerEnd: [String]? { get }
  static func source(for test: TestIntermediate, module: ModuleIntermediate) -> String
  static func testCall(for test: TestIntermediate) -> String
  static func testSummary(testCalls: [String]) -> [String]
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
    return scalar ∈ allowedIdentifierStartCharacters
      ∨ (allowsAllUnicodeIdentifiers ∧ scalar.properties.isIDStart ∧ ¬scalar.isVulnerableToNormalization)
  }
  static func allowedAsIdentifierContinuation(_ scalar: Unicode.Scalar) -> Bool {
    return scalar ∈ allowedIdentifierContinuationCharacters
    ∨ (allowsAllUnicodeIdentifiers ∧ scalar.properties.isIDContinue ∧ ¬scalar.isVulnerableToNormalization)
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
      allowedAsIdentifierStart(first) {
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

  static func call(to reference: ActionUse, context: ActionIntermediate?, module: ModuleIntermediate) -> String {
    if let parameter = context?.lookupParameter(reference.actionName) {
      return String(sanitize(identifier: parameter.names.identifier(), leading: false))
    } else {
      let bareAction = module.lookupAction(reference.actionName)!
      let action = (context?.isCoverageWrapper ?? false) ? bareAction : module.lookupAction(bareAction.coverageTrackingIdentifier())!
      if let native = nativeImplementation(of: action) {
        var result = ""
        for index in native.textComponents.indices {
          result.append(contentsOf: String(native.textComponents[index]))
          if index ≠ native.textComponents.indices.last {
            let rootIndex = native.reordering[index]
            let reordered = action.reorderings[reference.actionName]![rootIndex]
            let argument = reference.arguments[reordered]
            result.append(contentsOf: call(to: argument, context: context, module: module))
          }
        }
        return result
      } else {
        let name = sanitize(identifier: action.names.identifier(), leading: true)
        let arguments = reference.arguments
          .lazy.map({ argument in
            return call(to: argument, context: context, module: module)
          })
          .joined(separator: ", ")
        return "\(name)(\(arguments))"
      }
    }
  }

  static func declaration(for action: ActionIntermediate, module: ModuleIntermediate) -> String? {
    if nativeImplementation(of: action) ≠ nil {
      return nil
    }

    let name = sanitize(identifier: action.names.identifier(), leading: true)
    let parameters = action.parameters
      .lazy.map({ source(for: $0, module: module) })
      .joined(separator: ", ")

    let returnValue: String?
    if let specified = action.returnValue {
      let type = module.lookupThing(specified)!
      if let native = nativeName(of: type) {
        returnValue = String(native)
      } else {
        returnValue = sanitize(identifier: type.names.identifier(), leading: false)
      }
    } else {
      returnValue = emptyReturnType
    }

    let returnSection = returnValue.flatMap({ self.returnSection(with: $0) })
    let returnKeyword = returnValue == nil ? "" : "return "

    let coverageRegistration: String?
    if let identifier = action.coveredIdentifier {
      coverageRegistration = self.coverageRegistration(identifier: sanitize(stringLiteral: identifier))
    } else {
      coverageRegistration = nil
    }
    let implementation = statement(expression: action.implementation!, context: action, module: module)
    return actionDeclaration(
      name: name,
      parameters: parameters,
      returnSection: returnSection,
      returnKeyword: returnKeyword,
      coverageRegistration: coverageRegistration,
      implementation: implementation
    )
  }

  static func build(module: ModuleIntermediate) -> String {
    var result: [String] = []
    if let imports = importsNeededByTestScaffolding {
      result.append(contentsOf: imports)
    }
    if ¬result.isEmpty {
      result.append("")
    }

    let regions = module.actions.values
      .lazy.filter({ ¬$0.isCoverageWrapper })
      .lazy.compactMap({ $0.coverageRegionIdentifier() })
      .sorted()
      .map({ sanitize(stringLiteral: $0) })
    result.append(contentsOf: coverageRegionSet(regions: regions))
    result.append(contentsOf: registerCoverageAction)

    if let start = actionDeclarationsContainerStart {
      result.append("")
      result.append(contentsOf: start)
    }
    for actionIdentifier in module.actions.keys.sorted() {
      if let declaration = module.actions[actionIdentifier]
        .flatMap({ declaration(for: $0, module: module) }) {
        result.append(contentsOf: [
          "",
          declaration
        ])
      }
    }
    for test in module.tests {
      result.append(contentsOf: [
        "",
        source(for: test, module: module),
      ])
    }
    result.append("")
    result.append(contentsOf: testSummary(testCalls: module.tests.map({ testCall(for: $0) })))
    if let end = actionDeclarationsContainerEnd {
      result.append(contentsOf: end)
    }

    return result.joined(separator: "\n").appending("\n")
  }
}
