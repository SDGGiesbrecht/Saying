extension Array {

  func mapAll<T>(_ transform: (Self.Element) -> T?) -> [T]? {
    var result: [T] = []
    for element in self {
      if let transformed = transform(element) {
        result.append(transformed)
      } else {
        return nil
      }
    }
    return result
  }
}

extension Array where Element == String {
  mutating func appendSeparatorLine() {
    if !isEmpty,
      last != "" {
      append("")
    }
  }
}
