struct ImportIntermediate {
  var name: String
  var condition: String?
}

extension ImportIntermediate: Hashable {}

extension ImportIntermediate {

  static func construct(
    importNode: ParsedImportSyntax
  ) -> Result<ImportIntermediate, ErrorList<LiteralIntermediate.ConstructionError>> {
    let name: String
    switch LiteralIntermediate.construct(literal: importNode.importNode) {
    case .failure(let error):
      return .failure(error)
    case .success(let literal):
      name = literal.string
    }
    var condition: String?
    if let parsed = importNode.condition {
      switch LiteralIntermediate.construct(literal: parsed.condition) {
      case .failure(let error):
        return .failure(error)
      case .success(let literal):
        condition = literal.string
      }
    }
    return .success(ImportIntermediate(name: name, condition: condition))
  }
}

extension ImportIntermediate: Comparable {

  static func < (lhs: ImportIntermediate, rhs: ImportIntermediate) -> Bool {
    return (lhs.name, lhs.condition ?? "") < (rhs.name, rhs.condition ?? "")
  }
}
