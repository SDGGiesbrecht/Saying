public struct GreekQuestionMarkSyntax {

  public init() {
  }

  public var type: SyntaxNodeType {
    return SyntaxNodeType.greekQuestionMarkSyntax(self)
  }
}

extension GreekQuestionMarkSyntax {
  public static var scalar: Unicode.Scalar {
    return ";" as Unicode.Scalar
  }
}
