public struct GreekQuestionMarkSyntax {

  public init() {
  }
}

extension GreekQuestionMarkSyntax {
  public static var scalar: Unicode.Scalar {
    return ";" as Unicode.Scalar
  }
}
