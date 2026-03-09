@echo off
title URGENT FIX - Kivun Terminal
echo ========================================
echo KIVUN TERMINAL - URGENT FIX
echo ========================================
echo.
echo This will fix the launcher on this PC.
echo.
echo What it does:
echo 1. Checks installation directory
echo 2. Copies working launcher files
echo 3. Fixes shortcuts
echo.
pause

REM Check if installation exists
if not exist "%LOCALAPPDATA%\Kivun" (
    echo ERROR: Kivun not installed in %LOCALAPPDATA%\Kivun
    echo Please run the installer first.
    pause
    exit /b 1
)

echo.
echo [1] Copying launcher files...
copy /Y "scripts\claude-hebrew-konsole.bat" "%LOCALAPPDATA%\Kivun\"
copy /Y "scripts\kivun-terminal.bat" "%LOCALAPPDATA%\Kivun\"
copy /Y "scripts\kivun-launch.sh" "%LOCALAPPDATA%\Kivun\"
copy /Y "scripts\post-install.sh" "%LOCALAPPDATA%\Kivun\"
copy /Y "scripts\create-shortcut.vbs" "%LOCALAPPDATA%\Kivun\"
copy /Y "config\config.txt" "%LOCALAPPDATA%\Kivun\"
copy /Y "config\ClaudeHebrew.profile" "%LOCALAPPDATA%\Kivun\"
copy /Y "config\ColorSchemeNoam.colorscheme" "%LOCALAPPDATA%\Kivun\"

echo.
echo [2] Fixing shortcuts...
cd "%LOCALAPPDATA%\Kivun"
call create-shortcut.vbs

echo.
echo ========================================
echo FIX COMPLETE!
echo ========================================
echo.
echo Try the desktop shortcut now.
echo.
pause
