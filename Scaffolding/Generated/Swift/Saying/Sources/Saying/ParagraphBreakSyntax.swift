public struct ParagraphBreakSyntax {

  public init() {
  }

  public var children: [SyntaxNodeType] {
    return []
  }

  public var type: SyntaxNodeType {
    return SyntaxNodeType.paragraphBreakSyntax(self)
  }
}

extension ParagraphBreakSyntax {
  public static var scalar: Unicode.Scalar {
    return "\u{2029}" as Unicode.Scalar
  }
}
