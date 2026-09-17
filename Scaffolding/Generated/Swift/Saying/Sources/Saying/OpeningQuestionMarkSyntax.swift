public struct OpeningQuestionMarkSyntax {

  public init() {
  }

  public var children: [SyntaxNode] {
    return []
  }
}

extension OpeningQuestionMarkSyntax {
  public static var scalar: Unicode.Scalar {
    return "¿" as Unicode.Scalar
  }
}
