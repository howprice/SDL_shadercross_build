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

# Set CXX flags for macOS only
if [[ "$(uname -s)" == "Darwin" ]]; then
    CXX_FLAGS_EXTRA="-DCMAKE_CXX_FLAGS=-Wno-invalid-specialization"
else
    CXX_FLAGS_EXTRA=""
fi

cmake -S . -B build -GNinja -DCMAKE_PREFIX_PATH=../SDL/build/ -DSDLSHADERCROSS_VENDORED=ON -DSDLSHADERCROSS_DXC=ON -DENABLE_SPIRV_CODEGEN=ON -DSDLSHADERCROSS_STATIC=ON -DSDLSHADERCROSS_CLI=ON -DSDLSHADERCROSS_CLI_STATIC=ON -DCMAKE_C_COMPILER=/usr/bin/clang -DCMAKE_CXX_COMPILER=/usr/bin/clang++ $CXX_FLAGS_EXTRA
ninja -C build
cd ../..

if [[ "$(uname -s)" == "Darwin" ]]; then
    DYLIB_EXT="dylib"
else
    DYLIB_EXT="so"
fi

mkdir -p bin
cp external/SDL_shadercross/build/shadercross bin/
cp external/SDL_shadercross/build/external/DirectXShaderCompiler/lib/libdxcompiler.$DYLIB_EXT bin/
cp external/SDL_shadercross/build/external/DirectXShaderCompiler/lib/libdxil.$DYLIB_EXT bin/
echo "Build complete! Executable is in bin/shadercross"

echo "Testing shadercross HLSL to DXIL"
bin/shadercross shaders/test.vert.hlsl -s hlsl -d dxil -t vertex -e "main" -o bin/test.vert.dxil
bin/shadercross shaders/test.frag.hlsl -s hlsl -d dxil -t fragment -e "main" -o bin/test.frag.dxil
echo "Testing shadercross HLSL to SPIRV"
bin/shadercross shaders/test.vert.hlsl -s hlsl -d spirv -t vertex -e "main" -o bin/test.vert.spirv
bin/shadercross shaders/test.frag.hlsl -s hlsl -d spirv -t fragment -e "main" -o bin/test.frag.spirv
echo "Testing shadercross HLSL to MSL"
bin/shadercross shaders/test.vert.hlsl -s hlsl -d msl -t vertex -e "main" -o bin/test.vert.msl
bin/shadercross shaders/test.frag.hlsl -s hlsl -d msl -t fragment -e "main" -o bin/test.frag.msl
echo "Shader compilation tests completed successfully."

# return to original directory
popd > /dev/null
