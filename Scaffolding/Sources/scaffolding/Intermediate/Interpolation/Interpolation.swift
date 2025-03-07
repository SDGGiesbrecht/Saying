import SDGText

struct Interpolation<InterpolationParameter>
where InterpolationParameter: InterpolationParameterProtocol {
  private var parameters: [InterpolationParameter]
  private var reorderings: [StrictString: [Int]]
}

extension Interpolation {

  static var none: Interpolation {
    return Interpolation(parameters: [], reorderings: [:])
  }

  static func construct<Entries, ParameterNode, ParameterDefinition>(
    entries: Entries,
    getEntryName: (Entries.Element) -> UnicodeText,
    getParameters: (Entries.Element) -> [ParameterNode],
    getParameterName: (ParameterNode) -> UnicodeText,
    getDefinitionOrReference: (ParameterNode) -> DefinitionOrReference<ParameterDefinition>,
    getNestedSignature: (ParameterNode) -> ParsedSignature?,
    getNestedParameters: (ParsedSignature) -> [ParameterNode],
    constructParameter: (
      _ names: Set<StrictString>,
      _ nestedParameters: Interpolation?,
      _ definition: ParameterDefinition
    ) -> InterpolationParameter
  ) -> Result<Interpolation, ErrorList<ConstructionError>>
  where Entries: Collection, Entries.Element: ParsedSyntaxNode, ParameterNode: ParsedSyntaxNode {
    var errors: [ConstructionError] = []
    var parameterIndices: [StrictString: Int] = [:]
    var parameterReferences: [StrictString: UnicodeText] = [:]
    var foundDefinitionEntry = false
    for entry in entries {
      var isDefinitionEntry: Bool?
      let parameters = getParameters(entry)
      if parameters.isEmpty {
        foundDefinitionEntry = true
      }
      for (index, parameter) in parameters.enumerated() {
        let parameterName = StrictString(getParameterName(parameter))
        switch getDefinitionOrReference(parameter) {
        case .definition:
          if index == 0,
            foundDefinitionEntry {
            errors.append(.multipleParameterDefinitionSets(entry))
          }
          if isDefinitionEntry == false {
            errors.append(.definitionInReferenceSet(parameter))
          }
          isDefinitionEntry = true
          foundDefinitionEntry = true
          parameterIndices[parameterName] = index
        case .reference(let reference):
          if isDefinitionEntry == true {
            errors.append(.referenceInDefinitionSet(parameter))
          }
          isDefinitionEntry = false
          parameterReferences[parameterName] = reference.name.name()
        }
      }
    }
    var parameterDefinitions: [ParameterDefinition] = []
    var reorderings: [StrictString: [Int]] = [:]
    var nestedSignatures: [Int: [ParsedSignature]] = [:]
    var completeParameterIndexTable: [StrictString: Int] = parameterIndices
    for entry in entries {
      var reordering: [Int] = []
      let entryName = StrictString(getEntryName(entry))
      for (position, parameter) in getParameters(entry).enumerated() {
        let nestedSignature = getNestedSignature(parameter)
        switch getDefinitionOrReference(parameter) {
        case .definition(let definition):
          parameterDefinitions.append(definition)
          reordering.append(position)
          if let nested = nestedSignature {
            nestedSignatures[position, default: []].append(nested)
          }
        case .reference(let reference):
          var resolving = StrictString(reference.name.name())
          var checked: Set<StrictString> = []
          while let next = parameterReferences[resolving].map({ StrictString($0) }) {
            checked.insert(resolving)
            resolving = next
            if checked.contains(next) {
              if parameterIndices[resolving] == nil {
                errors.append(.cyclicalParameterReference(parameter))
              }
              break
            }
          }
          if let index = parameterIndices[resolving] {
            reordering.append(index)
            completeParameterIndexTable[StrictString(getParameterName(parameter))] = index
            if let nested = nestedSignature {
              nestedSignatures[index, default: []].append(nested)
            }
          } else {
            errors.append(.parameterNotFound(reference))
          }
        }
      }
      let existingReordering = reorderings[entryName]
      if existingReordering == nil
        || existingReordering == reordering {
        reorderings[entryName] = reordering
      } else {
        errors.append(.rearrangedParameters(entry))
      }
    }
    let parameters = parameterDefinitions.enumerated().map { index, definition in
      let names = Set(
        completeParameterIndexTable.keys
          .lazy.filter({ name in
            return completeParameterIndexTable[name] == index
          })
      )
      var nestedParemeters: Interpolation?
      if let nested = nestedSignatures[index] {
        switch Interpolation.construct(
          entries: nested,
          getEntryName: { $0.name() },
          getParameters: getNestedParameters,
          getParameterName: getParameterName,
          getDefinitionOrReference: getDefinitionOrReference,
          getNestedSignature: getNestedSignature,
          getNestedParameters: getNestedParameters,
          constructParameter: constructParameter
        ) {
        case .failure(let error):
          errors.append(contentsOf: error.errors)
        case .success(let constructed):
          nestedParemeters = constructed
        }
      }
      return constructParameter(names, nestedParemeters, definition)
    }
    if !errors.isEmpty {
      return .failure(ErrorList(errors))
    }
    return .success(Interpolation(parameters: parameters, reorderings: reorderings))
  }
}

