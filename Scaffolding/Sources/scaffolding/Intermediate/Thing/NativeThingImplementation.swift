import SDGLogic
import SDGText

struct NativeThingImplementation {
  var textComponents: [StrictString]
  var parameters: [NativeThingImplementationParameter]
  var requiredImport: StrictString?
}

extension NativeThingImplementation {

  static func construct(
    implementation: ParsedNativeThing
  ) -> Result<NativeThingImplementation, ErrorList<ConstructionError>> {
    var errors: [ConstructionError] = []
    let components = implementation.type.components
    var textComponents: [StrictString] = []
    var parameters: [NativeThingImplementationParameter] = []
    for index in components.indices {
      let element = components[index]
      switch element {
      case .parameter(let parameter):
        parameters.append(NativeThingImplementationParameter(parameter))
      case .literal(let literal):
        switch LiteralIntermediate.construct(literal: literal) {
        case .failure(let error):
          errors.append(contentsOf: error.errors.map({ ConstructionError.literalError($0) }))
        case .success(let literal):
          textComponents.append(StrictString(literal.string))
        }
      }
    }
    if ¬errors.isEmpty {
      return .failure(ErrorList(errors))
    }
    return .success(NativeThingImplementation(
      textComponents: textComponents,
      parameters: parameters,
      requiredImport: implementation.importNode?.importNode.identifierText()
    ))
  }
}
