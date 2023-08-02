protocol StoredLocation: ParsedSyntaxNode {}

extension StoredLocation {
  var context: UTF8Segments {
    return location.base
  }
  var startIndex: UTF8Segments.Index {
    return location.startIndex
  }
  var endIndex: UTF8Segments.Index {
    return location.endIndex
  }
}
