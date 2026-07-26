import Foundation

func run(
  command: [String],
  in workingDirectory: URL? = nil,
  reportProgress: (_ line: String) -> Void = { _ in }
) throws {
  let commandString = command.map({ (argument: String) -> String in
    if argument.contains(" ") {
      return "\u{27}\(argument)\u{27}"
    } else {
      return argument
    }
  }).joined(separator: " ")
  reportProgress("% " + commandString)

  let process = Process()
  process.executableURL = URL(fileURLWithPath: "/bin/sh")
  process.arguments = ["\u{2D}c", commandString]
  if workingDirectory != nil {
    process.currentDirectoryURL = workingDirectory
  }
  let pipe = Pipe()
  process.standardOutput = pipe
  process.standardError = pipe

  try process.run()

  var stream = Data()
  let newLineData = "\n".data(using: String.Encoding.utf8)!
  func read() -> Data? {
    let new = pipe.fileHandleForReading.availableData
    return new.isEmpty ? nil : new
  }
  while let newData = read() {
    stream.append(newData)
    while let lineEnd = stream.range(of: newLineData) {
      let lineData = stream[..<lineEnd.lowerBound]
      stream.removeSubrange(..<lineEnd.upperBound)
      let line = String(data: lineData, encoding: .utf8)
        ?? String(data: lineData, encoding: .isoLatin1)!
      reportProgress(line)
    }
  }
  while process.isRunning {}

  let exitCode = process.terminationStatus
  if exitCode == 0 {
    return
  } else {
    throw ProcessError(exitCode: exitCode)
  }
}

struct ProcessError: Error {
  let exitCode: Int32
}
