@echo off
REM Automated Ubuntu Setup for ClaudeHebrew
REM Handles the complete setup without manual intervention

setlocal enabledelayedexpansion

echo ============================================
echo   ClaudeHebrew - Automated Ubuntu Setup
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

echo [1/6] Checking WSL installation...
wsl --status >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo Installing WSL...
    wsl --install --no-distribution
    echo.
    echo RESTART REQUIRED: Please restart your computer
    echo After restart, run this script again
    pause
    exit /b 0
) else (
    echo ✓ WSL is installed
)

echo.
echo [2/6] Checking Ubuntu distribution...
wsl -l | findstr /i "Ubuntu" >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo ✓ Ubuntu distribution exists
) else (
    echo Installing Ubuntu...
    wsl --install -d Ubuntu --no-launch
    timeout /t 10 /nobreak >nul
)

echo.
echo [3/6] Checking if Ubuntu has a user configured...
wsl -d Ubuntu whoami 2>nul | findstr /i "root" >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo Ubuntu is using root - setting up regular user...

    REM Get username
    for /f "tokens=1 delims=." %%a in ("%USERNAME%") do set LINUXUSER=%%a
    echo Creating user: !LINUXUSER!

    REM Create user and configure
    wsl -d Ubuntu -u root bash -c "useradd -m -s /bin/bash !LINUXUSER! && usermod -aG sudo !LINUXUSER! && echo '!LINUXUSER!:temp123' | chpasswd && echo '[user]' > /etc/wsl.conf && echo 'default=!LINUXUSER!' >> /etc/wsl.conf"

    REM Restart WSL
    wsl --terminate Ubuntu
    timeout /t 3 /nobreak >nul

    echo ✓ User !LINUXUSER! created (password: temp123)
    echo   IMPORTANT: Change password in Ubuntu with 'passwd' command
) else (
    wsl -d Ubuntu whoami 2>nul | findstr /v /i "root" >nul 2>&1
    if %ERRORLEVEL% EQU 0 (
        echo ✓ Ubuntu has a regular user configured
    )
)

echo.
echo [4/6] Configuring Windows Terminal...
REM Find Windows Terminal settings
set "WTSETTINGS=%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
if exist "!WTSETTINGS!" (
    echo ✓ Found Windows Terminal settings
    REM Note: Windows Terminal will auto-detect Ubuntu on next launch
) else (
    echo Windows Terminal settings not found - will auto-configure on first launch
)

echo.
echo [5/6] Verifying Ubuntu is working...
wsl -d Ubuntu echo "Ubuntu is working!" >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo ✓ Ubuntu is operational
) else (
    echo ✗ Ubuntu verification failed
    echo   Try running: wsl --install -d Ubuntu
    pause
    exit /b 1
)

echo.
echo [6/6] Setup Complete!
echo.
echo ============================================
echo   Next Steps:
echo ============================================
echo 1. Open Windows Terminal (it will default to Ubuntu)
echo 2. In Ubuntu, run the post-install script:
echo    cd /mnt/c/Users/%USERNAME%/Downloads/ClaudeHebrew_Installer
echo    bash post-install.sh
echo.
echo 3. Launch ClaudeHebrew:
echo    claude-hebrew-konsole.bat
echo.
pause