extension Interpolation where InterpolationParameter == ParameterIntermediate {
  mutating func apply(swiftLabels: [UnicodeText?], accordingTo name: UnicodeText) {
    let indices = reorderings[StrictString(name)]!
    for (index, label) in zip(indices, swiftLabels) {
      parameters[index].swiftLabel = label
    }
  }
}

extension Interpolation where InterpolationParameter == ParameterIntermediate {
  func merging(
    requirement: Interpolation,
    provisionDeclarationName: ParsedActionName
  ) -> Result<Interpolation, ErrorList<ReferenceError>> {
    var errors: [ReferenceError] = []
    let correlatedName = self.reorderings.keys.first(where: { requirement.reorderings[$0] != nil })!
    let nameToRequirement = requirement.reorderings[correlatedName]!
    let nameToSelf = self.reorderings[correlatedName]!
    let mergedParameters = self.parameters.indices.map { index in
      let nameIndex = nameToSelf.firstIndex(of: index)!
      let requirementIndex = nameToRequirement[nameIndex]
      return self.parameters[index]
        .merging(requirement: requirement.parameters[requirementIndex])
    }
    var mergedReorderings = self.reorderings
    for (name, reordering) in requirement.reorderings {
      let rearranged = reordering.map { requirementIndex in
        let correlatedNameIndex = nameToRequirement.firstIndex(of: requirementIndex)!
        let ownIndex = nameToSelf[correlatedNameIndex]
        return ownIndex
      }
      if let existing = mergedReorderings[name] {
        if existing != rearranged {
          errors.append(.mismatchedParameters(name: UnicodeText(name), declaration: provisionDeclarationName))
        }
      } else {
        mergedReorderings[name] = rearranged
      }
    }
    if !errors.isEmpty {
      return .failure(ErrorList(errors))
    }
    return .success(
      Interpolation(
        parameters: mergedParameters,
        reorderings: mergedReorderings
      )
    )
  }
}
extension Interpolation {
  func mappingParameters(_ transform: (InterpolationParameter) -> InterpolationParameter) -> Interpolation {
    var copy = self
    copy.parameters = copy.parameters.map(transform)
    return copy
  }
}

extension Interpolation {
  func parameter(named identifier: UnicodeText) -> InterpolationParameter? {
    return parameters.first(where: { $0.names.contains(StrictString(identifier)) })
  }

