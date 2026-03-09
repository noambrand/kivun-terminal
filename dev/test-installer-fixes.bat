@echo off
REM Kivun Terminal Installer - Verification Script
REM Tests the fixes applied to the installer

echo ================================================================
echo Kivun Terminal Installer - Verification Tests
echo ================================================================
echo.

echo [Test 1] Git Detection Test
echo ---------------------------
echo Testing 'where git.exe' command...
where git.exe >nul 2>&1
if %errorlevel% == 0 (
    echo PASS: Git detected correctly
    where git.exe
) else (
    echo INFO: Git not found (expected if not installed)
)
echo.

echo [Test 2] WSL Detection Test
echo ---------------------------
echo Testing 'where bash' vs 'where git.exe'...
where bash >nul 2>&1
if %errorlevel% == 0 (
    echo WARNING: 'where bash' found bash - this would cause false positive!
    where bash
) else (
    echo PASS: No bash in PATH (good)
)
echo.

echo [Test 3] Ubuntu Detection Test
echo ---------------------------
echo Testing Ubuntu availability...
wsl -d Ubuntu echo OK >nul 2>&1
if %errorlevel% == 0 (
    echo PASS: Ubuntu is installed and working
    wsl -d Ubuntu -- whoami
) else (
    echo INFO: Ubuntu not found or not working (expected if not installed)
)
echo.

echo [Test 4] WSL Version Test
echo ---------------------------
echo Testing WSL version detection...
wsl --version >nul 2>&1
if %errorlevel% == 0 (
    echo PASS: Modern WSL detected
    wsl --version
) else (
    echo INFO: WSL not installed or old version
)
echo.

echo [Test 5] State File Test
echo ---------------------------
set INSTALL_DIR=%LOCALAPPDATA%\Kivun
if exist "%INSTALL_DIR%\.wsl-updated" (
    echo PASS: State file exists
    echo Contents:
    type "%INSTALL_DIR%\.wsl-updated"
) else (
    echo INFO: State file not found (expected on first run)
)
echo.

echo [Test 6] Installation Files Test
echo ---------------------------
if exist "%INSTALL_DIR%\init-ubuntu.sh" (
    echo PASS: init-ubuntu.sh exists
) else (
    echo INFO: init-ubuntu.sh not found (created during installation)
)

if exist "%INSTALL_DIR%\post-install.sh" (
    echo PASS: post-install.sh exists
) else (
    echo INFO: post-install.sh not found (installed during setup)
)
echo.

echo [Test 7] Path Conversion Test
echo ---------------------------
echo Testing Windows to WSL path conversion...
set TEST_PATH=%INSTALL_DIR%\test.sh
echo Windows path: %TEST_PATH%
echo Expected WSL: /mnt/c/Users/%USERNAME%/AppData/Local/Kivun/test.sh
wsl -- wslpath "%TEST_PATH%" 2>nul
if %errorlevel% == 0 (
    echo PASS: wslpath command works
) else (
    echo INFO: WSL not available for path conversion test
)
echo.

echo [Test 8] Installer File Check
echo ---------------------------
cd /d %~dp0
if exist "Kivun_Terminal_Setup.nsi" (
    echo PASS: Main installer script exists
) else (
    echo FAIL: Main installer script NOT FOUND!
)

if exist "publish\dev\Kivun_Terminal_Setup.nsi" (
    echo PASS: Publish/dev installer script exists
) else (
    echo INFO: Publish/dev installer not found
)

if exist "Git-2.53.0-64-bit.exe" (
    echo PASS: Git installer bundle exists
) else (
    echo WARNING: Git installer bundle missing!
)

if exist "node-v24.14.0-x64.msi" (
    echo PASS: Node.js installer bundle exists
) else (
    echo WARNING: Node.js installer bundle missing!
)
echo.

echo [Test 9] Specific Bug Checks
echo ---------------------------
echo Checking for fixed bugs in NSI script...

findstr /C:"where bash" "Kivun_Terminal_Setup.nsi" >nul 2>&1
if %errorlevel% == 0 (
    echo FAIL: Bug #1 NOT FIXED - 'where bash' still present!
) else (
    echo PASS: Bug #1 FIXED - 'where bash' removed
)

findstr /C:"where git.exe" "Kivun_Terminal_Setup.nsi" >nul 2>&1
if %errorlevel% == 0 (
    echo PASS: Bug #1 FIXED - 'where git.exe' used instead
) else (
    echo FAIL: Bug #1 NOT FIXED - 'where git.exe' not found!
)

findstr /C:"WindowsToWSLPath" "Kivun_Terminal_Setup.nsi" >nul 2>&1
if %errorlevel% == 0 (
    echo PASS: Bug #3 FIXED - WindowsToWSLPath function added
) else (
    echo FAIL: Bug #3 NOT FIXED - WindowsToWSLPath function missing!
)

findstr /C:"WSLComplete" "Kivun_Terminal_Setup.nsi" >nul 2>&1
if %errorlevel% == 0 (
    echo PASS: Bug #2 FIXED - WSLComplete label exists
) else (
    echo FAIL: Bug #2 NOT FIXED - WSLComplete label missing!
)
echo.

echo ================================================================
echo Verification Complete
echo ================================================================
echo.
echo If all PASS, the installer fixes are correctly applied.
echo Review any FAIL or WARNING messages above.
echo.
pause
