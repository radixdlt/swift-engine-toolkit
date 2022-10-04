echo "Building the library";

# cargo build --target x86_64-apple-ios --release         # iOS Simulator & iPhone x86 target
cargo build --target aarch64-apple-ios-sim --release    # iOS Simulator Aarch64 target
cargo build --target aarch64-apple-ios --release        # iOS iPhone Aarch64 target

cargo build --target aarch64-apple-darwin --release # Apple Silicon Mac
cargo build --target x86_64-apple-darwin --release # Intel Mac

(
    cd ./target

    mkdir macOS

     # Combine the two macOS builds into one fat file
    lipo -create \
        aarch64-apple-darwin/release/libtransaction_library.a \
        x86_64-apple-darwin/release/libtransaction_library.a \
        -o macOS/libtransaction_library.a
)

# Create the C header of the provided functions and adding it to the directory of each of the 
# builds
(
    rustup default nightly

    # Creating the header file
    cbindgen \
        --config cbindgen.toml \
        --crate transaction-library \
        --output transaction_library.h

    # Copying the header file to all of the builds
    cp transaction_library.h ./target/aarch64-apple-ios-sim/release/
    cp transaction_library.h ./target/aarch64-apple-ios/release/
    
    cp transaction_library.h ./target/macOS
    
    # The root-level header is no longer needed now. Safe to delete
    rm transaction_library.h

    rustup default stable
)

# Creating an XC Framework of the static libraries. Note: at the current moment of time, I have
# removed the `x86_64-apple-ios` target from the XC Framework as it clashed with 
# `ios-arm64-simulator`. If this causes issues, then we can look into it further. 
xcodebuild -create-xcframework \
    -library ./target/aarch64-apple-ios/release/libtransaction_library.a \
    -headers ./target/aarch64-apple-ios/release/transaction_library.h \
    -library ./target/aarch64-apple-ios-sim/release/libtransaction_library.a \
    -headers ./target/aarch64-apple-ios-sim/release/transaction_library.h \
    -library ./target/macOS/libtransaction_library.a \
    -headers ./target/macOS/transaction_library.h \
    -output ./target/TX_lib.xcframework

echo "Done!"