  func ordered(for name: UnicodeText) -> [InterpolationParameter] {
    guard let reordering = reorderings[StrictString(name)] else {
      return []
    }
    return reordering.map({ parameters[$0] })
  }
  func reordering(from origin: UnicodeText, to destination: UnicodeText) -> [Int] {
    if parameters.isEmpty {
      return []
    }
    let baseToOrigin = reorderings[StrictString(origin)]!
    let originToBase: [Int] = baseToOrigin.indices.map({ baseToOrigin.firstIndex(of: $0)! })
    let baseToDestination = reorderings[StrictString(destination)]!
    return baseToDestination.map({ originToBase[$0] })
  }
}
func order<Element>(_ parameters: [Element], for reordering: [Int]) -> [Element] {
  return reordering.map({ parameters[$0] })
}

extension Interpolation {
  var inAnyOrder: [InterpolationParameter] {
    return parameters
  }
}

extension Interpolation where InterpolationParameter == ParameterIntermediate {
  func removingOtherNamesAnd(
    replacing originalName: UnicodeText,
    with newName: UnicodeText
  ) -> Interpolation {
    return Interpolation(
      parameters: parameters,
      reorderings: reorderings == [:]
        ? [:]
        : [StrictString(newName): reorderings[StrictString(originalName)]!]
    )
  }
  func prefixingEach(
    with prefix: UnicodeText
  ) -> Interpolation {
    return Interpolation(
      parameters: parameters.map({ $0.prefixing(with: prefix) }),
      reorderings: reorderings
    )
  }
}

extension Interpolation where InterpolationParameter == ParameterIntermediate {
  static func accessor(
    containerType: ParsedTypeReference,
    partIdentifier: UnicodeText
  ) -> Interpolation {
    return Interpolation(
      parameters: [
        .nativeParameterStub(names: ["part"], type: .partReference(container: containerType, identifier: partIdentifier)),
        .nativeParameterStub(names: ["container"], type: containerType),
      ],
      reorderings: [
        "() of ()": [0, 1],
        "() von ()": [0, 1],
        "() de ()": [0, 1],
        "() של ()": [0, 1],
      ]
    )
  }

  static func enumerationWrap(
    enumerationType: ParsedTypeReference,
    caseIdentifier: UnicodeText,
    valueType: ParsedTypeReference
  ) -> Interpolation {
    return Interpolation(
      parameters: [
        .nativeParameterStub(names: ["value"], type: valueType),
        .nativeParameterStub(names: ["case"], type: .enumerationCase(enumeration: enumerationType, identifier: caseIdentifier)),
      ],
      reorderings: [
        "wrap () as ()": [0, 1]
      ]
    )
  }
  static func enumerationUnwrap(
    enumerationType: ParsedTypeReference,
    caseIdentifier: UnicodeText,
    valueType: ParsedTypeReference
  ) -> Interpolation {
    return Interpolation(
      parameters: [
        .nativeParameterStub(names: ["enumeration"], type: enumerationType),
        .nativeParameterStub(names: ["case"], type: .enumerationCase(enumeration: enumerationType, identifier: caseIdentifier)),
        .nativeParameterStub(names: ["value"], type: valueType),
        .nativeParameterStub(names: ["consequence"], type: .statements),
      ],
      reorderings: [
        "if () is (), unwrap it as (), ()": [0, 1, 2, 3]
      ]
    )
  }
  static func enumerationCheck(
    enumerationType: ParsedTypeReference,
    caseIdentifier: UnicodeText,
    empty: Bool
  ) -> Interpolation {
    return Interpolation(
      parameters: [
        .nativeParameterStub(names: ["enumeration"], type: enumerationType),
        .nativeParameterStub(names: ["case"], type: empty ? enumerationType : .enumerationCase(enumeration: enumerationType, identifier: caseIdentifier)),
      ],
      reorderings: [
        "() is case ()": [0, 1]
      ]
    )
  }
  func names() -> Set<StrictString> {
    return Set(reorderings.keys)
  }
}
