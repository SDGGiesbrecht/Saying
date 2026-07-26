import Foundation

extension FileManager {

  private static let unknownFileReadingError = NSError(
    domain: NSCocoaErrorDomain,
    code: NSFileReadUnknownError,
    userInfo: nil
  )

  func deepFileEnumeration(in directory: URL) throws -> [URL] {
    var failureReason: Error?
    guard let enumerator = FileManager.default.enumerator(
      at: directory,
      includingPropertiesForKeys: [.isDirectoryKey],
      options: [],
      errorHandler: { (_, error: Error) -> Bool in
        failureReason = error
        return false
      }
    ) else {
      throw FileManager.unknownFileReadingError
    }
    var result: [URL] = []
    for object in enumerator {
      guard let url = object as? URL else {
        throw FileManager.unknownFileReadingError
      }
      var objCBool: ObjCBool = false
      let isDirectory = FileManager.default.fileExists(atPath: url.path, isDirectory: &objCBool)
        && objCBool.boolValue
      if !isDirectory {
        result.append(url)
      }
    }
    if let error = failureReason {
      throw error
    }
    return result
  }
}
