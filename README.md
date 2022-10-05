# TransactionKit

A description of this package.

# Binaries exluded
Binaries total size is 50+50+100 (iOS, iOS Sim, macOS (Intel/Apple Silicon)) mb for the three different `libTX.a` files.

For now you need to build the [transaction library](https://github.com/radixdlt/transaction-library) your self, using `build.sh`

# Supported Platforms
The underlying binary is built for these platforms:
* iOS (ARM64, used since [iPhone 5S][iphonearchs])
* iOS Simulator (ARM64)
* macOS, both Apple Silicon (ARM64) and Intel (x86).

iOS x86 is not supported since [it is obsolete][iphonearchs] and runs on iPhones which are not capable of running iOS 15, which is required by Babylon Wallet app.
> arm64 is the current 64-bit ARM CPU architecture, as used since the iPhone 5S and later (6, 6S, SE and 7)

# Build

```sh
rustup update
rustup toolchain install nightly
rustup target add x86_64-apple-ios aarch64-apple-ios aarch64-apple-ios-sim aarch64-apple-darwin x86_64-apple-darwin
cargo install cargo-lipo
cargo install --force cbindgen
```

Then run:

```sh
./build.sh
```

Which should create a working `libTX.xcframework` references from the `Package.swift`

# Example
In order to run the example app, make sure to close down any other Xcode window which might have opened this SPM package and then standing in the root run:

```sh
open Example/AppTX.xcodeproj
```

**I have successfully run this example on an iPhone 7 (iOS 15.6.1)**

**I have successfully archived this example for iOS, resulting in an .xcarchive weighing 12.3 mb**

[iphonearchs]: https://docs.elementscompiler.com/Platforms/Cocoa/CpuArchitectures/
