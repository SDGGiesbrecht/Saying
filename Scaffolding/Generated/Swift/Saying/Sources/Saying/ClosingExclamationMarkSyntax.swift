public struct ClosingExclamationMarkSyntax {

  public init() {
  }

  public var children: [SyntaxNode] {
    return []
  }
}

extension ClosingExclamationMarkSyntax {
  public static var scalar: Unicode.Scalar {
    return "!" as Unicode.Scalar
  }
}
