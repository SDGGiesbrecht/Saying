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
          Node(name: "LeftChevronQuotationMark", kind: .fixedLeaf("«")),
          Node(name: "RightChevronQuotationMark", kind: .fixedLeaf("»")),
          Node(name: "SixesQuotationMark", kind: .fixedLeaf("“")),
          Node(name: "NinesQuotationMark", kind: .fixedLeaf("”")),
          Node(name: "LowQuotationMark", kind: .fixedLeaf("„")),
          Node(name: "Colon", kind: .fixedLeaf(":")),
          Node(name: "SymbolInsertionMark", kind: .fixedLeaf("¤")),
          Node(name: "Space", kind: .fixedLeaf(" ")),
          Node(name: "ThingKeyword", kind: .keyword(["thing", "Ding", "chose", "πράγμα", "דבר"])),
          Node(name: "ActionKeyword", kind: .keyword(["action", "Tat", /* action */ "ενέργεια", "פעולה"])),
          Node(name: "TestKeyword", kind: .keyword(["test", "Test", /* test */ "δοκιμή", "בדיקה"])),
          Node(name: "ParameterKeyword", kind: .keyword(["parameter", "Übergabewert", "paramètre", "παράμετρος", "פרמטר"])),
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
              Child(name: "precedingSpace", type: "Space", kind: .optional),
              Child(name: "colon", type: "Colon", kind: .fixed),
              Child(name: "followingSpace", type: "Space", kind: .fixed),
            ])
          ),
        ],
        Node.separatedList(
          name: "UninterruptedIdentifier",
          entryName: "component",
          entryType: "IdentifierComponent",
          separatorName: "space",
          separatorType: "Space",
          isIdentifierSegment: true
        ),
        [
          Node(
            name: "InitialIdentifierSegment",
            kind: .compound(children: [
              Child(name: "segment", type: "UninterruptedIdentifier", kind: .required),
              Child(name: "space", type: "Space", kind: .optional),
            ]),
            isIdentifierSegment: true
          ),
          Node(
            name: "TextMedialIdentifierSegment",
            kind: .compound(children: [
              Child(name: "initialSpace", type: "Space", kind: .optional),
              Child(name: "segment", type: "UninterruptedIdentifier", kind: .required),
              Child(name: "finalSpace", type: "Space", kind: .optional),
            ])
          ),
          Node(
            name: "MedialIdentifierSegment",
            kind: .alternates([
              Alternate(name: "text", type: "TextMedialIdentifierSegment"),
              Alternate(name: "space", type: "Space"),
            ]),
            isIdentifierSegment: true
          ),
          Node(
            name: "FinalIdentifierSegment",
            kind: .compound(children: [
              Child(name: "space", type: "Space", kind: .optional),
              Child(name: "segment", type: "UninterruptedIdentifier", kind: .required),
            ]),
            isIdentifierSegment: true
          ),

          Node(
            name: "LiteralSegment",
            kind: .alternates([
              Alternate(name: "identifier", type: "IdentifierComponent"),
              Alternate(name: "space", type: "Space"),
              Alternate(name: "colon", type: "Colon"),
            ])
          ),
          Node(
            name: "Symbol",
            kind: .compound(children: [
              Child(name: "mark", type: "SymbolInsertionMark", kind: .fixed),
              Child(name: "openingParenthesis", type: "OpeningParenthesis", kind: .fixed),
              Child(name: "code", type: "IdentifierComponent", kind: .required),
              Child(name: "closingParenthesis", type: "ClosingParenthesis", kind: .fixed),
            ])
          ),
          Node(
            name: "LiteralComponent",
            kind: .alternates([
              Alternate(name: "segment", type: "LiteralSegment"),
              Alternate(name: "escape", type: "Symbol"),
            ])
          ),
          Node(
            name: "ChevronString",
            kind: .compound(children: [
              Child(name: "openingQuotationMark", type: "LeftChevronQuotationMark", kind: .fixed),
              Child(name: "contents", type: "LiteralComponent", kind: .array),
              Child(name: "closingQuotationMark", type: "RightChevronQuotationMark", kind: .fixed),
            ])
          ),
          Node(
            name: "SixNineString",
            kind: .compound(children: [
              Child(name: "openingQuotationMark", type: "SixesQuotationMark", kind: .fixed),
              Child(name: "contents", type: "LiteralComponent", kind: .array),
              Child(name: "closingQuotationMark", type: "NinesQuotationMark", kind: .fixed),
            ])
          ),
          Node(
            name: "LowSixString",
            kind: .compound(children: [
              Child(name: "openingQuotationMark", type: "LowQuotationMark", kind: .fixed),
              Child(name: "contents", type: "LiteralComponent", kind: .array),
              Child(name: "closingQuotationMark", type: "SixesQuotationMark", kind: .fixed),
            ])
          ),
          Node(
            name: "Literal",
            kind: .alternates([
              Alternate(name: "sixNine", type: "SixNineString"),
              Alternate(name: "lowSix", type: "LowSixString"),
              Alternate(name: "chevrons", type: "ChevronString"),
            ])
          ),

          Node(
            name: "Argument",
            kind: .compound(children: [
              Child(name: "openingParenthesis", type: "OpeningParenthesis", kind: .fixed),
              Child(name: "argument", type: "Action", kind: .required),
              Child(name: "closingParenthesis", type: "ClosingParenthesis", kind: .fixed),
            ])
          ),
        ],
        Node.separatedList(
          name: "ActionArguments",
          entryName: "argument",
          entryType: "Argument",
          separatorName: "identifierSegment",
          separatorType: "MedialIdentifierSegment"
        ),
        [
          Node(
            name: "CompoundAction",
            kind: .compound(children: [
              Child(name: "initialIdentifierSegment", type: "InitialIdentifierSegment", kind: .optional),
              Child(name: "arguments", type: "ActionArguments", kind: .required),
              Child(name: "finalIdentifierSegment", type: "FinalIdentifierSegment", kind: .optional),
            ])
          ),
          Node(
            name: "Action",
            kind: .alternates([
              Alternate(name: "compound", type: "CompoundAction"),
              Alternate(name: "simple", type: "UninterruptedIdentifier"),
            ]),
            isIndirect: true
          ),

          Node(
            name: "ParagraphEntry",
            kind: .compound(children: [
              Child(name: "language", type: "UninterruptedIdentifier", kind: .required),
              Child(name: "colon", type: "SpacedColon", kind: .required),
              Child(name: "text", type: "UninterruptedIdentifier", kind: .required),
            ])
          ),
        ],
        Node.separatedList(
          name: "ParagraphList",
          entryName: "text",
          entryType: "ParagraphEntry",
          separatorName: "lineBreak",
          separatorType: "LineBreak"
        ),
        [
          Node(
            name: "Paragraph",
            kind: .compound(children: [
              Child(name: "openingBracket", type: "OpeningBracket", kind: .fixed),
              Child(name: "openingLineBreak", type: "LineBreak", kind: .fixed),
              Child(name: "paragraphs", type: "ParagraphList", kind: .required),
              Child(name: "closingLineBreak", type: "LineBreak", kind: .fixed),
              Child(name: "closingBracket", type: "ClosingBracket", kind: .fixed),
            ])
          ),

          Node(
            name: "ParameterDetails",
            kind: .compound(children: [
              Child(name: "openingParenthesis", type: "OpeningParenthesis", kind: .fixed),
              Child(name: "openingLineBreak", type: "LineBreak", kind: .fixed),
              Child(name: "paragraph", type: "Paragraph", kind: .required),
              Child(name: "closingLineBreak", type: "LineBreak", kind: .fixed),
              Child(name: "closingParenthesis", type: "ClosingParenthesis", kind: .fixed),
            ])
          ),
          Node(
            name: "ParameterDocumentation",
            kind: .compound(children: [
              Child(name: "keyword", type: "ParameterKeyword", kind: .required),
              Child(name: "colon", type: "SpacedColon", kind: .required),
              Child(name: "name", type: "UninterruptedIdentifier", kind: .required),
              Child(name: "lineBreak", type: "LineBreak", kind: .fixed),
              Child(name: "details", type: "ParameterDetails", kind: .required),
            ])
          ),
          Node(
            name: "TestDetails",
            kind: .compound(children: [
              Child(name: "openingParenthesis", type: "OpeningParenthesis", kind: .fixed),
              Child(name: "test", type: "Action", kind: .required),
              Child(name: "closingParenthesis", type: "ClosingParenthesis", kind: .fixed),
            ])
          ),
          Node(
            name: "Test",
            kind: .compound(children: [
              Child(name: "keyword", type: "TestKeyword", kind: .required),
              Child(name: "space", type: "Space", kind: .fixed),
              Child(name: "details", type: "TestDetails", kind: .required),
            ])
          ),

          Node(
            name: "DocumentationEntry",
            kind: .alternates([
              Alternate(name: "parameter", type: "ParameterDocumentation"),
              Alternate(name: "test", type: "Test"),
              Alternate(name: "paragraph", type: "Paragraph"),
            ])
          ),
        ],
        Node.separatedList(
          name: "DocumentationList",
          entryName: "entry",
          entryType: "DocumentationEntry",
          separatorName: "lineBreak",
          separatorType: "LineBreak"
        ),
        [
          Node(
            name: "Documentation",
            kind: .compound(children: [
              Child(name: "openingBracket", type: "OpeningBracket", kind: .fixed),
              Child(name: "openingLineBreak", type: "LineBreak", kind: .fixed),
              Child(name: "entries", type: "DocumentationList", kind: .required),
              Child(name: "closingLineBreak", type: "LineBreak", kind: .fixed),
              Child(name: "closingBracket", type: "ClosingBracket", kind: .fixed),
            ])
          ),
          Node(
            name: "AttachedDocumentation",
            kind: .compound(children: [
              Child(name: "documentation", type: "Documentation", kind: .required),
              Child(name: "lineBreak", type: "LineBreak", kind: .fixed),
            ])
          ),

          Node(
            name: "ThingNameEntry",
            kind: .compound(children: [
              Child(name: "language", type: "UninterruptedIdentifier", kind: .required),
              Child(name: "colon", type: "SpacedColon", kind: .required),
              Child(name: "name", type: "UninterruptedIdentifier", kind: .required),
            ])
          )
        ],
        Node.separatedList(
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
            name: "ParameterReference",
            kind: .compound(children: [
              Child(name: "openingBracket", type: "OpeningBracket", kind: .fixed),
              Child(name: "name", type: "UninterruptedIdentifier", kind: .required),
              Child(name: "closingBracket", type: "ClosingBracket", kind: .fixed),
            ])
          ),
          Node(
            name: "ParameterType",
            kind: .alternates([
              Alternate(name: "type", type: "UninterruptedIdentifier"),
              Alternate(name: "reference", type: "ParameterReference"),
            ])
          ),
          Node(
            name: "Parameter",
            kind: .compound(children: [
              Child(name: "openingParenthesis", type: "OpeningParenthesis", kind: .fixed),
              Child(name: "name", type: "UninterruptedIdentifier", kind: .required),
              Child(name: "colon", type: "SpacedColon", kind: .required),
              Child(name: "type", type: "ParameterType", kind: .required),
              Child(name: "closingParenthesis", type: "ClosingParenthesis", kind: .fixed),
            ])
          ),
        ],
        Node.separatedList(
          name: "ParameterList",
          entryName: "parameter",
          entryType: "Parameter",
          separatorName: "identifierSegment",
          separatorType: "MedialIdentifierSegment"
        ),
        [
          Node(
            name: "CompoundSignature",
            kind: .compound(children: [
              Child(name: "initialIdentifierSegment", type: "InitialIdentifierSegment", kind: .optional),
              Child(name: "parameters", type: "ParameterList", kind: .required),
              Child(name: "finalIdentifierSegment", type: "FinalIdentifierSegment", kind: .optional),
            ])
          ),
          Node(
            name: "Signature",
            kind: .alternates([
              Alternate(name: "compound", type: "CompoundSignature"),
              Alternate(name: "simple", type: "UninterruptedIdentifier"),
            ])
          ),
          Node(
            name: "ActionNameEntry",
            kind: .compound(children: [
              Child(name: "language", type: "UninterruptedIdentifier", kind: .required),
              Child(name: "colon", type: "SpacedColon", kind: .required),
              Child(name: "name", type: "Signature", kind: .required),
            ])
          )
        ],
        Node.separatedList(
          name: "ActionNameList",
          entryName: "name",
          entryType: "ActionNameEntry",
          separatorName: "lineBreak",
          separatorType: "LineBreak"
        ),
        [
          Node(
            name: "ActionName",
            kind: .compound(children: [
              Child(name: "openingParenthesis", type: "OpeningParenthesis", kind: .fixed),
              Child(name: "openingLineBreak", type: "LineBreak", kind: .fixed),
              Child(name: "names", type: "ActionNameList", kind: .required),
              Child(name: "closingLineBreak", type: "LineBreak", kind: .fixed),
              Child(name: "closingParenthesis", type: "ClosingParenthesis", kind: .fixed),
            ])
          ),

          Node(
            name: "ReturnValue",
            kind: .compound(children: [
              Child(name: "type", type: "UninterruptedIdentifier", kind: .required),
              Child(name: "lineBreak", type: "LineBreak", kind: .fixed),
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
            name: "ImplementationComponent",
            kind: .alternates([
              Alternate(name: "parameter", type: "UninterruptedIdentifier"),
              Alternate(name: "literal", type: "Literal"),
            ])
          ),
        ],
        Node.separatedList(
          name: "NativeAction",
          entryName: "component",
          entryType: "ImplementationComponent",
          separatorName: "space",
          separatorType: "Space"
        ),
        [
          Node(
            name: "ActionImplementation",
            kind: .compound(children: [
              Child(name: "language", type: "UninterruptedIdentifier", kind: .required),
              Child(name: "colon", type: "SpacedColon", kind: .required),
              Child(name: "type", type: "NativeAction", kind: .required),
            ])
          ),

          Node(
            name: "ThingDeclaration",
            kind: .compound(children: [
              Child(name: "keyword", type: "ThingKeyword", kind: .required),
              Child(name: "keywordLineBreak", type: "LineBreak", kind: .fixed),
              Child(name: "documentation", type: "AttachedDocumentation", kind: .optional),
              Child(name: "name", type: "ThingName", kind: .required),
              Child(name: "nameLineBreak", type: "LineBreak", kind: .fixed),
              Child(name: "implementation", type: "ThingImplementation", kind: .required),
            ])
          ),
          Node(
            name: "ActionDeclaration",
            kind: .compound(children: [
              Child(name: "keyword", type: "ActionKeyword", kind: .required),
              Child(name: "keywordLineBreak", type: "LineBreak", kind: .fixed),
              Child(name: "documentation", type: "AttachedDocumentation", kind: .optional),
              Child(name: "name", type: "ActionName", kind: .required),
              Child(name: "nameLineBreak", type: "LineBreak", kind: .fixed),
              Child(name: "returnValue", type: "ReturnValue", kind: .optional),
              Child(name: "implementation", type: "ActionImplementation", kind: .required),
            ])
          ),
          Node(
            name: "Declaration",
            kind: .alternates([
              Alternate(name: "thing", type: "ThingDeclaration"),
              Alternate(name: "action", type: "ActionDeclaration"),
            ])
          ),
        ],
      ] as [[Node]]
    ).joined()
  )

  static func separatedList(
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
