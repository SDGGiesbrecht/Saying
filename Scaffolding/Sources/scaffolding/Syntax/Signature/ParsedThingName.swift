extension ParsedThingName {

  var namesDictionary: [UnicodeText: ParsedThingSignature] {
    var dictionary: [UnicodeText: ParsedThingSignature] = [:]
    for entry in names.names {
      dictionary[entry.language.identifierText()] = entry.name
    }
    return dictionary
  }
}
