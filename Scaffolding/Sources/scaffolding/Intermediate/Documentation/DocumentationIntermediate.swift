struct DocumentationIntermediate {
  var paragraphs: [ParsedParagraph]
  var parameters: [[ParsedParameterDocumentation]]
  var tests: [TestIntermediate]
  var declaration: ParsedDocumentation?
}

extension DocumentationIntermediate {
  static func construct(
    _ declaration: ParsedDocumentation,
    namespace: [Set<UnicodeText>],
    inheritedVisibility: AccessIntermediate
  ) -> Result<DocumentationIntermediate, ErrorList<LiteralIntermediate.ConstructionError>> {
    var errors: [LiteralIntermediate.ConstructionError] = []
    var paragraphs: [ParsedParagraph] = []
    var parameters: [ParsedParameterDocumentation] = []
    var testIndex = 1
    var tests: [TestIntermediate] = []
    for entry in declaration.entries.entries {
      switch entry {
      case .parameter(let parameter):
        parameters.append(parameter)
      case .test(let test):
        switch TestIntermediate.construct(test, location: namespace, index: testIndex, inheritedVisibility: inheritedVisibility) {
        case .failure(let error):
          errors.append(contentsOf: error.errors)
        case .success(let constructed):
          tests.append(constructed)
        }
        testIndex += 1
      case .paragraph(let paragraph):
        paragraphs.append(paragraph)
      }
    }
    if !errors.isEmpty {
      return .failure(ErrorList(errors))
    }
    return .success(
      DocumentationIntermediate(
        paragraphs: paragraphs,
        parameters: [parameters],
        tests: tests,
        declaration: declaration
      )
    )
  }
}

extension DocumentationIntermediate {
  func resolvingExtensionContext(
    typeLookup: [UnicodeText: UnicodeText]
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
    typeLookup: [UnicodeText: ParsedTypeReference],
    specializationNamespace: [Set<UnicodeText>],
    specializationVisibility: AccessIntermediate
  ) -> DocumentationIntermediate {
    return DocumentationIntermediate(
      paragraphs: paragraphs,
      parameters: parameters,
      tests: tests.map({ test in
        return test.specializing(
          typeLookup: typeLookup,
          specializationNamespace: specializationNamespace,
          specializationVisibility: specializationVisibility
        )
      })
    )
  }
}
extension Optional where Wrapped == DocumentationIntermediate {

  func merging(
    inherited: DocumentationIntermediate?,
    typeLookup: [UnicodeText: ParsedTypeReference],
    specializationNamespace: [Set<UnicodeText>],
    specializationVisibility: AccessIntermediate
  ) -> DocumentationIntermediate? {
    guard let base = inherited?.specializing(
      typeLookup: typeLookup,
      specializationNamespace: specializationNamespace,
      specializationVisibility: specializationVisibility
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
  func validateReferences(inheritedVisibility: AccessIntermediate, referenceLookup: [ReferenceDictionary], errors: inout [ReferenceError]) {
    var paragraphs: [ParsedParagraph] = []
    for paragraph in self.paragraphs {
      paragraphs.append(paragraph)
    }
    for parameter in parameters.lazy.flatMap({ $0 }) {
      paragraphs.append(parameter.details.paragraph)
    }
    let testContext: TestContext? = TestContext(isHidden: false, inheritedVisibility: inheritedVisibility)
    for paragraph in paragraphs {
      for languageEntry in paragraph.paragraphs.text {
        for span in languageEntry.text.spans {
          for segment in [span.first].appending(contentsOf: span.continuations) {
            switch segment {
            case .identifierCharacters, .openingParenthesis, .closingParenthesis, .openingQuestionMark, .closingQuestionMark, .rightToLeftQuestionMark, .greekQuestionMark, .openingExclamationMark, .closingExclamationMark:
              break
            case .reference(let reference):
              let identifier = reference.identifier
              let identifierText = identifier.identifierText()

              var foundTarget: Bool = false
              var bestVisibility: AccessIntermediate = .nowhere
              var accessError: () -> ReferenceError = { fatalError() }
              for action in referenceLookup.lookupActions(
                identifierText,
                signature: [],
                specifiedReturnValue: .none,
                reportAllForErrorAnalysis: true
              ) {
                if action.access > bestVisibility {
                  foundTarget = true
                  bestVisibility = action.access
                  accessError = { .actionAccessNarrowerThanDocumentationVisibility(reference: identifier) }
                }
              }
              if case .simple(let simpleIdentifier) = identifier {
                if let thing = referenceLookup.lookupThing(identifierText, components: []) {
                  foundTarget = true
                  if thing.access > bestVisibility {
                    bestVisibility = thing.access
                    accessError = { .thingAccessNarrowerThanDocumentationVisibility(reference: simpleIdentifier) }
                  }
                }
              }
              if foundTarget {
                testContext.validateAccess(
                  to: bestVisibility,
                  testOnly: false,
                  errors: &errors,
                  unavailableOutsideTestsError: { fatalError() },
                  unavailableInVisibleTestsError: { accessError() }
                )
              } else {
                errors.append(.noSuchIdentifier(identifier))
              }
            }
          }
        }
      }
    }
  }
}
