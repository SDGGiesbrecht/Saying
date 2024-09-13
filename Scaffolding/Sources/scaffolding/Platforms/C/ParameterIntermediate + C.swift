import SDGText

extension ParameterIntermediate {

  func cSource(module: ModuleIntermediate) -> String {
    let name = C.sanitize(identifier: names.identifier(), leading: false)
    let type = module.lookupThing(self.type)!
    let typeSource: StrictString
    if let c = type.c {
      typeSource = c
    } else {
      typeSource = C.sanitize(identifier: type.names.identifier(), leading: false)
    }
    return "\(typeSource) \(name)"
  }
}
