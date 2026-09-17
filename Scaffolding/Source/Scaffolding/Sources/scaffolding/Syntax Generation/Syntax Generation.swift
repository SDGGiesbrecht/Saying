import Saying

extension ModuleIntermediate {
  mutating func unfoldSyntax() throws {
    var nodeTypes: [NodeNames] = []
    for nodePrototype in referenceDictionary.allThings() {
      let names = nodePrototype.declaration.name.namesDictionary
      let englishName = names["English"]!.name()
      if String(englishName).hasSuffix(" syntax") {
        let names = NodeNames(
          identifier: Set(names.values.lazy.map({ $0.name() })).identifier(),
          english: englishName,
          deutscher: names["Deutsch"]?.name(),
          français: names["français"]?.name(),
          ελληνικό: names["ελληνικά"]?.name(),
          swift: names["Swift"]!.name()
        )
        nodeTypes.append(names)

        let suffixesForScalarSwap = [" syntax", " character syntax"]
        var scalarName: UnicodeText?
        for suffix in suffixesForScalarSwap {
          if scalarName != nil {
            break
          }
          var possibleScalarAction = UnicodeText(englishName.dropLast(suffix.count))
          possibleScalarAction.append(contentsOf: " scalar")
          if referenceDictionary.lookupAction(
            possibleScalarAction,
            signature: [],
            specifiedReturnValue: .compilerGeneratedReference(to: "Unicode scalar"),
            parentContexts: [],
            reportAllForErrorAnalysis: false
          ) != nil {
            scalarName = possibleScalarAction
          }
        }

        var newSource: [String] = []
        newSource.append(contentsOf: syntaxNodeParsedDeclaration(names: names))
        newSource.append("")
        newSource.append(
          contentsOf: syntaxNodeCreation(
            names: names,
            parsed: false,
            scalarName: scalarName
          )
        )
        newSource.append("")
        newSource.append(
          contentsOf: syntaxNodeCreation(
            names: names,
            parsed: true,
            scalarName: scalarName
          )
        )
        newSource.append("")
        newSource.append(contentsOf: syntaxNodeGeneralContainers(names: names, parsed: false))
        newSource.append("")
        newSource.append(contentsOf: syntaxNodeGeneralContainers(names: names, parsed: true))
        newSource.append("")
        newSource.append(contentsOf: syntaxNodeType(names: names, parsed: false))
        newSource.append("")
        newSource.append(contentsOf: syntaxNodeType(names: names, parsed: true))
        newSource.append("")
        newSource.append(contentsOf: syntaxNodeAbility(names: names, parsed: false))
        newSource.append("")
        newSource.append(contentsOf: syntaxNodeAbility(names: names, parsed: true))
        try addGeneratedSource(newSource: newSource)
      }
    }
    nodeTypes.sort(by: { $0.identifier.lexicographicallyPrecedes($1.identifier) })
    try addGeneratedSource(newSource: syntaxNodeTypeDeclaration(nodeTypes: nodeTypes, parsed: false))
    try addGeneratedSource(newSource: syntaxNodeTypeDeclaration(nodeTypes: nodeTypes, parsed: true))
  }

  mutating func addGeneratedSource(newSource: [String]) throws {
    switch GitStyleSayingSource(
      origin: compilerGeneratedOrigin(),
      code: UnicodeText(newSource.joined(separator: "\n"))
    ).parsed().code {
    case .writing:
      fatalError("Writing not implemented yet.")
    case .utf8(let file):
      try self.add(
        file: ParsedDeclarationList.fastParse(source: file, origin: compilerGeneratedOrigin())
        ?? ParsedDeclarationList.diagnosticParse(source: file, origin: compilerGeneratedOrigin()).get()
      )
    }
  }
}
