// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  name: "scaffolding",
  dependencies: [
    .package(path: "../../../Source"),
    .package(path: "../../Generated/Swift/Saying"),
  ],
  targets: [
    .executableTarget(
      name: "scaffolding",
      dependencies: [
        .product(name: "Source", package: "Source"), // Just so that IDEs show the files.
        .product(name: "Saying", package: "Saying"),
        "Syntax",
      ]
    ),
    .target(
      name: "Syntax",
      dependencies: [
        .product(name: "Saying", package: "Saying")
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
