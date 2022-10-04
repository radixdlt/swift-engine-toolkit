#!/bin/sh -e

echo "🔮 ✨ Building libTX...";

cd $(dirname $0)
script_parent=$PWD

echo "🔮 🗑 Removing any existing libTX.xcframework..."
rm -rf ../libTX.xcframework

cd transaction-library

echo "🔮 🛠 🎯 Building targets for all platforms...☑️"

echo "🔮 🦀  Switch rust to stable ⚖️"
rustup default stable

# cargo build --target x86_64-apple-ios --release         # iOS Simulator & iPhone x86 target
cargo build --target aarch64-apple-ios-sim --release    # iOS Simulator Aarch64 target
cargo build --target aarch64-apple-ios --release        # iOS iPhone Aarch64 target

cargo build --target aarch64-apple-darwin --release # Apple Silicon Mac
cargo build --target x86_64-apple-darwin --release # Intel Mac

echo "🔮 🛠 🎯 Finished building all targets ✅"

# Create a fat binary for mac (combining Intel Mac + Apple Silicon Mac)
(
    cd target
    mkdir -p macos-arm64_x86_64

     # Combine the two macOS builds into one fat file
    lipo -create \
        aarch64-apple-darwin/release/libtransaction_library.a \
        x86_64-apple-darwin/release/libtransaction_library.a \
        -o macos-arm64_x86_64/libTX.a

	echo "🔮 🙏 Finished merging some of the targets using 'lipo'"
)



# Create the C header of the provided functions and adding it to the directory of each of the
# builds
(
	echo "🔮 🦀 Switch rust to nightly 🌓"
    rustup default nightly

    # Creating the header file
	echo "🔮 Creating header file..."
    cbindgen \
        --lang c \
        --config cbindgen.toml \
        --crate transaction-library \
        --output libTX.h

    echo "🔮 🦀 Restore rust to stable ⚖️"
    rustup default stable
)

echo "🔮 📦 Manually packaging '.xcframework' ☑️"

# `xcodebuild -create-xcframework` does not work for us, or at least we have not yet found
# the proper command. We have been using `xcodebuild -create-xcframework` to create the
# `Info.plist` file originally, with the three values in the `AvailableLibraries`.
# The `HeaderPath` value inside each element in `AvailableLibraries` has originally been
# using a seperate Header, this results in symbol conflicts when we try to build the
# TransactionKit SPM target, error: "type of expression is ambiguous without more context"
# This is using Xcode Version 14.0.1 (14A400) on Apple Silicon MacOS 12.6 (21G115).

cd $script_parent
cd ..

rm -rf libTX.xcframework
mkdir libTX.xcframework
mkdir libTX.xcframework/Headers
mkdir libTX.xcframework/ios-arm64
mkdir libTX.xcframework/ios-arm64-simulator
mkdir libTX.xcframework/macos-arm64_x86_64
cp build/Info.plist libTX.xcframework/
cp build/module.modulemap libTX.xcframework/Headers/
cp build/transaction-library/libTX.h libTX.xcframework/Headers/
cp build/transaction-library/target/macos-arm64_x86_64/libTX.a libTX.xcframework/macos-arm64_x86_64/
cp build/transaction-library/target/aarch64-apple-ios/release/libtransaction_library.a libTX.xcframework/ios-arm64/libTX.a
cp build/transaction-library/target/aarch64-apple-ios-sim/release/libtransaction_library.a libTX.xcframework/ios-arm64-simulator/libTX.a

#xcodebuild -create-xcframework \
#    -library target/aarch64-apple-ios/release/libTX.a \
#    -headers target/aarch64-apple-ios/release/include \
#    -library target/aarch64-apple-ios-sim/release/libTX.a \
#    -headers target/aarch64-apple-ios-sim/release/include \
#    -library target/macos-arm64_x86_64/libTX.a \
#    -headers target/macos-arm64_x86_64/include \
#    -output ../../libTX.xcframework

echo "🔮 Done! ✅"
