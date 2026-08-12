public struct RightChevronQuotationMarkSyntax {

  public init() {
  }

  public var type: SyntaxNodeType {
    return SyntaxNodeType.rightChevronQuotationMarkSyntax(self)
  }
}

extension RightChevronQuotationMarkSyntax {
  public static var scalar: Unicode.Scalar {
    return "»" as Unicode.Scalar
  }
}
