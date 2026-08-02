extension ParsedNativeRequirementContents {

  var requirements: [ParsedNativeThingReference] {
    switch self {
    case .list(let list):
      return list.requirements.requirements
    case .single(let single):
      return [single]
    }
  }
}
