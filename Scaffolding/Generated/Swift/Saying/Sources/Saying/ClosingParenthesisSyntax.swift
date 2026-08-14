public struct ClosingParenthesisSyntax {

  public init() {
  }

  public var children: [SyntaxNodeType] {
    return []
  }

  public var type: SyntaxNodeType {
    return SyntaxNodeType.closingParenthesisSyntax(self)
  }
}

extension ClosingParenthesisSyntax {
  public static var scalar: Unicode.Scalar {
    return ")" as Unicode.Scalar
  }
}
