public struct RightChevronQuotationMarkSyntax {

  public init() {
  }

  public var children: [SyntaxNodeType] {
    return []
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
