public struct RightArrowSyntax {

  public init() {
  }

  public var children: [SyntaxNodeType] {
    return []
  }

  public var type: SyntaxNodeType {
    return SyntaxNodeType.rightArrowSyntax(self)
  }
}

extension RightArrowSyntax {
  public static var scalar: Unicode.Scalar {
    return "→" as Unicode.Scalar
  }
}
