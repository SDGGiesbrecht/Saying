import SDGLogic
import SDGCollections
import SDGText

struct RequirementIntermediate {
  fileprivate var prototype: ActionPrototype
  var declaration: ParsedRequirementDeclaration?

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

extension RequirementIntermediate {

  static func construct(
    _ declaration: ParsedRequirementDeclaration
  ) -> Result<RequirementIntermediate, ErrorList<RequirementIntermediate.ConstructionError>> {
    var errors: [RequirementIntermediate.ConstructionError] = []

    let prototype: ActionPrototype
    switch ActionPrototype.construct(declaration) {
    case .failure(let prototypeError):
      errors.append(contentsOf: prototypeError.errors.map({ .brokenPrototype($0) }))
      return .failure(ErrorList(errors))
    case .success(let constructed):
      prototype = constructed
    }
    if ¬errors.isEmpty {
      return .failure(ErrorList(errors))
    }
    return .success(
      RequirementIntermediate(
        prototype: prototype,
        declaration: declaration
      )
    )
  }

  func validateReferences(module: ModuleIntermediate, errors: inout [ReferenceError]) {
    prototype.validateReferences(module: module, errors: &errors)
  }
}

extension RequirementIntermediate {
  func lookupParameter(_ identifier: StrictString) -> ParameterIntermediate? {
    return prototype.lookupParameter(identifier)
  }
}
