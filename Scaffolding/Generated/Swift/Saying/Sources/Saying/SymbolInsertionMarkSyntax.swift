public struct SymbolInsertionMarkSyntax {

  public init() {
  }

  public var type: SyntaxNodeType {
    return SyntaxNodeType.symbolInsertionMarkSyntax(self)
  }
}

extension SymbolInsertionMarkSyntax {
  public static var scalar: Unicode.Scalar {
    return "¤" as Unicode.Scalar
  }
}
