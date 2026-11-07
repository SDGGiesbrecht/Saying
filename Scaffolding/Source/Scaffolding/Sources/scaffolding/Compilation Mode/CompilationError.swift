import Saying

enum CompilationError: Error {
  case missingEntryPoints([UnicodeText])
}
