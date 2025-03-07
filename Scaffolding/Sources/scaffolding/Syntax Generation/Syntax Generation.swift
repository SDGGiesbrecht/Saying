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
        var newSource = [
          "action",
          " [",
          "  test {verify (ignore \(englishName) (create \(englishName)))}",
          " ]",
          " (",
          "  English: ignore \(englishName) (syntax: \(englishName))",
          " )",
          " truth value",
          " {",
          "  ← true",
          " }",
          "",
          "action (clients)",
          " (",
          "  English: create \(englishName)",
        ]
        if let deutsch = deutscherName {
          newSource.append("  Deutsch: \(deutsch) erstellen")
        }
        if let français = nomFrançais {
          newSource.append("  français : créer \(français)")
        }
        if let ελληνικά = ελληνικόΌνομα {
          newSource.append("  ελληνικά: δημιουργία σύνταξης \(StrictString(ελληνικά.dropFirst(9)))")
        }
        newSource.append(contentsOf: [
          "  Swift: \(swiftName).init",
          " )",
          " \(englishName)",
          " create",
          "",
          "thing (clients)",
          " (",
          "  English: parsed \(englishName)",
        ])
        if let deutsch = deutscherName {
          newSource.append("  Deutsch: zerteilte \(deutsch)")
        }
        if let français = nomFrançais {
          newSource.append("  français : syntaxe analysée \(StrictString(français.dropFirst(8)))")
        }
        if let ελληνικά = ελληνικόΌνομα {
          newSource.append("  ελληνικά: αναλυμένη \(ελληνικά)")
        }
        newSource.append(contentsOf: [
          "  Swift: ReplacementParsed\(swiftName)",
          " )",
          " {",
          " }",
        ])
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
