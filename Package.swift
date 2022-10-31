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
        
		// Due to SPM bug We MUST explicitly declare dependency on all packages
		// that SLIP10 depend on
		// https://forums.swift.org/t/package-built-with-dependency-on-another-package-that-uses-a-build-tool-plugin-fails-to-find-the-build-tool-product/58408/2
		// This is very unfortunate and we hope it gets fixed in the future.
		.package(url: "https://github.com/Sajjon/K1.git", from: "0.0.4"),
		.package(url: "git@github.com:radixdlt/Bite.git", from: "0.0.1"),
		.package(url: "git@github.com:radixdlt/Mnemonic.git", from: "0.0.5"),
		.package(url: "git@github.com:radixdlt/SLIP10.git", from: "0.0.19"),
        
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
				
				// Due to SPM bug We MUST explicitly declare dependency on all packages
				// that SLIP10 depend on
				// https://forums.swift.org/t/package-built-with-dependency-on-another-package-that-uses-a-build-tool-plugin-fails-to-find-the-build-tool-product/58408/2
				// This is very unfortunate and we hope it gets fixed in the future.
				.product(name: "Bite", package: "Bite"),
				.product(name: "K1", package: "K1"),
				.product(name: "Mnemonic", package: "Mnemonic"),
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
