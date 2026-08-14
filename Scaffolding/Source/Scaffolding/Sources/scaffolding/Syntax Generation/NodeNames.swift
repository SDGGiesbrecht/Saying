import Saying

struct NodeNames {
  var identifier: UnicodeText
  var english: UnicodeText
  var deutscher: UnicodeText?
  var français: UnicodeText?
  var ελληνικό: UnicodeText?
  var swift: UnicodeText
}

extension NodeNames {
  var lowercasedSwift: UnicodeText {
    var result = swift
    let first = result.removeFirst()
    return "\(first.properties.lowercaseMapping)\(result)"
  }
}
