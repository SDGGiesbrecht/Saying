public struct OpeningBraceSyntax {

  public init() {
  }

  public var children: [SyntaxNode] {
    return []
  }
}

extension OpeningBraceSyntax {
  public static var scalar: Unicode.Scalar {
    return "{" as Unicode.Scalar
  }
}
