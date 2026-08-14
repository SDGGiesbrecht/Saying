public struct ClosingBraceSyntax {

  public init() {
  }

  public var children: [SyntaxNodeType] {
    return []
  }

  public var type: SyntaxNodeType {
    return SyntaxNodeType.closingBraceSyntax(self)
  }
}

extension ClosingBraceSyntax {
  public static var scalar: Unicode.Scalar {
    return "}" as Unicode.Scalar
  }
}
