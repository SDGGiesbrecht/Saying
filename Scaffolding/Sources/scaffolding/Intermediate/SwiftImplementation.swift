import SDGLogic
import SDGText

struct SwiftImplementation {
  var reordering: [Int]
  var textComponents: [StrictString]
}

extension SwiftImplementation {

  static func construct(
    implementation: ParsedNativeAction,
    indexTable: [StrictString: Int]
  ) -> Result<SwiftImplementation, ErrorList<ConstructionError>> {
    let components = implementation.components
    var reordering: [Int] = []
    var textComponents: [StrictString] = []
    var errors: [ConstructionError] = []
    for index in components.indices {
      let element = components[index]
      switch element {
      case .parameter(let parameter):
        if textComponents.isEmpty {
          textComponents.append("")
        }
        if let parameterIndex = indexTable[parameter.identifierText()] {
          reordering.append(parameterIndex)
        } else {
          errors.append(.parameterNotFound(parameter))
        }
        if index == components.indices.last {
          textComponents.append("")
        }
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
    return .success(SwiftImplementation(reordering: reordering, textComponents: textComponents))
  }
}
