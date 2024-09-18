import SDGText

enum FileParseError<NodeParseError>: Error
where NodeParseError: Error {
  case brokenNode(NodeParseError)
  case extraneousText(Slice<UTF8Segments>)
}
