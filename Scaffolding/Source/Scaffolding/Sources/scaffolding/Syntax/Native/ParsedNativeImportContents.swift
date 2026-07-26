extension ParsedNativeImportContents {

  var imports: [ParsedImportSyntax] {
    switch self {
    case .list(let list):
      return list.imports.imports
    case .single(let single):
      return [single]
    }
  }
}
