public struct ClosingQuestionMarkSyntax {

  public init() {
  }

  public var children: [SyntaxNode] {
    return []
  }
}

extension ClosingQuestionMarkSyntax {
  public static var scalar: Unicode.Scalar {
    return "?" as Unicode.Scalar
  }
}
