import Saying
import Syntax

extension ParsedIdentifierSegment {

  func identifierText() -> UnicodeText {
    return source()
  }
}
