public struct SayingSourceSlice {
  public let origin: UnicodeText
  public let code: SayingSourceCodeSlice

  init(_ origin: UnicodeText, _ code: SayingSourceCodeSlice) {
    self.origin = origin
    self.code = code
  }
}
