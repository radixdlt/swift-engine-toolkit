// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TransactionKit",
    platforms: [.macOS(.v12), .iOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "TransactionKit",
            targets: ["TransactionKit"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .binaryTarget(
            name: "libTX",
            path: "Sources/libTX/libTX.xcframework"
        ),
        .target(
            name: "TransactionKit",
            dependencies: ["libTX"]
        ),
        .testTarget(
            name: "TransactionKitTests",
            dependencies: ["TransactionKit"]
        ),
    ]
)
