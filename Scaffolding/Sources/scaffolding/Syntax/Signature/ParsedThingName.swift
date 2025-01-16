import SDGText

extension ParsedThingName {

  var namesDictionary: [StrictString: ParsedThingSignature] {
    var dictionary: [StrictString: ParsedThingSignature] = [:]
    for entry in names.names {
      dictionary[entry.language.identifierText()] = entry.name
    }
    return dictionary
  }
}
