public struct LineBreakSyntax {

  public init() {
  }

  public var type: SyntaxNodeType {
    return SyntaxNodeType.lineBreakSyntax(self)
  }
}

extension LineBreakSyntax {
  public static var scalar: Unicode.Scalar {
    return "\u{2028}" as Unicode.Scalar
  }
}
