public struct OpeningParenthesisSyntax {

  public init() {
  }
}

extension OpeningParenthesisSyntax {
  public static var scalar: Unicode.Scalar {
    return "(" as Unicode.Scalar
  }
}
