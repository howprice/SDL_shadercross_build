# DONE

- Add SDL3 repo as submodule, 
  - Specifically at version 3.4.0 https://github.com/libsdl-org/SDL/releases/tag/release-3.4.0
  - https://github.com/libsdl-org/SDL/commit/a962f40bbba175e9716557a25d5d7965f134a3d3

- Add SDL_shadercross as submodule

- Add build.sh to:
  - Configure and build SDL as a static library
  - Configure and build SDL_shadercross against SDL static lib as a static, vendored, CLI executable

# TODO

- Add shaders/test.vert.hlsl and shaders/test.frag.hlsl to text shadercross executable
  - Add commands to build.sh to compile these shaders

- Add build.bat to build on Windows from Visual Studio Developer Command Prompt
