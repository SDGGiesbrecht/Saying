public struct LeftChevronQuotationMarkSyntax {

  public init() {
  }

  public var children: [SyntaxNodeType] {
    return []
  }

  public var type: SyntaxNodeType {
    return SyntaxNodeType.leftChevronQuotationMarkSyntax(self)
  }
}

extension LeftChevronQuotationMarkSyntax {
  public static var scalar: Unicode.Scalar {
    return "«" as Unicode.Scalar
  }
}
