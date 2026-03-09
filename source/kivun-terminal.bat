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
echo   KIVUN TERMINAL - STARTING...
echo   LOG FILE: %LOG_FILE%
echo ========================================
echo.

call :LOG "START - Launching Kivun Terminal (Main Launcher)"

REM Get working directory
if "%~1"=="" (
    set "WORK_DIR=%USERPROFILE%"
    call :LOG "INFO - Using default work directory: %USERPROFILE%"
) else (
    set "WORK_DIR=%~1"
    call :LOG "INFO - Using specified work directory: %~1"
)
echo Work directory: %WORK_DIR%

REM Read language preference
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
echo Language: %RESPONSE_LANGUAGE%
echo Keyboard: %PRIMARY_LANGUAGE%
echo VcXsrv: %USE_VCXSRV%

REM Set language-specific prompt
call :LOG "INFO - Setting language-specific prompt for %RESPONSE_LANGUAGE%"
if /i "%RESPONSE_LANGUAGE%"=="hebrew" (
    set "CLAUDE_PROMPT=Always respond in Hebrew, even if the user writes in English"
) else (
    set "CLAUDE_PROMPT=Always respond in English, even if the user writes in Hebrew"
)
call :LOG "SUCCESS - Prompt configured"

REM Check WSL
echo.
echo Checking WSL...
call :LOG "INFO - Checking WSL installation"
wsl --version 2>&1 >> "%LOG_FILE%"
if %ERRORLEVEL% NEQ 0 (
    call :LOG "ERROR - WSL not found or not working (error %ERRORLEVEL%)"
    echo ERROR: WSL not found or not working.
    echo Run the Kivun Terminal installer to fix this.
    echo.
    echo Log file: %LOG_FILE%
    pause
    exit /b 1
)
call :LOG "SUCCESS - WSL is installed and working"
echo   WSL: OK

call :LOG "INFO - Checking Ubuntu distribution"
wsl -d Ubuntu echo OK 2>&1 >> "%LOG_FILE%"
if %ERRORLEVEL% NEQ 0 (
    call :LOG "WARNING - Ubuntu not responding, attempting WSL restart"
    echo Ubuntu not responding, restarting WSL...
    wsl --shutdown
    call :LOG "INFO - WSL shutdown command issued, waiting 3 seconds"
    timeout /t 3 /nobreak >nul
    wsl -d Ubuntu echo OK 2>&1 >> "%LOG_FILE%"
    if %ERRORLEVEL% NEQ 0 (
        call :LOG "ERROR - Ubuntu not available after restart (error %ERRORLEVEL%)"
        echo ERROR: Ubuntu not available.
        echo Run the Kivun Terminal installer to fix this.
        echo.
        echo Log file: %LOG_FILE%
        pause
        exit /b 1
    )
    call :LOG "SUCCESS - Ubuntu is now responding after restart"
) else (
    call :LOG "SUCCESS - Ubuntu is running"
)
echo   Ubuntu: OK

REM Check if Konsole is installed
call :LOG "INFO - Checking if Konsole is installed"
wsl -d Ubuntu -- bash -c "command -v konsole" 2>&1 >> "%LOG_FILE%"
if %ERRORLEVEL% NEQ 0 (
    call :LOG "WARNING - Konsole not found, attempting installation"
    echo   Konsole: NOT FOUND - installing...
    wsl -d Ubuntu -- sudo apt-get install -y konsole 2>&1 >> "%LOG_FILE%"
    wsl -d Ubuntu -- bash -c "command -v konsole" 2>&1 >> "%LOG_FILE%"
    if %ERRORLEVEL% NEQ 0 (
        call :LOG "ERROR - Konsole installation failed"
        echo   Konsole install failed - will run Claude directly.
        goto :run_direct
    )
    call :LOG "SUCCESS - Konsole installed successfully"
) else (
    call :LOG "SUCCESS - Konsole is installed"
)
echo   Konsole: OK

REM Check if Claude Code is installed
call :LOG "INFO - Checking if Claude Code is installed"
wsl -d Ubuntu -- bash -c "command -v claude" 2>&1 >> "%LOG_FILE%"
if %ERRORLEVEL% NEQ 0 (
    call :LOG "ERROR - Claude Code not found in Ubuntu"
    echo   Claude Code: NOT FOUND
    echo   Please install Claude Code: sudo npm install -g @anthropic-ai/claude-code
    goto :run_direct
)
call :LOG "SUCCESS - Claude Code is installed"
echo   Claude: OK

REM Convert paths
call :LOG "INFO - Converting Windows paths to WSL paths"
for /f "delims=" %%i in ('wsl wslpath "%WORK_DIR%" 2^>nul') do set "WSL_PATH=%%i"
if "%WSL_PATH%"=="" (
    set "WSL_PATH=~"
    call :LOG "WARNING - Path conversion failed, using home directory"
) else (
    call :LOG "SUCCESS - WSL work path: %WSL_PATH%"
)
call :LOG "INFO - Converting installation directory: %~dp0"
for /f "delims=" %%i in ('wsl wslpath "%~dp0." 2^>nul') do set "INST_WSL=%%i"
if "%INST_WSL%"=="" (
    call :LOG "ERROR - Installation path conversion failed!"
    call :LOG "ERROR - %~dp0 could not be converted to WSL path"
) else (
    call :LOG "SUCCESS - Installation WSL path: %INST_WSL%"
)
echo.
echo Path: %WSL_PATH%

