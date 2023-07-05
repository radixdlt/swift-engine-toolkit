// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EngineToolkitUniFFI",
    platforms: [.macOS(.v12), .iOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "EngineToolkitUniFFI",
            type: .dynamic,
            targets: ["EngineToolkitUniFFI"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/krzysztofzablocki/Difference.git", from: "1.0.1"),
    ],
    targets: [
        .binaryTarget(
            name: "RadixEngineToolkitUniFFI",
            path: "Sources/RadixEngineToolkitUniFFI/RadixEngineToolkitUniFFI.xcframework"
        ),
        .target(
            name: "EngineToolkitUniFFI",
            dependencies: [
                "RadixEngineToolkitUniFFI",
            ]
        ),
        .testTarget(
            name: "EngineToolkitTests",
            dependencies: [
                "Difference",
                "EngineToolkitUniFFI",
            ],
            resources: []
        ),
    ]
)
