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
      let source = String.UnicodeScalarView(unicode)
      return "\(range.legibleStartLocation()): \(message) “\(source)”"
    }
  }
}
