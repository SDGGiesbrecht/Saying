enum FileParseError<NodeParseError>: DiagnosticError
where NodeParseError: DiagnosticError {
  case brokenNode(NodeParseError)
  case extraneousText(SayingSourceSlice)

  var message: String {
    switch self {
    case .brokenNode(let error):
      return error.message
    case .extraneousText:
      return defaultMessage
    }
  }

  var range: SayingSourceSlice {
    switch self {
    case .brokenNode(let error):
      return error.range
    case .extraneousText(let location):
      return location
    }
  }
}
