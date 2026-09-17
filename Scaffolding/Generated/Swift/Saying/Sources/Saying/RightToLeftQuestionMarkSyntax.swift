public struct RightToLeftQuestionMarkSyntax {

  public init() {
  }

  public var children: [SyntaxNode] {
    return []
  }
}

extension RightToLeftQuestionMarkSyntax {
  public static var scalar: Unicode.Scalar {
    return "؟" as Unicode.Scalar
  }
}
