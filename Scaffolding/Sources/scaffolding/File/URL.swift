import Foundation

extension URL {

  var isSaying: Bool {
    return pathExtension == "saying"
  }

  var sourceFormat: SourceFormat {
    let encoding = deletingPathExtension()
    // Only UTF‐8 supported at the moment.
    let style = encoding.deletingPathExtension()
    switch style.pathExtension {
    case "git":
      return .utf8(gitStyle: true)
    default:
      return .utf8(gitStyle: false)
    }
  }

  func path(relativeTo other: URL) -> String {
    var ownPath = self.path
    let otherPath = other.path
    if !ownPath.starts(with: otherPath) {
      return ownPath
    }
    ownPath.removeFirst(otherPath.count)
    if ownPath.first == "/" {
      ownPath.removeFirst()
    }
    return ownPath
  }
}
