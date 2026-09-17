public struct ClosingParenthesisSyntax {

  public init() {
  }

  public var children: [SyntaxNode] {
    return []
  }
}

extension ClosingParenthesisSyntax {
  public static var scalar: Unicode.Scalar {
    return ")" as Unicode.Scalar
  }
}
