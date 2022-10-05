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

cargo build --target aarch64-apple-ios-sim --release    # iOS Simulator Aarch64 target
cargo build --target aarch64-apple-ios --release        # iOS iPhone Aarch64 target

cargo build --target aarch64-apple-darwin --release # Apple Silicon Mac
cargo build --target x86_64-apple-darwin --release # Intel Mac

echo "🔮 🛠 🎯 Finished building all targets ✅"

# Create a fat binary for mac (combining Intel Mac + Apple Silicon Mac)
(
    cd target
    mkdir -p macos-arm64_x86_64

     # Combine two builds for the macOS archictures together into one fat file.
    lipo -create \
        aarch64-apple-darwin/release/libtransaction_library.a \
        x86_64-apple-darwin/release/libtransaction_library.a \
        -o macos-arm64_x86_64/libTX.a
        
    # Lipo is not needed for iOS, since we only support one architecture, and that is `aarch64` (ARM64 iOS).
    # And lipo is only used to combine different architectures for same platform together.
    
    mv aarch64-apple-ios/release/libtransaction_library.a aarch64-apple-ios/release/libTX.a
    mv aarch64-apple-ios-sim/release/libtransaction_library.a aarch64-apple-ios-sim/release/libTX.a

	echo "🔮 🙏 Finished merging some of the targets using 'lipo'"
)

# Create the C header of the provided functions and adding it to the directory of each of the
# builds
(
	echo "🔮 🦀 Switch rust to nightly 🌓"
    rustup default nightly

    # Creating the header file
	echo "🔮 👤 Creating header file..."
    cbindgen \
        --lang c \
        --config cbindgen.toml \
        --crate transaction-library \
        --output libTX.h
        
    echo "🔮 Making sure folder 'include' exists"
    mkdir -p include

    echo "🔮 👤 Copying header 'libTX.h' to 'include' folder"
    cp libTX.h include

    echo "🔮 🗺 Copying header 'module.modulemap' to 'include' folder"
    cp ../module.modulemap include

    echo "🔮 🗂 Copying 'include' folder for iOS target"
    cp -r include target/aarch64-apple-ios/release/

    echo "🔮 🗂 Copying 'include' folder for iOS Sim target"
    cp -r include target/aarch64-apple-ios-sim/release/

    echo "🔮 🗂 Copying 'include' folder for Mac target"
    cp -r include target/macos-arm64_x86_64/

    echo "🔮 🗑 Removing folder 'include'"
    rm -r include

    echo "🔮 🦀 Restore rust to stable ⚖️"
    rustup default stable
)

echo "🔮 📦 Creating '.xcframework' for platforms: [iOS, iOS Simulator, macOS] ☑️"

# iOS, iOS Sim, macOS
xcodebuild -create-xcframework \
    -library target/aarch64-apple-ios/release/libTX.a \
    -headers target/aarch64-apple-ios/release/include \
    -library target/aarch64-apple-ios-sim/release/libTX.a \
    -headers target/aarch64-apple-ios-sim/release/include \
    -library target/macos-arm64_x86_64/libTX.a \
    -headers target/macos-arm64_x86_64/include \
    -output ../../libTX.xcframework

echo "🔮 📦 Created '.xcframework' for platforms: [iOS, iOS Simulator, macOS] ✅"
