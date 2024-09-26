import SDGText

extension ParsedActionName {

  var names: [StrictString: ParsedSignature] {
    switch self {
    case .multiple(let multiple):
      var dictionary: [StrictString: ParsedSignature] = [:]
      for entry in multiple.names.names {
        dictionary[entry.language.identifierText()] = entry.name
      }
      return dictionary
    case .single(let single):
      return ["": single]
    }
  }
}
