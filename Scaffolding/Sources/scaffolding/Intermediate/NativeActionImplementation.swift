import SDGLogic
import SDGText

struct NativeActionImplementationIntermediate {
  var reordering: [Int]
  var textComponents: [StrictString]
  var requiredImport: StrictString?
}

extension NativeActionImplementationIntermediate {

  static func construct(
    implementation: ParsedNativeAction,
    indexTable: [StrictString: Int]
  ) -> Result<NativeActionImplementationIntermediate, ErrorList<ConstructionError>> {
    let components = implementation.expression.components
    var reordering: [Int] = []
    var textComponents: [StrictString] = []
    var errors: [ConstructionError] = []
    for index in components.indices {
      let element = components[index]
      switch element {
      case .parameter(let parameter):
        if let parameterIndex = indexTable[parameter.identifierText()] {
          reordering.append(parameterIndex)
        } else {
          errors.append(.parameterNotFound(parameter))
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
    if ¬textComponents.contains(where: { $0.contains("(") })
      ∨ ¬textComponents.contains(where: { $0.contains(")") }) {
      errors.append(.parenthesesMissing(implementation.expression))
    }
    let requiredImport = implementation.importNode?.importNode.identifierText()
    if ¬errors.isEmpty {
      return .failure(ErrorList(errors))
    }
    return .success(
      NativeActionImplementationIntermediate(
        reordering: reordering,
        textComponents: textComponents,
        requiredImport: requiredImport
      )
    )
  }
}
