public struct RightArrowSyntax {

  public init() {
  }

  public var children: [SyntaxNode] {
    return []
  }
}

extension RightArrowSyntax {
  public static var scalar: Unicode.Scalar {
    return "→" as Unicode.Scalar
  }
}
