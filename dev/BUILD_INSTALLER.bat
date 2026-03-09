@echo off
REM Build the RTL Terminal Setup Wizard
REM This creates a single .exe installer that includes everything

echo ============================================
echo   Building RTL Terminal Setup Wizard
echo ============================================
echo.

REM Check if NSIS is installed
set NSIS_PATH=
if exist "C:\Program Files (x86)\NSIS\makensis.exe" (
    set NSIS_PATH=C:\Program Files (x86)\NSIS\makensis.exe
) else if exist "C:\Program Files\NSIS\makensis.exe" (
    set NSIS_PATH=C:\Program Files\NSIS\makensis.exe
) else (
    echo NSIS not found - Installing...
    echo.

    REM Install NSIS
    if exist "%~dp0nsis-3.11-setup.exe" (
        echo Running NSIS installer...
        start /wait "" "%~dp0nsis-3.11-setup.exe" /S

        REM Wait for installation
        timeout /t 5 /nobreak >nul

        REM Check again
        if exist "C:\Program Files (x86)\NSIS\makensis.exe" (
            set NSIS_PATH=C:\Program Files (x86)\NSIS\makensis.exe
        ) else if exist "C:\Program Files\NSIS\makensis.exe" (
            set NSIS_PATH=C:\Program Files\NSIS\makensis.exe
        ) else (
            echo ERROR: NSIS installation failed
            pause
            exit /b 1
        )
    ) else (
        echo ERROR: nsis-3.11-setup.exe not found
        echo Please download NSIS from https://nsis.sourceforge.io/
        pause
        exit /b 1
    )
)

echo NSIS found: %NSIS_PATH%
echo.

REM Build the installer
echo Compiling RTL_Terminal_Setup.nsi...
echo.

"%NSIS_PATH%" "%~dp0RTL_Terminal_Setup.nsi"

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ============================================
    echo   BUILD SUCCESSFUL!
    echo ============================================
    echo.
    echo Installer created: RTL_Terminal_Setup.exe
    echo.
    echo This single file contains everything needed:
    echo   - Git Bash installer
    echo   - Node.js installer
    echo   - WSL and Ubuntu setup
    echo   - Konsole and Claude Code installation
    echo   - All configuration and documentation
    echo.
    echo File size:
    dir /b "%~dp0RTL_Terminal_Setup.exe" 2>nul && for %%A in ("%~dp0RTL_Terminal_Setup.exe") do echo   %%~zA bytes
    echo.
    echo You can now distribute this single .exe file!
    echo.
) else (
    echo.
    echo ERROR: Build failed
    echo Check the output above for errors
    echo.
)

pause
