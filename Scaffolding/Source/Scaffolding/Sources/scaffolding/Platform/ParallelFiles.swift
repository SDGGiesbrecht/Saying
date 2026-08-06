struct ParallelFiles {
  private var files: [String: [String]] = [:]
  let fileNameLengthLimit: Int?

  var fileSettings: String? = nil
  var imports: [String] = []

  init(fileNameLengthLimit: Int?) {
    let universalFileNameLengthLimit = 128 // 256 tripped limits cross‐compiling from Linux in Windows CI.
    var limit = universalFileNameLengthLimit
    if let fileNameLengthLimit = fileNameLengthLimit {
      limit = min(limit, fileNameLengthLimit)
    }
    self.fileNameLengthLimit = limit
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
    return files.mapValues { body in
      var file: [String] = []

      if let settings = fileSettings {
        file.appendSeparatorLine()
        file.append(settings)
      }

      if !imports.isEmpty {
        file.appendSeparatorLine()
        file.append(contentsOf: imports)
      }

      file.append(contentsOf: body)

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
