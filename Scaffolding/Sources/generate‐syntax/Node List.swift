extension Node {

  static let nodes: [Node] = [
    Node(name: "ParagraphBreak", kind: .fixedLeaf("\u{2029}"), graph: [.complete, .tokens]),
    Node(name: "LineBreak", kind: .fixedLeaf("\u{2028}"), graph: [.complete, .tokens]),
    Node(name: "OpeningParenthesis", kind: .fixedLeaf("("), graph: [.complete, .tokens]),
    Node(name: "ClosingParenthesis", kind: .fixedLeaf(")"), graph: [.complete, .tokens]),
    Node(name: "OpeningBracket", kind: .fixedLeaf("["), graph: [.complete, .tokens]),
    Node(name: "ClosingBracket", kind: .fixedLeaf("]"), graph: [.complete, .tokens]),
    Node(name: "OpeningQuotationMark", kind: .fixedLeaf("“"), graph: [.complete, .tokens]),
    Node(name: "ClosingQuotationMark", kind: .fixedLeaf("”"), graph: [.complete, .tokens]),
    Node(name: "Colon", kind: .fixedLeaf(":"), graph: [.complete, .tokens]),
    Node(name: "SymbolInsertionMark", kind: .fixedLeaf("¤"), graph: [.complete, .tokens]),
    Node(name: "Space", kind: .fixedLeaf(" "), graph: [.complete, .tokens]),
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
      }()),
      graph: [.complete, .tokens]
    ),
    Node(name: "ErrorToken", kind: .errorToken, graph: [.tokens]),

    Node(
      name: "SpacedColon",
      kind: .compound(children: [
        Child(name: "leadingSpace", type: "Space", kind: .optional),
        Child(name: "colon", type: "Colon", kind: .required),
        Child(name: "trailingSpace", type: "Space", kind: .required),
      ]),
      graph: [.complete]
    ),
  ]
}
