import SDGLogic
import SDGText

protocol Platform {
  // Identifiers
  static func sanitize(identifier: StrictString, leading: Bool) -> String

  // Things
  static func nativeName(of thing: Thing) -> StrictString?

  // Actions
  static func nativeImplementation(of action: ActionIntermediate) -> SwiftImplementation?
  static func source(for parameter: ParameterIntermediate, module: ModuleIntermediate) -> String
  static var emptyReturnType: String? { get }
  static func returnSection(with returnValue: String) -> String?
  static func coverageRegistration(identifier: String) -> String
  static func expression(doing actionUse: ActionUse, context: ActionIntermediate, module: ModuleIntermediate) -> String
  static func actionDeclaration(
    name: String,
    parameters: String,
    returnSection: String?,
    returnKeyword: String?,
    coverageRegistration: String?,
    implementation: String
  ) -> String
}

extension Platform {

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
      #warning("Need to sanitize string literal.")
      coverageRegistration = self.coverageRegistration(identifier: String(identifier))
    } else {
      coverageRegistration = nil
    }
    let implementation = expression(doing: action.implementation!, context: action, module: module)
    return actionDeclaration(
      name: name,
      parameters: parameters,
      returnSection: returnSection,
      returnKeyword: returnKeyword,
      coverageRegistration: coverageRegistration,
      implementation: implementation
    )
  }
}
