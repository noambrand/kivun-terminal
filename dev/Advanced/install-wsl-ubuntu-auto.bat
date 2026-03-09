@echo off
REM Fully Automated WSL + Ubuntu Installation
REM No manual username/password prompts needed

setlocal enabledelayedexpansion

echo ============================================
echo   ClaudeHebrew - Automated WSL Setup
echo ============================================
echo.

REM Check for admin rights
net session >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: This script requires Administrator privileges
    echo Right-click and select "Run as Administrator"
    pause
    exit /b 1
)

echo [1/5] Checking WSL...
wsl --status >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo WSL already installed
) else (
    echo Installing WSL...
    wsl --install --no-distribution
    echo.
    echo ============================================
    echo   RESTART REQUIRED
    echo ============================================
    echo After restart, run this script again
    pause
    exit /b 0
)

echo.
echo [2/5] Checking for existing Ubuntu...
wsl -l | findstr /i "Ubuntu" >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo Ubuntu already exists - checking configuration...
    wsl -d Ubuntu whoami >nul 2>&1
    if %ERRORLEVEL% EQU 0 (
        echo Ubuntu is already configured
        goto :configured
    )
)

echo.
echo [3/5] Installing Ubuntu...
echo This may take a few minutes...
wsl --install -d Ubuntu --no-launch
timeout /t 5 /nobreak >nul

echo.
echo [4/5] Auto-configuring Ubuntu...
REM Get Windows username (lowercase, no domain)
for /f "tokens=1 delims=." %%a in ("%USERNAME%") do set WSLUSER=%%a
set WSLUSER=!WSLUSER:~0,1!!WSLUSER:~1!
REM Convert to lowercase
for %%L in (a b c d e f g h i j k l m n o p q r s t u v w x y z) do (
    set WSLUSER=!WSLUSER:%%L=%%L!
)

echo Creating user: !WSLUSER!

REM Create user with auto-generated password
set AUTOPWD=Ubuntu2024!
wsl -d Ubuntu -u root bash -c "useradd -m -s /bin/bash !WSLUSER! 2>/dev/null || true"
wsl -d Ubuntu -u root bash -c "usermod -aG sudo !WSLUSER!"
wsl -d Ubuntu -u root bash -c "echo '!WSLUSER!:!AUTOPWD!' | chpasswd"
wsl -d Ubuntu -u root bash -c "echo '[user]' > /etc/wsl.conf && echo 'default=!WSLUSER!' >> /etc/wsl.conf"

REM Restart WSL
wsl --terminate Ubuntu
timeout /t 3 /nobreak >nul

echo.
echo [5/5] Saving credentials...
REM Save credentials for user reference
echo WSL Ubuntu Credentials > "%USERPROFILE%\ubuntu-credentials.txt"
echo ======================= >> "%USERPROFILE%\ubuntu-credentials.txt"
echo Username: !WSLUSER! >> "%USERPROFILE%\ubuntu-credentials.txt"
echo Password: !AUTOPWD! >> "%USERPROFILE%\ubuntu-credentials.txt"
echo. >> "%USERPROFILE%\ubuntu-credentials.txt"
echo Change password in Ubuntu with: passwd >> "%USERPROFILE%\ubuntu-credentials.txt"
echo Credentials saved to: %USERPROFILE%\ubuntu-credentials.txt

:configured
echo.
echo ============================================
echo   Setup Complete!
echo ============================================
echo.
echo Credentials saved to: ubuntu-credentials.txt
echo.
echo Next step: Run post-install.sh in Ubuntu
echo   wt -p Ubuntu
echo   cd /mnt/c/Users/%USERNAME%/Downloads/ClaudeHebrew_Installer
echo   bash post-install.sh
echo.
pause
