extension ParsedNativeImportContents {

  var imports: [ParsedLiteral] {
    switch self {
    case .list(let list):
      return list.imports.imports
    case .single(let single):
      return [single]
    }
  }
}
