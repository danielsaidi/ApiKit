// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "ApiKit",
    platforms: [
        .iOS(.v13),
        .macOS(.v11),
        .tvOS(.v13),
        .watchOS(.v6),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "ApiKit",
            targets: ["ApiKit"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "ApiKit",
            dependencies: []
        ),
        .testTarget(
            name: "ApiKitTests",
            dependencies: ["ApiKit"]
        )
    ]
)
