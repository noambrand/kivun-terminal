@echo off
REM Check ClaudeHebrew installation status

echo ============================================
echo   ClaudeHebrew - Installation Status
echo ============================================
echo.

echo [1/3] Checking WSL...
wsl --status >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo ✓ WSL is installed
    wsl --status
) else (
    echo ✗ WSL is NOT installed
    echo   Run: install-claude-hebrew-improved.bat
    goto :end
)

echo.
echo [2/3] Checking Ubuntu distribution...
wsl -l -v | findstr -i "Ubuntu"
if %ERRORLEVEL% EQU 0 (
    echo ✓ Ubuntu is installed
) else (
    echo ✗ Ubuntu is NOT installed
    echo   Run: launch-ubuntu-setup.bat
    echo   OR: wsl --install -d Ubuntu
    goto :end
)

echo.
echo [3/3] Checking if Ubuntu is configured...
wsl -d Ubuntu whoami >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo ✓ Ubuntu is configured with user:
    wsl -d Ubuntu whoami
    echo.
    echo Installation complete! Next steps:
    echo 1. Run post-install.sh in Ubuntu
    echo 2. Launch with: claude-hebrew-konsole.bat
) else (
    echo ✗ Ubuntu needs first-time setup
    echo   Run: launch-ubuntu-setup.bat
)

:end
echo.
echo ============================================
pause
