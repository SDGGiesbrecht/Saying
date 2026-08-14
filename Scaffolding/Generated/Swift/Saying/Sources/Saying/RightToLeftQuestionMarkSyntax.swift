public struct RightToLeftQuestionMarkSyntax {

  public init() {
  }

  public var children: [SyntaxNodeType] {
    return []
  }

  public var type: SyntaxNodeType {
    return SyntaxNodeType.rightToLeftQuestionMarkSyntax(self)
  }
}

extension RightToLeftQuestionMarkSyntax {
  public static var scalar: Unicode.Scalar {
    return "؟" as Unicode.Scalar
  }
}
