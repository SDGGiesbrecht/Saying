public struct OpeningExclamationMarkSyntax {

  public init() {
  }

  public var children: [SyntaxNode] {
    return []
  }
}

extension OpeningExclamationMarkSyntax {
  public static var scalar: Unicode.Scalar {
    return "¡" as Unicode.Scalar
  }
}
