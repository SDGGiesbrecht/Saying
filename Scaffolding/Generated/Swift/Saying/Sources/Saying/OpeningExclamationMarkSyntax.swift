public struct OpeningExclamationMarkSyntax {

  public init() {
  }

  public var children: [SyntaxNodeType] {
    return []
  }

  public var type: SyntaxNodeType {
    return SyntaxNodeType.openingExclamationMarkSyntax(self)
  }
}

extension OpeningExclamationMarkSyntax {
  public static var scalar: Unicode.Scalar {
    return "¡" as Unicode.Scalar
  }
}
