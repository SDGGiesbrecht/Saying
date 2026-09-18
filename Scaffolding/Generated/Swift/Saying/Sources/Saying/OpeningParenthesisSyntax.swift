public struct OpeningParenthesisSyntax {

  public init() {
  }

  public var children: [SyntaxNode] {
    return []
  }
}

extension OpeningParenthesisSyntax {
  public static var scalar: Unicode.Scalar {
    return "(" as Unicode.Scalar
  }
}
