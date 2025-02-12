import SDGText

extension ParsedAbilityName {

  var namesDictionary: [StrictString: ParsedAbilitySignature] {
    var dictionary: [StrictString: ParsedAbilitySignature] = [:]
    for entry in names.names {
      dictionary[StrictString(entry.language.identifierText())] = entry.name
    }
    return dictionary
  }
}
