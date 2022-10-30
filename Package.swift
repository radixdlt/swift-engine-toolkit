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
        
        .package(url: "git@github.com:radixdlt/SLIP10.git", from: "0.0.17"),
        
        // Haskell-like `newtype` feature.
        .package(url: "https://github.com/pointfreeco/swift-tagged.git", from: "0.7.0"),
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
				.product(name: "SLIP10", package: "SLIP10"),
                .product(name: "Tagged", package: "swift-tagged"),
            ]
        ),
        .testTarget(
            name: "EngineToolkitTests",
            dependencies: [
                "Difference",
                "EngineToolkit"
            ],
            resources: [
                .process("TestVectors/"),
            ]
        )
    ]
)
