extension Node {

  static let nodes: [Node] = Array(
    (
      [
        [
          Node(name: "ParagraphBreakSyntax", kind: .fixedLeaf("\u{2029}")),
          Node(name: "LineBreakSyntax", kind: .fixedLeaf("\u{2028}")),
          Node(name: "OpeningParenthesisSyntax", kind: .fixedLeaf("(")),
          Node(name: "ClosingParenthesisSyntax", kind: .fixedLeaf(")")),
          Node(name: "OpeningBracketSyntax", kind: .fixedLeaf("[")),
          Node(name: "ClosingBracketSyntax", kind: .fixedLeaf("]")),
          Node(name: "OpeningBraceSyntax", kind: .fixedLeaf("{")),
          Node(name: "ClosingBraceSyntax", kind: .fixedLeaf("}")),
          Node(name: "LeftChevronQuotationMarkSyntax", kind: .fixedLeaf("«")),
          Node(name: "RightChevronQuotationMarkSyntax", kind: .fixedLeaf("»")),
          Node(name: "SixesQuotationMarkSyntax", kind: .fixedLeaf("“")),
          Node(name: "NinesQuotationMarkSyntax", kind: .fixedLeaf("”")),
          Node(name: "LowQuotationMarkSyntax", kind: .fixedLeaf("„")),
          Node(name: "OpeningQuestionMarkSyntax", kind: .fixedLeaf("¿")),
          Node(name: "ClosingQuestionMarkSyntax", kind: .fixedLeaf("?")),
          Node(name: "RightToLeftQuestionMarkSyntax", kind: .fixedLeaf("؟")),
          Node(name: "GreekQuestionMarkSyntax", kind: .fixedLeaf(";")),
          Node(name: "OpeningExclamationMarkSyntax", kind: .fixedLeaf("¡")),
          Node(name: "ClosingExclamationMarkSyntax", kind: .fixedLeaf("!")),
          Node(name: "ColonCharacterSyntax", kind: .fixedLeaf(":")),
          Node(name: "SlashSyntax", kind: .fixedLeaf("/")),
          Node(name: "BulletCharacterSyntax", kind: .fixedLeaf("•")),
          Node(name: "DownArrowSyntax", kind: .fixedLeaf("↓")),
          Node(name: "RightArrowSyntax", kind: .fixedLeaf("→")),
          Node(name: "LeftArrowSyntax", kind: .fixedLeaf("←")),
          Node(name: "SymbolInsertionMarkSyntax", kind: .fixedLeaf("¤")),
          Node(name: "SpaceSyntax", kind: .fixedLeaf(" ")),
          Node(name: "LanguageKeyword", kind: .keyword(["language", "Sprache", "langue", "γλώσσα", "שפה"])),
          Node(name: "ThingKeyword", kind: .keyword(["thing", "Ding", "chose", "πράγμα", "דבר"])),
          Node(name: "EnumerationKeyword", kind: .keyword(["enumeration", "Aufzählung", "énumération", "απαρίθμηση", "ספירה"])),
          Node(name: "CaseKeyword", kind: .keyword(["case", "Fall", "cas", "περίπτωση", "מקרה"])),
          Node(name: "PartKeyword", kind: .keyword(["part", "Teil", "partie", "μέρος", "חלק"])),
          Node(name: "ActionKeyword", kind: .keyword(["action", "Tat", /* action */ "ενέργεια", "פעולה"])),
          Node(name: "FlowKeyword", kind: .keyword(["flow", "Ablauf", "déroulement", "ροή", "זרימה"])),
          Node(name: "RequirementKeyword", kind: .keyword(["requirement", "Bedingung", "condition", "απαίτηση", "צורך"])),
          Node(name: "ChoiceKeyword", kind: .keyword(["choice", "Wahl", "choix", "επιλογή", "בחירה"])),
          Node(name: "CreateKeyword", kind: .keyword(["create", "erstellen", "créer", "δημιουργία", "צור"])),
          Node(name: "AbilityKeyword", kind: .keyword(["ability", "Fähigkeit", "capacité", "ικανότητα", "יכולת"])),
          Node(name: "UseKeyword", kind: .keyword(["use", "Verwendung", "utilisation", "χρήση", "שימוש"])),
          Node(name: "ExtensionKeyword", kind: .keyword(["extension", "Erweiterung", /* extension */ "επέκταση", "הרחבה"])),
          Node(name: "ClientsKeyword", kind: .keyword(["clients", "Kunden", /* clients */ "πελάτες", "לקוחות"])),
          Node(name: "UnitKeyword", kind: .keyword(["unit", "Einheit", "unité", "μονάδα", "יחידה"])),
          Node(name: "FileKeyword", kind: .keyword(["file", "Datei", "fichier", "αρχείο", "קובץ"])),
          Node(name: "NowhereKeyword", kind: .keyword(["nowhere", "nirgendwo", "nulle" /* part */, "πουθενά", "אין" /* גישה */])),
          Node(name: "TestsKeyword", kind: .keyword(["tests", "Prüfungen", "essais", "δοκιμές", "בדיקות"])),
          Node(name: "TestKeyword", kind: .keyword(["test", "Prüfung", "essai", "δοκιμή", "בדיקה"])),
          Node(name: "HiddenKeyword", kind: .keyword(["hidden", "versteckt", "caché", "κρυφή", "נסתרת"])),
          Node(name: "ParameterKeyword", kind: .keyword(["parameter", "Übergabewert", "paramètre", "παράμετρος", "פרמטר"])),
          Node(
            name: "IdentifierComponent",
            kind: .variableLeaf(allowed: {
              var values: [UInt32] = []
              values.append(contentsOf: 0x2B...0x2C) // +–,
              values.append(0x2E) // .
              values.append(contentsOf: 0x30...0x39) // 0–9
              values.append(contentsOf: 0x3C...0x3E) // <–>
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
              values.append(contentsOf: 0x2BB...0x2BC) // ʻ–ʼ
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
              values.append(contentsOf: 0x490...0x493) // Ґ–ғ
              values.append(contentsOf: 0x49A...0x49B) // Қ–қ
              values.append(contentsOf: 0x4A2...0x4A3) // Ң–ң
              values.append(contentsOf: 0x4AE...0x4B1) // Ү–ұ
              values.append(contentsOf: 0x4B6...0x4B7) // Ҷ–ҷ
              values.append(contentsOf: 0x4BA...0x4BB) // Һ–һ
              values.append(contentsOf: 0x4D8...0x4D9) // Ә–ә
              values.append(contentsOf: 0x4E8...0x4E9) // Ө–ө
              values.append(contentsOf: 0x531...0x556) // Ա–Ֆ
              values.append(contentsOf: 0x55B...0x55E) // ՛–՞
              values.append(contentsOf: 0x561...0x586) // ա–ֆ
              values.append(contentsOf: 0x589...0x58A) // ։–֊
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
              values.append(contentsOf: 0x901...0x903) // ◌ँ–◌ः
              values.append(contentsOf: 0x905...0x90B) // अ–ऋ
              values.append(contentsOf: 0x90F...0x910) // ए–ऐ
              values.append(contentsOf: 0x913...0x928) // ओ–न
              values.append(contentsOf: 0x92A...0x930) // प–र
              values.append(0x932) // ल
              values.append(contentsOf: 0x935...0x939) // व–ह
              values.append(0x93C) // ◌़
              values.append(contentsOf: 0x93E...0x943) // ◌ा–◌ृ
              values.append(contentsOf: 0x947...0x948) // ◌े–◌ै
              values.append(contentsOf: 0x94B...0x94D) // ◌ो–◌्
              values.append(0x964) // ।
              values.append(contentsOf: 0x966...0x96F) // ०–९
              values.append(contentsOf: 0x10D0...0x10F0) // ა–ჰ
              values.append(contentsOf: 0x1100...0x1112) // ᄀ–ᄒ
              values.append(contentsOf: 0x1161...0x1175) // ᅡ–ᅵ
              values.append(contentsOf: 0x11A8...0x11C2) // ᆨ–ᇂ
              values.append(0x2010) // ‐
              values.append(0x2019) // ’
              values.append(contentsOf: 0x2212...0x2213) // −–∓
              values.append(contentsOf: 0x2227...0x222A) // ∧–∪
              values.append(0x2236) // ∶
              values.append(contentsOf: 0x2264...0x2265) // ≤–≥
              values.append(0x22C5) // ⋅
              values.append(contentsOf: 0x266D...0x266F) // ♭–♯
              return Set(values.lazy.map({ Unicode.Scalar($0)! }))
            }())
          ),

          Node(
            name: "Colon",
            kind: .compound(children: [
              Child(name: "precedingSpace", type: "SpaceSyntax", kind: .optional),
              Child(name: "colon", type: "ColonCharacterSyntax", kind: .fixed),
              Child(name: "followingSpace", type: "SpaceSyntax", kind: .fixed),
            ])
          ),
          Node(
            name: "Bullet",
            kind: .compound(children: [
              Child(name: "bullet", type: "BulletCharacterSyntax", kind: .fixed),
              Child(name: "followingSpace", type: "SpaceSyntax", kind: .fixed),
            ])
          ),
          Node(
            name: "ThroughArrow",
            kind: .compound(children: [
              Child(name: "arrow", type: "DownArrowSyntax", kind: .fixed),
              Child(name: "space", type: "SpaceSyntax", kind: .fixed),
            ])
          ),
          Node(
            name: "YieldArrowCharacter",
            kind: .alternates([
              Alternate(name: "right", type: "RightArrowSyntax"),
              Alternate(name: "left", type: "LeftArrowSyntax"),
            ])
          ),
          Node(
            name: "YieldArrow",
            kind: .compound(children: [
              Child(name: "arrow", type: "YieldArrowCharacter", kind: .required),
              Child(name: "space", type: "SpaceSyntax", kind: .fixed),
            ])
          ),

          Node(
            name: "EmptyParentheses",
            kind: .compound(children: [
              Child(name: "openingParenthesis", type: "OpeningParenthesisSyntax", kind: .fixed),
              Child(name: "closingParenthesis", type: "ClosingParenthesisSyntax", kind: .fixed),
            ])
          ),
          Node(
            name: "EmptyBraces",
            kind: .compound(children: [
              Child(name: "openingBrace", type: "OpeningBraceSyntax", kind: .fixed),
              Child(name: "closingBrace", type: "ClosingBraceSyntax", kind: .fixed),
            ])
          ),
          Node(
            name: "EmptyExclamation",
            kind: .compound(children: [
              Child(name: "openingExclamationMark", type: "OpeningExclamationMarkSyntax", kind: .optional),
              Child(name: "closingExclamationMark", type: "ClosingExclamationMarkSyntax", kind: .fixed),
            ])
          ),

        ],
        Node.separatedList(
          name: "UninterruptedIdentifier",
          entryName: "component", entryNamePlural: "components",
          entryType: "IdentifierComponent",
          separatorName: "space",
          separatorType: "SpaceSyntax",
          fixedSeparator: true,
          isIdentifierSegment: true
        ),
        [
          Node(
            name: "InitialIdentifierSegment",
            kind: .compound(children: [
              Child(name: "segment", type: "UninterruptedIdentifier", kind: .required),
              Child(name: "space", type: "SpaceSyntax", kind: .optional),
            ]),
            isIdentifierSegment: true
          ),
          Node(
            name: "TextMedialIdentifierSegment",
            kind: .compound(children: [
              Child(name: "initialSpace", type: "SpaceSyntax", kind: .optional),
              Child(name: "segment", type: "UninterruptedIdentifier", kind: .required),
              Child(name: "finalSpace", type: "SpaceSyntax", kind: .optional),
            ])
          ),
          Node(
            name: "MedialIdentifierSegment",
            kind: .alternates([
              Alternate(name: "text", type: "TextMedialIdentifierSegment"),
              Alternate(name: "space", type: "SpaceSyntax"),
            ]),
            isIdentifierSegment: true
          ),
          Node(
            name: "FinalIdentifierSegment",
            kind: .compound(children: [
              Child(name: "space", type: "SpaceSyntax", kind: .optional),
              Child(name: "segment", type: "UninterruptedIdentifier", kind: .required),
            ]),
            isIdentifierSegment: true
          ),

          Node(
            name: "DocumentationReferenceIdentifier",
            kind: .alternates([
              Alternate(name: "action", type: "ActionReference"),
              Alternate(name: "simple", type: "UninterruptedIdentifier"),
            ])
          ),
          Node(
            name: "DocumentationReference",
            kind: .compound(children: [
              Child(name: "openingBrace", type: "OpeningBraceSyntax", kind: .fixed),
              Child(name: "identifier", type: "DocumentationReferenceIdentifier", kind: .required),
              Child(name: "closingBrace", type: "ClosingBraceSyntax", kind: .fixed),
            ])
          ),
          Node(
            name: "DocumentationTextSegment",
            kind: .alternates([
              Alternate(name: "identifierCharacters", type: "IdentifierComponent"),
              Alternate(name: "openingParenthesis", type: "OpeningParenthesisSyntax"),
              Alternate(name: "closingParenthesis", type: "ClosingParenthesisSyntax"),
              Alternate(name: "openingQuestionMark", type: "OpeningQuestionMarkSyntax"),
              Alternate(name: "closingQuestionMark", type: "ClosingQuestionMarkSyntax"),
              Alternate(name: "rightToLeftQuestionMark", type: "RightToLeftQuestionMarkSyntax"),
              Alternate(name: "greekQuestionMark", type: "GreekQuestionMarkSyntax"),
              Alternate(name: "openingExclamationMark", type: "OpeningExclamationMarkSyntax"),
              Alternate(name: "closingExclamationMark", type: "ClosingExclamationMarkSyntax"),
              Alternate(name: "reference", type: "DocumentationReference")
            ])
          ),
          Node(
            name: "DocumentationTextSpan",
            kind: .compound(children: [
              Child(name: "first", type: "DocumentationTextSegment", kind: .required),
              Child(name: "continuations", type: "DocumentationTextSegment", kind: .array),
            ])
          ),
        ],
        Node.separatedList(
          name: "DocumentationText",
          entryName: "span", entryNamePlural: "spans",
          entryType: "DocumentationTextSpan",
          separatorName: "space",
          separatorType: "SpaceSyntax",
          fixedSeparator: true
        ),

        [
          Node(
            name: "LiteralSegment",
            kind: .alternates([
              Alternate(name: "identifier", type: "IdentifierComponent"),
              Alternate(name: "openingParenthesis", type: "OpeningParenthesisSyntax"),
              Alternate(name: "closingParenthesis", type: "ClosingParenthesisSyntax"),
              Alternate(name: "openingBracket", type: "OpeningBracketSyntax"),
              Alternate(name: "closingBracket", type: "ClosingBracketSyntax"),
              Alternate(name: "openingBrace", type: "OpeningBraceSyntax"),
              Alternate(name: "closingBrace", type: "ClosingBraceSyntax"),
              Alternate(name: "openingQuestionMark", type: "OpeningQuestionMarkSyntax"),
              Alternate(name: "closingQuestionMark", type: "ClosingQuestionMarkSyntax"),
              Alternate(name: "rightToLeftQuestionMark", type: "RightToLeftQuestionMarkSyntax"),
              Alternate(name: "greekQuestionMark", type: "GreekQuestionMarkSyntax"),
              Alternate(name: "openingExclamationMark", type: "OpeningExclamationMarkSyntax"),
              Alternate(name: "closingExclamationMark", type: "ClosingExclamationMarkSyntax"),
              Alternate(name: "colon", type: "ColonCharacterSyntax"),
              Alternate(name: "slash", type: "SlashSyntax"),
              Alternate(name: "bulletCharacter", type: "BulletCharacterSyntax"),
              Alternate(name: "downArrow", type: "DownArrowSyntax"),
              Alternate(name: "rightArrow", type: "RightArrowSyntax"),
              Alternate(name: "leftArrow", type: "LeftArrowSyntax"),
              Alternate(name: "space", type: "SpaceSyntax"),
            ])
          ),
          Node(
            name: "Symbol",
            kind: .compound(children: [
              Child(name: "mark", type: "SymbolInsertionMarkSyntax", kind: .fixed),
              Child(name: "openingParenthesis", type: "OpeningParenthesisSyntax", kind: .fixed),
              Child(name: "code", type: "IdentifierComponent", kind: .required),
              Child(name: "closingParenthesis", type: "ClosingParenthesisSyntax", kind: .fixed),
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
              Child(name: "openingQuotationMark", type: "LeftChevronQuotationMarkSyntax", kind: .fixed),
              Child(name: "contents", type: "LiteralComponent", kind: .array),
              Child(name: "closingQuotationMark", type: "RightChevronQuotationMarkSyntax", kind: .fixed),
            ])
          ),
          Node(
            name: "SixNineString",
            kind: .compound(children: [
              Child(name: "openingQuotationMark", type: "SixesQuotationMarkSyntax", kind: .fixed),
              Child(name: "contents", type: "LiteralComponent", kind: .array),
              Child(name: "closingQuotationMark", type: "NinesQuotationMarkSyntax", kind: .fixed),
            ])
          ),
          Node(
            name: "LowSixString",
            kind: .compound(children: [
              Child(name: "openingQuotationMark", type: "LowQuotationMarkSyntax", kind: .fixed),
              Child(name: "contents", type: "LiteralComponent", kind: .array),
              Child(name: "closingQuotationMark", type: "SixesQuotationMarkSyntax", kind: .fixed),
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
            name: "AccessDeclaration",
            kind: .alternates([
              Alternate(name: "file", type: "FileKeyword"),
              Alternate(name: "unit", type: "UnitKeyword"),
              Alternate(name: "clients", type: "ClientsKeyword"),
            ])
          ),
          Node(
            name: "WriteAccessDeclaration",
            kind: .alternates([
              Alternate(name: "nowhere", type: "NowhereKeyword"),
              Alternate(name: "general", type: "AccessDeclaration"),
            ])
          ),
          Node(
            name: "ReadWriteAccessDeclaration",
            kind: .compound(children: [
              Child(name: "read", type: "AccessDeclaration", kind: .required),
              Child(name: "slash", type: "SlashSyntax", kind: .fixed),
              Child(name: "write", type: "WriteAccessDeclaration", kind: .required),
            ])
          ),
          Node(
            name: "StorageAccessDeclaration",
            kind: .alternates([
              Alternate(name: "differing", type: "ReadWriteAccessDeclaration"),
              Alternate(name: "same", type: "AccessDeclaration"),
            ])
          ),
          Node(
            name: "Access",
            kind: .compound(children: [
              Child(name: "space", type: "SpaceSyntax", kind: .fixed),
              Child(name: "openingParenthesis", type: "OpeningParenthesisSyntax", kind: .fixed),
              Child(name: "keyword", type: "AccessDeclaration", kind: .required),
              Child(name: "closingParenthesis", type: "ClosingParenthesisSyntax", kind: .fixed),
            ])
          ),
          Node(
            name: "StorageAccess",
            kind: .compound(children: [
              Child(name: "space", type: "SpaceSyntax", kind: .fixed),
              Child(name: "openingParenthesis", type: "OpeningParenthesisSyntax", kind: .fixed),
              Child(name: "keywords", type: "StorageAccessDeclaration", kind: .required),
              Child(name: "closingParenthesis", type: "ClosingParenthesisSyntax", kind: .fixed),
            ])
          ),
          Node(
            name: "TestAccess",
            kind: .compound(children: [
              Child(name: "space", type: "SpaceSyntax", kind: .fixed),
              Child(name: "openingParenthesis", type: "OpeningParenthesisSyntax", kind: .fixed),
              Child(name: "keyword", type: "TestsKeyword", kind: .required),
              Child(name: "closingParenthesis", type: "ClosingParenthesisSyntax", kind: .fixed),
            ])
          ),

          Node(
            name: "PassedArgument",
            kind: .compound(children: [
              Child(name: "openingParenthesis", type: "OpeningParenthesisSyntax", kind: .fixed),
              Child(name: "argument", type: "AnnotatedAction", kind: .required),
              Child(name: "closingParenthesis", type: "ClosingParenthesisSyntax", kind: .fixed),
            ])
          ),
          Node(
            name: "EmptyArgument",
            kind: .compound(children: [
              Child(name: "openingParenthesis", type: "OpeningParenthesisSyntax", kind: .fixed),
              Child(name: "closingParenthesis", type: "ClosingParenthesisSyntax", kind: .fixed),
            ])
          ),
          Node(
            name: "Argument",
            kind: .alternates([
              Alternate(name: "passed", type: "PassedArgument"),
              Alternate(name: "flow", type: "BracedStatementList"),
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
        Node.separatedList(
          name: "EmptyActionArguments",
          entryName: "argument", entryNamePlural: "arguments",
          entryType: "EmptyArgument",
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
            name: "ActionReference",
            kind: .compound(children: [
              Child(name: "initialIdentifierSegment", type: "InitialIdentifierSegment", kind: .optional),
              Child(name: "arguments", type: "EmptyActionArguments", kind: .required),
              Child(name: "finalIdentifierSegment", type: "FinalIdentifierSegment", kind: .optional),
            ])
          ),
          Node(
            name: "TypeAnnotation",
            kind: .compound(children: [
              Child(name: "colon", type: "Colon", kind: .required),
              Child(name: "yieldArrow", type: "YieldArrow", kind: .optional),
              Child(name: "type", type: "ThingReference", kind: .required),
            ])
          ),
          Node(
            name: "Action",
            kind: .alternates([
              Alternate(name: "compound", type: "CompoundAction"),
              Alternate(name: "reference", type: "ActionReference"),
              Alternate(name: "simple", type: "UninterruptedIdentifier"),
              Alternate(name: "literal", type: "Literal")
            ]),
            isIndirect: true
          ),
          Node(
            name: "Passage",
            kind: .alternates([
              Alternate(name: "bullet", type: "Bullet"),
              Alternate(name: "throughArrow", type: "ThroughArrow"),
            ])
          ),
          Node(
            name: "AnnotatedAction",
            kind: .compound(children: [
              Child(name: "passage", type: "Passage", kind: .optional),
              Child(name: "action", type: "Action", kind: .required),
              Child(name: "type", type: "TypeAnnotation", kind: .optional),
            ])
          ),

          Node(
            name: "ParagraphEntry",
            kind: .compound(children: [
              Child(name: "language", type: "UninterruptedIdentifier", kind: .required),
              Child(name: "colon", type: "Colon", kind: .required),
              Child(name: "text", type: "DocumentationText", kind: .required),
            ])
          ),
        ],
        Node.separatedList(
          name: "ParagraphList",
          entryName: "text", entryNamePlural: "text",
          entryType: "ParagraphEntry",
          separatorName: "lineBreak",
          separatorType: "LineBreakSyntax",
          fixedSeparator: true
        ),
        [
          Node(
            name: "Paragraph",
            kind: .compound(children: [
              Child(name: "openingBracket", type: "OpeningBracketSyntax", kind: .fixed),
              Child(name: "openingLineBreak", type: "LineBreakSyntax", kind: .fixed),
              Child(name: "paragraphs", type: "ParagraphList", kind: .required),
              Child(name: "closingLineBreak", type: "LineBreakSyntax", kind: .fixed),
              Child(name: "closingBracket", type: "ClosingBracketSyntax", kind: .fixed),
            ])
          ),

          Node(
            name: "ParameterDetails",
            kind: .compound(children: [
              Child(name: "openingParenthesis", type: "OpeningParenthesisSyntax", kind: .fixed),
              Child(name: "openingLineBreak", type: "LineBreakSyntax", kind: .fixed),
              Child(name: "paragraph", type: "Paragraph", kind: .required),
              Child(name: "closingLineBreak", type: "LineBreakSyntax", kind: .fixed),
              Child(name: "closingParenthesis", type: "ClosingParenthesisSyntax", kind: .fixed),
            ])
          ),
          Node(
            name: "ParameterDocumentation",
            kind: .compound(children: [
              Child(name: "keyword", type: "ParameterKeyword", kind: .required),
              Child(name: "colon", type: "Colon", kind: .required),
              Child(name: "name", type: "UninterruptedIdentifier", kind: .required),
              Child(name: "lineBreak", type: "LineBreakSyntax", kind: .fixed),
              Child(name: "details", type: "ParameterDetails", kind: .required),
            ])
          ),
          Node(
            name: "TestVisibility",
            kind: .compound(children: [
              Child(name: "space", type: "SpaceSyntax", kind: .fixed),
              Child(name: "openingParenthesis", type: "OpeningParenthesisSyntax", kind: .fixed),
              Child(name: "keyword", type: "HiddenKeyword", kind: .required),
              Child(name: "closingParenthesis", type: "ClosingParenthesisSyntax", kind: .fixed),
            ])
          ),
          Node(
            name: "ShortTestImplementation",
            kind: .compound(children: [
              Child(name: "openingBrace", type: "OpeningBraceSyntax", kind: .fixed),
              Child(name: "test", type: "Action", kind: .required),
              Child(name: "closingBrace", type: "ClosingBraceSyntax", kind: .fixed),
            ])
          ),
          Node(
            name: "TestImplemenation",
            kind: .alternates([
              Alternate(name: "short", type: "ShortTestImplementation"),
              Alternate(name: "long", type: "BracedStatementList"),
            ])
          ),
          Node(
            name: "Test",
            kind: .compound(children: [
              Child(name: "keyword", type: "TestKeyword", kind: .required),
              Child(name: "visibility", type: "TestVisibility", kind: .optional),
              Child(name: "space", type: "SpaceSyntax", kind: .fixed),
              Child(name: "implementation", type: "TestImplemenation", kind: .required),
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
          separatorType: "LineBreakSyntax",
          fixedSeparator: true
        ),
        [
          Node(
            name: "Documentation",
            kind: .compound(children: [
              Child(name: "openingBracket", type: "OpeningBracketSyntax", kind: .fixed),
              Child(name: "openingLineBreak", type: "LineBreakSyntax", kind: .fixed),
              Child(name: "entries", type: "DocumentationList", kind: .required),
              Child(name: "closingLineBreak", type: "LineBreakSyntax", kind: .fixed),
              Child(name: "closingBracket", type: "ClosingBracketSyntax", kind: .fixed),
            ])
          ),
          Node(
            name: "AttachedDocumentation",
            kind: .compound(children: [
              Child(name: "documentation", type: "Documentation", kind: .required),
              Child(name: "lineBreak", type: "LineBreakSyntax", kind: .fixed),
            ])
          ),

          Node(
            name: "PartNameEntry",
            kind: .compound(children: [
              Child(name: "language", type: "UninterruptedIdentifier", kind: .required),
              Child(name: "colon", type: "Colon", kind: .required),
              Child(name: "name", type: "UninterruptedIdentifier", kind: .required),
            ])
          ),
          Node(
            name: "CaseNameEntry",
            kind: .compound(children: [
              Child(name: "language", type: "UninterruptedIdentifier", kind: .required),
              Child(name: "colon", type: "Colon", kind: .required),
              Child(name: "name", type: "UninterruptedIdentifier", kind: .required),
            ])
          ),
        ],
        Node.separatedList(
          name: "PartNameList",
          entryName: "name", entryNamePlural: "names",
          entryType: "PartNameEntry",
          separatorName: "lineBreak",
          separatorType: "LineBreakSyntax",
          fixedSeparator: true
        ),
        Node.separatedList(
          name: "CaseNameList",
          entryName: "name", entryNamePlural: "names",
          entryType: "CaseNameEntry",
          separatorName: "lineBreak",
          separatorType: "LineBreakSyntax",
          fixedSeparator: true
        ),
        [
          Node(
            name: "PartName",
            kind: .compound(children: [
              Child(name: "openingParenthesis", type: "OpeningParenthesisSyntax", kind: .fixed),
              Child(name: "openingLineBreak", type: "LineBreakSyntax", kind: .fixed),
              Child(name: "names", type: "PartNameList", kind: .required),
              Child(name: "closingLineBreak", type: "LineBreakSyntax", kind: .fixed),
              Child(name: "closingParenthesis", type: "ClosingParenthesisSyntax", kind: .fixed),
            ])
          ),
          Node(
            name: "CaseName",
            kind: .compound(children: [
              Child(name: "openingParenthesis", type: "OpeningParenthesisSyntax", kind: .fixed),
              Child(name: "openingLineBreak", type: "LineBreakSyntax", kind: .fixed),
              Child(name: "names", type: "CaseNameList", kind: .required),
              Child(name: "closingLineBreak", type: "LineBreakSyntax", kind: .fixed),
              Child(name: "closingParenthesis", type: "ClosingParenthesisSyntax", kind: .fixed),
            ])
          ),

          Node(
            name: "ThingSignature",
            kind: .alternates([
              Alternate(name: "compound", type: "AbilitySignature"),
              Alternate(name: "simple", type: "UninterruptedIdentifier"),
            ])
          ),
          Node(
            name: "ThingNameEntry",
            kind: .compound(children: [
              Child(name: "language", type: "UninterruptedIdentifier", kind: .required),
              Child(name: "colon", type: "Colon", kind: .required),
              Child(name: "name", type: "ThingSignature", kind: .required),
            ])
          )
        ],
        Node.separatedList(
          name: "ThingNameList",
          entryName: "name", entryNamePlural: "names",
          entryType: "ThingNameEntry",
          separatorName: "lineBreak",
          separatorType: "LineBreakSyntax",
          fixedSeparator: true
        ),
        [
          Node(
            name: "ThingName",
            kind: .compound(children: [
              Child(name: "openingParenthesis", type: "OpeningParenthesisSyntax", kind: .fixed),
              Child(name: "openingLineBreak", type: "LineBreakSyntax", kind: .fixed),
              Child(name: "names", type: "ThingNameList", kind: .required),
              Child(name: "closingLineBreak", type: "LineBreakSyntax", kind: .fixed),
              Child(name: "closingParenthesis", type: "ClosingParenthesisSyntax", kind: .fixed),
            ])
          ),

          Node(
            name: "ThingReference",
            kind: .alternates([
              Alternate(name: "compound", type: "UseSignature"),
              Alternate(name: "simple", type: "UninterruptedIdentifier"),
            ]),
            isIndirect: true
          ),
          Node(
            name: "ConcreteParameterType",
            kind: .compound(children: [
              Child(name: "passage", type: "Passage", kind: .optional),
              Child(name: "yieldArrow", type: "YieldArrow", kind: .optional),
              Child(name: "type", type: "ThingReference", kind: .required),
            ])
          ),
          Node(
            name: "ParameterType",
            kind: .alternates([
              Alternate(name: "type", type: "ConcreteParameterType"),
              Alternate(name: "statements", type: "EmptyBraces"),
            ])
          ),
          Node(
            name: "ParameterReference",
            kind: .compound(children: [
              Child(name: "openingBracket", type: "OpeningBracketSyntax", kind: .fixed),
              Child(name: "name", type: "ParameterName", kind: .required),
              Child(name: "closingBracket", type: "ClosingBracketSyntax", kind: .fixed),
            ])
          ),
          Node(
            name: "ParameterTypeOrReference",
            kind: .alternates([
              Alternate(name: "type", type: "ParameterType"),
              Alternate(name: "reference", type: "ParameterReference"),
            ]),
            isIndirect: true
          ),
        ],
        Node.separatedList(
          name: "NameParameterList",
          entryName: "parameter", entryNamePlural: "parameters",
          entryType: "EmptyParentheses",
          separatorName: "identifierSegment",
          separatorType: "MedialIdentifierSegment",
          fixedSeparator: false
        ),
        [
          Node(
            name: "CompoundParameterName",
            kind: .compound(children: [
              Child(name: "initialIdentifierSegment", type: "InitialIdentifierSegment", kind: .optional),
              Child(name: "parameters", type: "NameParameterList", kind: .required),
              Child(name: "finalIdentifierSegment", type: "FinalIdentifierSegment", kind: .optional),
            ])
          ),
          Node(
            name: "ParameterName",
            kind: .alternates([
              Alternate(name: "compound", type: "CompoundParameterName"),
              Alternate(name: "simple", type: "UninterruptedIdentifier"),
            ])
          ),
          Node(
            name: "Parameter",
            kind: .compound(children: [
              Child(name: "openingParenthesis", type: "OpeningParenthesisSyntax", kind: .fixed),
              Child(name: "name", type: "Signature", kind: .required),
              Child(name: "colon", type: "Colon", kind: .required),
              Child(name: "type", type: "ParameterTypeOrReference", kind: .required),
              Child(name: "closingParenthesis", type: "ClosingParenthesisSyntax", kind: .fixed),
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
            ]),
            isIndirect: true
          ),
          Node(
            name: "ActionNameEntry",
            kind: .compound(children: [
              Child(name: "language", type: "UninterruptedIdentifier", kind: .required),
              Child(name: "colon", type: "Colon", kind: .required),
              Child(name: "name", type: "Signature", kind: .required),
            ])
          )
        ],
        Node.separatedList(
          name: "ActionNameList",
          entryName: "name", entryNamePlural: "names",
          entryType: "ActionNameEntry",
          separatorName: "lineBreak",
          separatorType: "LineBreakSyntax",
          fixedSeparator: true
        ),
        [
          Node(
            name: "MultipleActionNames",
            kind: .compound(children: [
              Child(name: "openingParenthesis", type: "OpeningParenthesisSyntax", kind: .fixed),
              Child(name: "openingLineBreak", type: "LineBreakSyntax", kind: .fixed),
              Child(name: "names", type: "ActionNameList", kind: .required),
              Child(name: "closingLineBreak", type: "LineBreakSyntax", kind: .fixed),
              Child(name: "closingParenthesis", type: "ClosingParenthesisSyntax", kind: .fixed),
            ])
          ),
          Node(
            name: "ActionName",
            kind: .alternates([
              Alternate(name: "multiple", type: "MultipleActionNames"),
              Alternate(name: "single", type: "Signature"),
            ])
          ),

          Node(
            name: "AbilityParameterType",
            kind: .compound(children: [
              Child(name: "openingParenthesis", type: "OpeningParenthesisSyntax", kind: .fixed),
              Child(name: "name", type: "UninterruptedIdentifier", kind: .required),
              Child(name: "closingParenthesis", type: "ClosingParenthesisSyntax", kind: .fixed),
            ])
          ),
          Node(
            name: "UseArgumentType",
            kind: .compound(children: [
              Child(name: "openingParenthesis", type: "OpeningParenthesisSyntax", kind: .fixed),
              Child(name: "name", type: "ThingReference", kind: .required),
              Child(name: "closingParenthesis", type: "ClosingParenthesisSyntax", kind: .fixed),
            ])
          ),
          Node(
            name: "AbilityParameterReference",
            kind: .compound(children: [
              Child(name: "openingParenthesis", type: "OpeningParenthesisSyntax", kind: .fixed),
              Child(name: "name", type: "UninterruptedIdentifier", kind: .required),
              Child(name: "colon", type: "Colon", kind: .required),
              Child(name: "reference", type: "ParameterReference", kind: .required),
              Child(name: "closingParenthesis", type: "ClosingParenthesisSyntax", kind: .fixed),
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
              Child(name: "colon", type: "Colon", kind: .required),
              Child(name: "name", type: "AbilitySignature", kind: .required),
            ])
          )
        ],
        Node.separatedList(
          name: "AbilityNameList",
          entryName: "name", entryNamePlural: "names",
          entryType: "AbilityNameEntry",
          separatorName: "lineBreak",
          separatorType: "LineBreakSyntax",
          fixedSeparator: true
        ),
        [
          Node(
            name: "AbilityName",
            kind: .compound(children: [
              Child(name: "openingParenthesis", type: "OpeningParenthesisSyntax", kind: .fixed),
              Child(name: "openingLineBreak", type: "LineBreakSyntax", kind: .fixed),
              Child(name: "names", type: "AbilityNameList", kind: .required),
              Child(name: "closingLineBreak", type: "LineBreakSyntax", kind: .fixed),
              Child(name: "closingParenthesis", type: "ClosingParenthesisSyntax", kind: .fixed),
            ])
          ),
        ],
        Node.separatedList(
          name: "UseArgumentList",
          entryName: "argument", entryNamePlural: "arguments",
          entryType: "UseArgumentType",
          separatorName: "identifierSegment",
          separatorType: "MedialIdentifierSegment",
          fixedSeparator: false
        ),
        [
          Node(
            name: "UseSignature",
            kind: .compound(children: [
              Child(name: "initialIdentifierSegment", type: "InitialIdentifierSegment", kind: .optional),
              Child(name: "arguments", type: "UseArgumentList", kind: .required),
              Child(name: "finalIdentifierSegment", type: "FinalIdentifierSegment", kind: .optional),
            ])
          ),

          Node(
            name: "ActionReturnValue",
            kind: .compound(children: [
              Child(name: "type", type: "ThingReference", kind: .required),
              Child(name: "lineBreak", type: "LineBreakSyntax", kind: .fixed),
            ])
          ),
          Node(
            name: "RequirementReturnValue",
            kind: .compound(children: [
              Child(name: "lineBreak", type: "LineBreakSyntax", kind: .fixed),
              Child(name: "type", type: "ThingReference", kind: .required),
            ])
          ),

          Node(
            name: "ModifiedImplementationParameter",
            kind: .compound(children: [
              Child(name: "initialModifierSegment", type: "InitialIdentifierSegment", kind: .optional),
              Child(name: "openingParenthesis", type: "OpeningParenthesisSyntax", kind: .fixed),
              Child(name: "parameter", type: "UninterruptedIdentifier", kind: .required),
              Child(name: "closingParenthesis", type: "ClosingParenthesisSyntax", kind: .fixed),
              Child(name: "finalModifierSegment", type: "FinalIdentifierSegment", kind: .optional),
            ])
          ),
          Node(
            name: "ImplementationParameter",
            kind: .alternates([
              Alternate(name: "modified", type: "ModifiedImplementationParameter"),
              Alternate(name: "simple", type: "UninterruptedIdentifier"),
            ])
          ),
          Node(
            name: "ImplementationComponent",
            kind: .alternates([
              Alternate(name: "parameter", type: "ImplementationParameter"),
              Alternate(name: "literal", type: "Literal"),
            ])
          ),
        ],
        Node.separatedList(
          name: "NativeImportList",
          entryName: "importNode", entryNamePlural: "imports",
          entryType: "Literal",
          separatorName: "lineBreak",
          separatorType: "LineBreakSyntax",
          fixedSeparator: true
        ),
        [
          Node(
            name: "SpacedImportList",
            kind: .compound(children: [
              Child(name: "openingLineBreak", type: "LineBreakSyntax", kind: .fixed),
              Child(name: "imports", type: "NativeImportList", kind: .required),
              Child(name: "closingLineBreak", type: "LineBreakSyntax", kind: .fixed),
            ])
          ),
          Node(
            name: "NativeImportContents",
            kind: .alternates([
              Alternate(name: "list", type: "SpacedImportList"),
              Alternate(name: "single", type: "Literal"),
            ])
          ),
          Node(
            name: "NativeImport",
            kind: .compound(children: [
              Child(name: "space", type: "SpaceSyntax", kind: .fixed),
              Child(name: "openingParenthesis", type: "OpeningParenthesisSyntax", kind: .fixed),
              Child(name: "imports", type: "NativeImportContents", kind: .required),
              Child(name: "closingParenthesis", type: "ClosingParenthesisSyntax", kind: .fixed),
            ])
          ),
        ],
        Node.separatedList(
          name: "NativeRequirementList",
          entryName: "requirement", entryNamePlural: "requirements",
          entryType: "NativeThingReference",
          separatorName: "lineBreak",
          separatorType: "LineBreakSyntax",
          fixedSeparator: true
        ),
        [
          Node(
            name: "SpacedNativeRequirementList",
            kind: .compound(children: [
              Child(name: "openingLineBreak", type: "LineBreakSyntax", kind: .fixed),
              Child(name: "requirements", type: "NativeRequirementList", kind: .required),
              Child(name: "closingLineBreak", type: "LineBreakSyntax", kind: .fixed),
            ])
          ),
          Node(
            name: "NativeRequirementContents",
            kind: .alternates([
              Alternate(name: "list", type: "SpacedNativeRequirementList"),
              Alternate(name: "single", type: "NativeThingReference"),
            ])
          ),
          Node(
            name: "NativeIndirectRequirements",
            kind: .compound(children: [
              Child(name: "space", type: "SpaceSyntax", kind: .fixed),
              Child(name: "openingBracket", type: "OpeningBracketSyntax", kind: .fixed),
              Child(name: "requirements", type: "NativeRequirementContents", kind: .required),
              Child(name: "closingBracket", type: "ClosingBracketSyntax", kind: .fixed),
            ])
          ),
          Node(
            name: "NativeRequiredCode",
            kind: .compound(children: [
              Child(name: "space", type: "SpaceSyntax", kind: .fixed),
              Child(name: "openingBrace", type: "OpeningBraceSyntax", kind: .fixed),
              Child(name: "requirements", type: "NativeRequirementContents", kind: .required),
              Child(name: "closingBrace", type: "ClosingBraceSyntax", kind: .fixed),
            ])
          ),
        ],
        Node.separatedList(
          name: "NativeThingReference",
          entryName: "component", entryNamePlural: "components",
          entryType: "ImplementationComponent",
          separatorName: "space",
          separatorType: "SpaceSyntax",
          fixedSeparator: true
        ),
        Node.separatedList(
          name: "NativeActionExpression",
          entryName: "component", entryNamePlural: "components",
          entryType: "ImplementationComponent",
          separatorName: "space",
          separatorType: "SpaceSyntax",
          fixedSeparator: true
        ),
        [
          Node(
            name: "NativeReferenceCountedThing",
            kind: .compound(children: [
              Child(name: "type", type: "NativeThingReference", kind: .required),
              Child(name: "firstSlash", type: "SlashSyntax", kind: .fixed),
              Child(name: "hold", type: "NativeActionExpression", kind: .required),
              Child(name: "secondSlash", type: "SlashSyntax", kind: .fixed),
              Child(name: "release", type: "NativeActionExpression", kind: .required),
              Child(name: "thirdSlash", type: "SlashSyntax", kind: .fixed),
              Child(name: "copy", type: "NativeActionExpression", kind: .required),
            ])
          ),
          Node(
            name: "AnyNativeThing",
            kind: .alternates([
              Alternate(name: "referenceCounted", type: "NativeReferenceCountedThing"),
              Alternate(name: "simple", type: "NativeThingReference"),
            ])
          ),
          Node(
            name: "NativeThing",
            kind: .compound(children: [
              Child(name: "type", type: "AnyNativeThing", kind: .required),
              Child(name: "importNode", type: "NativeImport", kind: .optional),
              Child(name: "indirectNode", type: "NativeIndirectRequirements", kind: .optional),
              Child(name: "code", type: "NativeRequiredCode", kind: .optional),
            ])
          ),
          Node(
            name: "NativeAction",
            kind: .compound(children: [
              Child(name: "expression", type: "NativeActionExpression", kind: .required),
              Child(name: "importNode", type: "NativeImport", kind: .optional),
              Child(name: "indirectNode", type: "NativeIndirectRequirements", kind: .optional),
              Child(name: "code", type: "NativeRequiredCode", kind: .optional),
            ])
          ),
          Node(
            name: "NativeStorageCase",
            kind: .compound(children: [
              Child(name: "store", type: "NativeAction", kind: .required),
              Child(name: "firstSlash", type: "SlashSyntax", kind: .fixed),
              Child(name: "retrieve", type: "NativeAction", kind: .required),
              Child(name: "secondSlash", type: "SlashSyntax", kind: .fixed),
              Child(name: "check", type: "NativeAction", kind: .required),
            ])
          ),
          Node(
            name: "NativeThingImplementation",
            kind: .compound(children: [
              Child(name: "language", type: "UninterruptedIdentifier", kind: .required),
              Child(name: "colon", type: "Colon", kind: .required),
              Child(name: "implementation", type: "NativeThing", kind: .required),
            ])
          ),
          Node(
            name: "NativeActionImplementation",
            kind: .compound(children: [
              Child(name: "language", type: "UninterruptedIdentifier", kind: .required),
              Child(name: "colon", type: "Colon", kind: .required),
              Child(name: "expression", type: "NativeAction", kind: .required),
            ])
          ),
          Node(
            name: "NativeStorageCaseImplementation",
            kind: .compound(children: [
              Child(name: "language", type: "UninterruptedIdentifier", kind: .required),
              Child(name: "colon", type: "Colon", kind: .required),
              Child(name: "expressions", type: "NativeStorageCase", kind: .required),
            ])
          ),
          Node(
            name: "SourceThingImplementation",
            kind: .compound(children: [
              Child(name: "openingBrace", type: "OpeningBraceSyntax", kind: .fixed),
              Child(name: "parts", type: "PartListSection", kind: .optional),
              Child(name: "closingLineBreak", type: "LineBreakSyntax", kind: .fixed),
              Child(name: "closingBrace", type: "ClosingBraceSyntax", kind: .fixed),
            ])
          ),
          Node(
            name: "ActionStatement",
            kind: .compound(children: [
              Child(name: "yieldArrow", type: "YieldArrow", kind: .optional),
              Child(name: "action", type: "Action", kind: .required),
            ])
          ),
          Node(
            name: "Statement",
            kind: .alternates([
              Alternate(name: "valid", type: "ActionStatement"),
              Alternate(name: "emptyReturn", type: "YieldArrowCharacter"),
              Alternate(name: "deadEnd", type: "EmptyExclamation"),
            ])
          ),
        ],
          Node.separatedList(
            name: "StatementList",
            entryName: "statement", entryNamePlural: "statements",
            entryType: "Statement",
            separatorName: "lineBreak",
            separatorType: "LineBreakSyntax",
            fixedSeparator: true
          ),
        [
          Node(
            name: "NonEmptyBracedStatementList",
            kind: .compound(children: [
              Child(name: "openingBrace", type: "OpeningBraceSyntax", kind: .fixed),
              Child(name: "openingLineBreak", type: "LineBreakSyntax", kind: .fixed),
              Child(name: "statements", type: "StatementList", kind: .required),
              Child(name: "closingLineBreak", type: "LineBreakSyntax", kind: .fixed),
              Child(name: "closingBrace", type: "ClosingBraceSyntax", kind: .fixed),
            ])
          ),
          Node(
            name: "BracedStatementList",
            kind: .alternates([
              Alternate(name: "empty", type: "EmptyBraces"),
              Alternate(name: "nonEmpty", type: "NonEmptyBracedStatementList"),
            ])
          ),
          Node(
            name: "SourceOrCreationActionImplementation",
            kind: .alternates([
              Alternate(name: "source", type: "BracedStatementList"),
              Alternate(name: "creation", type: "CreateKeyword"),
            ])
          ),
        ],
          Node.separatedList(
            name: "NativeThingImplementations",
            entryName: "implementation", entryNamePlural: "implementations",
            entryType: "NativeThingImplementation",
            separatorName: "lineBreak",
            separatorType: "LineBreakSyntax",
            fixedSeparator: true
          ),
          Node.separatedList(
            name: "NativeActionImplementations",
            entryName: "implementation", entryNamePlural: "implementations",
            entryType: "NativeActionImplementation",
            separatorName: "lineBreak",
            separatorType: "LineBreakSyntax",
            fixedSeparator: true
          ),
          Node.separatedList(
            name: "NativeStorageCaseImplementations",
            entryName: "implementation", entryNamePlural: "implementations",
            entryType: "NativeStorageCaseImplementation",
            separatorName: "lineBreak",
            separatorType: "LineBreakSyntax",
            fixedSeparator: true
          ),

        [
          Node(
            name: "DualThingImplementation",
            kind: .compound(children: [
              Child(name: "native", type: "NativeThingImplementations", kind: .required),
              Child(name: "lineBreak", type: "LineBreakSyntax", kind: .fixed),
              Child(name: "source", type: "SourceThingImplementation", kind: .required),
            ])
          ),
          Node(
            name: "DualEnumerationImplementation",
            kind: .compound(children: [
              Child(name: "native", type: "NativeThingImplementations", kind: .required),
              Child(name: "lineBreak", type: "LineBreakSyntax", kind: .fixed),
              Child(name: "source", type: "Cases", kind: .required),
            ])
          ),
          Node(
            name: "DualActionImplementation",
            kind: .compound(children: [
              Child(name: "native", type: "NativeActionImplementations", kind: .required),
              Child(name: "lineBreak", type: "LineBreakSyntax", kind: .fixed),
              Child(name: "source", type: "SourceOrCreationActionImplementation", kind: .required),
            ])
          ),
          Node(
            name: "EmptyCaseImplementations",
            kind: .compound(children: [
              Child(name: "lineBreak", type: "LineBreakSyntax", kind: .fixed),
              Child(name: "implementations", type: "NativeActionImplementations", kind: .required),
            ])
          ),
          Node(
            name: "StorageCaseImplementations",
            kind: .compound(children: [
              Child(name: "lineBreak", type: "LineBreakSyntax", kind: .fixed),
              Child(name: "implementations", type: "NativeStorageCaseImplementations", kind: .required),
            ])
          ),
          Node(
            name: "ThingImplementations",
            kind: .alternates([
              Alternate(name: "source", type: "SourceThingImplementation"),
              Alternate(name: "dual", type: "DualThingImplementation"),
              Alternate(name: "native", type: "NativeThingImplementations"),
            ])
          ),
          Node(
            name: "EnumerationImplementations",
            kind: .alternates([
              Alternate(name: "source", type: "Cases"),
              Alternate(name: "dual", type: "DualEnumerationImplementation"),
            ])
          ),
          Node(
            name: "ActionImplementations",
            kind: .alternates([
              Alternate(name: "source", type: "SourceOrCreationActionImplementation"),
              Alternate(name: "dual", type: "DualActionImplementation"),
              Alternate(name: "native", type: "NativeActionImplementations"),
            ])
          ),

          Node(
            name: "DualCaseDetails",
            kind: .compound(children: [
              Child(name: "contents", type: "RequirementReturnValue", kind: .required),
              Child(name: "implementation", type: "StorageCaseImplementations", kind: .required),
            ])
          ),
          Node(
            name: "CaseDetails",
            kind: .alternates([
              Alternate(name: "implementation", type: "EmptyCaseImplementations"),
              Alternate(name: "dual", type: "DualCaseDetails"),
              Alternate(name: "contents", type: "RequirementReturnValue"),
            ])
          ),

          Node(
            name: "LanguageDeclaration",
            kind: .compound(children: [
              Child(name: "keyword", type: "LanguageKeyword", kind: .required),
              Child(name: "access", type: "Access", kind: .optional),
              Child(name: "keywordLineBreak", type: "LineBreakSyntax", kind: .fixed),
              Child(name: "name", type: "UninterruptedIdentifier", kind: .required),
            ])
          ),
          Node(
            name: "ThingDeclaration",
            kind: .compound(children: [
              Child(name: "keyword", type: "ThingKeyword", kind: .required),
              Child(name: "access", type: "Access", kind: .optional),
              Child(name: "testAccess", type: "TestAccess", kind: .optional),
              Child(name: "keywordLineBreak", type: "LineBreakSyntax", kind: .fixed),
              Child(name: "documentation", type: "AttachedDocumentation", kind: .optional),
              Child(name: "name", type: "ThingName", kind: .required),
              Child(name: "nameLineBreak", type: "LineBreakSyntax", kind: .fixed),
              Child(name: "implementation", type: "ThingImplementations", kind: .required),
            ])
          ),
          Node(
            name: "PartDeclaration",
            kind: .compound(children: [
              Child(name: "keyword", type: "PartKeyword", kind: .required),
              Child(name: "access", type: "StorageAccess", kind: .optional),
              Child(name: "testAccess", type: "TestAccess", kind: .optional),
              Child(name: "keywordLineBreak", type: "LineBreakSyntax", kind: .fixed),
              Child(name: "documentation", type: "AttachedDocumentation", kind: .optional),
              Child(name: "name", type: "PartName", kind: .required),
              Child(name: "typeLineBreak", type: "LineBreakSyntax", kind: .fixed),
              Child(name: "type", type: "ThingReference", kind: .required),
              Child(name: "implementations", type: "EmptyCaseImplementations", kind: .optional),
            ])
          ),
          Node(
            name: "CaseDeclaration",
            kind: .compound(children: [
              Child(name: "keyword", type: "CaseKeyword", kind: .required),
              Child(name: "keywordLineBreak", type: "LineBreakSyntax", kind: .fixed),
              Child(name: "documentation", type: "AttachedDocumentation", kind: .optional),
              Child(name: "name", type: "CaseName", kind: .required),
              Child(name: "details", type: "CaseDetails", kind: .optional),
            ])
          ),
        ],
          Node.separatedList(
            name: "PartList",
            entryName: "partNode", entryNamePlural: "parts",
            entryType: "PartDeclaration",
            separatorName: "paragraphBreak",
            separatorType: "ParagraphBreakSyntax",
            fixedSeparator: true
          ),
          Node.separatedList(
            name: "CaseList",
            entryName: "caseNode", entryNamePlural: "cases",
            entryType: "CaseDeclaration",
            separatorName: "paragraphBreak",
            separatorType: "ParagraphBreakSyntax",
            fixedSeparator: true
          ),
        [
          Node(
            name: "PartListSection",
            kind: .compound(children: [
              Child(name: "openingLineBreak", type: "LineBreakSyntax", kind: .fixed),
              Child(name: "parts", type: "PartList", kind: .required),
            ])
          ),
          Node(
            name: "CaseListSection",
            kind: .compound(children: [
              Child(name: "openingLineBreak", type: "LineBreakSyntax", kind: .fixed),
              Child(name: "cases", type: "CaseList", kind: .required),
            ])
          ),
          Node(
            name: "Cases",
            kind: .compound(children: [
              Child(name: "openingBrace", type: "OpeningBraceSyntax", kind: .fixed),
              Child(name: "cases", type: "CaseListSection", kind: .required),
              Child(name: "closingLineBreak", type: "LineBreakSyntax", kind: .fixed),
              Child(name: "closingBrace", type: "ClosingBraceSyntax", kind: .fixed),
            ])
          ),
          Node(
            name: "EnumerationDeclaration",
            kind: .compound(children: [
              Child(name: "keyword", type: "EnumerationKeyword", kind: .required),
              Child(name: "access", type: "Access", kind: .optional),
              Child(name: "testAccess", type: "TestAccess", kind: .optional),
              Child(name: "keywordLineBreak", type: "LineBreakSyntax", kind: .fixed),
              Child(name: "documentation", type: "AttachedDocumentation", kind: .optional),
              Child(name: "name", type: "ThingName", kind: .required),
              Child(name: "nameLineBreak", type: "LineBreakSyntax", kind: .fixed),
              Child(name: "implementation", type: "EnumerationImplementations", kind: .required),
            ])
          ),
          Node(
            name: "ActionLikeKeyword",
            kind: .alternates([
              Alternate(name: "action", type: "ActionKeyword"),
              Alternate(name: "flow", type: "FlowKeyword"),
            ])
          ),
          Node(
            name: "ActionDeclaration",
            kind: .compound(children: [
              Child(name: "keyword", type: "ActionLikeKeyword", kind: .required),
              Child(name: "access", type: "Access", kind: .optional),
              Child(name: "testAccess", type: "TestAccess", kind: .optional),
              Child(name: "keywordLineBreak", type: "LineBreakSyntax", kind: .fixed),
              Child(name: "documentation", type: "AttachedDocumentation", kind: .optional),
              Child(name: "name", type: "ActionName", kind: .required),
              Child(name: "nameLineBreak", type: "LineBreakSyntax", kind: .fixed),
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
              Child(name: "keywordLineBreak", type: "LineBreakSyntax", kind: .fixed),
              Child(name: "documentation", type: "AttachedDocumentation", kind: .optional),
              Child(name: "name", type: "ActionName", kind: .required),
              Child(name: "returnValue", type: "RequirementReturnValue", kind: .optional),
            ])
          ),
          Node(
            name: "ChoiceDeclaration",
            kind: .compound(children: [
              Child(name: "keyword", type: "ChoiceKeyword", kind: .required),
              Child(name: "access", type: "Access", kind: .optional),
              Child(name: "testAccess", type: "TestAccess", kind: .optional),
              Child(name: "keywordLineBreak", type: "LineBreakSyntax", kind: .fixed),
              Child(name: "documentation", type: "AttachedDocumentation", kind: .optional),
              Child(name: "name", type: "ActionName", kind: .required),
              Child(name: "nameLineBreak", type: "LineBreakSyntax", kind: .fixed),
              Child(name: "returnValue", type: "ActionReturnValue", kind: .optional),
              Child(name: "implementation", type: "ActionImplementations", kind: .required),
            ])
          ),
          
          Node(
            name: "RequirementsElement",
            kind: .alternates([
              Alternate(name: "requirement", type: "RequirementDeclaration"),
              Alternate(name: "choice", type: "ChoiceDeclaration"),
            ])
          ),
        ],
          Node.separatedList(
            name: "RequirementsList",
            entryName: "requirement", entryNamePlural: "requirements",
            entryType: "RequirementsElement",
            separatorName: "paragraphBreak",
            separatorType: "ParagraphBreakSyntax",
            fixedSeparator: true
          ),
        [
          Node(
            name: "RequirementsListSection",
            kind: .compound(children: [
              Child(name: "openingLineBreak", type: "LineBreakSyntax", kind: .fixed),
              Child(name: "requirements", type: "RequirementsList", kind: .required),
            ])
          ),
          Node(
            name: "Requirements",
            kind: .compound(children: [
              Child(name: "openingBrace", type: "OpeningBraceSyntax", kind: .fixed),
              Child(name: "requirements", type: "RequirementsListSection", kind: .optional),
              Child(name: "closingLineBreak", type: "LineBreakSyntax", kind: .fixed),
              Child(name: "closingBrace", type: "ClosingBraceSyntax", kind: .fixed),
            ])
          ),
          Node(
            name: "AbilityDeclaration",
            kind: .compound(children: [
              Child(name: "keyword", type: "AbilityKeyword", kind: .required),
              Child(name: "access", type: "Access", kind: .optional),
              Child(name: "testAccess", type: "TestAccess", kind: .optional),
              Child(name: "keywordLineBreak", type: "LineBreakSyntax", kind: .fixed),
              Child(name: "documentation", type: "AttachedDocumentation", kind: .optional),
              Child(name: "name", type: "AbilityName", kind: .required),
              Child(name: "nameLineBreak", type: "LineBreakSyntax", kind: .fixed),
              Child(name: "requirements", type: "Requirements", kind: .required),
            ])
          ),

        ],
          Node.separatedList(
            name: "FulfillmentList",
            entryName: "fulfillment", entryNamePlural: "fulfillments",
            entryType: "ActionDeclaration",
            separatorName: "paragraphBreak",
            separatorType: "ParagraphBreakSyntax",
            fixedSeparator: true
          ),
        [
          Node(
            name: "FulfillmentListSection",
            kind: .compound(children: [
              Child(name: "openingLineBreak", type: "LineBreakSyntax", kind: .fixed),
              Child(name: "fulfillments", type: "FulfillmentList", kind: .required),
            ])
          ),
          Node(
            name: "Fulfillments",
            kind: .compound(children: [
              Child(name: "openingBrace", type: "OpeningBraceSyntax", kind: .fixed),
              Child(name: "fulfillments", type: "FulfillmentListSection", kind: .optional),
              Child(name: "closingLineBreak", type: "LineBreakSyntax", kind: .fixed),
              Child(name: "closingBrace", type: "ClosingBraceSyntax", kind: .fixed),
            ])
          ),
          Node(
            name: "Use",
            kind: .compound(children: [
              Child(name: "keyword", type: "UseKeyword", kind: .required),
              Child(name: "access", type: "Access", kind: .optional),
              Child(name: "testAccess", type: "TestAccess", kind: .optional),
              Child(name: "keywordLineBreak", type: "LineBreakSyntax", kind: .fixed),
              Child(name: "use", type: "UseSignature", kind: .required),
              Child(name: "nameLineBreak", type: "LineBreakSyntax", kind: .fixed),
              Child(name: "fulfillments", type: "Fulfillments", kind: .required),
            ])
          ),

          Node(
            name: "Provision",
            kind: .alternates([
              Alternate(name: "thing", type: "ThingDeclaration"),
              Alternate(name: "enumeration", type: "EnumerationDeclaration"),
              Alternate(name: "action", type: "ActionDeclaration"),
              Alternate(name: "use", type: "Use"),
            ])
          ),
        ],
          Node.separatedList(
            name: "ProvisionList",
            entryName: "provision", entryNamePlural: "provisions",
            entryType: "Provision",
            separatorName: "paragraphBreak",
            separatorType: "ParagraphBreakSyntax",
            fixedSeparator: true
          ),
        [
          Node(
            name: "ProvisionListSection",
            kind: .compound(children: [
              Child(name: "openingLineBreak", type: "LineBreakSyntax", kind: .fixed),
              Child(name: "provisions", type: "ProvisionList", kind: .required),
            ])
          ),
          Node(
            name: "Provisions",
            kind: .compound(children: [
              Child(name: "openingBrace", type: "OpeningBraceSyntax", kind: .fixed),
              Child(name: "provisions", type: "ProvisionListSection", kind: .optional),
              Child(name: "closingLineBreak", type: "LineBreakSyntax", kind: .fixed),
              Child(name: "closingBrace", type: "ClosingBraceSyntax", kind: .fixed),
            ])
          ),
          Node(
            name: "ExtensionSyntax",
            kind: .compound(children: [
              Child(name: "keyword", type: "ExtensionKeyword", kind: .required),
              Child(name: "keywordLineBreak", type: "LineBreakSyntax", kind: .fixed),
              Child(name: "ability", type: "AbilitySignature", kind: .required),
              Child(name: "abilityLineBreak", type: "LineBreakSyntax", kind: .fixed),
              Child(name: "provisions", type: "Provisions", kind: .required),
            ])
          ),

          Node(
            name: "Declaration",
            kind: .alternates([
              Alternate(name: "language", type: "LanguageDeclaration"),
              Alternate(name: "thing", type: "ThingDeclaration"),
              Alternate(name: "enumeration", type: "EnumerationDeclaration"),
              Alternate(name: "action", type: "ActionDeclaration"),
              Alternate(name: "ability", type: "AbilityDeclaration"),
              Alternate(name: "use", type: "Use"),
              Alternate(name: "extensionSyntax", type: "ExtensionSyntax"),
            ])
          ),
        ],

        Node.separatedList(
          name: "DeclarationList",
          entryName: "declaration", entryNamePlural: "declarations",
          entryType: "Declaration",
          separatorName: "paragraphBreak",
          separatorType: "ParagraphBreakSyntax",
          fixedSeparator: true
        ),
      ] as [[Node]]
    ).joined()
  )

  static func separatedList(
    name: String,
    entryName: String,
    entryNamePlural: String,
    entryType: String,
    separatorName: String,
    separatorType: String,
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
