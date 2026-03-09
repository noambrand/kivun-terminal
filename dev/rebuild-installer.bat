@echo off
REM Rebuild Kivun Terminal Installer with Updated Shortcuts

echo ========================================
echo   Rebuilding Kivun Terminal Installer
echo ========================================
echo.

echo This will create a new Kivun_Terminal_Setup.exe with:
echo   - Updated shortcuts (point to claude-hebrew-konsole.bat)
echo   - All v1.0.3 fixes included
echo.

REM Check if NSIS is installed
if not exist "C:\Program Files (x86)\NSIS\makensis.exe" (
    echo ERROR: NSIS not found!
    echo.
    echo Install NSIS from: BUILD_FILES\nsis-3.11-setup.exe
    echo Then run this script again.
    pause
    exit /b 1
)

echo Compiling installer...
echo.

"C:\Program Files (x86)\NSIS\makensis.exe" /V2 Kivun_Terminal_Setup.nsi

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo   SUCCESS!
    echo ========================================
    echo.
    echo New installer created: Kivun_Terminal_Setup.exe
    echo.
    echo Copy this to the other PC and run it.
    echo.
) else (
    echo.
    echo ========================================
    echo   FAILED!
    echo ========================================
    echo.
    echo Check the error messages above.
    echo.
)

pause
