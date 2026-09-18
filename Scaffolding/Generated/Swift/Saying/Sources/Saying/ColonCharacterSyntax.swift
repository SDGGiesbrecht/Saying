public struct ColonCharacterSyntax {

  public init() {
  }

  public var children: [SyntaxNode] {
    return []
  }
}

extension ColonCharacterSyntax {
  public static var scalar: Unicode.Scalar {
    return ":" as Unicode.Scalar
  }
}
