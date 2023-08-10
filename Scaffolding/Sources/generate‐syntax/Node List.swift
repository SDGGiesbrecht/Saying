import SDGText

extension Node {

  static let nodes: [Node] = Array(
    (
      [
        [
          Node(name: "ParagraphBreak", kind: .fixedLeaf("\u{2029}")),
          Node(name: "LineBreak", kind: .fixedLeaf("\u{2028}")),
          Node(name: "OpeningParenthesis", kind: .fixedLeaf("(")),
          Node(name: "ClosingParenthesis", kind: .fixedLeaf(")")),
          Node(name: "OpeningBracket", kind: .fixedLeaf("[")),
          Node(name: "ClosingBracket", kind: .fixedLeaf("]")),
          Node(name: "OpeningQuotationMark", kind: .fixedLeaf("“")),
          Node(name: "ClosingQuotationMark", kind: .fixedLeaf("”")),
          Node(name: "Colon", kind: .fixedLeaf(":")),
          Node(name: "SymbolInsertionMark", kind: .fixedLeaf("¤")),
          Node(name: "Space", kind: .fixedLeaf(" ")),
          Node(name: "ThingKeyword", kind: .keyword(["thing", "Ding", "chose", "πράγμα", "דבר"])),
          Node(name: "ActionKeyword", kind: .keyword(["action", "Tat", /* action */ "ενέργεια", "פעולה"])),
          Node(
            name: "IdentifierComponent",
            kind: .variableLeaf(allowed: {
              var values: [UInt32] = []
              values.append(0x2E) // .
              values.append(contentsOf: 0x30...0x39) // 0–9
              values.append(contentsOf: 0x41...0x5A) // A–Z
              values.append(contentsOf: 0x61...0x7A) // a–z
              values.append(contentsOf: 0x300...0x302) // ◌̀–◌̂
              values.append(0x308) // “◌̈”
              values.append(0x327) // “◌̧”
              values.append(contentsOf: 0x3B1...0x3C9) // α–ω
              values.append(contentsOf: 0x5D0...0x5EA) // א–ת
              return Set(values.lazy.map({ Unicode.Scalar($0)! }))
            }())
          ),

          Node(
            name: "SpacedColon",
            kind: .compound(children: [
              Child(name: "leadingSpace", type: "Space", kind: .optional),
              Child(name: "colon", type: "Colon", kind: .fixed),
              Child(name: "trailingSpace", type: "Space", kind: .fixed),
            ])
          ),
        ],
        Node.nonEmptySeparatedList(
          name: "UninterruptedIdentifier",
          entryName: "component",
          entryType: "IdentifierComponent",
          separatorName: "space",
          separatorType: "Space",
          isIdentifierSegment: true
        ),

        [
          Node(
            name: "ParagraphEntry",
            kind: .compound(children: [
              Child(name: "language", type: "UninterruptedIdentifier", kind: .required),
              Child(name: "colon", type: "SpacedColon", kind: .required),
              Child(name: "text", type: "UninterruptedIdentifier", kind: .required),
            ])
          ),
        ],
        Node.nonEmptySeparatedList(
          name: "ParagraphList",
          entryName: "text",
          entryType: "ParagraphEntry",
          separatorName: "lineBreak",
          separatorType: "LineBreak"
        ),

        [
          Node(
            name: "ThingNameEntry",
            kind: .compound(children: [
              Child(name: "language", type: "UninterruptedIdentifier", kind: .required),
              Child(name: "colon", type: "SpacedColon", kind: .required),
              Child(name: "name", type: "UninterruptedIdentifier", kind: .required),
            ])
          )
        ],
        Node.nonEmptySeparatedList(
          name: "ThingNameList",
          entryName: "name",
          entryType: "ThingNameEntry",
          separatorName: "lineBreak",
          separatorType: "LineBreak"
        ),
        [
          Node(
            name: "ThingName",
            kind: .compound(children: [
              Child(name: "openingParenthesis", type: "OpeningParenthesis", kind: .fixed),
              Child(name: "openingLineBreak", type: "LineBreak", kind: .fixed),
              Child(name: "names", type: "ThingNameList", kind: .required),
              Child(name: "closingLineBreak", type: "LineBreak", kind: .fixed),
              Child(name: "closingParenthesis", type: "ClosingParenthesis", kind: .fixed),
            ])
          ),

          Node(
            name: "ThingImplementation",
            kind: .compound(children: [
              Child(name: "language", type: "UninterruptedIdentifier", kind: .required),
              Child(name: "colon", type: "SpacedColon", kind: .required),
              Child(name: "type", type: "UninterruptedIdentifier", kind: .required),
            ])
          ),

          Node(
            name: "ThingDeclaration",
            kind: .compound(children: [
              Child(name: "keyword", type: "ThingKeyword", kind: .required),
              Child(name: "keywordLineBreak", type: "LineBreak", kind: .fixed),
              Child(name: "name", type: "ThingName", kind: .required),
              Child(name: "implementationLineBreak", type: "LineBreak", kind: .fixed),
              Child(name: "implementation", type: "ThingImplementation", kind: .required),
            ])
          ),
        ],
      ] as [[Node]]
    ).joined()
  )

  static func nonEmptySeparatedList(
    name: StrictString,
    entryName: StrictString,
    entryType: StrictString,
    separatorName: StrictString,
    separatorType: StrictString,
    isIdentifierSegment: Bool = false
  ) -> [Node] {
    return [
      Node(name: "\(name)Continuation", kind: .compound(children: [
        Child(name: separatorName, type: separatorType, kind: .required),
        Child(name: entryName, type: entryType, kind: .required),
      ])),
      Node(
        name: name,
        kind: .compound(children: [
          Child(name: "first", type: entryType, kind: .required),
          Child(name: "continuations", type: "\(name)Continuation", kind: .array),
        ]),
        isIdentifierSegment: isIdentifierSegment
      ),
    ]
  }
}
