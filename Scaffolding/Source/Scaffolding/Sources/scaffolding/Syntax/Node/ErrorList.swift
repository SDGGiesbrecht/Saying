import Syntax

extension ErrorList: CustomStringConvertible {
  public var description: String {
    var result = ["["]
    result.append(contentsOf: errors.map({ $0.diagnostic }))
    result.append("]")
    return result.joined(separator: "\n\n")
  }
}
