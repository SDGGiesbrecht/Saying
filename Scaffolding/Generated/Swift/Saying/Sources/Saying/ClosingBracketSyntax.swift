public struct ClosingBracketSyntax {

  public init() {
  }

  public var children: [SyntaxNode] {
    return []
  }
}

extension ClosingBracketSyntax {
  public static var scalar: Unicode.Scalar {
    return "]" as Unicode.Scalar
  }
}
