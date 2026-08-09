public struct LineBreakSyntax {

  public init() {
  }
}

extension LineBreakSyntax {
  public static var scalar: Unicode.Scalar {
    return "\u{2028}" as Unicode.Scalar
  }
}
