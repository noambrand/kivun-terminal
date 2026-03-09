@echo off
title Collecting Kivun Terminal Diagnostic Logs
echo ========================================
echo   KIVUN TERMINAL - LOG COLLECTION
echo ========================================
echo.
echo Creating diagnostic report...
echo This will be saved to your Desktop.
echo.

set "OUTPUT=%USERPROFILE%\Desktop\Kivun_Diagnostic_Report.txt"
set "INSTALL_LOG=%LOCALAPPDATA%\Kivun\LAUNCH_LOG.txt"
set "BASH_LOG_WIN=%LOCALAPPDATA%\Kivun\BASH_LAUNCH_LOG.txt"

REM Create report header
echo ======================================== > "%OUTPUT%"
echo KIVUN TERMINAL - DIAGNOSTIC REPORT >> "%OUTPUT%"
echo ======================================== >> "%OUTPUT%"
echo Generated: %DATE% %TIME% >> "%OUTPUT%"
echo User: %USERNAME% >> "%OUTPUT%"
echo Computer: %COMPUTERNAME% >> "%OUTPUT%"
echo. >> "%OUTPUT%"

REM Add Windows launch log
echo ========================================  >> "%OUTPUT%"
echo WINDOWS LAUNCH LOG >> "%OUTPUT%"
echo ======================================== >> "%OUTPUT%"
if exist "%INSTALL_LOG%" (
    type "%INSTALL_LOG%" >> "%OUTPUT%" 2>&1
    echo Log file found and included. >> "%OUTPUT%"
) else (
    echo ERROR: Launch log not found at: >> "%OUTPUT%"
    echo %INSTALL_LOG% >> "%OUTPUT%"
)
echo. >> "%OUTPUT%"

REM Add Bash launch log
echo ======================================== >> "%OUTPUT%"
echo BASH LAUNCH LOG >> "%OUTPUT%"
echo ======================================== >> "%OUTPUT%"
REM Try to read from Windows path first
if exist "%BASH_LOG_WIN%" (
    type "%BASH_LOG_WIN%" >> "%OUTPUT%" 2>&1
    echo Bash log found and included. >> "%OUTPUT%"
) else (
    REM Try to read via WSL
    wsl cat "/mnt/c/Users/%USERNAME%/AppData/Local/Kivun/BASH_LAUNCH_LOG.txt" >> "%OUTPUT%" 2>&1
    if %ERRORLEVEL% EQU 0 (
        echo Bash log found via WSL and included. >> "%OUTPUT%"
    ) else (
        echo Bash log not found (launcher may not have reached bash script). >> "%OUTPUT%"
    )
)
echo. >> "%OUTPUT%"

REM Add system information
echo ======================================== >> "%OUTPUT%"
echo SYSTEM INFORMATION >> "%OUTPUT%"
echo ======================================== >> "%OUTPUT%"
echo Windows Version: >> "%OUTPUT%"
ver >> "%OUTPUT%" 2>&1
echo. >> "%OUTPUT%"
echo WSL Version: >> "%OUTPUT%"
wsl --version >> "%OUTPUT%" 2>&1
echo. >> "%OUTPUT%"
echo WSL Status: >> "%OUTPUT%"
wsl --status >> "%OUTPUT%" 2>&1
echo. >> "%OUTPUT%"
echo Ubuntu Check: >> "%OUTPUT%"
wsl -d Ubuntu echo "Ubuntu is accessible" >> "%OUTPUT%" 2>&1
echo. >> "%OUTPUT%"

REM Show result
echo.
echo ========================================
echo DIAGNOSTIC REPORT CREATED SUCCESSFULLY
echo ========================================
echo.
echo Location: %OUTPUT%
echo.
echo Please send this file when reporting issues.
echo.
pause
