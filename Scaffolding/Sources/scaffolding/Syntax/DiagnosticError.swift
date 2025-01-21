protocol DiagnosticError: Error {
  var range: Slice<UTF8Segments> { get }
  var message: String { get }
}

extension DiagnosticError {

  var message: String {
    return defaultMessage
  }

  var defaultMessage: String {
    let full = "\(self)"
    return full.prefix(upTo: "(").map({ String($0.contents) }) ?? full
  }

  var diagnostic: String {
    let preceding = String(String.UnicodeScalarView(range.base[..<range.startIndex]))
    let line = preceding.lines
      .lazy.map({ $0.newline.elementsEqual("\u{2029}".scalars) ? 2 : 1 })
      .reduce(0, +)
    let source = String.UnicodeScalarView(range)
    return "\(line): \(message) “\(source)”"
  }
}
