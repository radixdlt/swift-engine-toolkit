# TransactionKit

A description of this package.

# Binaries exluded
Binaries total size is 50+50+100 (iOS, iOS Sim, macOS (Intel/Apple Silicon)) mb for the three different `libTX.a` files.

For now you need to build the [transaction library](https://github.com/radixdlt/transaction-library) your self, using `build.sh`

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

