public struct SayingSource {
  public let origin: UnicodeText
  public let code: SayingSourceCode

  public init(origin: UnicodeText, code: SayingSourceCode) {
    self.origin = origin
    self.code = code
  }
}
