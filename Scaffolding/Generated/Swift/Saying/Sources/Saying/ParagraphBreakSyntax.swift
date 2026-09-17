public struct ParagraphBreakSyntax {

  public init() {
  }

  public var children: [SyntaxNode] {
    return []
  }
}

extension ParagraphBreakSyntax {
  public static var scalar: Unicode.Scalar {
    return "\u{2029}" as Unicode.Scalar
  }
}
