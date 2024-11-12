import SDGLogic
import SDGText

struct NativeThingImplementation {
  var type: StrictString
  var requiredImport: StrictString?
}

extension NativeThingImplementation {

  static func construct(
    implementation: ParsedNativeThing
  ) -> NativeThingImplementation {
    var textComponents: [StrictString] = []
    for component in implementation.type.components {
      switch component {
      case .literal(let literal):
        switch LiteralIntermediate.construct(literal: literal) {
        case .failure(let error):
          #warning("Not implemented yet.")
        case .success(let literal):
          textComponents.append(StrictString(literal.string))
        }
      case .parameter(let parameter):
        #warning("Not implemented yet.")
      }
    }
    #warning("Dropping parameters, etc.")
    let type = textComponents.joined()
    return NativeThingImplementation(
      type: type,
      requiredImport: implementation.importNode?.importNode.identifierText()
    )
  }
}
