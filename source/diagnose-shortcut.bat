@echo off
title Shortcut Diagnostic Tool
echo ========================================
echo KIVUN TERMINAL - SHORTCUT DIAGNOSTIC
echo ========================================
echo.

REM Check if we're in the right directory
echo [1] Current Directory:
cd
echo.

REM Check if launcher exists
echo [2] Looking for claude-hebrew-konsole.bat:
if exist "claude-hebrew-konsole.bat" (
    echo    FOUND: claude-hebrew-konsole.bat
) else (
    echo    NOT FOUND: claude-hebrew-konsole.bat
    echo    PROBLEM: Launcher not in current directory!
)
echo.

REM Check config.txt
echo [3] Looking for config.txt:
if exist "config.txt" (
    echo    FOUND: config.txt
) else (
    echo    NOT FOUND: config.txt
    echo    PROBLEM: Config file not in current directory!
)
echo.

REM Check scripts
echo [4] Looking for kivun-launch.sh:
if exist "kivun-launch.sh" (
    echo    FOUND: kivun-launch.sh
) else (
    echo    NOT FOUND: kivun-launch.sh
    echo    PROBLEM: Launch script not in current directory!
)
echo.

REM Try to run the launcher with pause
echo [5] Attempting to run launcher...
echo    Press any key to try running claude-hebrew-konsole.bat
pause >/dev/null

if exist "claude-hebrew-konsole.bat" (
    call claude-hebrew-konsole.bat
) else (
    echo    ERROR: Launcher not found!
)

echo.
echo ========================================
echo Diagnostic complete. Window will stay open.
echo Press any key to exit.
pause >/dev/null
