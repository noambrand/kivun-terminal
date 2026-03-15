@echo off
chcp 65001 >nul 2>&1
setlocal enabledelayedexpansion
title Kivun Terminal

REM ========================================
REM   Kivun Terminal v2.0 - Launcher
REM   Runs Claude Code natively on Windows
REM ========================================

REM --- Read configuration ---
set "RESPONSE_LANGUAGE=english"
set "SCRIPT_DIR=%~dp0"

if exist "!SCRIPT_DIR!config.txt" (
    for /f "usebackq tokens=1,* delims==" %%A in ("!SCRIPT_DIR!config.txt") do (
        set "LINE=%%A"
        if not "!LINE:~0,1!"=="#" (
            if "%%A"=="RESPONSE_LANGUAGE" set "RESPONSE_LANGUAGE=%%B"
        )
    )
)

REM --- Determine work directory ---
set "WORK_DIR=%USERPROFILE%"

if "%~1"=="" goto :work_dir_done
if /i "%~1"=="READFILE" (
    REM Read path from file written by folder-picker.vbs
    set "PATHFILE=%LOCALAPPDATA%\Kivun\kivun-workdir.txt"
    if exist "!PATHFILE!" (
        for /f "usebackq delims=" %%P in ("!PATHFILE!") do set "WORK_DIR=%%P"
    )
    goto :work_dir_done
)

REM Direct folder path argument
if exist "%~1" (
    set "WORK_DIR=%~1"
)

:work_dir_done

REM --- Verify Claude Code is installed ---
set "CLAUDE_FOUND=0"
where claude.cmd >nul 2>&1 && set "CLAUDE_FOUND=1"
if "!CLAUDE_FOUND!"=="0" (
    where claude >nul 2>&1 && set "CLAUDE_FOUND=1"
)
if "!CLAUDE_FOUND!"=="0" (
    echo.
    echo ========================================
    echo   ERROR: Claude Code not found
    echo ========================================
    echo.
    echo Claude Code is not installed or not in PATH.
    echo.
    echo To install, run:
    echo   npm install -g @anthropic-ai/claude-code
    echo.
    pause
    exit /b 1
)

REM --- Set language prompt ---
set "LANG_PROMPT="
if /i "!RESPONSE_LANGUAGE!"=="hebrew" set "LANG_PROMPT=Always respond in Hebrew."
if /i "!RESPONSE_LANGUAGE!"=="arabic" set "LANG_PROMPT=Always respond in Arabic."
if /i "!RESPONSE_LANGUAGE!"=="persian" set "LANG_PROMPT=Always respond in Persian (Farsi)."
if /i "!RESPONSE_LANGUAGE!"=="urdu" set "LANG_PROMPT=Always respond in Urdu."
if /i "!RESPONSE_LANGUAGE!"=="kurdish" set "LANG_PROMPT=Always respond in Kurdish."
if /i "!RESPONSE_LANGUAGE!"=="pashto" set "LANG_PROMPT=Always respond in Pashto."
if /i "!RESPONSE_LANGUAGE!"=="sindhi" set "LANG_PROMPT=Always respond in Sindhi."
if /i "!RESPONSE_LANGUAGE!"=="yiddish" set "LANG_PROMPT=Always respond in Yiddish."
if /i "!RESPONSE_LANGUAGE!"=="syriac" set "LANG_PROMPT=Always respond in Syriac."
if /i "!RESPONSE_LANGUAGE!"=="dhivehi" set "LANG_PROMPT=Always respond in Dhivehi."
if /i "!RESPONSE_LANGUAGE!"=="nko" set "LANG_PROMPT=Always respond in N'Ko."
if /i "!RESPONSE_LANGUAGE!"=="adlam" set "LANG_PROMPT=Always respond in Fulani (Adlam script)."
if /i "!RESPONSE_LANGUAGE!"=="mandaic" set "LANG_PROMPT=Always respond in Mandaic."
if /i "!RESPONSE_LANGUAGE!"=="samaritan" set "LANG_PROMPT=Always respond in Samaritan."
if /i "!RESPONSE_LANGUAGE!"=="dari" set "LANG_PROMPT=Always respond in Dari (Afghan Persian)."
if /i "!RESPONSE_LANGUAGE!"=="uyghur" set "LANG_PROMPT=Always respond in Uyghur."
if /i "!RESPONSE_LANGUAGE!"=="balochi" set "LANG_PROMPT=Always respond in Balochi."
if /i "!RESPONSE_LANGUAGE!"=="kashmiri" set "LANG_PROMPT=Always respond in Kashmiri."
if /i "!RESPONSE_LANGUAGE!"=="shahmukhi" set "LANG_PROMPT=Always respond in Punjabi (Shahmukhi)."
if /i "!RESPONSE_LANGUAGE!"=="azeri_south" set "LANG_PROMPT=Always respond in South Azerbaijani."
if /i "!RESPONSE_LANGUAGE!"=="jawi" set "LANG_PROMPT=Always respond in Malay (Jawi script)."
if /i "!RESPONSE_LANGUAGE!"=="hausa_ajami" set "LANG_PROMPT=Always respond in Hausa (Ajami script)."
if /i "!RESPONSE_LANGUAGE!"=="rohingya" set "LANG_PROMPT=Always respond in Rohingya."
if /i "!RESPONSE_LANGUAGE!"=="turoyo" set "LANG_PROMPT=Always respond in Turoyo (Neo-Aramaic)."

REM --- Try Windows Terminal first ---
where wt.exe >nul 2>&1
if errorlevel 1 goto :fallback_cmd

REM Launch via Windows Terminal (claude is a .cmd file, needs cmd /c)
if defined LANG_PROMPT (
    start "" wt.exe --maximized -p "Kivun Terminal" -d "!WORK_DIR!" -- cmd /c claude --append-system-prompt "!LANG_PROMPT!"
) else (
    start "" wt.exe --maximized -p "Kivun Terminal" -d "!WORK_DIR!" -- cmd /c claude
)
exit /b 0

:fallback_cmd
REM Fallback: run Claude directly in this window with light blue colors
color B0
title Kivun Terminal
cd /d "!WORK_DIR!"
if defined LANG_PROMPT (
    claude --append-system-prompt "!LANG_PROMPT!"
) else (
    claude
)
exit /b 0
