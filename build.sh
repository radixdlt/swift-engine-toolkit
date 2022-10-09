#!/bin/sh -e

git submodule init
git submodule update

./Sources/RadixEngineToolkit/build/build.sh
