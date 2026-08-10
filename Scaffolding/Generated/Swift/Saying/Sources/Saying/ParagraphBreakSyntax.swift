public struct ParagraphBreakSyntax {

  public init() {
  }
}

extension ParagraphBreakSyntax {
  public static var scalar: Unicode.Scalar {
    return "\u{2029}" as Unicode.Scalar
  }
}
