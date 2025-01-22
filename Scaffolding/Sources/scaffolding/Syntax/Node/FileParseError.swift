enum FileParseError<NodeParseError>: DiagnosticError
where NodeParseError: DiagnosticError {
  case brokenNode(NodeParseError)
  case extraneousText(Slice<UnicodeSegments>)

  var message: String {
    switch self {
    case .brokenNode(let error):
      return error.message
    case .extraneousText:
      return defaultMessage
    }
  }

  var range: Slice<UnicodeSegments> {
    switch self {
    case .brokenNode(let error):
      return error.range
    case .extraneousText(let location):
      return location
    }
  }
}
