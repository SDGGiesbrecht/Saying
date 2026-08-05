struct ParallelFiles {
  private var files: [String: [String]] = [:]
  let fileNameLengthLimit: Int?

  init(fileNameLengthLimit: Int?) {
    self.fileNameLengthLimit = fileNameLengthLimit
  }
}

extension ParallelFiles {

  private func trimIfNecessary(_ fileName: String) -> String {
    guard let limit = fileNameLengthLimit,
      limit < fileName.unicodeScalars.count else {
      return fileName
    }
    return String(fileName.unicodeScalars.prefix(limit)).appending("...")
  }

  subscript(name: String) -> [String] {
    get {
      return files[trimIfNecessary(name), default: []]
    }
    set {
      files[trimIfNecessary(name)] = newValue
    }
  }

  func completed() -> [String: String] {
    return files.mapValues { file in
      var joined = file.joined(separator: "\n").appending("\n")
      while joined.first == "\n" {
        joined.removeFirst()
      }
      while joined.hasSuffix("\n\n") {
        joined.removeLast()
      }
      return joined
    }
  }
}
