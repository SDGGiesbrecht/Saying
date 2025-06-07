extension ParsedAbilityName {

  var namesDictionary: [UnicodeText: ParsedAbilitySignature] {
    var dictionary: [UnicodeText: ParsedAbilitySignature] = [:]
    for entry in names.names {
      dictionary[entry.language.identifierText()] = entry.name
    }
    return dictionary
  }
}
