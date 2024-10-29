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
    return NativeThingImplementation(
      type: implementation.type.identifierText(),
      requiredImport: implementation.importNode?.importNode.identifierText()
    )
  }
}
