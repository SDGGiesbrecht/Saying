public struct ClosingBracketSyntax {

  public init() {
  }

  public var type: SyntaxNodeType {
    return SyntaxNodeType.closingBracketSyntax(self)
  }
}

extension ClosingBracketSyntax {
  public static var scalar: Unicode.Scalar {
    return "]" as Unicode.Scalar
  }
}
