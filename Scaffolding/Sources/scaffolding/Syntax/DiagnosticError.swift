protocol DiagnosticError: Error {
  var range: SayingSourceSlice { get }
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
    switch range.code {
    case .utf8(let unicode):
      let preceding = String(String.UnicodeScalarView(unicode.base[..<unicode.startIndex]))
      let line = preceding.lines
        .lazy.map({ $0.newline.elementsEqual("\u{2029}".scalars) ? 2 : 1 })
        .reduce(0, +)
      let source = String.UnicodeScalarView(unicode)
      return "\(range.origin)\n\(line): \(message) “\(source)”"
    }
  }
}
