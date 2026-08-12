public struct ClosingExclamationMarkSyntax {

  public init() {
  }

  public var type: SyntaxNodeType {
    return SyntaxNodeType.closingExclamationMarkSyntax(self)
  }
}

extension ClosingExclamationMarkSyntax {
  public static var scalar: Unicode.Scalar {
    return "!" as Unicode.Scalar
  }
}
