extension UInt64 {
  public static var arithmeticZero: UInt64 {
    return 0
  }
}

extension UInt64 {
  public static var one: UInt64 {
    return 1
  }
}

extension UInt64 {
  public mutating func incrementAccordingToDefaultUnlimitedIncrementation() {
    self += .one
  }
}

extension UInt64 {
  public mutating func increment() {
    self.incrementAccordingToDefaultUnlimitedIncrementation()
  }
}
