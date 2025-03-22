import SDGText

extension ModuleIntermediate {
  mutating func unfoldSyntax() throws {
    for nodePrototype in referenceDictionary.allThings() {
      let names = nodePrototype.declaration.name.namesDictionary
      let englishName = StrictString(names["English"]!.name())
      if englishName.hasSuffix(" syntax") {
        let deutscherName = (names["Deutsch"]?.name()).map({ StrictString($0) })
        let nomFrançais = (names["français"]?.name()).map({ StrictString($0) })
        let ελληνικόΌνομα = (names["ελληνικά"]?.name()).map({ StrictString($0) })
        let swiftName = StrictString(names["Swift"]!.name())

        var newSource: [String] = []
        newSource.append(
          contentsOf: syntaxNodeParsedDeclaration(
            englishName: englishName,
            deutscherName: deutscherName,
            nomFrançais: nomFrançais,
            ελληνικόΌνομα: ελληνικόΌνομα,
            swiftName: swiftName
          )
        )
        newSource.append("")
        newSource.append(contentsOf: syntaxNodeParsedLocation(englishName: englishName))
        newSource.append("")
        newSource.append(
          contentsOf: syntaxNodeCreation(
            englishName: englishName,
            deutscherName: deutscherName,
            nomFrançais: nomFrançais,
            ελληνικόΌνομα: ελληνικόΌνομα,
            swiftName: swiftName,
            parsed: false
          )
        )
        newSource.append("")
        newSource.append(
          contentsOf: syntaxNodeCreation(
            englishName: englishName,
            deutscherName: deutscherName,
            nomFrançais: nomFrançais,
            ελληνικόΌνομα: ελληνικόΌνομα,
            swiftName: swiftName,
            parsed: true
          )
        )
        newSource.append("")
        newSource.append(contentsOf: syntaxNodeStorage(englishName: englishName, parsed: false))
        newSource.append("")
        newSource.append(contentsOf: syntaxNodeStorage(englishName: englishName, parsed: true))
        let file = GitStyleFile(
          source: UnicodeText(StrictString(newSource.joined(separator: "\n")))
        ).parsed()
        try self.add(
          file: ParsedDeclarationList.fastParse(source: file)
          ?? ParsedDeclarationList.diagnosticParse(source: file).get()
        )
      }
    }
  }
}
