public struct LeftArrowSyntax {

  public init() {
  }

  public var children: [SyntaxNode] {
    return []
  }
}

extension LeftArrowSyntax {
  public static var scalar: Unicode.Scalar {
    return "←" as Unicode.Scalar
  }
}
