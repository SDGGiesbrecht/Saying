import SDGLogic
import SDGText

struct NativeThingImplementation {
  var type: StrictString
  var requiredImport: StrictString?
}

extension NativeThingImplementation {

  static func construct(
    implementation: ParsedNativeThing
  ) -> Result<NativeThingImplementation, ErrorList<ConstructionError>> {
    var errors: [ConstructionError] = []
    var textComponents: [StrictString] = []
    for component in implementation.type.components {
      switch component {
      case .literal(let literal):
        switch LiteralIntermediate.construct(literal: literal) {
        case .failure(let error):
          errors.append(contentsOf: error.errors.map({ ConstructionError.literalError($0) }))
        case .success(let literal):
          textComponents.append(StrictString(literal.string))
        }
      case .parameter(let parameter):
        #warning("Not implemented yet.")
        print("Native thing is dropping parameter.")
      }
    }
    #warning("Dropping parameters, etc.")
    let type = textComponents.joined()
    if ¬errors.isEmpty {
      return .failure(ErrorList(errors))
    }
    return .success(NativeThingImplementation(
      type: type,
      requiredImport: implementation.importNode?.importNode.identifierText()
    ))
  }
}
