import Saying
import Syntax

extension IdentifierSegment {

  func identifierText() -> UnicodeText {
    return source()
  }
}
