extension ParsedActionName {

  var names: [UnicodeText: ParsedSignature] {
    switch self {
    case .multiple(let multiple):
      var dictionary: [UnicodeText: ParsedSignature] = [:]
      for entry in multiple.names.names {
        dictionary[entry.language.identifierText()] = entry.name
      }
      return dictionary
    case .single(let single):
      return ["": single]
    }
  }
}
