@echo off
setlocal enabledelayedexpansion
title Kivun Terminal - Debug Mode

echo ========================================
echo   Kivun Terminal - Starting...
echo ========================================
echo.

REM Read language preference
set RESPONSE_LANGUAGE=english
if exist "%~dp0config.txt" (
    for /f "tokens=1,2 delims==" %%a in ('type "%~dp0config.txt" ^| findstr /v "^#"') do (
        if "%%a"=="RESPONSE_LANGUAGE" set RESPONSE_LANGUAGE=%%b
    )
)
echo [1/5] Language: %RESPONSE_LANGUAGE%

REM Get working directory
if "%~1"=="" (
    set "WORK_DIR=%USERPROFILE%"
) else (
    set "WORK_DIR=%~1"
)
echo [2/5] Work dir: %WORK_DIR%

REM Check WSL
echo [3/5] Checking WSL...

REM First check if WSL supports modern commands
wsl --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo   ERROR: WSL is outdated or not properly installed
    echo.
    echo   SOLUTION: Run the Kivun Terminal installer again.
    echo             It will update WSL automatically.
    echo.
    echo   ALTERNATIVE (advanced):
    echo     1. Open PowerShell as Administrator
    echo     2. Run: wsl --update
    echo     3. Restart your computer
    echo.
    pause
    exit /b 1
)

wsl -d Ubuntu echo "WSL OK" >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo   ERROR: WSL not responding
    echo   Attempting restart...
    wsl --shutdown
    timeout /t 3 /nobreak >nul
    wsl -d Ubuntu echo "WSL OK" >nul 2>&1
    if %ERRORLEVEL% NEQ 0 (
        echo   FATAL: Cannot start WSL
        echo.
        echo   Possible solutions:
        echo   - Run: wsl --set-default Ubuntu
        echo   - Restart your computer
        echo   - Reinstall WSL
        echo.
        pause
        exit /b 1
    )
)
echo   WSL: OK

REM Convert path
echo [4/5] Converting path...
for /f "delims=" %%i in ('wsl wslpath "%WORK_DIR%"') do set "WSL_PATH=%%i"
if "%WSL_PATH%"=="" (
    echo   ERROR: Path conversion failed
    echo   Using home directory instead
    set "WSL_PATH=~"
)
echo   WSL path: %WSL_PATH%

REM Set prompt
if /i "%RESPONSE_LANGUAGE%"=="hebrew" (
    set "PROMPT_TEXT=Always respond in Hebrew, even if the user writes in English"
) else (
    set "PROMPT_TEXT=Always respond in English, even if the user writes in Hebrew"
)

REM Launch Konsole
echo [5/5] Launching Konsole...
echo.
echo Command:
echo   cd %WSL_PATH%
echo   konsole --profile ClaudeHebrew
echo   claude --append-system-prompt "%PROMPT_TEXT%"
echo.
echo Press Ctrl+C to cancel, or
pause

wsl bash -c "cd '%WSL_PATH%' 2>/dev/null || cd ~; konsole --profile ClaudeHebrew -e bash -l -c 'claude --append-system-prompt \"%PROMPT_TEXT%\"' 2>&1 | grep -v QStandardPaths"

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ========================================
    echo ERROR: Konsole failed to launch
    echo ========================================
    echo.
    echo Possible causes:
    echo   1. Konsole not installed in WSL
    echo   2. ClaudeHebrew profile not configured
    echo   3. Claude Code not installed
    echo.
    echo Run post-install.sh to fix
    echo.
    pause
)
