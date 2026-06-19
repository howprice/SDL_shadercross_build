@echo off

setlocal enabledelayedexpansion

if "%VisualStudioVersion%"=="" (
	echo Please run in Visual Studio Native Tools Command Prompt or run vcvarsall.bat to ensure cmake is on the path
	EXIT /B 1
)

if %VisualStudioVersion% == 15.0 (
	set CMAKE_GENERATOR="Visual Studio 15 2017"
) else if %VisualStudioVersion% == 16.0 (
	set CMAKE_GENERATOR="Visual Studio 16 2019"
) else if %VisualStudioVersion% == 17.0 (
	set CMAKE_GENERATOR="Visual Studio 17 2022"
) else if %VisualStudioVersion% == 18.0 (
	set CMAKE_GENERATOR="Visual Studio 18 2026"
) else (
	echo Unsupported Visual Studio version
	EXIT /B 1
)

REM Change to script directory
pushd %~dp0

REM Configure and build SDL as a static library in Release config.
REM This will generate external\SDL\build\Release\SDL3-static.lib
cd external\SDL
cmake -S . -B build -G%CMAKE_GENERATOR% -DSDL_STATIC=ON -DSDL_SHARED=OFF
if %ERRORLEVEL% neq 0 exit /b %ERRORLEVEL%
cmake --build build --config Release
if %ERRORLEVEL% neq 0 exit /b %ERRORLEVEL%

REM Configure and build SDL_shadercross as a static, vendored, CLI executable with SPIR-V support.
cd ..\SDL_shadercross
cmake -S . -B build -G%CMAKE_GENERATOR% -DCMAKE_PREFIX_PATH=../SDL/build/ -DSDLSHADERCROSS_VENDORED=ON -DSDLSHADERCROSS_DXC=ON -DENABLE_SPIRV_CODEGEN=ON -DSDLSHADERCROSS_STATIC=ON -DSDLSHADERCROSS_CLI=ON -DSDLSHADERCROSS_CLI_STATIC=ON -DCMAKE_CXX_FLAGS="/wd5285"
if %ERRORLEVEL% neq 0 exit /b %ERRORLEVEL%
cmake --build build --config Release
if %ERRORLEVEL% neq 0 exit /b %ERRORLEVEL%
cd ..\..

echo Build complete!

if not exist bin mkdir bin
copy external\SDL_shadercross\build\Release\shadercross.exe bin\
copy external\SDL_shadercross\build\external\DirectXShaderCompiler\Release\bin\dxcompiler.dll bin\
copy external\SDL_shadercross\build\external\DirectXShaderCompiler\Release\bin\dxil.dll bin\
echo Executable and DXC DLLs copied to bin\

echo Testing shadercross HLSL to DXIL
bin\shadercross shaders\test.vert.hlsl -s hlsl -d dxil -t vertex -e "main" -o bin\test.vert.dxil
if %ERRORLEVEL% neq 0 exit /b %ERRORLEVEL%
bin\shadercross shaders\test.frag.hlsl -s hlsl -d dxil -t fragment -e "main" -o bin\test.frag.dxil
if %ERRORLEVEL% neq 0 exit /b %ERRORLEVEL%
echo Testing shadercross HLSL to SPIRV
bin\shadercross shaders\test.vert.hlsl -s hlsl -d spirv -t vertex -e "main" -o bin\test.vert.spirv
if %ERRORLEVEL% neq 0 exit /b %ERRORLEVEL%
bin\shadercross shaders\test.frag.hlsl -s hlsl -d spirv -t fragment -e "main" -o bin\test.frag.spirv
if %ERRORLEVEL% neq 0 exit /b %ERRORLEVEL%
echo Shader compilation tests completed successfully.

REM Return to original directory
popd

EXIT /B 0
