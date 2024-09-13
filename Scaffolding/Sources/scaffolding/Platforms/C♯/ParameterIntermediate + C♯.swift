import SDGText

extension ParameterIntermediate {

  func cSharpSource(module: ModuleIntermediate) -> String {
    let name = CSharp.sanitize(identifier: names.identifier(), leading: false)
    let type = module.lookupThing(self.type)!
    let typeSource: String
    if let cSharp = type.cSharp {
      typeSource = String(cSharp)
    } else {
      typeSource = CSharp.sanitize(identifier: type.names.identifier(), leading: false)
    }
    return "\(typeSource) \(name)"
  }
}
