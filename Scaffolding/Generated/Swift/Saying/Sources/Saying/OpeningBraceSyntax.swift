public struct OpeningBraceSyntax {

  public init() {
  }

  public var children: [SyntaxNodeType] {
    return []
  }

  public var type: SyntaxNodeType {
    return SyntaxNodeType.openingBraceSyntax(self)
  }
}

extension OpeningBraceSyntax {
  public static var scalar: Unicode.Scalar {
    return "{" as Unicode.Scalar
  }
}
