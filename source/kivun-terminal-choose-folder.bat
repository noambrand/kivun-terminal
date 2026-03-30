@echo off
chcp 65001 >nul 2>&1
setlocal enabledelayedexpansion
title ClaudeCode Launchpad CLI - Choose Folder

echo ========================================
echo   ClaudeCode Launchpad CLI - Folder Selector
echo ========================================
echo.
echo Opening folder picker...
echo.

REM Folder picker writes path to file (Unicode-safe) and echoes OK/CANCELLED
for /f "delims=" %%i in ('cscript //nologo "%~dp0folder-picker.vbs" 2^>nul') do set "PICKER_RESULT=%%i"

REM Check if user cancelled or picker failed
if "!PICKER_RESULT!"=="CANCELLED" (
    echo Cancelled.
    timeout /t 2 >nul
    exit /b 0
)

if "!PICKER_RESULT!"=="OK" (
    echo Folder selected. Starting ClaudeCode Launchpad CLI...
    echo.
    REM Pass READFILE marker - kivun-terminal.bat will read path from file
    call "%~dp0kivun-terminal.bat" "READFILE"
) else (
    echo.
    echo ========================================
    echo Folder picker unavailable
    echo ========================================
    echo.
    echo FALLBACK: Please type or paste the folder path
    echo.
    echo Examples:
    echo   C:\Users\noam\Documents\MyProject
    echo   C:\Projects\WebApp
    echo.
    echo ========================================
    echo.
    set /p "CHOSEN_FOLDER=Enter path: "

    REM Remove quotes
    set "CHOSEN_FOLDER=!CHOSEN_FOLDER:"=!"

    REM Check if empty
    if "!CHOSEN_FOLDER!"=="" (
        echo.
        echo No path entered!
        timeout /t 2 >nul
        exit /b 1
    )

    REM Check if folder exists
    if not exist "!CHOSEN_FOLDER!" (
        echo.
        echo ERROR: Folder does not exist!
        echo Path: !CHOSEN_FOLDER!
        echo.
        pause
        exit /b 1
    )

    REM Write typed path via VBS (preserves Unicode)
    cscript //nologo "%~dp0write-path.vbs" "!CHOSEN_FOLDER!" 2>nul
    call "%~dp0kivun-terminal.bat" "READFILE"
)
