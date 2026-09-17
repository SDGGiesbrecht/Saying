public struct RightChevronQuotationMarkSyntax {

  public init() {
  }

  public var children: [SyntaxNode] {
    return []
  }
}

extension RightChevronQuotationMarkSyntax {
  public static var scalar: Unicode.Scalar {
    return "»" as Unicode.Scalar
  }
}
