@echo off
chcp 65001 >nul 2>&1
setlocal enabledelayedexpansion
title Kivun Terminal - Choose Folder

echo ========================================
echo   Kivun Terminal - Folder Selector
echo ========================================
echo.
echo Opening folder picker...
echo.

REM Try VBScript folder picker first
for /f "delims=" %%i in ('cscript //nologo "%~dp0folder-picker.vbs" 2^>nul') do set "CHOSEN_FOLDER=%%i"

REM Check if user cancelled
if "!CHOSEN_FOLDER!"=="CANCELLED" (
    echo Cancelled.
    timeout /t 2 >nul
    exit /b 0
)

REM If folder picker failed or returned empty, fallback to typing
if "!CHOSEN_FOLDER!"=="" (
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
)

REM Show selected folder
echo.
echo ========================================
echo Selected folder:
echo !CHOSEN_FOLDER!
echo ========================================
echo.
echo Starting Kivun Terminal...
echo.

REM Launch Kivun Terminal in the chosen folder
call "%~dp0kivun-terminal.bat" "!CHOSEN_FOLDER!"
