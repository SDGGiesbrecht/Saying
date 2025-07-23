import SDGText

extension ModuleIntermediate {
  mutating func unfoldSyntax() throws {
    for nodePrototype in referenceDictionary.allThings() {
      let names = nodePrototype.declaration.name.namesDictionary
      let englishName = StrictString(names["English"]!.name())
      if englishName.hasSuffix(" syntax") {
        let deutscherName = (names["Deutsch"]?.name())
        let nomFrançais = (names["français"]?.name())
        let ελληνικόΌνομα = (names["ελληνικά"]?.name())
        let swiftName = names["Swift"]!.name()

        var newSource: [String] = []
        newSource.append(
          contentsOf: syntaxNodeParsedDeclaration(
            englishName: UnicodeText(englishName),
            deutscherName: deutscherName,
            nomFrançais: nomFrançais,
            ελληνικόΌνομα: ελληνικόΌνομα,
            swiftName: swiftName
          )
        )
        newSource.append("")
        newSource.append(
          contentsOf: syntaxNodeCreation(
            englishName: UnicodeText(englishName),
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
            englishName: UnicodeText(englishName),
            deutscherName: deutscherName,
            nomFrançais: nomFrançais,
            ελληνικόΌνομα: ελληνικόΌνομα,
            swiftName: swiftName,
            parsed: true
          )
        )
        newSource.append("")
        newSource.append(contentsOf: syntaxNodeGeneralUse(englishName: UnicodeText(englishName), parsed: false))
        newSource.append("")
        newSource.append(contentsOf: syntaxNodeGeneralUse(englishName: UnicodeText(englishName), parsed: true))
        switch GitStyleSayingSource(
          origin: compilerGeneratedOrigin(),
          code: UnicodeText(newSource.joined(separator: "\n"))
        ).parsed().code {
        case .utf8(let file):
          try self.add(
            file: ParsedDeclarationList.fastParse(source: file, origin: compilerGeneratedOrigin())
            ?? ParsedDeclarationList.diagnosticParse(source: file, origin: compilerGeneratedOrigin()).get()
          )
        }
      }
    }
  }
}
