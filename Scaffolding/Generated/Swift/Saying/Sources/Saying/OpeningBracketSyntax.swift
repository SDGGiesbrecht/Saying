public struct OpeningBracketSyntax {

  public init() {
  }

  public var children: [SyntaxNode] {
    return []
  }
}

extension OpeningBracketSyntax {
  public static var scalar: Unicode.Scalar {
    return "[" as Unicode.Scalar
  }
}
