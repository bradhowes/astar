// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "AStar",
  platforms: [
    .iOS(.v14),
    .macOS(.v12),
    .tvOS(.v13),
    .watchOS(.v6),
  ],
  products: [
    .library(name: "AStar", targets: ["AStar"]),
  ],
  dependencies: [
    .package(url: "https://github.com/bradhowes/PriorityQueue", from: "1.2.0"),
    .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0")
  ],
  targets: [
    .target(
      name: "AStar",
      dependencies: [
        .product(name: "PriorityQueue", package: "PriorityQueue")
      ]
    ),
    .testTarget(
      name: "AStarTests",
      dependencies: ["AStar"]
    )
  ],
  swiftLanguageModes: [.v6, .v5]
)
