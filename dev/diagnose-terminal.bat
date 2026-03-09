@echo off
REM Diagnose why Konsole is not opening
title Kivun Terminal - Diagnostics

echo ========================================
echo   Kivun Terminal - Diagnostics
echo ========================================
echo.

echo [1] Checking shortcuts...
echo.

REM Check desktop shortcut
if exist "%USERPROFILE%\Desktop\Kivun Terminal.lnk" (
    echo Desktop shortcut: EXISTS
    cscript //nologo "%~dp0check-shortcut.vbs" "%USERPROFILE%\Desktop\Kivun Terminal.lnk"
) else (
    echo Desktop shortcut: NOT FOUND
)

echo.
echo [2] Checking WSL and Konsole...
echo.

REM Check WSL
wsl --version >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo WSL: INSTALLED
) else (
    echo WSL: NOT INSTALLED *** PROBLEM ***
    goto :end
)

REM Check Ubuntu
wsl -d Ubuntu echo OK >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo Ubuntu: WORKING
) else (
    echo Ubuntu: NOT WORKING *** PROBLEM ***
    goto :end
)

REM Check Konsole
wsl -d Ubuntu -- bash -c "command -v konsole" >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo Konsole: INSTALLED
) else (
    echo Konsole: NOT INSTALLED *** PROBLEM ***
    echo.
    echo FIX: Run this in WSL Ubuntu:
    echo   sudo apt install -y konsole
    goto :end
)

REM Check Claude Code
wsl -d Ubuntu -- bash -c "command -v claude" >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo Claude Code: INSTALLED
) else (
    echo Claude Code: NOT INSTALLED *** PROBLEM ***
    echo.
    echo FIX: Run this in WSL Ubuntu:
    echo   npm install -g @anthropic-ai/claude-code
)

echo.
echo [3] Testing Konsole launch...
echo.
echo Launching Konsole test window...
wsl -d Ubuntu -- konsole -e echo "Konsole works! Press Enter to close." &
timeout /t 5 /nobreak >nul

wsl -d Ubuntu -- bash -c "pgrep -x konsole" >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo Konsole: LAUNCHED SUCCESSFULLY
    echo.
    echo If you see a Konsole window, everything works!
    echo If NOT, WSLg may not be available on this PC.
) else (
    echo Konsole: FAILED TO LAUNCH *** PROBLEM ***
    echo.
    echo This PC may not support WSLg.
    echo Try enabling VcXsrv mode in config.txt:
    echo   USE_VCXSRV=true
)

:end
echo.
echo ========================================
echo   Diagnostics Complete
echo ========================================
echo.
pause
