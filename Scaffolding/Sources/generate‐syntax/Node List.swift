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
          Node(name: "OpeningBrace", kind: .fixedLeaf("{")),
          Node(name: "ClosingBrace", kind: .fixedLeaf("}")),
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
          Node(name: "RequirementKeyword", kind: .keyword(["requirement", "Bedingung", "condition", "απαίτηση", "צורך"])),
          Node(name: "AbilityKeyword", kind: .keyword(["ability", "Fähigkeit", "capacité", "ικανότητα", "יכולת"])),
          Node(name: "ClientsKeyword", kind: .keyword(["clients", "Kunden", /* clients */ "πελάτες", "לקוחות"])),
          Node(name: "TestsKeyword", kind: .keyword(["tests", "Prüfungen", "essais", "δοκιμές", "בדיקות"])),
          Node(name: "TestKeyword", kind: .keyword(["test", "Prüfung", "essai", "δοκιμή", "בדיקה"])),
          Node(name: "ParameterKeyword", kind: .keyword(["parameter", "Übergabewert", "paramètre", "παράμετρος", "פרמטר"])),
          Node(
            name: "IdentifierComponent",
            kind: .variableLeaf(allowed: {
              var values: [UInt32] = []
              values.append(contentsOf: 0x2B...0x2C) // +–,
              values.append(0x2E) // .
              values.append(contentsOf: 0x30...0x39) // 0–9
              values.append(contentsOf: 0x3B...0x3E) // ;–>
              values.append(contentsOf: 0x41...0x5A) // A–Z
              values.append(contentsOf: 0x61...0x7A) // a–z
              values.append(0xAC) // ¬
              values.append(0xB1) // ±
              values.append(0xB7) // ·
              values.append(0xC6) // Æ
              values.append(0xD0) // Ð
              values.append(contentsOf: 0xD7...0xD8) // ×–Ø
              values.append(contentsOf: 0xDE...0xDF) // Þ–ß
              values.append(0xE6) // æ
              values.append(0xF0) // ð
              values.append(contentsOf: 0xF7...0xF8) // ÷–ø
              values.append(0xFE) // þ
              values.append(contentsOf: 0x110...0x111) // Đ–đ
              values.append(contentsOf: 0x126...0x127) // Ħ–ħ
              values.append(0x131) // ı
              values.append(contentsOf: 0x141...0x142) // Ł–ł
              values.append(contentsOf: 0x152...0x153) // Œ–œ
              values.append(0x18F) // Ə
              values.append(0x259) // ə
              values.append(contentsOf: 0x300...0x304) // ◌̀–◌̄
              values.append(contentsOf: 0x306...0x30C) // ◌̆–◌̌
              values.append(0x31B) // ◌̛
              values.append(0x323) // ◌̣
              values.append(contentsOf: 0x326...0x328) // ◌̦–◌̨
              values.append(0x338) // ◌̸
              values.append(contentsOf: 0x391...0x3A1) // Α–Ρ
              values.append(contentsOf: 0x3A3...0x3A9) // Σ–Ω
              values.append(contentsOf: 0x3B1...0x3C9) // α–ω
              values.append(0x402) // Ђ
              values.append(contentsOf: 0x404...0x406) // Є–І
              values.append(contentsOf: 0x408...0x40B) // Ј–Ћ
              values.append(contentsOf: 0x40F...0x418) // Џ–И
              values.append(contentsOf: 0x41A...0x438) // К–и
              values.append(contentsOf: 0x43A...0x44F) // к–я
              values.append(0x452) // ђ
              values.append(contentsOf: 0x454...0x456) // є–і
              values.append(contentsOf: 0x458...0x45B) // ј–ћ
              values.append(0x45F) // џ
              values.append(contentsOf: 0x490...0x491) // Ґ–ґ
              values.append(contentsOf: 0x5D0...0x5EA) // א–ת
              values.append(0x60C) // ،
              values.append(0x61B) // ؛
              values.append(0x621) // ء
              values.append(contentsOf: 0x627...0x63A) // ا–غ
              values.append(contentsOf: 0x641...0x64A) // ف–ي
              values.append(contentsOf: 0x653...0x655) // ◌ٓ–◌ٕ
              values.append(contentsOf: 0x660...0x669) // ٠–٩
              values.append(0x679) // ٹ
              values.append(0x67E) // پ
              values.append(0x686) // چ
              values.append(0x688) // ڈ
              values.append(0x691) // ڑ
              values.append(0x698) // ژ
              values.append(0x6A9) // ک
              values.append(0x6AF) // گ
              values.append(0x6BA) // ں
              values.append(0x6BE) // ھ
              values.append(0x6C1) // ہ
              values.append(0x6CC) // ی
              values.append(0x6D2) // ے
              values.append(0x6D4) // ۔
              values.append(contentsOf: 0x6F0...0x6F9) // ۰–۹
              values.append(contentsOf: 0x1100...0x1112) // ᄀ–ᄒ
              values.append(contentsOf: 0x1161...0x1175) // ᅡ–ᅵ
              values.append(contentsOf: 0x11A8...0x11C2) // ᆨ–ᇂ
              values.append(0x2010) // ‐
              values.append(0x2019) // ’
              values.append(contentsOf: 0x2212...0x2213) // −–∓
              values.append(contentsOf: 0x2227...0x222A) // ∧–∪
              values.append(0x2236) // ∶
              values.append(0x22C5) // ⋅
              values.append(contentsOf: 0x266D...0x266F) // ♭–♯
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
          entryName: "component", entryNamePlural: "components",
          entryType: "IdentifierComponent",
          separatorName: "space",
          separatorType: "Space",
          fixedSeparator: true,
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
            name: "Access",
            kind: .compound(children: [
              Child(name: "space", type: "Space", kind: .fixed),
              Child(name: "openingParenthesis", type: "OpeningParenthesis", kind: .fixed),
              Child(name: "keyword", type: "ClientsKeyword", kind: .required),
              Child(name: "closingParenthesis", type: "ClosingParenthesis", kind: .fixed),
            ])
          ),
          Node(
            name: "TestAccess",
            kind: .compound(children: [
              Child(name: "space", type: "Space", kind: .fixed),
              Child(name: "openingParenthesis", type: "OpeningParenthesis", kind: .fixed),
              Child(name: "keyword", type: "TestsKeyword", kind: .required),
              Child(name: "closingParenthesis", type: "ClosingParenthesis", kind: .fixed),
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
          entryName: "argument", entryNamePlural: "arguments",
          entryType: "Argument",
          separatorName: "identifierSegment",
          separatorType: "MedialIdentifierSegment",
          fixedSeparator: false
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
          entryName: "text", entryNamePlural: "text",
          entryType: "ParagraphEntry",
          separatorName: "lineBreak",
          separatorType: "LineBreak",
          fixedSeparator: true
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
          entryName: "entry", entryNamePlural: "entries",
          entryType: "DocumentationEntry",
          separatorName: "lineBreak",
          separatorType: "LineBreak",
          fixedSeparator: true
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
          entryName: "name", entryNamePlural: "names",
          entryType: "ThingNameEntry",
          separatorName: "lineBreak",
          separatorType: "LineBreak",
          fixedSeparator: true
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
          entryName: "parameter", entryNamePlural: "parameters",
          entryType: "Parameter",
          separatorName: "identifierSegment",
          separatorType: "MedialIdentifierSegment",
          fixedSeparator: false
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
          entryName: "name", entryNamePlural: "names",
          entryType: "ActionNameEntry",
          separatorName: "lineBreak",
          separatorType: "LineBreak",
          fixedSeparator: true
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
            name: "AbilityParameterType",
            kind: .compound(children: [
              Child(name: "openingParenthesis", type: "OpeningParenthesis", kind: .fixed),
              Child(name: "name", type: "UninterruptedIdentifier", kind: .required),
              Child(name: "closingParenthesis", type: "ClosingParenthesis", kind: .fixed),
            ])
          ),
          Node(
            name: "AbilityParameterReference",
            kind: .compound(children: [
              Child(name: "openingParenthesis", type: "OpeningParenthesis", kind: .fixed),
              Child(name: "name", type: "UninterruptedIdentifier", kind: .required),
              Child(name: "colon", type: "SpacedColon", kind: .required),
              Child(name: "reference", type: "ParameterReference", kind: .required),
              Child(name: "closingParenthesis", type: "ClosingParenthesis", kind: .fixed),
            ])
          ),
          Node(
            name: "AbilityParameter",
            kind: .alternates([
              Alternate(name: "type", type: "AbilityParameterType"),
              Alternate(name: "reference", type: "AbilityParameterReference"),
            ])
          ),
        ],
        Node.separatedList(
          name: "AbilityParameterList",
          entryName: "parameter", entryNamePlural: "parameters",
          entryType: "AbilityParameter",
          separatorName: "identifierSegment",
          separatorType: "MedialIdentifierSegment",
          fixedSeparator: false
        ),
        [
          Node(
            name: "AbilitySignature",
            kind: .compound(children: [
              Child(name: "initialIdentifierSegment", type: "InitialIdentifierSegment", kind: .optional),
              Child(name: "parameters", type: "AbilityParameterList", kind: .required),
              Child(name: "finalIdentifierSegment", type: "FinalIdentifierSegment", kind: .optional),
            ])
          ),
          Node(
            name: "AbilityNameEntry",
            kind: .compound(children: [
              Child(name: "language", type: "UninterruptedIdentifier", kind: .required),
              Child(name: "colon", type: "SpacedColon", kind: .required),
              Child(name: "name", type: "AbilitySignature", kind: .required),
            ])
          )
        ],
        Node.separatedList(
          name: "AbilityNameList",
          entryName: "name", entryNamePlural: "names",
          entryType: "AbilityNameEntry",
          separatorName: "lineBreak",
          separatorType: "LineBreak",
          fixedSeparator: true
        ),
        [
          Node(
            name: "AbilityName",
            kind: .compound(children: [
              Child(name: "openingParenthesis", type: "OpeningParenthesis", kind: .fixed),
              Child(name: "openingLineBreak", type: "LineBreak", kind: .fixed),
              Child(name: "names", type: "AbilityNameList", kind: .required),
              Child(name: "closingLineBreak", type: "LineBreak", kind: .fixed),
              Child(name: "closingParenthesis", type: "ClosingParenthesis", kind: .fixed),
            ])
          ),

          Node(
            name: "ActionReturnValue",
            kind: .compound(children: [
              Child(name: "type", type: "UninterruptedIdentifier", kind: .required),
              Child(name: "lineBreak", type: "LineBreak", kind: .fixed),
            ])
          ),
          Node(
            name: "RequirementReturnValue",
            kind: .compound(children: [
              Child(name: "lineBreak", type: "LineBreak", kind: .fixed),
              Child(name: "type", type: "UninterruptedIdentifier", kind: .required),
            ])
          ),

          Node(
            name: "NativeImport",
            kind: .compound(children: [
              Child(name: "space", type: "Space", kind: .required),
              Child(name: "openingParenthesis", type: "OpeningParenthesis", kind: .fixed),
              Child(name: "importNode", type: "UninterruptedIdentifier", kind: .required),
              Child(name: "closingParenthesis", type: "ClosingParenthesis", kind: .fixed),
            ])
          ),
          Node(
            name: "NativeThing",
            kind: .compound(children: [
              Child(name: "type", type: "UninterruptedIdentifier", kind: .required),
              Child(name: "importNode", type: "NativeImport", kind: .optional),
            ])
          ),
          Node(
            name: "ThingImplementation",
            kind: .compound(children: [
              Child(name: "language", type: "UninterruptedIdentifier", kind: .required),
              Child(name: "colon", type: "SpacedColon", kind: .required),
              Child(name: "implementation", type: "NativeThing", kind: .required),
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
          name: "NativeActionExpression",
          entryName: "component", entryNamePlural: "components",
          entryType: "ImplementationComponent",
          separatorName: "space",
          separatorType: "Space",
          fixedSeparator: true
        ),
        [
          Node(
            name: "NativeAction",
            kind: .compound(children: [
              Child(name: "expression", type: "NativeActionExpression", kind: .required),
              Child(name: "importNode", type: "NativeImport", kind: .optional),
            ])
          ),
          Node(
            name: "ActionImplementation",
            kind: .compound(children: [
              Child(name: "language", type: "UninterruptedIdentifier", kind: .required),
              Child(name: "colon", type: "SpacedColon", kind: .required),
              Child(name: "expression", type: "NativeAction", kind: .required),
            ])
          ),
        ],
          Node.separatedList(
            name: "ThingImplementations",
            entryName: "implementation", entryNamePlural: "implementations",
            entryType: "ThingImplementation",
            separatorName: "lineBreak",
            separatorType: "LineBreak",
            fixedSeparator: true
          ),
          Node.separatedList(
            name: "ActionImplementations",
            entryName: "implementation", entryNamePlural: "implementations",
            entryType: "ActionImplementation",
            separatorName: "lineBreak",
            separatorType: "LineBreak",
            fixedSeparator: true
          ),

        [
          Node(
            name: "ThingDeclaration",
            kind: .compound(children: [
              Child(name: "keyword", type: "ThingKeyword", kind: .required),
              Child(name: "access", type: "Access", kind: .optional),
              Child(name: "testAccess", type: "TestAccess", kind: .optional),
              Child(name: "keywordLineBreak", type: "LineBreak", kind: .fixed),
              Child(name: "documentation", type: "AttachedDocumentation", kind: .optional),
              Child(name: "name", type: "ThingName", kind: .required),
              Child(name: "nameLineBreak", type: "LineBreak", kind: .fixed),
              Child(name: "implementation", type: "ThingImplementations", kind: .required),
            ])
          ),
          Node(
            name: "ActionDeclaration",
            kind: .compound(children: [
              Child(name: "keyword", type: "ActionKeyword", kind: .required),
              Child(name: "access", type: "Access", kind: .optional),
              Child(name: "testAccess", type: "TestAccess", kind: .optional),
              Child(name: "keywordLineBreak", type: "LineBreak", kind: .fixed),
              Child(name: "documentation", type: "AttachedDocumentation", kind: .optional),
              Child(name: "name", type: "ActionName", kind: .required),
              Child(name: "nameLineBreak", type: "LineBreak", kind: .fixed),
              Child(name: "returnValue", type: "ActionReturnValue", kind: .optional),
              Child(name: "implementation", type: "ActionImplementations", kind: .required),
            ])
          ),
          Node(
            name: "RequirementDeclaration",
            kind: .compound(children: [
              Child(name: "keyword", type: "RequirementKeyword", kind: .required),
              Child(name: "access", type: "Access", kind: .optional),
              Child(name: "testAccess", type: "TestAccess", kind: .optional),
              Child(name: "keywordLineBreak", type: "LineBreak", kind: .fixed),
              Child(name: "documentation", type: "AttachedDocumentation", kind: .optional),
              Child(name: "name", type: "ActionName", kind: .required),
              Child(name: "returnValue", type: "RequirementReturnValue", kind: .optional),
            ])
          ),

        ],
          Node.separatedList(
            name: "RequirementsList",
            entryName: "requirement", entryNamePlural: "requirements",
            entryType: "RequirementDeclaration",
            separatorName: "paragraphBreak",
            separatorType: "ParagraphBreak",
            fixedSeparator: true
          ),
        [
          Node(
            name: "Requirements",
            kind: .compound(children: [
              Child(name: "openingBrace", type: "OpeningBrace", kind: .fixed),
              Child(name: "openingLineBreak", type: "LineBreak", kind: .fixed),
              Child(name: "requirements", type: "RequirementsList", kind: .optional),
              Child(name: "closingLineBreak", type: "LineBreak", kind: .fixed),
              Child(name: "closingBrace", type: "ClosingBrace", kind: .fixed),
            ])
          ),
          Node(
            name: "AbilityDeclaration",
            kind: .compound(children: [
              Child(name: "keyword", type: "AbilityKeyword", kind: .required),
              Child(name: "access", type: "Access", kind: .optional),
              Child(name: "testAccess", type: "TestAccess", kind: .optional),
              Child(name: "keywordLineBreak", type: "LineBreak", kind: .fixed),
              Child(name: "documentation", type: "AttachedDocumentation", kind: .optional),
              Child(name: "name", type: "AbilityName", kind: .required),
              Child(name: "nameLineBreak", type: "LineBreak", kind: .fixed),
              Child(name: "requirements", type: "Requirements", kind: .required),
            ])
          ),

          Node(
            name: "Declaration",
            kind: .alternates([
              Alternate(name: "thing", type: "ThingDeclaration"),
              Alternate(name: "action", type: "ActionDeclaration"),
              Alternate(name: "ability", type: "AbilityDeclaration"),
            ])
          ),
        ],

        Node.separatedList(
          name: "DeclarationList",
          entryName: "declaration", entryNamePlural: "declarations",
          entryType: "Declaration",
          separatorName: "paragraphBreak",
          separatorType: "ParagraphBreak",
          fixedSeparator: true
        ),
      ] as [[Node]]
    ).joined()
  )

  static func separatedList(
    name: StrictString,
    entryName: StrictString,
    entryNamePlural: StrictString,
    entryType: StrictString,
    separatorName: StrictString,
    separatorType: StrictString,
    fixedSeparator: Bool,
    isIdentifierSegment: Bool = false
  ) -> [Node] {
    return [
      Node(name: "\(name)Continuation", kind: .compound(children: [
        Child(name: separatorName, type: separatorType, kind: fixedSeparator ? .fixed : .required),
        Child(name: entryName, type: entryType, kind: .required),
      ])),
      Node(
        name: name,
        kind: .compound(children: [
          Child(name: "first", type: entryType, kind: .required),
          Child(name: "continuations", type: "\(name)Continuation", kind: .array),
        ]),
        isIdentifierSegment: isIdentifierSegment,
        utilities: [
          [
            "  var \(entryNamePlural): [\(entryType)] {",
            "    return Array([[first], continuations.lazy.map({ $0.\(entryName) })].joined())",
            "  }"
          ].joined(separator: "\n")
        ],
        parsedUtilities: [
          [
            "  var \(entryNamePlural): [Parsed\(entryType)] {",
            "    return Array([[first], continuations.lazy.map({ $0.\(entryName) })].joined())",
            "  }"
          ].joined(separator: "\n")
        ]
      ),
    ]
  }
}
