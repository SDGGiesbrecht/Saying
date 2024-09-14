import SDGLogic
import SDGText

struct Thing {
  var names: Set<StrictString>
  var c: StrictString?
  var cSharp: StrictString?
  var kotlin: StrictString?
  var swift: StrictString?
  var declaration: ParsedThingDeclaration
}

extension Thing {
  
  static func construct(
    _ declaration: ParsedThingDeclaration
  ) -> Result<Thing, ErrorList<Thing.ConstructionError>> {
    var errors: [Thing.ConstructionError] = []

    let names: Set<StrictString> = Set(
      declaration.name.names.names
        .lazy.map({ $0.name.identifierText() })
    )

    var c: StrictString?
    var cSharp: StrictString?
    var kotlin: StrictString?
    var swift: StrictString?
    for implementation in declaration.implementation.implementations {
      switch implementation.language.identifierText() {
      case "C":
        c = implementation.type.identifierText()
      case "C♯":
        cSharp = implementation.type.identifierText()
      case "Kotlin":
        kotlin = implementation.type.identifierText()
      case "Swift":
        swift = implementation.type.identifierText()
      default:
        errors.append(ConstructionError.unknownLanguage(implementation.language))
      }
    }
    if ¬errors.isEmpty {
      return .failure(ErrorList(errors))
    }
    return .success(
      Thing(
        names: names,
        c: c,
        cSharp: cSharp,
        kotlin: kotlin,
        swift: swift,
        declaration: declaration
      )
    )
  }
}
