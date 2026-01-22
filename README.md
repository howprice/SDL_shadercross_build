# SDL_shadercross_build

Builds static CLI [SDL_shadercross](https://github.com/libsdl-org/SDL_shadercross) executables.

## Building

This project uses submodules, which have nested submodules. Clone with:

    git clone git@github.com:howprice/SDL_shadercross_build.git --recurse-submodules

or after cloning:

    git submodule update --init --recursive

## Why

- I am working on a cross platform Windows + Linux project using SDL3 GPU
- I want to write shaders once in HLSL and compile to run on both platforms
- I do not want to commit shader binaries
- Adding shadercross runtime to my application (emulator) bloats it unnecessarily; Offline shader compilation is preferable to online in my case.
- I want to use SDL_shadercross to compile HLSL to DXIL/SPIR-V offline (at build time)
- SDL_shadercross binaries are not officially available - I found 3rd party Windows builds but not Linux
- There are no build instructions in the SDL_shadercross repo. Submodules are configured, but not SDL3

However, my project pulls in SDL3 via VCPKG for convenient cross platform building.
- I want to build shadercross executables statically, so don't depend on the built VCPKG SDL3.dll/.so location.
