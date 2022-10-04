#!/bin/sh -e

echo "🔮 Building libTX...✨";

script_parent=$(dirname $0)
cd $script_parent

echo "🔮 Removing any existing libTX.xcframework..."
rm -rf ../libTX.xcframework

cd transaction-library

echo "🔮 Building targets..."

rustup default stable

# cargo build --target x86_64-apple-ios --release         # iOS Simulator & iPhone x86 target
cargo build --target aarch64-apple-ios-sim --release    # iOS Simulator Aarch64 target
cargo build --target aarch64-apple-ios --release        # iOS iPhone Aarch64 target

cargo build --target aarch64-apple-darwin --release # Apple Silicon Mac
cargo build --target x86_64-apple-darwin --release # Intel Mac

echo "🔮 Finished building all targets."

# Create a fat binary for mac (combining Intel Mac + Apple Silicon Mac)
(
    cd target
    mkdir -p macos-arm64_x86_64

     # Combine the two macOS builds into one fat file
    lipo -create \
        aarch64-apple-darwin/release/libtransaction_library.a \
        x86_64-apple-darwin/release/libtransaction_library.a \
        -o macos-arm64_x86_64/libTX.a
        
    # Rename iOS `.a`-files.
    mv aarch64-apple-ios/release/libtransaction_library.a aarch64-apple-ios/release/libTX.a
    mv aarch64-apple-ios-sim/release/libtransaction_library.a aarch64-apple-ios-sim/release/libTX.a
    
	echo "🔮 Finished merging some of the targets using lipo."
)



# Create the C header of the provided functions and adding it to the directory of each of the 
# builds
(
	echo "🔮 Switch rust to nightly"
    rustup default nightly

    # Creating the header file
	echo "🔮 Creating header file..."
    cbindgen \
        --lang c \
        --config cbindgen.toml \
        --crate transaction-library \
        --output libTX.h
        
        	
	echo "🔮 Making sure folder 'include' exists"
	mkdir -p include
	
	echo "🔮 Copying header 'libTX.h' to 'include' folder"
	cp libTX.h include

	echo "🔮 Copying header 'module.modulemap' to 'include' folder"
	cp ../module.modulemap include
	
	echo "🔮 Copying 'include' folder for iOS target"
    cp -r include target/aarch64-apple-ios/release/
    
	echo "🔮 Copying header for iOS Sim target"
    cp -r include target/aarch64-apple-ios-sim/release/
    
	echo "🔮 Copying header for Mac target"
    cp -r include target/macos-arm64_x86_64/
    
	echo "🔮 Removing folder 'include'"
    rm -r include

	echo "🔮 Restore rust to stable"
    rustup default stable
)

echo "🔮 xcodebuild -create-xcframework"

# Creating an XC Framework of the static libraries. Note: at the current moment of time, I have
# removed the `x86_64-apple-ios` target from the XC Framework as it clashed with 
# `ios-arm64-simulator`. If this causes issues, then we can look into it further. 
xcodebuild -create-xcframework \
    -library target/aarch64-apple-ios/release/libTX.a \
	-headers target/aarch64-apple-ios/release/include \
    -library target/aarch64-apple-ios-sim/release/libTX.a \
    -headers target/aarch64-apple-ios-sim/release/include \
    -library target/macos-arm64_x86_64/libTX.a \
    -headers target/macos-arm64_x86_64/include \
    -output ../../libTX.xcframework

echo "🔮 Done! ✅"
