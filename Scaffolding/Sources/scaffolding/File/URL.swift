import Foundation

extension URL {

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
}
