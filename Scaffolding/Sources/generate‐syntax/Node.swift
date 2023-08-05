import SDGText

struct Node {

  static let nodes: [Node] = [
    Node(name: "ParagraphBreak"),
    Node(name: "LineBreak"),
    Node(name: "OpeningParenthesis"),
    Node(name: "ClosingParenthesis"),
    Node(name: "OpeningBracket"),
    Node(name: "ClosingBracket"),
    Node(name: "OpeningQuotationMark"),
    Node(name: "ClosingQuotationMark"),
    Node(name: "Colon"),
    Node(name: "SymbolInsertionMark"),
    Node(name: "Space"),
    Node(name: "IdentifierComponent"),
  ]

  let name: StrictString

  static func source() -> StrictString {
    return nodes.lazy.map({ $0.source() }).joined(separator: "\n\n")
  }
  func source() -> StrictString {
    return [
      "struct \(name) {}",
    ].joined(separator: "\n")
  }
}
