import SDGText

extension ParameterIntermediate {

  func swiftSource(module: ModuleIntermediate) -> String {
    let name = Swift.sanitize(identifier: names.identifier(), leading: false)
    let type = module.lookupThing(self.type)!
    let typeSource: StrictString
    if let swift = type.swift {
      typeSource = swift
    } else {
      typeSource = Swift.sanitize(identifier: type.names.identifier(), leading: false)
    }
    return "_ \(name): \(typeSource)"
  }
}
