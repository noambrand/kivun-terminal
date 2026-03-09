@echo off
title Kivun Terminal - Full Diagnostic
color 0F
echo ========================================
echo KIVUN TERMINAL - DIAGNOSTIC
echo ========================================
echo.
echo This will check why the launcher fails.
echo Window will stay open so you can read results.
echo.
pause

echo.
echo [1] CHECKING INSTALLATION DIRECTORY
echo ========================================
set INSTALL_DIR=%LOCALAPPDATA%\Kivun
echo Install directory: %INSTALL_DIR%
echo.

if exist "%INSTALL_DIR%" (
    echo [OK] Installation directory exists
) else (
    echo [ERROR] Installation directory NOT FOUND!
    echo         Expected: %INSTALL_DIR%
    goto :end_diagnostic
)

echo.
echo [2] CHECKING REQUIRED FILES
echo ========================================
cd /d "%INSTALL_DIR%"

set MISSING=0

if exist "claude-hebrew-konsole.bat" (
    echo [OK] claude-hebrew-konsole.bat
) else (
    echo [MISSING] claude-hebrew-konsole.bat
    set MISSING=1
)

if exist "kivun-launch.sh" (
    echo [OK] kivun-launch.sh
) else (
    echo [MISSING] kivun-launch.sh
    set MISSING=1
)

if exist "config.txt" (
    echo [OK] config.txt
) else (
    echo [MISSING] config.txt
    set MISSING=1
)

if exist "ClaudeHebrew.profile" (
    echo [OK] ClaudeHebrew.profile
) else (
    echo [MISSING] ClaudeHebrew.profile
    set MISSING=1
)

if exist "ColorSchemeNoam.colorscheme" (
    echo [OK] ColorSchemeNoam.colorscheme
) else (
    echo [MISSING] ColorSchemeNoam.colorscheme
    set MISSING=1
)

if %MISSING%==1 (
    echo.
    echo [ERROR] Some files are missing!
    echo         Reinstall may be needed.
)

echo.
echo [3] CHECKING WSL
echo ========================================
wsl --status >/dev/null 2>&1
if %ERRORLEVEL%==0 (
    echo [OK] WSL is installed
    wsl --list --verbose
) else (
    echo [ERROR] WSL not installed or not working
    echo         Run installer to set up WSL
    goto :end_diagnostic
)

echo.
echo [4] CHECKING UBUNTU
echo ========================================
wsl -d Ubuntu -- echo "Ubuntu OK" 2>/dev/null
if %ERRORLEVEL%==0 (
    echo [OK] Ubuntu is working
) else (
    echo [ERROR] Ubuntu not installed or not working
    echo         Run installer to set up Ubuntu
    goto :end_diagnostic
)

echo.
echo [5] READING CONFIG.TXT
echo ========================================
if exist "config.txt" (
    type config.txt | findstr /v "^#" | findstr "="
) else (
    echo [ERROR] config.txt not found
)

echo.
echo [6] TESTING LAUNCHER (VERBOSE MODE)
echo ========================================
echo.
echo Press any key to run launcher in debug mode...
pause >/dev/null

echo.
echo Running: claude-hebrew-konsole.bat
echo.
call claude-hebrew-konsole.bat
echo.
echo Exit code: %ERRORLEVEL%

:end_diagnostic
echo.
echo ========================================
echo DIAGNOSTIC COMPLETE
echo ========================================
echo.
echo Please send a screenshot of this window!
echo.
echo Press any key to exit...
pause >/dev/null
