import Saying

struct HashableSourceLocation: Hashable {
  let origin: UnicodeText
  let position: UnicodeSegments.Index
}
