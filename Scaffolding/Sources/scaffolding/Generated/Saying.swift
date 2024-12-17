func _0028_0029_002C_0020caching_0020in_0020_0028_0029_003A_0028_0028_003Aערך_0020אמת_003A_0029_0029_003A_0028_003Aoptional_0020_0028_0029_003Aערך_0020אמת_003A_0029_003Aערך_0020אמת(_ compute: () -> Bool, _ cache: inout Bool?) -> Bool {
  if let cached = (cache) {
return cached
}
  let result: Bool = (compute())
  cache = ((result) as Bool?)
  return result
}
