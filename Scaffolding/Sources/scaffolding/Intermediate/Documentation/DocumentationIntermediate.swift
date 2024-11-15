import SDGLogic
import SDGText

struct DocumentationIntermediate {
  var paragraphs: [ParsedParagraph]
  var parameters: [[ParsedParameterDocumentation]]
  var tests: [TestIntermediate]
  var declaration: ParsedDocumentation?
}

extension DocumentationIntermediate {

  static func construct(
    _ declaration: ParsedDocumentation,
    namespace: [Set<StrictString>]
  ) -> DocumentationIntermediate {

    var paragraphs: [ParsedParagraph] = []
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
      case .paragraph(let paragraph):
        paragraphs.append(paragraph)
      }
    }

    return DocumentationIntermediate(
      paragraphs: paragraphs,
      parameters: [parameters],
      tests: tests,
      declaration: declaration
    )
  }
}

extension DocumentationIntermediate {
  func resolvingExtensionContext(
    typeLookup: [StrictString: StrictString]
  ) -> DocumentationIntermediate {
    return DocumentationIntermediate(
      paragraphs: paragraphs,
      parameters: parameters,
      tests: tests.map({ test in
        return test.resolvingExtensionContext(typeLookup: typeLookup)
      })
    )
  }
  func specializing(
    typeLookup: [StrictString: SimpleTypeReference],
    specializationNamespace: [Set<StrictString>]
  ) -> DocumentationIntermediate {
    return DocumentationIntermediate(
      paragraphs: paragraphs,
      parameters: parameters,
      tests: tests.map({ test in
        return test.specializing(
          typeLookup: typeLookup,
          specializationNamespace: specializationNamespace
        )
      })
    )
  }
}
extension Optional where Wrapped == DocumentationIntermediate {

  func merging(
    inherited: DocumentationIntermediate?,
    typeLookup: [StrictString: SimpleTypeReference],
    specializationNamespace: [Set<StrictString>]
  ) -> DocumentationIntermediate? {
    guard let base = inherited?.specializing(
      typeLookup: typeLookup,
      specializationNamespace: specializationNamespace
    ) else {
      return self
    }
    guard let child = self else {
      return base
    }
    return DocumentationIntermediate(
      paragraphs: base.paragraphs.appending(contentsOf: child.paragraphs),
      parameters: base.parameters.appending(contentsOf: child.parameters),
      tests: base.tests.appending(contentsOf: child.tests),
      declaration: nil
    )
  }
}

extension DocumentationIntermediate {
  func validateReferences(referenceLookup: [ReferenceDictionary], errors: inout [ReferenceError]) {
    var paragraphs: [ParsedParagraph] = []
    for paragraph in self.paragraphs {
      paragraphs.append(paragraph)
    }
    for parameter in parameters.lazy.flatMap({ $0 }) {
      paragraphs.append(parameter.details.paragraph)
    }
    for paragraph in paragraphs {
      for languageEntry in paragraph.paragraphs.text {
        for span in languageEntry.text.spans {
          for segment in [span.first].appending(contentsOf: span.continuations) {
            switch segment {
            case .identifierCharacters, .openingParenthesis, .closingParenthesis:
              break
            case .reference(let reference):
              let identifier = reference.identifier
              if referenceLookup.lookupAction(
                identifier.identifierText(),
                signature: [],
                specifiedReturnValue: .none) == nil {
                errors.append(.noSuchIdentifier(identifier))
              }
            }
          }
        }
      }
    }
  }
}
