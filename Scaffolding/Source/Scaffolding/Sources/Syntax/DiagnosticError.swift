import Saying

public protocol DiagnosticError: Error {
  var range: SayingSourceSlice { get }
  var message: String { get }
}

extension DiagnosticError {
  
  public var defaultMessage: String {
    var result = "\(self)"
    if let parenthesis = result.firstIndex(of: "(") {
      result.removeSubrange(parenthesis...)
    }
    return result
  }
}
