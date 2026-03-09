@echo off
setlocal enabledelayedexpansion
title Kivun Terminal - Diagnostics

echo ========================================
echo   Kivun Terminal - System Diagnostics
echo ========================================
echo.

REM Check Windows version
echo [1/7] Windows Version:
ver
echo.

REM Check WSL version
echo [2/7] WSL Status:
wsl --version 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo   ERROR: WSL is outdated or not installed
    echo.
    echo   SOLUTION: Run the Kivun Terminal installer again.
    echo             It will update WSL automatically.
    echo.
    echo   ALTERNATIVE (advanced):
    echo     1. Open PowerShell as Administrator
    echo     2. Run: wsl --update
    echo     3. Restart computer
) else (
    echo   OK: WSL installed with modern version
    wsl --version 2>nul | findstr "WSL"
)
echo.

REM Check default distro
echo [3/7] Default Distribution:
wsl -l -v
echo.

REM Check Ubuntu
echo [4/7] Ubuntu Access:
wsl -d Ubuntu echo "Ubuntu is accessible" 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo   ERROR: Cannot access Ubuntu
    echo   Run: wsl --set-default Ubuntu
) else (
    echo   OK: Ubuntu accessible
)
echo.

REM Check Konsole
echo [5/7] Konsole Installation:
wsl -d Ubuntu which konsole 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo   ERROR: Konsole not found in Ubuntu
    echo   Run post-install.sh to install
) else (
    echo   OK: Konsole installed
)
echo.

REM Check Claude Code
echo [6/7] Claude Code Installation:
wsl -d Ubuntu which claude 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo   ERROR: Claude Code not found
    echo   Run: npm install -g @anthropic-ai/claude-code
) else (
    echo   OK: Claude Code installed
)
echo.

REM Check Node.js
echo [7/7] Node.js Version:
wsl -d Ubuntu node --version 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo   ERROR: Node.js not installed
    echo   Install Node.js in Ubuntu
) else (
    echo   OK: Node.js installed
)
echo.

REM Summary
echo ========================================
echo   Diagnostic Complete
echo ========================================
echo.
echo If any component shows ERROR, that may be
echo causing the launcher to fail.
echo.
echo Next steps:
echo   - Fix any ERRORs shown above
echo   - Try running kivun-terminal-debug.bat
echo   - Check README_INSTALLATION.md
echo.
pause
