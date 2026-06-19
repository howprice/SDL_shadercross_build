@echo off

if exist external\SDL\build (
    rmdir external\SDL\build /s /q
    echo Deleted external/SDL/build folder
) else (
    echo external/SDL/build folder does not exist
)

if exist external\SDL_shadercross\build (
    rmdir external\SDL_shadercross\build /s /q
    echo Deleted external/SDL_shadercross/build folder
) else (
    echo external/SDL_shadercross/build folder does not exist
)

if exist bin (
    rmdir bin /s /q
    echo Deleted bin folder
) else (
    echo bin folder does not exist
)
