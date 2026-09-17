public struct LineBreakSyntax {

  public init() {
  }

  public var children: [SyntaxNode] {
    return []
  }
}

extension LineBreakSyntax {
  public static var scalar: Unicode.Scalar {
    return "\u{2028}" as Unicode.Scalar
  }
}
