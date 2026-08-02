import Saying

protocol DiagnosticError: Error {
  var range: SayingSourceSlice { get }
  var message: String { get }
}

extension DiagnosticError {

  var message: String {
    return defaultMessage
  }

  var defaultMessage: String {
    var result = "\(self)"
    if let parenthesis = result.firstIndex(of: "(") {
      result.removeSubrange(parenthesis...)
    }
    return result
  }

  var diagnostic: String {
    switch range.code {
    case .writing:
      fatalError("Writing not implemented yet.")
    case .utf8(let unicode):
      let preceding = String(String.UnicodeScalarView(unicode.base[..<unicode.startIndex]))
      let line = preceding.unicodeScalars
        .lazy.map({ scalar in
          switch scalar {
          case "\u{2028}":
            return 1
          case "\u{2029}":
            return 2
          default:
            return 0
          }
        })
        .reduce(0, +)
      let source = String.UnicodeScalarView(unicode)
      return "\(range.origin)\n\(line): \(message) “\(source)”"
    }
  }
}
