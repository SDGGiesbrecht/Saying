// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  name: "scaffolding",
  dependencies: [
    .package(path: "../Source"),
    .package(url: "https://github.com/SDGGiesbrecht/SDGCornerstone", from: Version(10, 1, 3))
  ],
  targets: [
    .executableTarget(
      name: "scaffolding",
      dependencies: [
        .product(name: "Source", package: "Source"), // Just so that IDEs show the files.
        .product(name: "SDGText", package: "SDGCornerstone"),
        .product(name: "SDGPersistence", package: "SDGCornerstone"),
        .product(name: "SDGExternalProcess", package: "SDGCornerstone"),
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
      name: "generate‐syntax",
      dependencies: [
        .product(name: "SDGPersistence", package: "SDGCornerstone"),
      ]
    )
  ]
)