REM Fix line endings in launch script (Windows creates CRLF, bash needs LF)
call :LOG "INFO - Fixing line endings in kivun-launch.sh"
wsl -d Ubuntu -- sed -i "s/\r$//" "%INST_WSL%kivun-launch.sh" 2>&1 >> "%LOG_FILE%"
if %ERRORLEVEL% EQU 0 (
    call :LOG "SUCCESS - Line endings fixed"
) else (
    call :LOG "WARNING - Failed to fix line endings (error %ERRORLEVEL%)"
)

REM Start VcXsrv if enabled and not running
if /i "%USE_VCXSRV%"=="true" (
    echo.
    echo VcXsrv mode enabled - checking X server...
    call :LOG "INFO - VcXsrv mode enabled, checking if running"
    tasklist /FI "IMAGENAME eq vcxsrv.exe" 2>nul | find /I "vcxsrv.exe" >nul
    if %ERRORLEVEL% NEQ 0 (
        call :LOG "INFO - VcXsrv not running, attempting to start"
        if exist "C:\Program Files\VcXsrv\xlaunch.exe" (
            echo   Starting VcXsrv X server...
            start "" "C:\Program Files\VcXsrv\xlaunch.exe" -run "%~dp0kivun.xlaunch"
            timeout /t 2 /nobreak >nul
            call :LOG "SUCCESS - VcXsrv started"
        ) else (
            call :LOG "WARNING - VcXsrv not installed at expected path, falling back to WSLg"
            echo   WARNING: VcXsrv not installed at expected path.
            echo   Falling back to WSLg mode.
            set USE_VCXSRV=false
        )
    ) else (
        call :LOG "SUCCESS - VcXsrv already running"
        echo   VcXsrv: already running
    )
)

REM Convert bash log path to WSL format
for /f "delims=" %%i in ('wsl wslpath "%LOCALAPPDATA%\Kivun\BASH_LAUNCH_LOG.txt" 2^>nul') do set "BASH_LOG_WSL=%%i"
call :LOG "INFO - Bash log WSL path: %BASH_LOG_WSL%"

REM Launch via kivun-launch.sh (handles profile, colors, title, maximize)
echo.
echo Launching Konsole...
call :LOG "INFO - Launching Konsole via kivun-launch.sh"
call :LOG "INFO - Command: wsl -d Ubuntu bash %INST_WSL%kivun-launch.sh %WSL_PATH% [prompt] %PRIMARY_LANGUAGE% %USE_VCXSRV% %BASH_LOG_WSL%"
title Kivun Terminal - Loading
start "" wsl -d Ubuntu bash "%INST_WSL%kivun-launch.sh" "%WSL_PATH%" "%CLAUDE_PROMPT%" "%PRIMARY_LANGUAGE%" "%USE_VCXSRV%" "%BASH_LOG_WSL%"
if %ERRORLEVEL% EQU 0 (
    call :LOG "SUCCESS - Launch command executed"
) else (
    call :LOG "ERROR - Launch command failed (error %ERRORLEVEL%)"
)

REM Wait for Konsole to start (profile deploy + launch takes a few seconds)
call :LOG "INFO - Waiting 8 seconds for Konsole to start"
timeout /t 8 /nobreak >nul

REM Check if a konsole process is running inside WSL
call :LOG "INFO - Checking if Konsole process is running"
wsl -d Ubuntu -- bash -c "pgrep -x konsole" 2>&1 >> "%LOG_FILE%"
if %ERRORLEVEL% EQU 0 (
    call :LOG "SUCCESS - Konsole is running"
    echo Konsole is running successfully!
    echo.
    echo ========================================
    echo LAUNCH LOG SAVED TO:
    echo %LOG_FILE%
    echo ========================================
    pause
    exit
)

REM Retry check - konsole may still be starting
call :LOG "INFO - Konsole not detected yet, waiting 5 more seconds"
timeout /t 5 /nobreak >nul
wsl -d Ubuntu -- bash -c "pgrep -x konsole" 2>&1 >> "%LOG_FILE%"
if %ERRORLEVEL% EQU 0 (
    call :LOG "SUCCESS - Konsole is running (detected on second check)"
    echo Konsole is running successfully!
    echo.
    echo ========================================
    echo LAUNCH LOG SAVED TO:
    echo %LOG_FILE%
    echo ========================================
    pause
    exit
)
call :LOG "WARNING - Konsole process not detected, may not have started (WSLg issue?)"

echo.
echo Konsole did not start (WSLg may not be available on this PC).
echo.

:run_direct
call :LOG "INFO - Falling back to direct Claude execution in terminal"
echo ========================================
echo   Running Claude directly in terminal
echo ========================================
echo.
call :LOG "INFO - Executing: claude --append-system-prompt [prompt]"
wsl -d Ubuntu bash -l -c "cd '%WSL_PATH%' 2>/dev/null || cd ~; claude --append-system-prompt \"%CLAUDE_PROMPT%\""
call :LOG "COMPLETE - Claude session ended"
echo.
echo ========================================
echo LAUNCH LOG SAVED TO:
echo %LOG_FILE%
echo ========================================
pause
exit /b

:LOG
echo [%TIME%] %~1 >> "%LOG_FILE%"
echo [%TIME%] %~1
exit /b
