public struct LowQuotationMarkSyntax {

  public init() {
  }

  public var children: [SyntaxNode] {
    return []
  }
}

extension LowQuotationMarkSyntax {
  public static var scalar: Unicode.Scalar {
    return "„" as Unicode.Scalar
  }
}
