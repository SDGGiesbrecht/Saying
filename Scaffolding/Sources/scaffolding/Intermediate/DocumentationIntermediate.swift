import SDGLogic
import SDGText

struct DocumentationIntermediate {
  var parameters: [ParsedParameterDocumentation]
  var tests: [TestIntermediate]
  var declaration: ParsedDocumentation?
}

extension DocumentationIntermediate {

  static func construct(
    _ declaration: ParsedDocumentation,
    namespace: [Set<StrictString>]
  ) -> DocumentationIntermediate {

    var parameters: [ParsedParameterDocumentation] = []
    var testIndex = 1
    var tests: [TestIntermediate] = []
    for entry in declaration.entries.entries {
      switch entry {
      case .parameter(let parameter):
        parameters.append(parameter)
      case .test(let test):
        tests.append(TestIntermediate(test, location: namespace, index: testIndex))
        testIndex += 1
      case .paragraph:
        break
      }
    }

    return DocumentationIntermediate(
      parameters: parameters,
      tests: tests,
      declaration: declaration
    )
  }
}
