internal struct UTF8Segments {

  init(_ segments: [UTF8Segment]) {
    self.segments = segments
  }

  var segments: [UTF8Segment]
}
