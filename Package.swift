// swift-tools-version: 5.7.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import Foundation
import PackageDescription

let package = Package(
    name: "EngineToolkit",
    platforms: [.macOS(.v11), .iOS(.v11)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "EngineToolkit",
            targets: ["EngineToolkit"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/krzysztofzablocki/Difference.git", from: "1.0.1"),
    ],
    targets: [
        .binaryTarget(
            name: "RadixEngineToolkit",
            path: "Sources/RadixEngineToolkit/RadixEngineToolkit.xcframework"
        ),
        .target(
            name: "EngineToolkit",
            dependencies: [
                "RadixEngineToolkit",
            ]
        ),
        .testTarget(
            name: "EngineToolkitTests",
            dependencies: [
                "Difference",
                "EngineToolkit",
            ],
            resources: []
        ),
    ]
)
