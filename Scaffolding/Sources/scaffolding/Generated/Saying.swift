func compute(_ compute: () -> Bool, _ cache: inout Bool?) -> Bool {
  if let cached = (cache) {
return cached
}
  let result: Bool = (compute())
  cache = ((result) as Bool?)
  return result
}