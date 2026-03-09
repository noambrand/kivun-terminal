@echo off
REM ClaudeHebrew Installation Script v2
REM Must run as Administrator

echo ============================================
echo   ClaudeHebrew - Installation
echo   Konsole Terminal with Hebrew RTL Support
echo ============================================
echo.

REM Check for admin rights
net session >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: This script requires Administrator privileges
    echo Please run as Administrator
    pause
    exit /b 1
)

echo [1/5] Checking WSL installation...
wsl --status >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo WSL is already installed
) else (
    echo Installing WSL...
    wsl --install --no-distribution
    echo.
    echo WSL installation started. Computer restart required.
    echo After restart, run this script again.
    pause
    exit /b 0
)

echo.
echo [2/5] Checking for Ubuntu distribution...
wsl -l -v | findstr -i "Ubuntu" >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo Ubuntu is already installed
    echo.
    echo Installation appears complete!
    echo Run: ubuntu.exe
    echo Then inside Ubuntu, run the post-install script:
    echo   cd /mnt/c/Users/%USERNAME%/Downloads/ClaudeHebrew_Installer
    echo   bash post-install.sh
    pause
    exit /b 0
)

echo Ubuntu not found. Installing...
echo.
echo [3/5] Installing Ubuntu distribution...
wsl --install -d Ubuntu

echo.
echo [4/5] Waiting for installation to complete...
timeout /t 5 /nobreak >nul

echo.
echo [5/5] Launching Ubuntu for first-time setup...
echo.
echo IMPORTANT:
echo 1. Ubuntu terminal will open
echo 2. Create a username (lowercase, no spaces)
echo 3. Create a password (you won't see it as you type)
echo 4. After setup, run the post-install script:
echo    cd /mnt/c/Users/%USERNAME%/Downloads/ClaudeHebrew_Installer
echo    bash post-install.sh
echo.

REM Try to launch Ubuntu
start ubuntu.exe

echo.
echo If Ubuntu didn't open automatically:
echo 1. Open Start Menu
echo 2. Search for "Ubuntu"
echo 3. Click on "Ubuntu" app
echo 4. Complete the setup (username/password)
echo.
pause
