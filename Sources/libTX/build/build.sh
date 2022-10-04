echo "Building the library";

cd ./transaction-library

# cargo build --target x86_64-apple-ios --release         # iOS Simulator & iPhone x86 target
cargo build --target aarch64-apple-ios-sim --release    # iOS Simulator Aarch64 target
cargo build --target aarch64-apple-ios --release        # iOS iPhone Aarch64 target

cargo build --target aarch64-apple-darwin --release # Apple Silicon Mac
cargo build --target x86_64-apple-darwin --release # Intel Mac

# Create a fat binary for mac (combining Intel Mac + Apple Silicon Mac)
(
    cd ./target
    mkdir macos-arm64_x86_64

     # Combine the two macOS builds into one fat file
    lipo -create \
        aarch64-apple-darwin/release/libtransaction_library.a \
        x86_64-apple-darwin/release/libtransaction_library.a \
        -o macos-arm64_x86_64/libTX.a
        
    # Rename iOS `.a`-files.
    mv aarch64-apple-ios/release/libtransaction_library.a aarch64-apple-ios/release/libTX.a
    mv aarch64-apple-ios-sim/release/libtransaction_library.a aarch64-apple-ios-sim/release/libTX.a
)

# Create the C header of the provided functions and adding it to the directory of each of the 
# builds
(
    rustup default nightly

    # Creating the header file
    cbindgen \
        --lang c \
        --config cbindgen.toml \
        --crate transaction-library \
        --output libTX.h
        
    cp libTX.h ./target/libTX.h

    rustup default stable
)

# Creating an XC Framework of the static libraries. Note: at the current moment of time, I have
# removed the `x86_64-apple-ios` target from the XC Framework as it clashed with 
# `ios-arm64-simulator`. If this causes issues, then we can look into it further. 
xcodebuild -create-xcframework \
    -library ./target/aarch64-apple-ios/release/libTX.a \
    -library ./target/aarch64-apple-ios-sim/release/libTX.a \
    -library ./target/macos-arm64_x86_64/libTX.a \
    -headers ./target/libTX.h \
    -output ./target/libTX.xcframework

touch

echo "Done!"
