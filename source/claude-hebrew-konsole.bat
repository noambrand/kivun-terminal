@echo off
title Kivun Terminal - Launch Log: %LOCALAPPDATA%\Kivun\LAUNCH_LOG.txt

REM Initialize log file
set "LOG_FILE=%LOCALAPPDATA%\Kivun\LAUNCH_LOG.txt"
if not exist "%LOCALAPPDATA%\Kivun" mkdir "%LOCALAPPDATA%\Kivun"

REM Start new log entry
echo ======================================== >> "%LOG_FILE%"
echo KIVUN TERMINAL LAUNCH LOG >> "%LOG_FILE%"
echo ======================================== >> "%LOG_FILE%"
echo Date: %DATE% %TIME% >> "%LOG_FILE%"
echo User: %USERNAME% >> "%LOG_FILE%"
echo Computer: %COMPUTERNAME% >> "%LOG_FILE%"
echo Working Directory: %CD% >> "%LOG_FILE%"
echo Script Location: %~dp0 >> "%LOG_FILE%"
echo ======================================== >> "%LOG_FILE%"
echo WSL VERSION: >> "%LOG_FILE%"
wsl --version >> "%LOG_FILE%" 2>&1
echo ---------------------------------------- >> "%LOG_FILE%"
echo WSL STATUS: >> "%LOG_FILE%"
wsl --status >> "%LOG_FILE%" 2>&1
echo ---------------------------------------- >> "%LOG_FILE%"
echo WSL DISTRIBUTIONS: >> "%LOG_FILE%"
wsl -l -v >> "%LOG_FILE%" 2>&1
echo ======================================== >> "%LOG_FILE%"
echo. >> "%LOG_FILE%"

echo ========================================
echo   KIVUN TERMINAL - DESKTOP SHORTCUT MODE
echo   LOG FILE: %LOG_FILE%
echo ========================================
echo.

call :LOG "START - Launching Kivun Terminal (Desktop Shortcut Mode)"

REM Get working directory (default to user profile)
if "%~1"=="" (
    set "WORK_DIR=%USERPROFILE%"
    call :LOG "INFO - Using default work directory: %USERPROFILE%"
) else (
    set "WORK_DIR=%~1"
    call :LOG "INFO - Using specified work directory: %~1"
)

REM Read config
call :LOG "INFO - Reading config.txt"
set RESPONSE_LANGUAGE=english
set PRIMARY_LANGUAGE=hebrew
set USE_VCXSRV=false
if exist "%~dp0config.txt" (
    for /f "tokens=1,2 delims==" %%a in ('type "%~dp0config.txt" 2^>nul ^| findstr /v "^#"') do (
        if "%%a"=="RESPONSE_LANGUAGE" set RESPONSE_LANGUAGE=%%b
        if "%%a"=="PRIMARY_LANGUAGE" set PRIMARY_LANGUAGE=%%b
        if "%%a"=="USE_VCXSRV" set USE_VCXSRV=%%b
    )
    call :LOG "SUCCESS - Config loaded: language=%RESPONSE_LANGUAGE%, keyboard=%PRIMARY_LANGUAGE%, vcxsrv=%USE_VCXSRV%"
) else (
    call :LOG "WARNING - config.txt not found, using defaults"
)

REM Set language-specific prompt
call :LOG "INFO - Setting language-specific prompt for %RESPONSE_LANGUAGE%"
if /i "%RESPONSE_LANGUAGE%"=="hebrew" (
    set "CLAUDE_PROMPT=Always respond in Hebrew, even if the user writes in English"
) else (
    set "CLAUDE_PROMPT=Always respond in English, even if the user writes in Hebrew"
)
call :LOG "SUCCESS - Prompt configured"

REM Convert Windows paths to WSL paths
call :LOG "INFO - Converting Windows path to WSL path"
for /f "delims=" %%i in ('wsl wslpath "%WORK_DIR%" 2^>nul') do set "WSL_PATH=%%i"
if "%WSL_PATH%"=="" (
    set "WSL_PATH=~"
    call :LOG "WARNING - Path conversion failed, using home directory"
) else (
    call :LOG "SUCCESS - WSL path: %WSL_PATH%"
)
call :LOG "INFO - Converting installation directory: %~dp0"
for /f "delims=" %%i in ('wsl wslpath "%~dp0." 2^>nul') do set "INST_WSL=%%i"
if "%INST_WSL%"=="" (
    call :LOG "ERROR - Installation path conversion failed!"
    call :LOG "ERROR - %~dp0 could not be converted to WSL path"
) else (
    call :LOG "SUCCESS - Installation WSL path: %INST_WSL%"
)

REM Fix line endings in launch script
call :LOG "INFO - Fixing line endings in kivun-launch.sh"
wsl -d Ubuntu -- sed -i "s/\r$//" "%INST_WSL%kivun-launch.sh" 2>&1 >> "%LOG_FILE%"
if %ERRORLEVEL% EQU 0 (
    call :LOG "SUCCESS - Line endings fixed"
) else (
    call :LOG "WARNING - Failed to fix line endings (error %ERRORLEVEL%)"
)

REM Convert bash log path to WSL format
for /f "delims=" %%i in ('wsl wslpath "%LOCALAPPDATA%\Kivun\BASH_LAUNCH_LOG.txt" 2^>nul') do set "BASH_LOG_WSL=%%i"
call :LOG "INFO - Bash log WSL path: %BASH_LOG_WSL%"

REM Launch via kivun-launch.sh
call :LOG "INFO - Launching Konsole via kivun-launch.sh"
call :LOG "INFO - Command: wsl -d Ubuntu bash %INST_WSL%kivun-launch.sh %WSL_PATH% [prompt] %PRIMARY_LANGUAGE% %USE_VCXSRV% %BASH_LOG_WSL%"
start "" wsl -d Ubuntu bash "%INST_WSL%kivun-launch.sh" "%WSL_PATH%" "%CLAUDE_PROMPT%" "%PRIMARY_LANGUAGE%" "%USE_VCXSRV%" "%BASH_LOG_WSL%"
if %ERRORLEVEL% EQU 0 (
    call :LOG "SUCCESS - Launch command executed"
) else (
    call :LOG "ERROR - Launch command failed (error %ERRORLEVEL%)"
)

call :LOG "COMPLETE - Desktop shortcut launcher finished"
call :LOG "INFO - Konsole should appear in a few seconds"
echo.
echo Konsole launching...
echo Check log if issues: %LOG_FILE%
timeout /t 3 /nobreak >nul
exit /b

:LOG
echo [%TIME%] %~1 >> "%LOG_FILE%"
echo [%TIME%] %~1
exit /b
