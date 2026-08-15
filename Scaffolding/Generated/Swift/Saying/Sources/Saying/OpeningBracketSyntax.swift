public struct OpeningBracketSyntax {

  public init() {
  }

  public var children: [SyntaxNodeType] {
    return []
  }

  public var type: SyntaxNodeType {
    return SyntaxNodeType.openingBracketSyntax(self)
  }
}

extension OpeningBracketSyntax {
  public static var scalar: Unicode.Scalar {
    return "[" as Unicode.Scalar
  }
}
