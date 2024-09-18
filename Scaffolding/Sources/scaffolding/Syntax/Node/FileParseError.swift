import SDGText

enum FileParseError<NodeParseError>: DiagnosticError
where NodeParseError: DiagnosticError {
  case brokenNode(NodeParseError)
  case extraneousText(Slice<UTF8Segments>)

  var range: Slice<UTF8Segments> {
    switch self {
    case .brokenNode(let error):
      return error.range
    case .extraneousText(let location):
      return location
    }
  }
}
