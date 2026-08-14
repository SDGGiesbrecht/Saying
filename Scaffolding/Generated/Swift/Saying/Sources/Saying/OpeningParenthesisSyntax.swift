public struct OpeningParenthesisSyntax {

  public init() {
  }

  public var children: [SyntaxNodeType] {
    return []
  }

  public var type: SyntaxNodeType {
    return SyntaxNodeType.openingParenthesisSyntax(self)
  }
}

extension OpeningParenthesisSyntax {
  public static var scalar: Unicode.Scalar {
    return "(" as Unicode.Scalar
  }
}
