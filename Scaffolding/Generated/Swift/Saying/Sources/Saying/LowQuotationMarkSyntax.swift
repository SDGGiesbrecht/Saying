public struct LowQuotationMarkSyntax {

  public init() {
  }
}

extension LowQuotationMarkSyntax {
  public static var scalar: Unicode.Scalar {
    return "„" as Unicode.Scalar
  }
}
