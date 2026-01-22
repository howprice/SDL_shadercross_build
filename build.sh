#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Allow script to be launched from any directory
SOURCE=${BASH_SOURCE[0]}
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
#echo "SOURCE is '$SOURCE'"
#echo "SCRIPT_DIR is '$SCRIPT_DIR"
pushd $SCRIPT_DIR > /dev/null

# Configure and build SDL as a static library in Release config.
cd external/SDL
cmake -S . -B build -GNinja -DSDL_STATIC=ON -DSDL_SHARED=OFF -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER=/usr/bin/clang -DCMAKE_CXX_COMPILER=/usr/bin/clang++
ninja -C build

# Configure and build SDL_shadercross as a static, vendored, CLI executable with SPIR-V support.
cd ../SDL_shadercross
cmake -S . -B build -GNinja -DCMAKE_PREFIX_PATH=../SDL/build/ -DSDLSHADERCROSS_VENDORED=ON -DSDLSHADERCROSS_DXC=ON -DENABLE_SPIRV_CODEGEN=ON -DSDLSHADERCROSS_STATIC=ON -DSDLSHADERCROSS_CLI=ON -DSDLSHADERCROSS_CLI_STATIC=ON -DCMAKE_C_COMPILER=/usr/bin/clang -DCMAKE_CXX_COMPILER=/usr/bin/clang++
ninja -C build
cd ../..

mkdir -p bin
cp external/SDL_shadercross/build/shadercross bin/
echo "Build complete! Executable is in bin/shadercross"

# return to original directory
popd > /dev/null
