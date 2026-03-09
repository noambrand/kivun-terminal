@echo off
REM Simple WSL + Ubuntu Installation with Generic User
REM No user interaction needed

setlocal enabledelayedexpansion

echo ============================================
echo   ClaudeHebrew - Simple WSL Setup
echo ============================================
echo.

REM Check for admin rights
net session >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Requires Administrator privileges
    echo Right-click and select "Run as Administrator"
    pause
    exit /b 1
)

echo [1/5] Checking Git Bash...
where bash >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo Git Bash not found - Installing Git for Windows...
    echo.

    REM Download Git installer
    echo Downloading Git installer...
    powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/git-for-windows/git/releases/download/v2.44.0.windows.1/Git-2.44.0-64-bit.exe' -OutFile '%TEMP%\GitInstaller.exe'}"

    REM Install silently
    echo Installing Git Bash (this may take a few minutes)...
    "%TEMP%\GitInstaller.exe" /VERYSILENT /NORESTART /NOCANCEL /SP- /CLOSEAPPLICATIONS /RESTARTAPPLICATIONS /COMPONENTS="icons,ext\reg\shellhere,assoc,assoc_sh"

    REM Wait for installation to complete
    timeout /t 10 /nobreak >nul

    echo Git Bash installed successfully
    del "%TEMP%\GitInstaller.exe"
    echo.
) else (
    echo Git Bash already installed - skipping
    echo.
)

echo [2/5] Installing/Checking WSL...
wsl --status >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo Installing WSL...
    wsl --install --no-distribution
    echo.
    echo RESTART REQUIRED - Run this script again after restart
    pause
    exit /b 0
)

echo [3/5] Installing Ubuntu...
wsl -l -q 2>nul | findstr /i "Ubuntu" >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo Installing Ubuntu distribution...
    wsl --install -d Ubuntu --no-launch
    timeout /t 5 /nobreak >nul
) else (
    echo Ubuntu already installed - skipping
)

echo [4/5] Configuring Ubuntu with default user...

REM Read credentials from config.txt
set DEFUSER=username
set DEFPASS=password

if exist "%~dp0config.txt" (
    for /f "tokens=1,2 delims==" %%a in ('type "%~dp0config.txt" ^| findstr /v "^#"') do (
        if "%%a"=="USERNAME" set DEFUSER=%%b
        if "%%a"=="PASSWORD" set DEFPASS=%%b
    )
    echo Using credentials from config.txt
) else (
    echo Config.txt not found - using defaults
)

wsl -d Ubuntu -u root bash -c "useradd -m -s /bin/bash %DEFUSER% 2>/dev/null || true && usermod -aG sudo %DEFUSER% && echo '%DEFUSER%:%DEFPASS%' | chpasswd && echo '[user]' > /etc/wsl.conf && echo 'default=%DEFUSER%' >> /etc/wsl.conf"

wsl --terminate Ubuntu
timeout /t 2 /nobreak >nul

echo [5/5] Verifying...
wsl -d Ubuntu echo "Ubuntu ready!" >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo.
    echo ============================================
    echo   Setup Complete!
    echo ============================================
    echo.
    echo Ubuntu User: %DEFUSER%
    echo Password: %DEFPASS%
    echo.
    echo Next: Open Windows Terminal and run:
    echo   cd /mnt/c/Users/%USERNAME%/Downloads/ClaudeHebrew_Installer
    echo   bash post-install.sh
    echo.
) else (
    echo ERROR: Ubuntu setup failed
)

pause
