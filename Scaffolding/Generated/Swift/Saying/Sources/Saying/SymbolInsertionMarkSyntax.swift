public struct SymbolInsertionMarkSyntax {

  public init() {
  }

  public var children: [SyntaxNode] {
    return []
  }
}

extension SymbolInsertionMarkSyntax {
  public static var scalar: Unicode.Scalar {
    return "¤" as Unicode.Scalar
  }
}
