import SDGLogic
import SDGText

struct DocumentationIntermediate {
  var parameters: [[ParsedParameterDocumentation]]
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
      parameters: [parameters],
      tests: tests,
      declaration: declaration
    )
  }
}

extension DocumentationIntermediate {
  func specializing(
    typeLookup: [StrictString: SimpleTypeReference],
    canonicallyOrderedUseArguments: [Set<StrictString>]
  ) -> DocumentationIntermediate {
    return DocumentationIntermediate(
      parameters: parameters,
      tests: tests.map({ test in
        return test.specializing(
          typeLookup: typeLookup,
          canonicallyOrderedUseArguments: canonicallyOrderedUseArguments
        )
      })
    )
  }
}
extension Optional where Wrapped == DocumentationIntermediate {

  func merging(
    inherited: DocumentationIntermediate?,
    typeLookup: [StrictString: SimpleTypeReference],
    canonicallyOrderedUseArguments: [Set<StrictString>]
  ) -> DocumentationIntermediate? {
    guard let base = inherited?.specializing(
      typeLookup: typeLookup,
      canonicallyOrderedUseArguments: canonicallyOrderedUseArguments
    ) else {
      return self
    }
    guard let child = self else {
      return base
    }
    return DocumentationIntermediate(
      parameters: base.parameters.appending(contentsOf: child.parameters),
      tests: base.tests.appending(contentsOf: child.tests),
      declaration: nil
    )
  }
}
