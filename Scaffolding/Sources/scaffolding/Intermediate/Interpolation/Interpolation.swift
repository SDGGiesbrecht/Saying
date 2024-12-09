import SDGLogic
import SDGCollections
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
    getEntryName: (Entries.Element) -> StrictString,
    getParameters: (Entries.Element) -> [ParameterNode],
    getParameterName: (ParameterNode) -> StrictString,
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
    var parameterReferences: [StrictString: StrictString] = [:]
    var foundDefinitionEntry = false
    for entry in entries {
      var isDefinitionEntry: Bool?
      let parameters = getParameters(entry)
      if parameters.isEmpty {
        foundDefinitionEntry = true
      }
      for (index, parameter) in parameters.enumerated() {
        let parameterName = getParameterName(parameter)
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
      let entryName = getEntryName(entry)
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
          var resolving = reference.name.name()
          var checked: Set<StrictString> = []
          while let next = parameterReferences[resolving] {
            checked.insert(resolving)
            resolving = next
            if next ∈ checked {
              if parameterIndices[resolving] == nil {
                errors.append(.cyclicalParameterReference(parameter))
              }
              break
            }
          }
          if let index = parameterIndices[resolving] {
            reordering.append(index)
            completeParameterIndexTable[getParameterName(parameter)] = index
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
        ∨ existingReordering == reordering {
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
    if ¬errors.isEmpty {
      return .failure(ErrorList(errors))
    }
    return .success(Interpolation(parameters: parameters, reorderings: reorderings))
  }
}

extension Interpolation where InterpolationParameter == ParameterIntermediate {
  func merging(
    requirement: Interpolation,
    provisionDeclarationName: ParsedActionName
  ) -> Result<Interpolation, ErrorList<ReferenceError>> {
    var errors: [ReferenceError] = []
    let correlatedName = self.reorderings.keys.first(where: { requirement.reorderings[$0] ≠ nil })!
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
        if existing ≠ rearranged {
          errors.append(.mismatchedParameters(name: name, declaration: provisionDeclarationName))
        }
      } else {
        mergedReorderings[name] = rearranged
      }
    }
    if ¬errors.isEmpty {
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
  func parameter(named identifier: StrictString) -> InterpolationParameter? {
    return parameters.first(where: { $0.names.contains(identifier) })
  }

  func ordered(for name: StrictString) -> [InterpolationParameter] {
    guard let reordering = reorderings[name] else {
      return []
    }
    return reordering.map({ parameters[$0] })
  }
}

extension Interpolation {
  var inAnyOrder: [InterpolationParameter] {
    return parameters
  }
}

extension Interpolation where InterpolationParameter == ParameterIntermediate {
  func removingOtherNamesAnd(
    replacing originalName: StrictString,
    with newName: StrictString
  ) -> Interpolation {
    return Interpolation(
      parameters: parameters,
      reorderings: reorderings == [:]
        ? [:]
        : [newName: reorderings[originalName]!]
    )
  }
}

extension Interpolation where InterpolationParameter == ParameterIntermediate {
  static func enumerationWrap(
    enumerationType: ParsedTypeReference,
    caseIdentifier: StrictString,
    valueType: ParsedTypeReference
  ) -> Interpolation {
    return Interpolation(
      parameters: [
        ParameterIntermediate(
          names: ["value"],
          type: valueType,
          passAction: .parameterAction(names: ["value"], parameters: .none, returnValue: nil),
          executeAction: nil
        ),
        ParameterIntermediate(
          names: ["case"],
          type: .enumerationCase(enumeration: enumerationType, identifier: caseIdentifier),
          passAction: .parameterAction(names: ["case"], parameters: .none, returnValue: nil),
          executeAction: nil
        ),
      ],
      reorderings: [
        "wrap () as ()": [0, 1]
      ]
    )
  }
  static func enumerationUnwrap(
    enumerationType: ParsedTypeReference,
    caseIdentifier: StrictString,
    valueType: ParsedTypeReference
  ) -> Interpolation {
    return Interpolation(
      parameters: [
        ParameterIntermediate(
          names: ["enumeration"],
          type: enumerationType,
          passAction: .parameterAction(names: ["enumeration"], parameters: .none, returnValue: nil),
          executeAction: nil
        ),
        ParameterIntermediate(
          names: ["case"],
          type: .enumerationCase(enumeration: enumerationType, identifier: caseIdentifier),
          passAction: .parameterAction(names: ["case"], parameters: .none, returnValue: nil),
          executeAction: nil
        ),
        ParameterIntermediate(
          names: ["value"],
          type: valueType,
          passAction: .parameterAction(names: ["value"], parameters: .none, returnValue: nil),
          executeAction: nil
        ),
        ParameterIntermediate(
          names: ["consequence"],
          type: .statements,
          passAction: .parameterAction(names: ["consequence"], parameters: .none, returnValue: nil),
          executeAction: nil
        ),
      ],
      reorderings: [
        "if () is (), unwrap it as (), ()": [0, 1, 2, 3]
      ]
    )
  }
  func names() -> Set<StrictString> {
    return Set(reorderings.keys)
  }
}
