# DONE

- Add SDL3 repo as submodule, 
  - Specifically at version 3.4.0 https://github.com/libsdl-org/SDL/releases/tag/release-3.4.0
  - https://github.com/libsdl-org/SDL/commit/a962f40bbba175e9716557a25d5d7965f134a3d3

- Add SDL_shadercross as submodule

- Add build.sh to:
  - Configure and build SDL as a static library
  - Configure and build SDL_shadercross against SDL static lib as a static, vendored, CLI executable

- Add test HLSL shaders
  - Add commands to build.sh to compile these shaders

- Add build.bat to build on Windows from Visual Studio Developer Command Prompt

# TODO

- Fix Windows build to include SPIR-V
  - I'm not sure if this is related to the shadercross build or DirectX compiler.
  
  C:\dev\howprice\SDL_shadercross_build>bin\shadercross shaders\test.vert.hlsl -s hlsl -d dxil -t vertex -e "main" -o bin\test.vert.dxil
ERROR: Failed to compile DXIL from HLSL: HLSL compilation failed: SPIR-V CodeGen not available. Please recompile with -DENABLE_SPIRV_CODEGEN=ON.
