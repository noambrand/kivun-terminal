@echo off
setlocal enabledelayedexpansion
title Kivun Terminal - Keyboard Mode

echo ========================================
echo   Kivun Terminal - Keyboard Mode Toggle
echo ========================================
echo.

set "CONFIG=%~dp0config.txt"

if not exist "%CONFIG%" (
    echo ERROR: config.txt not found at %CONFIG%
    pause
    exit /b 1
)

REM Read current USE_VCXSRV value
set USE_VCXSRV=false
for /f "tokens=1,2 delims==" %%a in ('type "%CONFIG%" 2^>nul ^| findstr /v "^#"') do (
    if "%%a"=="USE_VCXSRV" set USE_VCXSRV=%%b
)

echo Current keyboard mode:
echo.
if /i "!USE_VCXSRV!"=="true" (
    echo   [*] VcXsrv mode  - Alt+Shift keyboard switching ENABLED
    echo   [ ] WSLg mode    - Default, no keyboard switching
) else (
    echo   [ ] VcXsrv mode  - Alt+Shift keyboard switching
    echo   [*] WSLg mode    - Default, no keyboard switching
)
echo.

REM Check VcXsrv installation status
if exist "C:\Program Files\VcXsrv\vcxsrv.exe" (
    echo VcXsrv status: Installed
) else (
    echo VcXsrv status: NOT INSTALLED
    echo   Download from: https://sourceforge.net/projects/vcxsrv/
    echo   Or re-run the Kivun Terminal installer and check the VcXsrv option.
)
echo.
echo ----------------------------------------
echo.

if /i "!USE_VCXSRV!"=="true" (
    echo Press [1] to switch to WSLg mode ^(disable VcXsrv^)
    echo Press [2] to keep VcXsrv mode ^(no change^)
) else (
    echo Press [1] to switch to VcXsrv mode ^(enable Alt+Shift switching^)
    echo Press [2] to keep WSLg mode ^(no change^)
)
echo Press [3] to exit without changes
echo.
choice /c 123 /n /m "Your choice: "

if %ERRORLEVEL%==3 goto :done
if %ERRORLEVEL%==2 goto :done

REM Toggle the value
if /i "!USE_VCXSRV!"=="true" (
    echo.
    echo Switching to WSLg mode...
    powershell -Command "(Get-Content '%CONFIG%') -replace '^USE_VCXSRV=true','USE_VCXSRV=false' | Set-Content '%CONFIG%'"
    echo.
    echo Done! Keyboard mode changed to: WSLg ^(default^)
    echo Alt+Shift switching will NOT be available in Konsole.
) else (
    REM Check if VcXsrv is installed before enabling
    if not exist "C:\Program Files\VcXsrv\vcxsrv.exe" (
        echo.
        echo WARNING: VcXsrv is not installed!
        echo.
        echo To use VcXsrv mode, you need to install VcXsrv first:
        echo   1. Re-run the Kivun Terminal installer and check the VcXsrv option
        echo   2. Or download manually from: https://sourceforge.net/projects/vcxsrv/
        echo.
        echo Enable VcXsrv mode anyway? ^(It will fall back to WSLg until VcXsrv is installed^)
        choice /c YN /n /m "Enable? (Y/N): "
        if !ERRORLEVEL!==2 goto :done
    )
    echo.
    echo Switching to VcXsrv mode...
    powershell -Command "(Get-Content '%CONFIG%') -replace '^USE_VCXSRV=false','USE_VCXSRV=true' | Set-Content '%CONFIG%'"
    echo.
    echo Done! Keyboard mode changed to: VcXsrv
    echo Alt+Shift will toggle between Hebrew and English in Konsole.
)

echo.
echo Restart Kivun Terminal for changes to take effect.

:done
echo.
pause
