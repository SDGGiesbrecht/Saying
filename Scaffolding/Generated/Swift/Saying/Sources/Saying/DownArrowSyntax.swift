public struct DownArrowSyntax {

  public init() {
  }

  public var type: SyntaxNodeType {
    return SyntaxNodeType.downArrowSyntax(self)
  }
}

extension DownArrowSyntax {
  public static var scalar: Unicode.Scalar {
    return "↓" as Unicode.Scalar
  }
}
