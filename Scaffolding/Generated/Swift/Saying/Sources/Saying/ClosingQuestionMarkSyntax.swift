public struct ClosingQuestionMarkSyntax {

  public init() {
  }

  public var children: [SyntaxNodeType] {
    return []
  }

  public var type: SyntaxNodeType {
    return SyntaxNodeType.closingQuestionMarkSyntax(self)
  }
}

extension ClosingQuestionMarkSyntax {
  public static var scalar: Unicode.Scalar {
    return "?" as Unicode.Scalar
  }
}
