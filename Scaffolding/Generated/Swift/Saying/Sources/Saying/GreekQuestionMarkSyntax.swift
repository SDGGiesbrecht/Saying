public struct GreekQuestionMarkSyntax {

  public init() {
  }

  public var children: [SyntaxNode] {
    return []
  }
}

extension GreekQuestionMarkSyntax {
  public static var scalar: Unicode.Scalar {
    return ";" as Unicode.Scalar
  }
}
