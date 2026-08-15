public struct OpeningQuestionMarkSyntax {

  public init() {
  }

  public var children: [SyntaxNodeType] {
    return []
  }

  public var type: SyntaxNodeType {
    return SyntaxNodeType.openingQuestionMarkSyntax(self)
  }
}

extension OpeningQuestionMarkSyntax {
  public static var scalar: Unicode.Scalar {
    return "¿" as Unicode.Scalar
  }
}
