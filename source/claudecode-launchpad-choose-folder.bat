@echo off
chcp 65001 >nul 2>&1
setlocal enabledelayedexpansion
title ClaudeCode Launchpad CLI - Choose Folder

echo ========================================
echo   ClaudeCode Launchpad CLI - Folder Selector
echo ========================================
echo.

REM Skip folder picker if --text-only flag is passed
if "%~1"=="--text-only" goto :textinput

echo Opening folder picker...
echo.

REM Folder picker writes path to file (Unicode-safe) and echoes OK/CANCELLED
for /f "delims=" %%i in ('cscript //nologo "%~dp0folder-picker.js" 2^>nul') do set "PICKER_RESULT=%%i"

if "!PICKER_RESULT!"=="OK" (
    echo Folder selected. Starting ClaudeCode Launchpad CLI...
    echo.
    REM Pass READFILE marker - claudecode-launchpad.bat will read path from file
    call "%~dp0claudecode-launchpad.bat" "READFILE"
    exit /b 0
)

REM Cancelled or picker failed - fall through to text input
:textinput
echo.
echo ========================================
echo   Type or paste a folder path
echo ========================================
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

REM Write typed path via JScript (preserves Unicode)
cscript //nologo "%~dp0write-path.js" "!CHOSEN_FOLDER!" 2>nul

REM --- Optional one-time Claude flags ---
echo.
set "ONE_TIME_FLAGS="
set /p "ONE_TIME_FLAGS=Claude flags (Enter to skip, e.g. --continue): "
if not "!ONE_TIME_FLAGS!"=="" (
    echo !ONE_TIME_FLAGS!> "%LOCALAPPDATA%\Kivun\kivun-claude-flags.txt"
)

call "%~dp0claudecode-launchpad.bat" "READFILE"
