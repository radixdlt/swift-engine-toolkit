#!/bin/sh -e

git submodule init
git submodule update
(cd ./Sources/RadixEngineToolkit/build/radix-engine-toolkit; git checkout main)

./Sources/RadixEngineToolkit/build/build.sh
