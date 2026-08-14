public struct LeftArrowSyntax {

  public init() {
  }

  public var type: SyntaxNodeType {
    return SyntaxNodeType.leftArrowSyntax(self)
  }
}

extension LeftArrowSyntax {
  public static var scalar: Unicode.Scalar {
    return "←" as Unicode.Scalar
  }
}
