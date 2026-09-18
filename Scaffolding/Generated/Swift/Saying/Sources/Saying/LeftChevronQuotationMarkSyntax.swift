public struct LeftChevronQuotationMarkSyntax {

  public init() {
  }

  public var children: [SyntaxNode] {
    return []
  }
}

extension LeftChevronQuotationMarkSyntax {
  public static var scalar: Unicode.Scalar {
    return "«" as Unicode.Scalar
  }
}
