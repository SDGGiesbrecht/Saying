// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  name: "scaffolding",
  dependencies: [
    .package(path: "../../../Source"),
  ],
  targets: [
    .executableTarget(
      name: "scaffolding",
      dependencies: [
        .product(name: "Source", package: "Source"), // Just so that IDEs show the files.
      ],
      plugins: [
        .plugin(name: "GenerateSyntax")
      ]
    ),
    .plugin(
      name: "GenerateSyntax",
      capability: .buildTool(),
      dependencies: [
        "generate‐syntax"
      ]
    ),
    .executableTarget(
      name: "generate‐syntax"
    ),
    .executableTarget(
      name: "update‐unicode"
    )
  ]
)
