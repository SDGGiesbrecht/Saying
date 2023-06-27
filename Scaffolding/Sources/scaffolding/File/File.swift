import Foundation

struct File {

  init(from url: URL) throws {
    self.url = url
    let encoding = url.deletingPathExtension()
    // Only UTF‐8 supported at the moment.
    let style = encoding.deletingPathExtension()
    switch style.pathExtension {
    case "git":
      contents = .utf8(try UTF8File(gitStyle: GitStyleFile(from: url)).source)
    default:
      contents = .utf8(try UTF8File(from: url).source)
    }
  }

  let url: URL
  let contents: Source
}
