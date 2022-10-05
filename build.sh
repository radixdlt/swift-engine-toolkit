#!/bin/sh -e

git submodule init
git submodule update

./Sources/libTX/build/build.sh
