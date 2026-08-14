public struct SpaceSyntax {

  public init() {
  }

  public var type: SyntaxNodeType {
    return SyntaxNodeType.spaceSyntax(self)
  }
}

extension SpaceSyntax {
  public static var scalar: Unicode.Scalar {
    return " " as Unicode.Scalar
  }
}
