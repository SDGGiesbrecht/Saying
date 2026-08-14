public struct LowQuotationMarkSyntax {

  public init() {
  }

  public var type: SyntaxNodeType {
    return SyntaxNodeType.lowQuotationMarkSyntax(self)
  }
}

extension LowQuotationMarkSyntax {
  public static var scalar: Unicode.Scalar {
    return "„" as Unicode.Scalar
  }
}
