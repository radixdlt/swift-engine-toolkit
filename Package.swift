// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EngineToolkit",
    platforms: [.macOS(.v12), .iOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "EngineToolkit",
            targets: ["EngineToolkit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/krzysztofzablocki/Difference.git", from: "1.0.1"),
        .package(url: "https://github.com/Sajjon/K1.git", .upToNextMajor(from: "0.0.1")),
    ],
    targets: [
        .binaryTarget(
            name: "RadixEngineToolkit",
            path: "Sources/RadixEngineToolkit/RadixEngineToolkit.xcframework"
        ),
        .target(
            name: "EngineToolkit",
            dependencies: ["RadixEngineToolkit"]
        ),
        .testTarget(
            name: "EngineToolkitTests",
            dependencies: [
                "Difference",
                "EngineToolkit",
                "K1",
            ],
            resources: [
                .copy("Resources"),
            ]
        )
    ]
)
